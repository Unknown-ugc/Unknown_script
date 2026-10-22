-- Cat Hub | Egg Detector (Luau)
-- The script carries its own copy, so auto execute works with NO file and NO URL.
-- Cat Hub | Egg Detector (Luau)
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer
local requestFunc = (syn and syn.request) or (http and http.request) or http_request or request or (fluxus and fluxus.request)

if not game:IsLoaded() then game.Loaded:Wait() end
-- stop duplicate runs (e.g. autoexec + queue_on_teleport firing together)
local genv = (getgenv and getgenv()) or _G
if tick() - (genv.__CatHubLock or 0) < 5 then return end
genv.__CatHubLock = tick()

-- ===== KEY SYSTEM =====
local SHOW_KEY_GUI = true                              -- true = show key screen, false = skip it
local KEYS = { "CAT-HUB-2024", "FREE-CAT-SNIPER" }      -- valid keys

-- ===== AUTO EXECUTE: automatic, no file or URL needed (the script carries its own copy) =====
local NOTIFY_TIME = 7                  -- seconds a notification / popup stays on screen

-- ===== EGG DETECTOR (runs in the background, webhook only) =====
local DETECTOR_ENABLED = true
local WEBHOOK_PRIVATE = ""             -- paste your PRIVATE webhook here (every egg)
local WEBHOOK_PUBLIC = ""              -- paste your PUBLIC webhook here (only big eggs)
local PUBLIC_MIN_VALUE = 1e9           -- 1B/s minimum for the public webhook
local SCAN_INTERVAL = 300              -- seconds between scans in the same server
-- WARNING: if you share this script with other people, leave both webhooks empty!

-- ===== CONFIG =====
local API_BASE = "https://cat-hub-api.onrender.com"
-- the script tries these routes in order and remembers the first one that works
local ROUTES = { "/public-eggs?limit=50", "/eggs?limit=50", "/api/eggs?limit=50", "/live-eggs?limit=50" }
local DISCORD_LINK = "https://discord.gg/FJK6QzNnf7"
local REFRESH = 0.5 -- poll twice per second; rendering only updates when egg data changes
local IS_MOBILE = UIS.TouchEnabled and not UIS.KeyboardEnabled

-- ===== THEME =====
local C = {
    bg = Color3.fromRGB(3, 5, 10), side = Color3.fromRGB(6, 10, 19), card = Color3.fromRGB(9, 15, 28), card2 = Color3.fromRGB(13, 22, 42),
    p = Color3.fromRGB(37, 99, 235), c = Color3.fromRGB(96, 165, 250), pk = Color3.fromRGB(29, 78, 216),
    txt = Color3.fromRGB(235, 243, 255), sub = Color3.fromRGB(135, 155, 190), white = Color3.new(1, 1, 1),
    ok = Color3.fromRGB(74, 222, 128), warn = Color3.fromRGB(251, 191, 36), bad = Color3.fromRGB(239, 68, 68),
}
local RAR = {
    common = Color3.fromRGB(156, 163, 175), uncommon = Color3.fromRGB(74, 222, 128), rare = Color3.fromRGB(59, 130, 246),
    epic = Color3.fromRGB(168, 85, 247), legendary = Color3.fromRGB(245, 158, 11), mythic = Color3.fromRGB(239, 68, 68),
    cosmic = Color3.fromRGB(99, 102, 241), secret = Color3.fromRGB(236, 72, 153), eternal = Color3.fromRGB(20, 184, 166),
    divine = Color3.fromRGB(253, 224, 71),
}
local RAR_LIST = { "Any", "Secret", "Divine", "Eternal", "Cosmic", "Mythic", "Legendary", "Epic", "Rare", "Uncommon", "Common" }
local function rcol(r) return RAR[string.lower(tostring(r or ""))] or C.p end

-- ===== HELPERS =====
local function new(cls, props, parent)
    local o = Instance.new(cls)
    for k, v in pairs(props) do o[k] = v end
    o.Parent = parent
    return o
end
local function round(o, r) return new("UICorner", { CornerRadius = UDim.new(0, r) }, o) end
local function stroke(o, col, th, tr) return new("UIStroke", { Color = col, Thickness = th or 1, Transparency = tr or 0, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, o) end
local function grad(o, c1, c2, rot) return new("UIGradient", { Color = ColorSequence.new(c1, c2), Rotation = rot or 0 }, o) end
local function tween(o, t, props) TS:Create(o, TweenInfo.new(t, Enum.EasingStyle.Quad), props):Play() end
local function T(p, text, size, col, font, props)
    local l = new("TextLabel", { BackgroundTransparency = 1, Text = text, TextSize = size, TextColor3 = col, Font = font or Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left }, p)
    for k, v in pairs(props or {}) do l[k] = v end
    return l
end
local function B(p, text, size, bg, col, props, rad)
    local b = new("TextButton", { AutoButtonColor = false, BackgroundColor3 = bg, Text = text, TextSize = size, TextColor3 = col, Font = Enum.Font.GothamBold, BorderSizePixel = 0 }, p)
    for k, v in pairs(props or {}) do b[k] = v end
    round(b, rad or 8)
    return b
end
local function hover(b, base, over)
    b.MouseEnter:Connect(function() tween(b, .12, { BackgroundColor3 = over }) end)
    b.MouseLeave:Connect(function() tween(b, .12, { BackgroundColor3 = base }) end)
end
local function box(p, ph, props)
    local t = new("TextBox", { BackgroundColor3 = C.card, PlaceholderText = ph, PlaceholderColor3 = C.sub, Text = "", TextColor3 = C.txt, Font = Enum.Font.GothamMedium, TextSize = 12, ClearTextOnFocus = false, TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0 }, p)
    for k, v in pairs(props or {}) do t[k] = v end
    round(t, 8); stroke(t, C.p, 1, .6); new("UIPadding", { PaddingLeft = UDim.new(0, 12) }, t)
    return t
end
local function pulse(o) TS:Create(o, TweenInfo.new(.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), { BackgroundTransparency = .65 }):Play() end
local function drag(handle, target)
    local dragging, startIn, startPos
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true; startIn = i.Position; startPos = target.Position; target:SetAttribute("moved", false)
            i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - startIn
            if d.Magnitude > 6 then target:SetAttribute("moved", true) end
            target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
end
local function guiParent() return (gethui and gethui()) or LP:WaitForChild("PlayerGui") end

-- ===== DATA HELPERS =====
local MULT = { K = 1e3, M = 1e6, B = 1e9, T = 1e12 }
local function parseValue(s)
    if type(s) == "number" then return s end
    local n, u = tostring(s or ""):match("([%d%.]+)%s*([KMBTkmbt]?)")
    n = tonumber(n)
    if not n then return 0 end
    return n * (MULT[(u or ""):upper()] or 1)
end
local function parseKg(str)
    local s = string.lower(str or "")
    local n = tonumber(s:match("([%d%.]+)"))
    if not n then return 0 end
    if s:find("k") then n = n * 1000 end
    return n
end
local function compact(n)
    n = tonumber(n) or 0
    local function trim(v) local t = string.format("%.2f", v):gsub("0+$", ""):gsub("%.$", ""); return t end
    local a = math.abs(n)
    if a >= 1e12 then return trim(n / 1e12) .. "T" end
    if a >= 1e9 then return trim(n / 1e9) .. "B" end
    if a >= 1e6 then return trim(n / 1e6) .. "M" end
    if a >= 1e3 then return trim(n / 1e3) .. "K" end
    return trim(n)
end
local function normImg(img)
    img = tostring(img or "")
    if img:match("^%d+$") then return "rbxassetid://" .. img end
    return img
end
local function pick(e, ...)
    for _, k in ipairs({ ... }) do if e[k] ~= nil and e[k] ~= "" then return e[k] end end
    return nil
end
local function normalize(e)
    if type(e) ~= "table" then return nil end
    local n = {}
    n.name = tostring(pick(e, "name", "eggName", "DisplayName", "title") or "Unknown Egg")
    n.rarity = tostring(pick(e, "rarity", "Rarity", "tier") or "Unknown")
    n.scale = tonumber(pick(e, "scale", "kg", "weight")) or 0
    n.sizeName = pick(e, "sizeName")
    n.serverId = pick(e, "serverId", "jobId", "gameInstanceId", "server_id")
    n.image = pick(e, "image", "icon", "Icon", "thumbnail")
    n.players = tonumber(pick(e, "players", "playerCount", "playing"))
    n.maxPlayers = tonumber(pick(e, "maxPlayers", "max"))
    n.valueNum = tonumber(pick(e, "valueNum", "earningRate")) or parseValue(e.value)
    n.value = e.value and tostring(e.value) or ("$" .. compact(n.valueNum) .. "/s")
    return n
end
local function extractList(d)
    if type(d) ~= "table" then return nil end
    if d[1] ~= nil or next(d) == nil then return d end
    for _, k in ipairs({ "eggs", "data", "items", "results", "records" }) do
        if type(d[k]) == "table" then return d[k] end
    end
    return nil
end

-- ===== LIVE EGG FETCH (with route fallback + exact error reason) =====
local activeRoute
local function pullEggs()
    if not requestFunc then return nil, "executor has no HTTP request function" end
    local routes = activeRoute and { activeRoute } or ROUTES
    local lastErr = "no response"
    for _, route in ipairs(routes) do
        local separator = route:find("?", 1, true) and "&" or "?"
        local requestUrl = API_BASE .. route .. separator .. "_=" .. tostring(math.floor(os.clock() * 1000))
        local ok, res = pcall(requestFunc, { Url = requestUrl, Method = "GET", Headers = { Accept = "application/json", ["Cache-Control"] = "no-cache", Pragma = "no-cache" } })
        if not ok then
            lastErr = "request failed: " .. tostring(res)
        elseif not res then
            lastErr = "empty response"
        else
            local code = tonumber(res.StatusCode) or 0
            if code >= 200 and code < 300 and res.Body then
                local okJ, dec = pcall(HttpService.JSONDecode, HttpService, res.Body)
                if okJ then
                    local list = extractList(dec)
                    if list then activeRoute = route; return list end
                    lastErr = "unexpected JSON shape"
                else
                    lastErr = "invalid JSON (server may be waking up)"
                end
            elseif code == 404 then
                lastErr = "HTTP 404 - route " .. route:match("^[^?]+") .. " not found on API"
            elseif code >= 500 or code == 0 then
                lastErr = "HTTP " .. code .. " - API is down or waking up, retrying"
            else
                lastErr = "HTTP " .. code
            end
        end
    end
    activeRoute = nil
    return nil, lastErr
end

-- ===== GAME DATA (egg snapshot of the current server) =====
local Assets, Networking
pcall(function() Assets = require(RS.Data.Assets); Networking = RS.Packages.Networking end)
local function snapshot()
    local out = {}
    if not Networking or not Assets then return out end
    pcall(function()
        local rf = Networking:FindFirstChild("RF/EggWorld/AskFieldEggSnapshot")
        local res = rf and rf:InvokeServer()
        if res and res.Records then
            for _, rc in pairs(res.Records) do
                local e = Assets.Directory[tostring(rc.AssetCategory)]
                if e then
                    table.insert(out, {
                        uid = rc.Uid, name = tostring(e.DisplayName or rc.AssetCategory),
                        rarity = e.Rarity and tostring(e.Rarity.DisplayName or e.Rarity.Name) or "Unknown",
                        scale = tonumber(rc.AssetScale) or 1, rec = rc, entry = e,
                    })
                end
            end
        end
    end)
    return out
end
local function findTargetEgg(t)
    for _, r in ipairs(snapshot()) do
        local sameName = string.lower(r.name) == string.lower(t.name)
        local sameRar = string.lower(r.rarity) == string.lower(t.rarity)
        local ts = tonumber(t.scale) or 0
        local sameScale = ts <= 0 or math.abs(r.scale - ts) <= math.max(ts * 0.01, 0.01)
        if sameName and sameRar and sameScale then return r end
    end
end
local function eggPosition(r)
    local rec = r.rec
    for _, k in ipairs({ "Position", "Pos", "CFrame", "WorldPosition" }) do
        local v = rec[k]
        if typeof(v) == "Vector3" then return v end
        if typeof(v) == "CFrame" then return v.Position end
    end
    local uid = tostring(r.uid or "")
    if uid ~= "" then
        for _, d in ipairs(workspace:GetDescendants()) do
            if d.Name == uid or d:GetAttribute("Uid") == uid or d:GetAttribute("EggUid") == uid then
                if d:IsA("PVInstance") then return d:GetPivot().Position end
                local p = d:FindFirstChildWhichIsA("BasePart", true)
                if p then return p.Position end
            end
        end
    end
    return nil
end

-- ===== PENDING TARGET + AUTO EXECUTE =====
local function savePending(t)
    t.ts = os.time()
    genv.__CatHubPending = t
end
local function clearPending() genv.__CatHubPending = nil end
local function loadPending()
    local t = genv.__CatHubPending
    clearPending()
    -- only valid when we are really inside the server we teleported to
    if type(t) == "table" and tostring(t.serverId) == game.JobId and os.time() - (tonumber(t.ts) or 0) < 180 then
        return t
    end
    return nil
end
-- long-bracket string that cannot clash with the text inside it
local function lb(text)
    local eq = string.rep("=", 8)
    return "[" .. eq .. "[" .. text .. "]" .. eq .. "]"
end
-- Re-queues this very script (embedded copy) so it runs again in the next server. No file or URL needed.
local queueWarned = false
local function queueSelf()
    local q = queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)
    local src = genv.__CatHubSource
    if type(q) ~= "function" or not src then
        if not queueWarned then
            queueWarned = true
            warn("[CAT HUB] Your executor has no queue_on_teleport. Put the script in your autoexec folder instead.")
        end
        return
    end
    local pendingJson = genv.__CatHubPending and HttpService:JSONEncode(genv.__CatHubPending) or "null"
    local code = "local g=(getgenv and getgenv()) or _G; "
        .. "g.__CatHubSource=" .. lb(src) .. "; "
        .. "g.__CatHubPending=game:GetService('HttpService'):JSONDecode(" .. lb(pendingJson) .. "); "
        .. "loadstring(g.__CatHubSource)()"
    pcall(q, code)
end
pcall(function()
    TeleportService.TeleportInitFailed:Connect(function(player)
        if player == LP then clearPending() end
    end)
end)

-- JOIN: remember the egg, queue the script, teleport. Notifications only appear in the NEW server.
local function joinServer(e)
    if not e.serverId then return false end
    savePending({ name = e.name, rarity = e.rarity, scale = e.scale, value = e.value, serverId = tostring(e.serverId) })
    queueSelf()
    local ok = pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, tostring(e.serverId), LP) end)
    if not ok then clearPending() end
    return ok
end

-- ===== REMOVE GONE EGGS FROM LIVE EGGS =====
local goneSet = genv.__CatHubGone or {}
genv.__CatHubGone = goneSet
local uiHooks = {}
local function goneKey(t)
    return tostring(t.serverId) .. "|" .. string.lower(tostring(t.name)) .. "|" .. string.format("%.2f", tonumber(t.scale) or 0)
end
-- called when we joined an egg's server and the egg is no longer there
local function reportGone(t)
    goneSet[goneKey(t)] = true
    if uiHooks.removeEgg then uiHooks.removeEgg(t) end
    task.spawn(function()
        if not requestFunc then return end
        pcall(requestFunc, {
            Url = API_BASE .. "/egg-gone", Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode({ serverId = t.serverId, name = t.name, rarity = t.rarity, scale = t.scale }),
        })
    end)
end

-- ===== NOTIFICATIONS / POPUP / EGG VIEW =====
local notifGui
local function getNotifGui()
    if notifGui and notifGui.Parent then return notifGui end
    notifGui = new("ScreenGui", { Name = "CatHubNotify", ResetOnSpawn = false, DisplayOrder = 1000 }, guiParent())
    return notifGui
end
local slots = {}
local function notify(kind, title, sub)
    local g = getNotifGui()
    local col = (kind == "ok") and C.ok or C.warn
    local idx = 1
    while slots[idx] do idx += 1 end
    slots[idx] = true
    local y = 10 + (idx - 1) * 74
    local card = new("Frame", { Size = UDim2.fromOffset(300, 64), AnchorPoint = Vector2.new(.5, 0), Position = UDim2.new(.5, 0, 0, -90), BackgroundColor3 = C.card, BorderSizePixel = 0 }, g)
    round(card, 14); stroke(card, col, 1.5, .1)
    round(new("Frame", { Size = UDim2.new(0, 4, 1, -24), Position = UDim2.fromOffset(8, 12), BackgroundColor3 = col, BorderSizePixel = 0 }, card), 2)
    T(card, title, 15, C.txt, Enum.Font.GothamBlack, { Position = UDim2.fromOffset(22, 8), Size = UDim2.new(1, -34, 0, 20) })
    T(card, sub, 11, C.sub, Enum.Font.GothamMedium, { Position = UDim2.fromOffset(22, 29), Size = UDim2.new(1, -34, 0, 18), TextTruncate = Enum.TextTruncate.AtEnd })
    local track = new("Frame", { Size = UDim2.new(1, -28, 0, 3), Position = UDim2.new(0, 14, 1, -8), BackgroundColor3 = C.card2, BorderSizePixel = 0 }, card); round(track, 2)
    local fill = new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = col, BorderSizePixel = 0 }, track); round(fill, 2)
    TS:Create(card, TweenInfo.new(.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Position = UDim2.new(.5, 0, 0, y) }):Play()
    TS:Create(fill, TweenInfo.new(NOTIFY_TIME, Enum.EasingStyle.Linear), { Size = UDim2.fromScale(0, 1) }):Play()
    task.delay(NOTIFY_TIME, function()
        TS:Create(card, TweenInfo.new(.3, Enum.EasingStyle.Quad), { Position = UDim2.new(.5, 0, 0, -90) }):Play()
        task.wait(.35); card:Destroy(); slots[idx] = nil
    end)
end

-- camera view
local viewing = nil
local viewHooks = {}
local function stopView()
    if not viewing then return end
    local v = viewing; viewing = nil
    for _, c in ipairs(v.conns or {}) do c:Disconnect() end
    if v.card then v.card:Destroy() end
    local cam = workspace.CurrentCamera
    if cam then
        local tw = TS:Create(cam, TweenInfo.new(.6, Enum.EasingStyle.Quad), { CFrame = v.prevCF })
        tw:Play(); tw.Completed:Wait()
        cam.CameraType = Enum.CameraType.Custom
        local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then cam.CameraSubject = hum end
    end
    if viewHooks.show then viewHooks.show() end
end
local function startView(pos, info)
    local cam = workspace.CurrentCamera
    if not cam then return end
    local g = getNotifGui()
    if not viewing then viewing = { prevCF = cam.CFrame } end
    for _, c in ipairs(viewing.conns or {}) do c:Disconnect() end
    viewing.conns = {}
    if viewHooks.hide then viewHooks.hide() end
    cam.CameraType = Enum.CameraType.Scriptable

    -- 360 orbit camera: drag to rotate, pinch / scroll to zoom
    local yaw, pitch, dist = 0, math.rad(25), 16
    local dragging, baseDist = false, dist
    local function add(c) table.insert(viewing.conns, c) end
    add(UIS.InputBegan:Connect(function(i, gp)
        if gp then return end
        local t = i.UserInputType
        if t == Enum.UserInputType.Touch or t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.MouseButton2 then
            dragging = true
        end
    end))
    add(UIS.InputEnded:Connect(function(i)
        local t = i.UserInputType
        if t == Enum.UserInputType.Touch or t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.MouseButton2 then
            dragging = false
        end
    end))
    add(UIS.InputChanged:Connect(function(i, gp)
        if i.UserInputType == Enum.UserInputType.MouseWheel then
            dist = math.clamp(dist - i.Position.Z * 2, 5, 45)
        elseif dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            yaw = yaw - i.Delta.X * 0.01
            pitch = math.clamp(pitch + i.Delta.Y * 0.008, -0.3, 1.4)
        end
    end))
    add(UIS.TouchPinch:Connect(function(_, scale, _, state)
        if state == Enum.UserInputState.Begin then baseDist = dist end
        dist = math.clamp(baseDist / math.max(scale, 0.1), 5, 45)
    end))
    add(RunService.RenderStepped:Connect(function()
        cam.CameraType = Enum.CameraType.Scriptable
        local offset = Vector3.new(math.sin(yaw) * math.cos(pitch), math.sin(pitch), math.cos(yaw) * math.cos(pitch)) * dist
        cam.CFrame = cam.CFrame:Lerp(CFrame.new(pos + offset, pos), 0.18)
    end))

    if viewing.card then viewing.card:Destroy() end
    local card = new("Frame", { Size = UDim2.fromOffset(300, 78), AnchorPoint = Vector2.new(.5, 1), Position = UDim2.new(.5, 0, 1, -24), BackgroundColor3 = C.card, BorderSizePixel = 0 }, g)
    round(card, 14); stroke(card, rcol(info.rarity), 1.5, .1)
    T(card, "👁 " .. tostring(info.name), 14, C.txt, Enum.Font.GothamBlack, { Position = UDim2.fromOffset(16, 9), Size = UDim2.new(1, -66, 0, 20), TextTruncate = Enum.TextTruncate.AtEnd })
    T(card, tostring(info.rarity) .. (info.value and ("  •  " .. tostring(info.value)) or ""), 11, C.sub, Enum.Font.GothamMedium, { Position = UDim2.fromOffset(16, 33), Size = UDim2.new(1, -66, 0, 18), TextTruncate = Enum.TextTruncate.AtEnd })
    T(card, "Drag to rotate  •  Pinch / scroll to zoom", 10, C.c, Enum.Font.GothamMedium, { Position = UDim2.fromOffset(16, 54), Size = UDim2.new(1, -66, 0, 16) })
    local x = B(card, "✕", 14, C.card2, C.txt, { Size = UDim2.fromOffset(34, 34), Position = UDim2.new(1, -46, 0, 8) }, 10)
    hover(x, C.card2, C.bad)
    x.MouseButton1Click:Connect(stopView)
    viewing.card = card
end
local function viewEgg(r, info)
    local pos = eggPosition(r)
    if not pos then
        notify("warn", "⚠️ Can't Locate Egg", "The egg couldn't be located in this server.")
        return
    end
    startView(pos, info)
end

-- centre popup shown when the egg is found
local function foundPopup(t, onYes)
    local g = getNotifGui()
    local f = new("Frame", { Size = UDim2.fromOffset(320, 184), AnchorPoint = Vector2.new(.5, .5), Position = UDim2.fromScale(.5, .5), BackgroundColor3 = C.white, BorderSizePixel = 0, Active = true }, g)
    round(f, 16); grad(f, Color3.fromRGB(10, 26, 58), Color3.fromRGB(2, 4, 9), 135); stroke(f, C.c, 2, .1)
    local sc = new("UIScale", { Scale = .8 }, f)
    TS:Create(sc, TweenInfo.new(.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
    local title = T(f, "🥚 Egg Found!", 22, C.white, Enum.Font.GothamBlack, { Position = UDim2.fromOffset(0, 14), Size = UDim2.new(1, 0, 0, 28), TextXAlignment = Enum.TextXAlignment.Center })
    grad(title, C.p, C.c, 0)
    T(f, tostring(t.name) .. " is in this server.", 13, C.txt, Enum.Font.GothamBold, { Position = UDim2.fromOffset(16, 52), Size = UDim2.new(1, -32, 0, 20), TextXAlignment = Enum.TextXAlignment.Center, TextTruncate = Enum.TextTruncate.AtEnd })
    T(f, "Do you want to view it?", 12, C.sub, Enum.Font.Gotham, { Position = UDim2.fromOffset(16, 76), Size = UDim2.new(1, -32, 0, 18), TextXAlignment = Enum.TextXAlignment.Center })
    local yes = B(f, "Yes, View", 13, C.p, C.white, { Size = UDim2.new(.5, -22, 0, 38), Position = UDim2.fromOffset(16, 108) }, 10)
    local no = B(f, "No, Thanks", 13, C.card2, C.txt, { Size = UDim2.new(.5, -22, 0, 38), Position = UDim2.new(.5, 6, 0, 108) }, 10)
    hover(yes, C.p, C.c); hover(no, C.card2, C.bad)
    local track = new("Frame", { Size = UDim2.new(1, -32, 0, 4), Position = UDim2.new(0, 16, 1, -16), BackgroundColor3 = C.card2, BorderSizePixel = 0 }, f); round(track, 2)
    local fill = new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = C.c, BorderSizePixel = 0 }, track); round(fill, 2)
    TS:Create(fill, TweenInfo.new(NOTIFY_TIME, Enum.EasingStyle.Linear), { Size = UDim2.fromScale(0, 1) }):Play()
    local closed = false
    local function close() if closed then return end closed = true; f:Destroy() end
    yes.MouseButton1Click:Connect(function() close(); onYes() end)
    no.MouseButton1Click:Connect(close)
    task.delay(NOTIFY_TIME, close)
end

-- runs ONLY in the new server after JOIN + auto execute
local function runPendingCheck(t)
    -- wait until our character has loaded into the new server before searching
    if not LP.Character then LP.CharacterAdded:Wait() end
    LP.Character:WaitForChild("HumanoidRootPart", 15)
    task.wait(1)
    local found
    for _ = 1, 8 do
        found = findTargetEgg(t)
        if found then break end
        task.wait(1.5)
    end
    if found then
        notify("ok", "🥚 Egg Found!", tostring(t.name) .. "  •  " .. tostring(t.rarity) .. (t.value and ("  •  " .. tostring(t.value)) or ""))
        foundPopup(t, function() viewEgg(found, t) end)
    else
        notify("warn", "⚠️ Egg Not Here", tostring(t.name) .. " is no longer in this server.")
        reportGone(t)
    end
end

-- ===== EGG DETECTOR (background, webhook only - no GUI) =====
local function startEggDetector()
	local CONFIG = {
		WebhookUrl = WEBHOOK_PRIVATE,
		PublicWebhookUrl = WEBHOOK_PUBLIC,
		PublicMinValue = PUBLIC_MIN_VALUE,
		ScanInterval = SCAN_INTERVAL,
	}
	local Players           = game:GetService("Players")
	local HttpService       = game:GetService("HttpService")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")

	local LocalPlayer = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait() and Players.LocalPlayer

	-- persistent state across re-executions (same executor session)
	local genv = (getgenv and getgenv()) or _G
	genv.__sx_state = genv.__sx_state or { Gen = 0, JobId = nil, LastScan = 0, Seen = {} }
	local State = genv.__sx_state
	State.Known = State.Known or {}
	State.Attempts = State.Attempts or {}
	State.LastScan = State.LastScan or 0
	if State.SessionDone == nil then State.SessionDone = true end
	State.Gen = State.Gen + 1
	local myGen = State.Gen

	-- ============================================================
	-- BACKGROUND EGG DETECTOR
	-- ============================================================

	local MIN_SCAN_TIME = 8      -- minimum seconds before a scan session may finish
	local STABLE_SCANS  = 3      -- scans in a row with no new egg = session complete
	local MAX_SCAN_TIME = 40     -- safety limit for one session
	local SCAN_STEP     = 2      -- seconds between scans inside a session
	local SEND_GAP      = 0.45   -- seconds between webhook posts (discord rate limit)
	local MAX_ATTEMPTS  = 3      -- webhook tries per egg before giving up on it
	local EGG_REMOTE    = "RF/EggWorld/AskFieldEggSnapshot"

	local warned = {}
	local function warnOnce(tag, msg)
		if warned[tag] then return end
		warned[tag] = true
		warn("[sx] " .. msg)
	end

	local env = {}

	local function loadEnv()
		if env.ready then return true end
		pcall(function()
			env.Assets = require(ReplicatedStorage:WaitForChild("Data", 15):WaitForChild("Assets", 15))
		end)
		pcall(function()
			env.Mutations = require(ReplicatedStorage:WaitForChild("Shared", 15):WaitForChild("Modules", 15):WaitForChild("Mutations", 15))
		end)
		pcall(function()
			env.Networking = ReplicatedStorage:WaitForChild("Packages", 15):WaitForChild("Networking", 15)
		end)
		env.ready = env.Assets ~= nil
		return env.ready
	end

	local function findRemote()
		local r = env.Networking and env.Networking:FindFirstChild(EGG_REMOTE)
		if r then return r end
		return ReplicatedStorage:FindFirstChild(EGG_REMOTE, true)
	end

	local function getScaleMultiplier(scale)
		scale = tonumber(scale) or 1
		if scale <= 5 then
			return scale ^ 1.85
		end
		return (scale / 5) ^ 1.2 * 19.637875755794113
	end

	local function formatMoney(value)
		local units = {
			{ 1e12, "T" },
			{ 1e9, "B" },
			{ 1e6, "M" },
			{ 1e3, "K" },
		}
		for _, unit in ipairs(units) do
			if value >= unit[1] then
				return string.format("$%.2f%s/s", value / unit[1], unit[2])
			end
		end
		return string.format("$%d/s", math.floor(value + 0.5))
	end

	local function getSizeName(scale)
		scale = tonumber(scale) or 1
		if scale >= 100 then
			return "Titanic"
		elseif scale >= 30 then
			return "Large"
		elseif scale >= 10 then
			return "Medium"
		end
		return "Small"
	end

	-- returns a table keyed by egg uid, or nil when the snapshot could not be read
	local function getEggs()
		if not loadEnv() then
			warnOnce("env", "game data modules not found (ReplicatedStorage.Data.Assets)")
			return nil
		end

		local remote = findRemote()
		if not remote then
			warnOnce("noremote", "egg remote not found: " .. EGG_REMOTE)
			return nil
		end

		local ok, result = pcall(function() return remote:InvokeServer() end)
		if not ok or type(result) ~= "table" or type(result.Records) ~= "table" then
			warnOnce("snap", "could not read egg snapshot: " .. tostring(result))
			return nil
		end

		local directory = env.Assets.Directory
		local currentEggs = {}
		local playerCount, maxPlayers = #Players:GetPlayers(), Players.MaxPlayers

		for _, record in pairs(result.Records) do
			if record.State == "Slot" or record.State == "Dropped" then
				local entry = directory and directory[tostring(record.AssetCategory)]
				if entry then
					local icon = ""
					if entry.Icon and tostring(entry.Icon) ~= "" then
						icon = tonumber(entry.Icon) and ("rbxassetid://" .. entry.Icon) or tostring(entry.Icon)
					end

					local mutation = 1
					if env.Mutations and type(env.Mutations.EarningsFor) == "function" then
						local okM, resM = pcall(
							env.Mutations.EarningsFor,
							type(record.Mutations) == "table" and record.Mutations or {}
						)
						if okM and type(resM) == "number" then
							mutation = resM
						end
					end

					local scale = tonumber(record.AssetScale) or 1
					local value = (tonumber(entry.EarningRate) or 0) * getScaleMultiplier(scale) * mutation

					currentEggs[tostring(record.Uid or record.AssetCategory)] = {
						name = tostring(entry.DisplayName or record.AssetCategory),
						serverId = game.JobId,
						rarity = entry.Rarity and tostring(entry.Rarity.DisplayName or entry.Rarity.Name) or "Unknown",
						sizeName = getSizeName(scale),
						scale = scale,
						value = formatMoney(value),
						valueNum = value,
						image = icon,
						players = playerCount,
						maxPlayers = maxPlayers,
					}
				end
			end
		end

		return currentEggs
	end

	-- ============================================================
	-- WEBHOOKS
	-- ============================================================

	local function httpRequest(opts)
		local fn = (syn and syn.request) or (http and http.request) or http_request or request or (fluxus and fluxus.request)
		if not fn then return nil end
		return fn(opts)
	end

	local function postJson(url, payload, label)
		if type(url) ~= "string" or not url:find("^https?://") then
			warnOnce("url" .. label, label .. " webhook url not set")
			return false
		end

		local body = HttpService:JSONEncode(payload)
		for attempt = 1, 3 do
			local ok, res = pcall(httpRequest, {
				Url = url,
				Method = "POST",
				Headers = { ["Content-Type"] = "application/json" },
				Body = body,
			})
			if not ok then
				warn("[sx] " .. label .. " webhook failed: " .. tostring(res))
				return false
			end
			if res == nil then
				warnOnce("nohttp", "executor has no http request function (syn.request / request / http_request)")
				return false
			end

			local code = tonumber(type(res) == "table" and (res.StatusCode or res.Status) or nil)
			if code == 429 and attempt < 3 then
				local wait = 2.5
				pcall(function()
					local d = HttpService:JSONDecode(res.Body)
					if d and tonumber(d.retry_after) then wait = tonumber(d.retry_after) + 0.25 end
				end)
				task.wait(wait) -- rate limited, honor retry_after
			elseif code and code >= 400 then
				warn("[sx] " .. label .. " webhook returned " .. tostring(code) .. " " .. tostring(res.Body))
				return false
			else
				return true
			end
		end
		return false
	end

	-- private: raw egg json, one egg per message
	local function pushPrivate(egg)
		return postJson(CONFIG.WebhookUrl, {
			content = "EGG",
			embeds = {{
				title = "New Egg Found",
				description = HttpService:JSONEncode({ egg }),
			}},
		}, "private")
	end

	-- public: readable card with a join link, only for eggs at or above PublicMinValue
	local function pushPublic(egg)
		local joinLink = string.format(
			"https://www.roblox.com/games/start?placeId=%s&gameInstanceId=%s",
			tostring(game.PlaceId),
			tostring(egg.serverId or "")
		)

		return postJson(CONFIG.PublicWebhookUrl, {
			embeds = {{
				title = tostring(egg.name or "Unknown Egg"),
				description = string.format(
					"**Rarity:** %s\n**KG/Size:** %s (%.1f)\n**Money:** %s\n**Players:** %s/%s",
					tostring(egg.rarity or "Unknown"),
					tostring(egg.sizeName or "Small"),
					tonumber(egg.scale) or 1,
					tostring(egg.value or "$0/s"),
					tostring(egg.players or "?"),
					tostring(egg.maxPlayers or "?")
				),
				url = joinLink,
				color = 16766720,
				fields = {{
					name = "JOIN SERVER",
					value = joinLink,
					inline = false,
				}},
				footer = { text = "CAT HUB • Egg Detector" },
			}},
		}, "public")
	end

	-- ============================================================
	-- SCAN SESSIONS
	-- ============================================================

	-- returns how many NEW eggs showed up, or nil when the snapshot was unreadable
	local function scanOnce(myGen)
		local eggs = getEggs()
		if not eggs then return nil end

		local added = 0
		for uid, egg in pairs(eggs) do
			if State.Gen ~= myGen then return added end
			if not State.Known[uid] then
				if State.Attempts[uid] == nil then added = added + 1 end
				local tries = (State.Attempts[uid] or 0) + 1
				State.Attempts[uid] = tries

				local okPrivate = pushPrivate(egg)
				task.wait(SEND_GAP)

				local okPublic = true
				if (egg.valueNum or 0) >= CONFIG.PublicMinValue then
					okPublic = pushPublic(egg)
					task.wait(SEND_GAP)
				end

				-- failed sends are retried on the next scan, up to MAX_ATTEMPTS
				if (okPrivate and okPublic) or tries >= MAX_ATTEMPTS then
					State.Known[uid] = true
				end
			end
		end
		return added
	end

	-- keeps scanning until no new egg appears for several scans in a row
	-- returns true when at least one snapshot was read
	local function scanSession(myGen)
		local startTime, stable, reached = tick(), 0, false
		while State.Gen == myGen do
			local added = scanOnce(myGen)
			if added ~= nil then reached = true end
			stable = ((added or 0) == 0) and (stable + 1) or 0

			local elapsed = tick() - startTime
			if elapsed >= MAX_SCAN_TIME or (elapsed >= MIN_SCAN_TIME and stable >= STABLE_SCANS) then
				break
			end
			task.wait(SCAN_STEP)
		end

		local count = 0
		for _ in pairs(State.Known) do count = count + 1 end
		print("[sx] scan finished, eggs tracked: " .. count)
		return reached
	end

	local function nextResetBoundary(fromTime)
		-- Strictly next wall-clock boundary: :00, :05, :10, :15, etc.
		return (math.floor((tonumber(fromTime) or os.time()) / CONFIG.ScanInterval) + 1) * CONFIG.ScanInterval
	end

	task.spawn(function()
		local sameServer = State.JobId == game.JobId
		local reexecuted = sameServer and (State.HasStarted == true or State.LastScan > 0)

		-- A new server gets an initial scan. Re-execution in the same server
		-- waits for the next real 5-minute boundary before scanning again.
		if not sameServer then
			State.JobId = game.JobId
			State.Known = {}
			State.Attempts = {}
			State.LastScan = 0
			State.SessionDone = true
		end

		local firstCycle = true
		local nextCycleAt = reexecuted and nextResetBoundary(os.time()) or nil

		while State.Gen == myGen do
			if nextCycleAt then
				while State.Gen == myGen and os.time() < nextCycleAt do
					task.wait(math.min(1, math.max(0.1, nextCycleAt - os.time())))
				end
				if State.Gen ~= myGen then break end
				-- New five-minute cycle: clear duplicate suppression so current
				-- eggs can be sent again after the API's matching reset.
				State.Known = {}
				State.Attempts = {}
			elseif firstCycle and not reexecuted then
				task.wait(5) -- initial field-load grace period only
				if State.Gen ~= myGen then break end
			end

			State.SessionDone = false
			local cycleStartedAt = os.time()
			State.HasStarted = true
			State.LastScan = cycleStartedAt
			local ok, reached = pcall(scanSession, myGen)
			if State.Gen ~= myGen then break end

			State.SessionDone = true
			if not ok then warnOnce("scanerr", "scan error: " .. tostring(reached)) end
			firstCycle = false

			if not ok or not reached then
				-- An unreadable snapshot must not consume the five-minute cycle.
				State.LastScan = 0
				for _ = 1, 15 do
					if State.Gen ~= myGen then break end
					task.wait(1)
				end
				if State.Gen ~= myGen then break end
				nextCycleAt = nil -- retry without waiting for the next boundary
			else
				-- Anchor the next cycle to the wall clock, not scan completion,
				-- so a scan that crosses 12:15 still catches the 12:15 reset.
				nextCycleAt = nextResetBoundary(cycleStartedAt)
				if nextCycleAt <= os.time() then
					nextCycleAt = nextResetBoundary(os.time())
				end
			end
		end
	end)


end

-- ===== KEY GUI =====
local loadMainUI
local function showKeyGui()
    local g = new("ScreenGui", { Name = "CatHubKey", ResetOnSpawn = false, DisplayOrder = 999 }, guiParent())
    local f = new("Frame", { Size = UDim2.fromOffset(320, 300), AnchorPoint = Vector2.new(.5, .5), Position = UDim2.fromScale(.5, .5), BackgroundColor3 = C.white, BorderSizePixel = 0, Active = true }, g)
    round(f, 16); grad(f, Color3.fromRGB(10, 26, 58), Color3.fromRGB(2, 4, 9), 135)
    local st = stroke(f, C.white, 2)
    new("UIGradient", { Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, C.p), ColorSequenceKeypoint.new(.5, C.c), ColorSequenceKeypoint.new(1, C.pk) }) }, st)
    drag(f, f)
    local t = T(f, "🐱 CAT HUB", 24, C.white, Enum.Font.GothamBlack, { Size = UDim2.new(1, 0, 0, 30), Position = UDim2.fromOffset(0, 18), TextXAlignment = Enum.TextXAlignment.Center })
    grad(t, C.p, C.c, 0)
    T(f, "ENTER YOUR KEY TO CONTINUE", 10, C.sub, Enum.Font.GothamBold, { Size = UDim2.new(1, 0, 0, 14), Position = UDim2.fromOffset(0, 50), TextXAlignment = Enum.TextXAlignment.Center })
    local input = box(f, "Enter key here...", { Size = UDim2.new(1, -40, 0, 38), Position = UDim2.fromOffset(20, 80) })
    local status = T(f, "", 10, C.bad, Enum.Font.Gotham, { Size = UDim2.new(1, -40, 0, 14), Position = UDim2.fromOffset(20, 122) })
    local submit = B(f, "Verify Key", 13, C.p, C.white, { Size = UDim2.new(1, -40, 0, 38), Position = UDim2.fromOffset(20, 144) }, 10)
    hover(submit, C.p, Color3.fromRGB(96, 165, 250))
    local dc = B(f, "💬  Join Discord to Get Key", 12, Color3.fromRGB(88, 101, 242), C.white, { Size = UDim2.new(1, -40, 0, 38), Position = UDim2.fromOffset(20, 198) }, 10)
    dc.MouseButton1Click:Connect(function()
        pcall(function() setclipboard(DISCORD_LINK) end)
        dc.Text = "✔  Copied!"; task.wait(2); dc.Text = "💬  Join Discord to Get Key"
    end)
    T(f, "Get your key in our Discord", 9, C.sub, Enum.Font.Gotham, { Size = UDim2.new(1, 0, 0, 14), Position = UDim2.new(0, 0, 1, -26), TextXAlignment = Enum.TextXAlignment.Center })
    submit.MouseButton1Click:Connect(function()
        local valid = false
        for _, k in ipairs(KEYS) do if input.Text == k then valid = true end end
        if valid then
            status.Text = "Key accepted! Loading..."; status.TextColor3 = C.ok
            task.wait(.8); g:Destroy(); loadMainUI()
        else
            status.Text = "Invalid key. Try again."; status.TextColor3 = C.bad; input.Text = ""
        end
    end)
end

-- ===== MAIN GUI =====
loadMainUI = function(startMinimized)
    local gui = new("ScreenGui", { Name = "CatHub", ResetOnSpawn = false, DisplayOrder = 999, ZIndexBehavior = Enum.ZIndexBehavior.Sibling }, guiParent())
    if DETECTOR_ENABLED then task.spawn(startEggDetector) end
    local main = new("Frame", { Size = UDim2.fromOffset(750, 480), AnchorPoint = Vector2.new(.5, .5), Position = UDim2.fromScale(.5, .5), BackgroundColor3 = C.white, BorderSizePixel = 0, Active = true }, gui)
    round(main, 16); grad(main, Color3.fromRGB(10, 26, 58), Color3.fromRGB(2, 4, 9), 135)
    local cam = workspace.CurrentCamera
    local vp = cam and cam.ViewportSize or Vector2.new(800, 600)
    local sc = new("UIScale", { Scale = math.min(1, math.max(280, vp.X - 20) / 750, math.max(240, vp.Y - 24) / 480) }, main)
    if IS_MOBILE then sc.Scale = math.min(sc.Scale, .9) end
    local ms = stroke(main, C.white, 2)
    local mg = new("UIGradient", { Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, C.p), ColorSequenceKeypoint.new(.5, C.c), ColorSequenceKeypoint.new(1, C.pk) }) }, ms)
    task.spawn(function() while gui.Parent do mg.Rotation = (mg.Rotation + 1.5) % 360; task.wait(.03) end end)

    -- header
    local head = new("Frame", { Size = UDim2.new(1, 0, 0, 48), BackgroundTransparency = 1, Active = true }, main)
    drag(head, main)
    local logo = T(head, "🐱 CAT HUB", 20, C.white, Enum.Font.GothamBlack, { Position = UDim2.fromOffset(16, 6), Size = UDim2.fromOffset(200, 26) })
    grad(logo, C.p, C.c, 0)
    T(head, "EGG DETECTOR  •  v5", 9, C.sub, Enum.Font.GothamBold, { Position = UDim2.fromOffset(18, 30), Size = UDim2.fromOffset(200, 12) })
    local pillH = new("Frame", { Size = UDim2.fromOffset(104, 24), Position = UDim2.new(1, -190, 0, 12), BackgroundColor3 = C.card2, BorderSizePixel = 0 }, head)
    round(pillH, 12); local pillSt = stroke(pillH, C.warn, 1, .3)
    local hDot = new("Frame", { Size = UDim2.fromOffset(8, 8), Position = UDim2.fromOffset(10, 8), BackgroundColor3 = C.warn, BorderSizePixel = 0 }, pillH); round(hDot, 4); pulse(hDot)
    local hTxt = T(pillH, "CONNECTING", 9, C.warn, Enum.Font.GothamBold, { Position = UDim2.fromOffset(24, 0), Size = UDim2.new(1, -28, 1, 0) })
    local minBtn = B(head, "–", 16, C.card2, C.txt, { Size = UDim2.fromOffset(30, 30), Position = UDim2.new(1, -76, 0, 9) }, 9)
    local closeBtn = B(head, "✕", 13, C.card2, C.txt, { Size = UDim2.fromOffset(30, 30), Position = UDim2.new(1, -40, 0, 9) }, 9)
    hover(minBtn, C.card2, C.p); hover(closeBtn, C.card2, C.bad)

    local mini = new("ImageButton", { Size = UDim2.fromOffset(64, 64), Position = UDim2.fromOffset(24, 90), BackgroundColor3 = C.bg, Image = "rbxthumb://type=Asset&id=85043883236326&w=420&h=420", Visible = false, ZIndex = 40, Active = true }, gui)
    round(mini, 32); stroke(mini, C.p, 3); drag(mini, mini)
    closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)
    minBtn.MouseButton1Click:Connect(function() main.Visible = false; mini.Visible = true end)
    local wasVisible = true
    viewHooks.hide = function() wasVisible = main.Visible; main.Visible = false end
    viewHooks.show = function() main.Visible = wasVisible end
    if startMinimized then main.Visible = false; mini.Visible = true end
    mini.MouseButton1Click:Connect(function()
        if mini:GetAttribute("moved") then mini:SetAttribute("moved", false) return end
        mini.Visible = false; main.Visible = true
    end)

    -- sidebar
    local side = new("Frame", { Size = UDim2.new(0, 150, 1, -58), Position = UDim2.fromOffset(10, 52), BackgroundColor3 = C.side, BorderSizePixel = 0 }, main)
    round(side, 12); stroke(side, C.p, 1, .7)
    local tabs = {}
    local function mkTab(key, txt, y)
        local b = B(side, txt, 12, C.card2, C.sub, { Size = UDim2.new(1, -20, 0, 40), Position = UDim2.fromOffset(10, y), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left }, 10)
        new("UIPadding", { PaddingLeft = UDim.new(0, 16) }, b)
        local bar = new("Frame", { Size = UDim2.new(0, 4, .6, 0), Position = UDim2.new(0, -10, .2, 0), BackgroundColor3 = C.pk, BorderSizePixel = 0, Visible = false }, b); round(bar, 2)
        tabs[key] = { b = b, bar = bar }
        return b
    end
    local tbHome, tbAuto, tbLive, tbServ = mkTab("Home", "🏠   Home", 12), mkTab("Auto", "⚡   Auto Join", 58), mkTab("Live", "🥚   Live Eggs", 104), mkTab("Serv", "🖥   Server", 150)
    local dcBtn = B(side, "💬  Discord", 11, Color3.fromRGB(88, 101, 242), C.white, { Size = UDim2.new(1, -20, 0, 34), Position = UDim2.new(0, 10, 1, -46) }, 10)
    dcBtn.MouseButton1Click:Connect(function()
        pcall(function() setclipboard(DISCORD_LINK) end)
        dcBtn.Text = "✔  Link copied"; task.wait(2); dcBtn.Text = "💬  Discord"
    end)

    -- pages
    local function mkPage()
        local f = new("Frame", { Size = UDim2.new(1, -180, 1, -58), Position = UDim2.fromOffset(170, 52), BackgroundColor3 = C.card, BorderSizePixel = 0, Visible = false, ClipsDescendants = true }, main)
        round(f, 12); stroke(f, C.p, 1, .7)
        return f
    end
    local function mkCard(p, y, h)
        local c = new("Frame", { Size = UDim2.new(1, -28, 0, h), Position = UDim2.fromOffset(14, y), BackgroundColor3 = C.card2, BorderSizePixel = 0 }, p)
        round(c, 10); stroke(c, C.p, 1, .75)
        return c
    end
    local fHome, fAuto, fLive, fServ = mkPage(), mkPage(), mkPage(), mkPage()
    local function scroller(p, pos, size)
        local s = new("ScrollingFrame", { Position = pos, Size = size, BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = C.p, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y }, p)
        new("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, s)
        return s
    end

    -- HOME
    local hero = mkCard(fHome, 14, 88)
    local ht = T(hero, "Welcome to Cat Hub", 18, C.white, Enum.Font.GothamBlack, { Position = UDim2.fromOffset(16, 10), Size = UDim2.new(1, -32, 0, 24) }); grad(ht, C.p, C.c, 0)
    T(hero, "Live egg discoveries, rarity tracking and value ranking — all in one place.", 11, C.sub, Enum.Font.Gotham, { Position = UDim2.fromOffset(16, 38), Size = UDim2.new(1, -32, 0, 36), TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Top })
    local statRow = new("Frame", { Size = UDim2.new(1, -28, 0, 78), Position = UDim2.fromOffset(14, 114), BackgroundTransparency = 1 }, fHome)
    new("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 10) }, statRow)
    local function tile(cap)
        local t = new("Frame", { Size = UDim2.new(1 / 3, -7, 1, 0), BackgroundColor3 = C.card2, BorderSizePixel = 0 }, statRow)
        round(t, 10); stroke(t, C.p, 1, .75)
        local v = T(t, "—", 20, C.txt, Enum.Font.GothamBlack, { Position = UDim2.fromOffset(14, 12), Size = UDim2.new(1, -28, 0, 28), TextTruncate = Enum.TextTruncate.AtEnd })
        T(t, cap, 9, C.sub, Enum.Font.GothamBold, { Position = UDim2.fromOffset(14, 46), Size = UDim2.new(1, -28, 0, 14) })
        return v
    end
    local statLive, statTop, statApi = tile("LIVE EGGS"), tile("TOP VALUE"), tile("API STATUS")
    local tips = mkCard(fHome, 204, 112)
    T(tips, "HOW IT WORKS", 11, C.c, Enum.Font.GothamBold, { Position = UDim2.fromOffset(16, 10), Size = UDim2.new(1, -32, 0, 16) })
    T(tips, "1.  Open Live Eggs to watch detections in real time.\n2.  Pick a rarity + minimum KG in Auto Join.\n3.  Tap JOIN on any egg to jump into its server.", 11, C.sub, Enum.Font.Gotham, { Position = UDim2.fromOffset(16, 32), Size = UDim2.new(1, -32, 0, 70), TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Top })

    -- chips
    local function chipGroup(parent, items, default, onSel)
        local chips = {}
        local function sel(n)
            for k, b in pairs(chips) do
                local on = (k == n)
                tween(b, .12, { BackgroundColor3 = on and rcol(k ~= "Any" and k or nil) or C.card })
                b.TextColor3 = on and C.white or C.sub
            end
            onSel(n)
        end
        for _, n in ipairs(items) do
            local b = B(parent, n, 11, C.card, C.sub, { AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromOffset(0, 26) }, 13)
            new("UIPadding", { PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12) }, b)
            chips[n] = b
            b.MouseButton1Click:Connect(function() sel(n) end)
        end
        return function() sel(default) end
    end

    -- AUTO JOIN
    local autoRarity, snipe = "Any", false
    local rcard = mkCard(fAuto, 14, 104)
    T(rcard, "TARGET RARITY", 11, C.c, Enum.Font.GothamBold, { Position = UDim2.fromOffset(16, 10), Size = UDim2.new(1, -32, 0, 16) })
    local rchips = new("Frame", { Position = UDim2.fromOffset(16, 34), Size = UDim2.new(1, -32, 0, 62), BackgroundTransparency = 1 }, rcard)
    new("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Wraps = true, Padding = UDim.new(0, 6) }, rchips)
    chipGroup(rchips, RAR_LIST, "Any", function(n) autoRarity = n end)()
    local kcard = mkCard(fAuto, 132, 76)
    T(kcard, "MINIMUM KG", 11, C.c, Enum.Font.GothamBold, { Position = UDim2.fromOffset(16, 8), Size = UDim2.new(1, -32, 0, 16) })
    local kBox = box(kcard, "1000 or 1k", { Size = UDim2.new(1, -32, 0, 32), Position = UDim2.fromOffset(16, 32) })
    local tcard = mkCard(fAuto, 222, 76)
    T(tcard, "AUTO JOIN", 14, C.txt, Enum.Font.GothamBlack, { Position = UDim2.fromOffset(16, 12), Size = UDim2.new(1, -100, 0, 20) })
    local autoStatus = T(tcard, "Auto join is off", 11, C.sub, Enum.Font.Gotham, { Position = UDim2.fromOffset(16, 38), Size = UDim2.new(1, -100, 0, 28), TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Top })
    local tgBtn = new("TextButton", { Text = "", AutoButtonColor = false, Size = UDim2.fromOffset(54, 28), AnchorPoint = Vector2.new(1, .5), Position = UDim2.new(1, -16, .5, 0), BackgroundColor3 = C.card, BorderSizePixel = 0 }, tcard)
    round(tgBtn, 14); local tgSt = stroke(tgBtn, C.sub, 2)
    local knob = new("Frame", { Size = UDim2.fromOffset(20, 20), Position = UDim2.fromOffset(4, 4), BackgroundColor3 = C.sub, BorderSizePixel = 0 }, tgBtn); round(knob, 10)
    local function setToggle(on)
        snipe = on
        tween(knob, .18, { Position = on and UDim2.fromOffset(30, 4) or UDim2.fromOffset(4, 4), BackgroundColor3 = on and C.ok or C.sub })
        tween(tgBtn, .18, { BackgroundColor3 = on and Color3.fromRGB(14, 60, 34) or C.card })
        tgSt.Color = on and C.ok or C.sub
        autoStatus.Text = on and "Watching the live feed for a match…" or "Auto join is off"
    end
    tgBtn.MouseButton1Click:Connect(function() setToggle(not snipe) end)

    -- LIVE
    local sBox = box(fLive, "Search by egg name...", { Size = UDim2.new(1, -128, 0, 34), Position = UDim2.fromOffset(14, 12) })
    local refBtn = B(fLive, "⟳  Refresh", 11, C.p, C.white, { Size = UDim2.fromOffset(92, 34), Position = UDim2.new(1, -106, 0, 12) }, 8)
    hover(refBtn, C.p, Color3.fromRGB(96, 165, 250))
    local chipScroll = new("ScrollingFrame", { Position = UDim2.fromOffset(14, 54), Size = UDim2.new(1, -28, 0, 30), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 0, ScrollingDirection = Enum.ScrollingDirection.X, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.X }, fLive)
    new("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 6), VerticalAlignment = Enum.VerticalAlignment.Center }, chipScroll)
    local liveDot = new("Frame", { Size = UDim2.fromOffset(8, 8), Position = UDim2.fromOffset(16, 98), BackgroundColor3 = C.warn, BorderSizePixel = 0 }, fLive); round(liveDot, 4); pulse(liveDot)
    local lTxt = T(fLive, "LIVE  •  CONNECTING", 10, C.warn, Enum.Font.GothamBold, { Position = UDim2.fromOffset(30, 90), Size = UDim2.new(1, -164, 0, 24), TextTruncate = Enum.TextTruncate.AtEnd })
    local totalEggLabel = T(fLive, "TOTAL EGGS: 0", 10, C.white, Enum.Font.GothamBlack, { AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -14, 0, 90), Size = UDim2.fromOffset(124, 24), TextXAlignment = Enum.TextXAlignment.Right, TextTruncate = Enum.TextTruncate.AtEnd })
    local lScr = scroller(fLive, UDim2.fromOffset(14, 118), UDim2.new(1, -28, 1, -128))

    -- SERVER
    local sScr = scroller(fServ, UDim2.fromOffset(14, 14), UDim2.new(1, -28, 1, -28))

    -- row builder
    local function mkRow(e, parent, showJoin, isNew)
        local col = rcol(e.rarity)
        local r = new("Frame", { Size = UDim2.new(1, -6, 0, 62), BackgroundColor3 = C.card2, BorderSizePixel = 0 }, parent)
        round(r, 12)
        local st = stroke(r, col, 1, .55)
        if isNew then st.Thickness = 2; st.Transparency = 0; tween(st, 1.6, { Thickness = 1, Transparency = .55 }) end
        local bar = new("Frame", { Size = UDim2.new(0, 4, 1, -20), Position = UDim2.fromOffset(0, 10), BackgroundColor3 = col, BorderSizePixel = 0 }, r); round(bar, 2)
        local tileF = new("Frame", { Size = UDim2.fromOffset(44, 44), Position = UDim2.fromOffset(12, 9), BackgroundColor3 = col, BackgroundTransparency = .82, BorderSizePixel = 0 }, r)
        round(tileF, 10); stroke(tileF, col, 1, .6)
        local imgId = normImg(e.image)
        if imgId ~= "" then
            new("ImageLabel", { Size = UDim2.new(1, -6, 1, -6), Position = UDim2.fromOffset(3, 3), BackgroundTransparency = 1, Image = imgId, ScaleType = Enum.ScaleType.Fit }, tileF)
        else
            T(tileF, "🥚", 24, C.white, Enum.Font.GothamBold, { Size = UDim2.fromScale(1, 1), TextXAlignment = Enum.TextXAlignment.Center })
        end
        T(r, e.name, 14, C.txt, Enum.Font.GothamBold, { Position = UDim2.fromOffset(66, 8), Size = UDim2.new(1, showJoin and -230 or -150, 0, 18), TextTruncate = Enum.TextTruncate.AtEnd })
        local line = new("Frame", { Position = UDim2.fromOffset(66, 32), Size = UDim2.new(1, showJoin and -230 or -150, 0, 18), BackgroundTransparency = 1 }, r)
        new("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 8), VerticalAlignment = Enum.VerticalAlignment.Center }, line)
        local pill = T(line, string.upper(e.rarity), 9, C.white, Enum.Font.GothamBold, { Size = UDim2.fromOffset(0, 16), AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 0, BackgroundColor3 = col, TextXAlignment = Enum.TextXAlignment.Center })
        round(pill, 8); new("UIPadding", { PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8) }, pill)
        local parts = {}
        if e.sizeName then table.insert(parts, tostring(e.sizeName)) elseif e.scale > 0 then table.insert(parts, compact(e.scale) .. " KG") end
        if e.players then table.insert(parts, "👥 " .. e.players .. (e.maxPlayers and ("/" .. e.maxPlayers) or "")) end
        if #parts > 0 then T(line, table.concat(parts, "  •  "), 10, C.sub, Enum.Font.GothamMedium, { Size = UDim2.fromOffset(0, 16), AutomaticSize = Enum.AutomaticSize.X }) end
        local v = T(r, e.value, 12, C.warn, Enum.Font.GothamBlack, { Size = UDim2.fromOffset(0, 24), AutomaticSize = Enum.AutomaticSize.X, AnchorPoint = Vector2.new(1, .5), Position = UDim2.new(1, showJoin and -84 or -14, .5, 0), BackgroundTransparency = .85, BackgroundColor3 = C.warn, TextXAlignment = Enum.TextXAlignment.Center })
        round(v, 12); new("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10) }, v)
        if showJoin then
            local j = B(r, "JOIN", 11, C.p, C.white, { Size = UDim2.fromOffset(62, 32), AnchorPoint = Vector2.new(1, .5), Position = UDim2.new(1, -10, .5, 0) }, 9)
            hover(j, C.p, Color3.fromRGB(96, 165, 250))
            j.MouseButton1Click:Connect(function()
                j.Text = joinServer(e) and "…" or "N/A"; task.wait(1.2); j.Text = "JOIN"
            end)
        end
    end

    -- live state
    local cache, seen, firstDone = {}, {}, false
    local selectedRarity = "Any"
    local lastErr
    local function setStatus(txt, col)
        lTxt.Text = txt; lTxt.TextColor3 = col; liveDot.BackgroundColor3 = col
        hDot.BackgroundColor3 = col; pillSt.Color = col; hTxt.TextColor3 = col
        hTxt.Text = (col == C.ok) and "LIVE" or ((col == C.bad) and "OFFLINE" or "CONNECTING")
    end
    local function matches(e)
        local q = string.lower(sBox.Text or "")
        return (q == "" or string.find(string.lower(e.name), q, 1, true) ~= nil)
            and (selectedRarity == "Any" or string.lower(e.rarity) == string.lower(selectedRarity))
    end
    local function redraw()
        for _, c in ipairs(lScr:GetChildren()) do if c:IsA("GuiObject") then c:Destroy() end end
        local shown = 0
        for _, e in ipairs(cache) do
            if matches(e) and shown < 60 then mkRow(e, lScr, true, e._new); shown += 1 end
            e._new = false
        end
        if shown == 0 then
            local empty = T(lScr, (#cache == 0) and ("No live eggs yet.\n" .. (lastErr and ("Reason: " .. lastErr) or "Waiting for the detector…")) or "No eggs match this search / filter.", 12, C.sub, Enum.Font.Gotham, { Size = UDim2.new(1, -6, 0, 60), BackgroundTransparency = 0, BackgroundColor3 = C.card2, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Center })
            round(empty, 10)
        end
    end
    chipGroup(chipScroll, RAR_LIST, "Any", function(n) selectedRarity = n; redraw() end)()
    sBox:GetPropertyChangedSignal("Text"):Connect(redraw)

    -- server snapshot
    local function getMyEggs()
        local t = {}
        for _, r in ipairs(snapshot()) do
            local earning = (tonumber(r.entry.EarningRate) or 0) * (r.scale ^ 1.5)
            table.insert(t, { name = r.name, rarity = r.rarity, scale = r.scale, valueNum = earning, value = "$" .. compact(earning) .. "/s", image = tostring(r.entry.Icon or "") })
        end
        table.sort(t, function(a, b) return a.valueNum > b.valueNum end)
        return t
    end
    local function refreshServ()
        for _, c in ipairs(sScr:GetChildren()) do if c:IsA("GuiObject") then c:Destroy() end end
        local eggs = getMyEggs()
        for _, e in ipairs(eggs) do mkRow(e, sScr, false, false) end
        if #eggs == 0 then
            round(T(sScr, "No eggs found in this server snapshot.", 12, C.sub, Enum.Font.Gotham, { Size = UDim2.new(1, -6, 0, 52), BackgroundTransparency = 0, BackgroundColor3 = C.card2, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Center }), 10)
        end
    end

    -- auto join check
    local function checkSnipe()
        if not snipe then return end
        local minKg = parseKg(kBox.Text)
        for _, e in ipairs(cache) do
            local okR = autoRarity == "Any" or string.lower(e.rarity) == string.lower(autoRarity)
            local okK = minKg == 0 or e.scale >= minKg
            if okR and okK and e.serverId and tostring(e.serverId) ~= game.JobId then
                setToggle(false)
                autoStatus.Text = "Found " .. e.name .. " — joining…"
                joinServer(e)
                return
            end
        end
    end

    -- fetch
    local fetching = false
    local lastRenderSignature = nil
    local function fetchLive(manual)
        if fetching then return end
        fetching = true
        local ok, err = pcall(function()
            if manual or #cache == 0 then setStatus("LIVE  •  syncing egg feed…", C.warn) end
            local requestStarted = os.clock()
            local list, e = pullEggs()
            local requestSeconds = os.clock() - requestStarted
            if not list then
                lastErr = e
                setStatus("API ERROR  •  " .. tostring(e), C.bad)
                statApi.Text = "ERROR"; statApi.TextColor3 = C.bad
                redraw()
                return
            end
            lastErr = nil
            local out = {}
            for _, raw in ipairs(list) do
                local n = normalize(raw)
                if n and not goneSet[goneKey(n)] then
                    local k = tostring(n.serverId or "") .. "|" .. n.name .. "|" .. tostring(n.valueNum)
                    n._new = firstDone and not seen[k]
                    seen[k] = true
                    table.insert(out, n)
                end
            end
            table.sort(out, function(a, b) return a.valueNum > b.valueNum end)
            local sigParts = {}
            for _, egg in ipairs(out) do
                table.insert(sigParts, table.concat({
                    tostring(egg.serverId or ""), tostring(egg.name or ""),
                    tostring(egg.rarity or ""), tostring(egg.scale or ""),
                    tostring(egg.valueNum or ""), tostring(egg.image or "")
                }, "|"))
            end
            local renderSignature = table.concat(sigParts, "\n")
            local dataChanged = renderSignature ~= lastRenderSignature
            cache = out; firstDone = true
            lastRenderSignature = renderSignature
            setStatus(("LIVE  •  %d eggs  •  API %.2fs  •  %s"):format(#cache, requestSeconds, os.date("%H:%M:%S")), C.ok)
            statLive.Text = tostring(#cache)
            totalEggLabel.Text = "TOTAL EGGS: " .. tostring(#cache)
            statTop.Text = cache[1] and cache[1].value or "—"
            statApi.Text = "ONLINE"; statApi.TextColor3 = C.ok
            if dataChanged then redraw() end
            checkSnipe()
        end)
        if not ok then setStatus("SCRIPT ERROR  •  " .. tostring(err), C.bad) end
        fetching = false
    end
    uiHooks.removeEgg = function(t)
        local k = goneKey(t)
        for i = #cache, 1, -1 do
            if goneKey(cache[i]) == k then table.remove(cache, i) end
        end
        statLive.Text = tostring(#cache)
        totalEggLabel.Text = "TOTAL EGGS: " .. tostring(#cache)
        statTop.Text = cache[1] and cache[1].value or "—"
        redraw()
    end
    refBtn.MouseButton1Click:Connect(function() task.spawn(fetchLive, true) end)

    -- tabs
    local pages = { Home = fHome, Auto = fAuto, Live = fLive, Serv = fServ }
    local function setTab(n)
        for k, p in pairs(pages) do p.Visible = (k == n) end
        for k, t in pairs(tabs) do
            local on = (k == n)
            tween(t.b, .15, { BackgroundTransparency = on and 0 or 1 })
            t.b.TextColor3 = on and C.txt or C.sub
            t.bar.Visible = on
        end
        if n == "Serv" then task.spawn(pcall, refreshServ) end
    end
    tbHome.MouseButton1Click:Connect(function() setTab("Home") end)
    tbAuto.MouseButton1Click:Connect(function() setTab("Auto") end)
    tbLive.MouseButton1Click:Connect(function() setTab("Live") end)
    tbServ.MouseButton1Click:Connect(function() setTab("Serv") end)
    setTab("Home")

    -- background poller (one request feeds Home, Live and Auto Join)
    task.spawn(function()
        while gui.Parent do
            fetchLive(false)
            task.wait(REFRESH)
        end
    end)

    -- Keep the Server tab fully working and refreshed independently, so its
    -- snapshot request cannot hold up the Live Eggs feed.
    task.spawn(function()
        while gui.Parent do
            if fServ.Visible then
                pcall(refreshServ)
            end
            task.wait(5)
        end
    end)
end

-- ===== START =====
for _, n in ipairs({ "CatHub", "CatHubKey", "CatHubNotify" }) do
    local old = guiParent():FindFirstChild(n)
    if old then old:Destroy() end
end
local pending = loadPending()
if pending then
    loadMainUI(true)                 -- joined from Cat Hub: skip key, open minimized
    task.spawn(runPendingCheck, pending)
elseif SHOW_KEY_GUI then
    showKeyGui()
else
    loadMainUI()
end

]=====]
local g = (getgenv and getgenv()) or _G
g.__CatHubSource = SRC
loadstring(SRC)()
