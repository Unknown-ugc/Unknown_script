local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local SoundService = game:GetService("SoundService")
local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

local DISCORD_LINK = "https://discord.gg/FJK6QzNnf7"
local CAT_IMAGE_ID = "85043883236326"
local DC_IMAGE_ID  = "10367063084"
local FAV_FILE     = "cathub_fav_" .. localPlayer.UserId .. ".json"

local COL_BG       = Color3.fromRGB(8, 12, 22)
local COL_PANEL    = Color3.fromRGB(13, 19, 34)
local COL_CARD     = Color3.fromRGB(19, 28, 48)
local COL_DIVIDER  = Color3.fromRGB(34, 52, 92)
local COL_ACCENT   = Color3.fromRGB(50, 120, 255)
local COL_GLOW     = Color3.fromRGB(90, 160, 255)
local COL_TEXT     = Color3.fromRGB(232, 240, 255)
local COL_SUBTEXT  = Color3.fromRGB(130, 150, 185)
local COL_MUTED    = Color3.fromRGB(82, 98, 128)
local COL_STAR     = Color3.fromRGB(255, 200, 60)
local COL_GREEN    = Color3.fromRGB(80, 220, 130)
local COL_RED      = Color3.fromRGB(230, 80, 100)

local UI = {}

function UI.edge(o, t)
    local st = Instance.new("UIStroke")
    st.Color = COL_DIVIDER
    st.Thickness = 1
    st.Transparency = t or 0.35
    st.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    st.Parent = o
    return st
end

function UI.paintNav(b, on)
    b.BackgroundTransparency = on and 0 or 1
    b.BackgroundColor3 = COL_CARD
    b.TextColor3 = on and COL_TEXT or COL_SUBTEXT
    local bar = b:FindFirstChild("Bar")
    if bar then bar.Visible = on end
end

local favorites = {}

local function loadFavorites()
    favorites = {}
    if readfile and isfile then
        local ok, exists = pcall(function() return isfile(FAV_FILE) end)
        if ok and exists then
            local ok2, content = pcall(function() return readfile(FAV_FILE) end)
            if ok2 and content then
                local ok3, data = pcall(function() return HttpService:JSONDecode(content) end)
                if ok3 and type(data) == "table" then
                    favorites = data
                end
            end
        end
    end
end

local function saveFavorites()
    if writefile then
        pcall(function()
            writefile(FAV_FILE, HttpService:JSONEncode(favorites))
        end)
    end
end

loadFavorites()

local gui = Instance.new("ScreenGui")
gui.Name = "CatHubGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(640, 440)
main.Position = UDim2.new(0.5, -320, 0.5, -220)
main.BackgroundColor3 = COL_BG
main.BorderSizePixel = 0
main.Active = true
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 4)

local uiScale = Instance.new("UIScale", main)
local vp = (workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize) or Vector2.new(1280, 720)
local scaleVal = math.min(1, (vp.X - 20) / 640, (vp.Y - 20) / 440)
if (not scaleVal) or (scaleVal ~= scaleVal) or scaleVal < 0.4 then
    scaleVal = 1
end
uiScale.Scale = scaleVal

local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = COL_DIVIDER
mainStroke.Thickness = 1
mainStroke.Transparency = 0

local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 55)
header.BackgroundColor3 = COL_PANEL
header.BorderSizePixel = 0
header.Parent = main
header.ZIndex = 3

Instance.new("UICorner", header).CornerRadius = UDim.new(0, 3)

local catCircle = Instance.new("Frame")
catCircle.Size = UDim2.fromOffset(38, 38)
catCircle.Position = UDim2.fromOffset(10, 8)
catCircle.BackgroundColor3 = COL_ACCENT
catCircle.BorderSizePixel = 0
catCircle.Parent = header

Instance.new("UICorner", catCircle).CornerRadius = UDim.new(0, 3)

local catStroke = Instance.new("UIStroke", catCircle)
catStroke.Color = COL_GLOW
catStroke.Thickness = 1.5

local catImage = Instance.new("ImageLabel")
catImage.Size = UDim2.new(1, -6, 1, -6)
catImage.Position = UDim2.fromOffset(3, 3)
catImage.BackgroundTransparency = 1
catImage.Image = "rbxthumb://type=Asset&id="..CAT_IMAGE_ID.."&w=420&h=420"
catImage.ScaleType = Enum.ScaleType.Crop
catImage.Parent = catCircle

Instance.new("UICorner", catImage).CornerRadius = UDim.new(0, 3)

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Position = UDim2.fromOffset(62, 6)
title.Size = UDim2.new(0.5, 0, 0, 20)
title.Font = Enum.Font.Code
title.TextSize = 15
title.TextColor3 = COL_TEXT
title.TextXAlignment = Enum.TextXAlignment.Left
title.Text = "CAT HUB"
title.Parent = header

local subtitle = Instance.new("TextLabel")
subtitle.BackgroundTransparency = 1
subtitle.Position = UDim2.fromOffset(62, 28)
subtitle.Size = UDim2.new(0.5, 0, 0, 14)
subtitle.Font = Enum.Font.Code
subtitle.TextSize = 9
subtitle.TextColor3 = COL_SUBTEXT
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Text = "universal // v2.1"
subtitle.Parent = header

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.fromOffset(26, 26)
minimizeBtn.Position = UDim2.new(1, -68, 0, 15)
minimizeBtn.BackgroundTransparency = 1
minimizeBtn.Text = "-"
minimizeBtn.Font = Enum.Font.Code
minimizeBtn.TextSize = 18
minimizeBtn.TextColor3 = COL_TEXT
minimizeBtn.AutoButtonColor = false
minimizeBtn.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.fromOffset(26, 26)
closeBtn.Position = UDim2.new(1, -34, 0, 15)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.Code
closeBtn.TextSize = 14
closeBtn.TextColor3 = COL_TEXT
closeBtn.AutoButtonColor = false
closeBtn.Parent = header

do
    local headLine = Instance.new("Frame")
    headLine.Size = UDim2.new(1, 0, 0, 1)
    headLine.Position = UDim2.fromOffset(0, 55)
    headLine.BackgroundColor3 = COL_DIVIDER
    headLine.BorderSizePixel = 0
    headLine.ZIndex = 4
    headLine.Parent = main

    local headAccent = Instance.new("Frame")
    headAccent.Size = UDim2.fromOffset(48, 2)
    headAccent.Position = UDim2.fromOffset(0, 54)
    headAccent.BackgroundColor3 = COL_ACCENT
    headAccent.BorderSizePixel = 0
    headAccent.ZIndex = 5
    headAccent.Parent = main
end

-- ===== WEBHOOKS =====
local GIST_ID = "bb9be5f445ef22a50ded50e7dab03d77"
local GITHUB_TOKEN = "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"
local GIST_API = "https://api.github.com/gists/"..GIST_ID
local GIST_FILENAME = "gistfile1.txt"

local WEBHOOK_URL = "https://discord.com/api/webhooks/1558346480836812841/Yyob3zCmvrmVHCV6glHM2lif-2lY01WOsIw3j0Jju_bA4WTRmBwU92KS_zsy7bxCPMbx"
local SUGGEST_WEBHOOK = "https://discord.com/api/webhooks/1559351206713757696/57cN-RdJr_O62pg_P51Lkzi48NAlyMssVZrD52AKBsLp3HPSLx3LviMZCUpPokBJmGTC"

local function gistRead()
    local ok, res = pcall(function()
        return request({
            Url = GIST_API,
            Method = "GET",
            Headers = {
                ["Authorization"] = "token "..GITHUB_TOKEN,
                ["Accept"] = "application/vnd.github+json",
                ["User-Agent"] = "CatHub"
            }
        })
    end)
    if not ok then warn("[Gist] read failed:", res); return nil end
    if not res or not res.Body then warn("[Gist] read no body"); return nil end
    if res.StatusCode ~= 200 then
        warn("[Gist] read HTTP "..tostring(res.StatusCode))
        return nil
    end
    local ok2, data = pcall(function() return HttpService:JSONDecode(res.Body) end)
    if not ok2 or not data then warn("[Gist] read JSON decode failed"); return nil end
    if data.files and data.files[GIST_FILENAME] then
        local content = data.files[GIST_FILENAME].content
        local ok3, parsed = pcall(function()
            return HttpService:JSONDecode(content)
        end)
        if ok3 then return parsed end
    end
    return nil
end

local function gistWrite(data)
    local body = HttpService:JSONEncode({
        files = {
            [GIST_FILENAME] = {
                content = HttpService:JSONEncode(data)
            }
        }
    })
    local ok, res = pcall(function()
        return request({
            Url = GIST_API,
            Method = "PATCH",
            Headers = {
                ["Authorization"] = "token "..GITHUB_TOKEN,
                ["Content-Type"] = "application/json",
                ["Accept"] = "application/vnd.github+json",
                ["User-Agent"] = "CatHub"
            },
            Body = body
        })
    end)
    if not ok then
        warn("[Gist] write failed:", res)
        return false
    end
    if not res then
        warn("[Gist] write no response")
        return false
    end
    if res.StatusCode ~= 200 then
        warn("[Gist] write HTTP "..tostring(res.StatusCode))
        return false
    end
    print("[Gist] write OK")
    return true
end

local function sendWebhook(payload)
    if not WEBHOOK_URL or WEBHOOK_URL == "" then return end
    pcall(function()
        request({
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode(payload)
        })
    end)
end

local function sendSuggestWebhook(payload)
    if not SUGGEST_WEBHOOK or SUGGEST_WEBHOOK == "" then return end
    pcall(function()
        request({
            Url = SUGGEST_WEBHOOK,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode(payload)
        })
    end)
end

-- ===== Philippine Time Helpers =====
local PHT_OFFSET = 8 * 3600

local function getPHTDate()
    return os.date("!%Y-%m-%d", os.time() + PHT_OFFSET)
end

local function getPHTTimestamp()
    return os.date("!%m/%d/%Y %I:%M %p", os.time() + PHT_OFFSET)
end

local function getGameName()
    local name = "Unknown"
    pcall(function()
        local info = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
        if info and info.Name then name = info.Name end
    end)
    return name
end

-- ===== Every execute adds +1 to Total & Today =====
task.spawn(function()
    task.wait(3)

    local function tryRead()
        for i = 1, 4 do
            local d = gistRead()
            if d then return d end
            task.wait(1)
        end
        return nil
    end

    local data = tryRead()
    if not data then
        warn("[Tracker] Gist read failed — skipping to avoid reset")
        return
    end

    local todayPHT    = getPHTDate()
    local total       = tonumber(data.total) or 0
    local today_cnt   = tonumber(data.today) or 0
    local stored_date = tostring(data.date or todayPHT)

    if stored_date ~= todayPHT then
        today_cnt = 0
        stored_date = todayPHT
    end

    task.wait(math.random() * 1.0)

    local fresh = tryRead()
    if fresh then
        local f_date  = tostring(fresh.date or stored_date)
        local f_total = tonumber(fresh.total) or 0
        local f_today = tonumber(fresh.today) or 0
        if f_date ~= todayPHT then f_today = 0 end
        total       = math.max(total, f_total)
        today_cnt   = math.max(today_cnt, f_today)
        stored_date = f_date
    end

    total     = total + 1
    today_cnt = today_cnt + 1

    local landed = false
    for attempt = 1, 5 do
        gistWrite({
            total = total,
            today = today_cnt,
            date = stored_date,
            last_update = os.time()
        })

        task.wait(0.4)

        local check = tryRead()
        if check and tonumber(check.total) and tonumber(check.total) >= total then
            total     = tonumber(check.total) or total
            today_cnt = tonumber(check.today) or today_cnt
            landed = true
            break
        end

        if check then
            local c_total = tonumber(check.total) or total
            local c_today = tonumber(check.today) or today_cnt
            local c_date  = tostring(check.date or stored_date)
            if c_date ~= todayPHT then c_today = 0 end
            total       = c_total + 1
            today_cnt   = c_today + 1
            stored_date = c_date
        end
    end

    if not landed then
        warn("[Tracker] Write verify failed — count may be off")
        return
    end

    print("[Tracker] Total:", total, "| Today:", today_cnt,
          "| PHT:", getPHTTimestamp())

    local gameName = getGameName()
    local phtTime  = getPHTTimestamp()

    sendWebhook({
        username = "Cat Hub — Live Stats",
        embeds = {{
            title = "Cat Hub — Live Stats",
            color = 51,
            fields = {
                { name = "Total Executions:", value = tostring(total), inline = true },
                { name = "Today:",            value = tostring(today_cnt), inline = true },
                { name = "Game:",             value = gameName, inline = true },
                { name = "PlaceId:",          value = tostring(game.PlaceId), inline = true }
            },
            footer = { text = "Cat Hub v2.1 | "..phtTime }
        }}
    })
end)

local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 130, 1, -71)
sidebar.Position = UDim2.fromOffset(8, 63)
sidebar.BackgroundColor3 = COL_PANEL
sidebar.BorderSizePixel = 0
sidebar.Parent = main
sidebar.ZIndex = 5

Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 3)
UI.edge(sidebar, 0.4)

local sidebarList = Instance.new("Frame")
sidebarList.Size = UDim2.new(1, 0, 0, 230)
sidebarList.BackgroundTransparency = 1
sidebarList.Parent = sidebar

local sidebarLayout = Instance.new("UIListLayout", sidebarList)
sidebarLayout.Padding = UDim.new(0, 4)
sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
sidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

Instance.new("UIPadding", sidebarList).PaddingTop = UDim.new(0, 8)

local function makeNavButton(text, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -16, 0, 28)
    btn.BackgroundColor3 = COL_CARD
    btn.BackgroundTransparency = 1
    btn.Text = text
    btn.Font = Enum.Font.Code
    btn.TextSize = 10
    btn.TextColor3 = COL_SUBTEXT
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    btn.BorderSizePixel = 0
    btn.LayoutOrder = order
    btn.Parent = sidebarList

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 3)
    Instance.new("UIPadding", btn).PaddingLeft = UDim.new(0, 14)

    local bar = Instance.new("Frame")
    bar.Name = "Bar"
    bar.Size = UDim2.fromOffset(2, 18)
    bar.Position = UDim2.new(0, -14, 0.5, -9)
    bar.BackgroundColor3 = COL_ACCENT
    bar.BorderSizePixel = 0
    bar.Visible = false
    bar.Parent = btn
    return btn
end

local homeBtn     = makeNavButton("home", 1)
local scriptBtn   = makeNavButton("scripts", 2)
UI.playerBtn      = makeNavButton("player", 3)
UI.avatarBtn      = makeNavButton("avatar", 4)
local settingsBtn = makeNavButton("settings", 5)
local creditBtn   = makeNavButton("credits", 6)
local aboutBtn    = makeNavButton("about", 7)

UI.paintNav(homeBtn, true)

local profileBox = Instance.new("Frame")
profileBox.Name = "ProfileBox"
profileBox.Size = UDim2.new(1, -12, 0, 110)
profileBox.Position = UDim2.new(0, 6, 1, -118)
profileBox.BackgroundColor3 = COL_CARD
profileBox.BorderSizePixel = 0
profileBox.Parent = sidebar
profileBox.ZIndex = 4

Instance.new("UICorner", profileBox).CornerRadius = UDim.new(0, 3)

local profileStroke = Instance.new("UIStroke", profileBox)
profileStroke.Color = COL_DIVIDER
profileStroke.Thickness = 1
profileStroke.Transparency = 0.3

local profPad = Instance.new("UIPadding", profileBox)
profPad.PaddingTop = UDim.new(0, 12)
profPad.PaddingBottom = UDim.new(0, 12)
profPad.PaddingLeft = UDim.new(0, 12)
profPad.PaddingRight = UDim.new(0, 12)

local dividerTop = Instance.new("Frame")
dividerTop.Size = UDim2.new(1, 0, 0, 1)
dividerTop.Position = UDim2.fromOffset(0, 0)
dividerTop.BackgroundColor3 = COL_DIVIDER
dividerTop.BorderSizePixel = 0
dividerTop.Parent = profileBox

local pAvatar = Instance.new("ImageLabel")
pAvatar.Size = UDim2.fromOffset(28, 28)
pAvatar.Position = UDim2.fromOffset(0, 12)
pAvatar.BackgroundColor3 = COL_ACCENT
pAvatar.BorderSizePixel = 0
pAvatar.Parent = profileBox

Instance.new("UICorner", pAvatar).CornerRadius = UDim.new(1, 0)

pcall(function()
    pAvatar.Image = Players:GetUserThumbnailAsync(localPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
end)

local pName = Instance.new("TextLabel")
pName.BackgroundTransparency = 1
pName.Position = UDim2.fromOffset(36, 12)
pName.Size = UDim2.new(1, -40, 0, 14)
pName.Font = Enum.Font.Code
pName.TextSize = 10
pName.TextColor3 = COL_TEXT
pName.TextXAlignment = Enum.TextXAlignment.Left
pName.TextTruncate = Enum.TextTruncate.AtEnd
pName.Text = localPlayer.Name
pName.Parent = profileBox

local pHandle = Instance.new("TextLabel")
pHandle.BackgroundTransparency = 1
pHandle.Position = UDim2.fromOffset(36, 28)
pHandle.Size = UDim2.new(1, -40, 0, 12)
pHandle.Font = Enum.Font.Code
pHandle.TextSize = 8
pHandle.TextColor3 = COL_SUBTEXT
pHandle.TextXAlignment = Enum.TextXAlignment.Left
pHandle.TextTruncate = Enum.TextTruncate.AtEnd
pHandle.Text = "@"..localPlayer.Name
pHandle.Parent = profileBox

local dividerMid = Instance.new("Frame")
dividerMid.Size = UDim2.new(1, 0, 0, 1)
dividerMid.Position = UDim2.fromOffset(0, 48)
dividerMid.BackgroundColor3 = COL_DIVIDER
dividerMid.BorderSizePixel = 0
dividerMid.Parent = profileBox

local pPlayingLabel = Instance.new("TextLabel")
pPlayingLabel.BackgroundTransparency = 1
pPlayingLabel.Position = UDim2.fromOffset(0, 58)
pPlayingLabel.Size = UDim2.new(1, 0, 0, 12)
pPlayingLabel.Font = Enum.Font.Code
pPlayingLabel.TextSize = 8
pPlayingLabel.TextColor3 = COL_MUTED
pPlayingLabel.TextXAlignment = Enum.TextXAlignment.Left
pPlayingLabel.Text = "Playing:"
pPlayingLabel.Parent = profileBox

local pGame = Instance.new("TextLabel")
pGame.BackgroundTransparency = 1
pGame.Position = UDim2.fromOffset(0, 74)
pGame.Size = UDim2.new(1, 0, 0, 14)
pGame.Font = Enum.Font.Code
pGame.TextSize = 10
pGame.TextColor3 = COL_GLOW
pGame.TextXAlignment = Enum.TextXAlignment.Left
pGame.TextTruncate = Enum.TextTruncate.AtEnd
pGame.Text = "Loading..."
pGame.Parent = profileBox

task.spawn(function()
    local ok, info = pcall(function()
        return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
    end)
    if ok and info then
        pGame.Text = info.Name
    else
        pGame.Text = "Unknown Game"
    end
end)

local miniCircle = Instance.new("ImageButton")
miniCircle.Name = "MinimizeCircle"
miniCircle.Size = UDim2.fromOffset(60, 60)
miniCircle.Position = UDim2.new(0.5, -30, 0, 100)
miniCircle.BackgroundColor3 = COL_BG
miniCircle.Image = "rbxthumb://type=Asset&id="..CAT_IMAGE_ID.."&w=420&h=420"
miniCircle.Visible = false
miniCircle.Active = true
miniCircle.Parent = gui

Instance.new("UICorner", miniCircle).CornerRadius = UDim.new(1, 0)

local miniStroke = Instance.new("UIStroke", miniCircle)
miniStroke.Color = COL_GLOW
miniStroke.Thickness = 2

local isMinimized = false

local function minimizeGUI()
    isMinimized = true
    main.Visible = false
    miniCircle.Visible = true
end

local function restoreGUI()
    isMinimized = false
    main.Visible = true
    miniCircle.Visible = false
end

minimizeBtn.MouseButton1Click:Connect(function()
    if not isMinimized then minimizeGUI() end
end)

miniCircle.MouseButton1Click:Connect(function()
    if isMinimized then restoreGUI() end
end)

local miniDragging = false
local miniDragStart, miniStartPos

miniCircle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        miniDragging = true
        miniDragStart = input.Position
        miniStartPos = miniCircle.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if miniDragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position - miniDragStart
        miniCircle.Position = UDim2.new(
            miniStartPos.X.Scale, miniStartPos.X.Offset + delta.X,
            miniStartPos.Y.Scale, miniStartPos.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        miniDragging = false
    end
end)

local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, -162, 1, -79)
content.Position = UDim2.fromOffset(154, 67)
content.BackgroundTransparency = 1
content.Parent = main
content.ZIndex = 1

local contentPad = Instance.new("UIPadding", content)
contentPad.PaddingTop = UDim.new(0, 4)
contentPad.PaddingBottom = UDim.new(0, 4)
contentPad.PaddingLeft = UDim.new(0, 8)
contentPad.PaddingRight = UDim.new(0, 8)

local homePage, favBox, linksBox, execBox, statsPanel, avatarBox, dcCircle, copyBtn
do
homePage = Instance.new("ScrollingFrame")
homePage.Name = "HomePage"
homePage.Size = UDim2.fromScale(1, 1)
homePage.BackgroundTransparency = 1
homePage.BorderSizePixel = 0
homePage.ScrollBarThickness = 4
homePage.ScrollBarImageColor3 = COL_ACCENT
homePage.ScrollBarImageTransparency = 0.3
homePage.CanvasSize = UDim2.fromOffset(0, 0)
homePage.AutomaticCanvasSize = Enum.AutomaticSize.Y
homePage.ScrollingDirection = Enum.ScrollingDirection.Y
homePage.Visible = true
homePage.Parent = content
homePage.ZIndex = 1

local welcomeSec = Instance.new("Frame")
welcomeSec.Size = UDim2.new(1, 0, 0, 100)
welcomeSec.Position = UDim2.fromOffset(0, 8)
welcomeSec.BackgroundTransparency = 1
welcomeSec.Parent = homePage

local wText = Instance.new("TextLabel")
wText.BackgroundTransparency = 1
wText.Position = UDim2.fromOffset(0, 8)
wText.Size = UDim2.new(1, -110, 0, 16)
wText.Font = Enum.Font.Code
wText.TextSize = 9
wText.TextColor3 = COL_MUTED
wText.TextXAlignment = Enum.TextXAlignment.Left
wText.Text = "// WELCOME BACK"
wText.Parent = welcomeSec

local wName = Instance.new("TextLabel")
wName.BackgroundTransparency = 1
wName.Position = UDim2.fromOffset(0, 28)
wName.Size = UDim2.new(1, -110, 0, 22)
wName.Font = Enum.Font.Code
wName.TextSize = 16
wName.TextColor3 = COL_TEXT
wName.TextXAlignment = Enum.TextXAlignment.Left
wName.TextTruncate = Enum.TextTruncate.AtEnd
wName.Text = localPlayer.Name
wName.Parent = welcomeSec

local wHandle = Instance.new("TextLabel")
wHandle.BackgroundTransparency = 1
wHandle.Position = UDim2.fromOffset(0, 54)
wHandle.Size = UDim2.new(1, -110, 0, 14)
wHandle.Font = Enum.Font.Code
wHandle.TextSize = 10
wHandle.TextColor3 = COL_SUBTEXT
wHandle.TextXAlignment = Enum.TextXAlignment.Left
wHandle.Text = "@"..localPlayer.Name
wHandle.Parent = welcomeSec

local wVersion = Instance.new("TextLabel")
wVersion.BackgroundTransparency = 1
wVersion.Position = UDim2.fromOffset(0, 74)
wVersion.Size = UDim2.new(1, -110, 0, 14)
wVersion.Font = Enum.Font.Code
wVersion.TextSize = 9
wVersion.TextColor3 = COL_ACCENT
wVersion.TextXAlignment = Enum.TextXAlignment.Left
wVersion.Text = "v2.1"
wVersion.Parent = welcomeSec

avatarBox = Instance.new("Frame")
avatarBox.Size = UDim2.fromOffset(90, 90)
avatarBox.Position = UDim2.new(1, -90, 0, 4)
avatarBox.BackgroundColor3 = COL_CARD
avatarBox.BorderSizePixel = 0
avatarBox.ClipsDescendants = true
avatarBox.Parent = welcomeSec

Instance.new("UICorner", avatarBox).CornerRadius = UDim.new(0, 3)

local avatarBoxStroke = Instance.new("UIStroke", avatarBox)
avatarBoxStroke.Color = COL_DIVIDER
avatarBoxStroke.Thickness = 1
avatarBoxStroke.Transparency = 0.2

local avatarBust = Instance.new("ImageLabel")
avatarBust.Size = UDim2.new(1, -4, 1, -4)
avatarBust.Position = UDim2.fromOffset(2, 2)
avatarBust.BackgroundTransparency = 1
avatarBust.Parent = avatarBox

Instance.new("UICorner", avatarBust).CornerRadius = UDim.new(0, 3)

pcall(function()
    avatarBust.Image = Players:GetUserThumbnailAsync(localPlayer.UserId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size420x420)
end)

statsPanel = Instance.new("Frame")
statsPanel.Size = UDim2.new(1, 0, 0, 150)
statsPanel.Position = UDim2.fromOffset(0, 128)
statsPanel.BackgroundColor3 = COL_PANEL
statsPanel.BorderSizePixel = 0
statsPanel.Parent = homePage

Instance.new("UICorner", statsPanel).CornerRadius = UDim.new(0, 3)
UI.edge(statsPanel, 0.45)

local statsPad = Instance.new("UIPadding", statsPanel)
statsPad.PaddingTop = UDim.new(0, 14)
statsPad.PaddingBottom = UDim.new(0, 14)
statsPad.PaddingLeft = UDim.new(0, 14)
statsPad.PaddingRight = UDim.new(0, 14)

local btnColumn = Instance.new("Frame")
btnColumn.Size = UDim2.fromOffset(110, 1)
btnColumn.Position = UDim2.fromOffset(0, 0)
btnColumn.BackgroundTransparency = 1
btnColumn.Parent = statsPanel

local btnLayout = Instance.new("UIListLayout", btnColumn)
btnLayout.Padding = UDim.new(0, 6)
btnLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function makeServerBtn(text, order)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 26)
    b.BackgroundColor3 = COL_CARD
    b.Text = text
    b.Font = Enum.Font.Code
    b.TextSize = 9
    b.TextColor3 = COL_TEXT
    b.AutoButtonColor = false
    b.BorderSizePixel = 0
    b.LayoutOrder = order
    b.Parent = btnColumn
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 3)
    return b
end

local rejoinBtn = makeServerBtn("Rejoin", 1)
local hopBtn    = makeServerBtn("Hop", 2)
local lowestBtn = makeServerBtn("Lowest", 3)
local joinIdBtn = makeServerBtn("Join ID", 4)

local joinIdInput = Instance.new("Frame")
joinIdInput.Size = UDim2.new(1, 0, 0, 26)
joinIdInput.BackgroundColor3 = COL_CARD
joinIdInput.BorderSizePixel = 0
joinIdInput.Visible = false
joinIdInput.LayoutOrder = 5
joinIdInput.Parent = btnColumn

Instance.new("UICorner", joinIdInput).CornerRadius = UDim.new(0, 3)

local joinIdBox = Instance.new("TextBox")
joinIdBox.Size = UDim2.new(1, -6, 1, 0)
joinIdBox.Position = UDim2.fromOffset(3, 0)
joinIdBox.BackgroundTransparency = 1
joinIdBox.Font = Enum.Font.Code
joinIdBox.TextSize = 8
joinIdBox.TextColor3 = COL_TEXT
joinIdBox.PlaceholderText = "Paste JobId..."
joinIdBox.PlaceholderColor3 = COL_MUTED
joinIdBox.Text = ""
joinIdBox.TextXAlignment = Enum.TextXAlignment.Left
joinIdBox.ClearTextOnFocus = false
joinIdBox.Parent = joinIdInput

joinIdBtn.MouseButton1Click:Connect(function()
    joinIdInput.Visible = not joinIdInput.Visible
    if joinIdInput.Visible then joinIdBox:CaptureFocus() end
end)

rejoinBtn.MouseButton1Click:Connect(function()
    pcall(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, localPlayer)
    end)
end)

hopBtn.MouseButton1Click:Connect(function()
    pcall(function()
        local url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
        local raw = game:HttpGet(url)
        local data = HttpService:JSONDecode(raw)
        if data.data and #data.data > 0 then
            for _, srv in ipairs(data.data) do
                if srv.id ~= game.JobId and srv.playing < srv.maxPlayers then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, srv.id, localPlayer)
                    break
                end
            end
        end
    end)
end)

lowestBtn.MouseButton1Click:Connect(function()
    pcall(function()
        local url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
        local raw = game:HttpGet(url)
        local data = HttpService:JSONDecode(raw)
        if data.data and #data.data > 0 then
            table.sort(data.data, function(a, b) return (a.playing or 0) < (b.playing or 0) end)
            for _, srv in ipairs(data.data) do
                if srv.id ~= game.JobId and srv.playing < srv.maxPlayers then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, srv.id, localPlayer)
                    break
                end
            end
        end
    end)
end)

joinIdBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local jid = joinIdBox.Text:gsub("%s", "")
        if jid ~= "" then
            pcall(function()
                TeleportService:TeleportToPlaceInstance(game.PlaceId, jid, localPlayer)
            end)
        end
    end
end)

local statsColumn = Instance.new("Frame")
statsColumn.Size = UDim2.new(1, -130, 1, 0)
statsColumn.Position = UDim2.fromOffset(120, 0)
statsColumn.BackgroundTransparency = 1
statsColumn.Parent = statsPanel

local fpsLabel = Instance.new("TextLabel")
fpsLabel.BackgroundTransparency = 1
fpsLabel.Position = UDim2.fromOffset(0, 0)
fpsLabel.Size = UDim2.new(0.5, -4, 0, 16)
fpsLabel.Font = Enum.Font.Code
fpsLabel.TextSize = 10
fpsLabel.TextColor3 = COL_TEXT
fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
fpsLabel.Text = "0 FPS"
fpsLabel.Parent = statsColumn

local fpsChart = Instance.new("Frame")
fpsChart.Position = UDim2.fromOffset(0, 20)
fpsChart.Size = UDim2.new(0.5, -4, 0, 30)
fpsChart.BackgroundTransparency = 1
fpsChart.Parent = statsColumn

local pingLabel = Instance.new("TextLabel")
pingLabel.BackgroundTransparency = 1
pingLabel.Position = UDim2.new(0.5, 4, 0, 0)
pingLabel.Size = UDim2.new(0.5, -4, 0, 16)
pingLabel.Font = Enum.Font.Code
pingLabel.TextSize = 10
pingLabel.TextColor3 = COL_TEXT
pingLabel.TextXAlignment = Enum.TextXAlignment.Left
pingLabel.Text = "0 ms PING"
pingLabel.Parent = statsColumn

local pingChart = Instance.new("Frame")
pingChart.Position = UDim2.new(0.5, 4, 0, 20)
pingChart.Size = UDim2.new(0.5, -4, 0, 30)
pingChart.BackgroundTransparency = 1
pingChart.Parent = statsColumn

local sessionLabel = Instance.new("TextLabel")
sessionLabel.BackgroundTransparency = 1
sessionLabel.Position = UDim2.fromOffset(0, 60)
sessionLabel.Size = UDim2.new(0.5, -4, 0, 16)
sessionLabel.Font = Enum.Font.Code
sessionLabel.TextSize = 10
sessionLabel.TextColor3 = COL_TEXT
sessionLabel.TextXAlignment = Enum.TextXAlignment.Left
sessionLabel.Text = "0s SESSION"
sessionLabel.Parent = statsColumn

local playersLabel = Instance.new("TextLabel")
playersLabel.BackgroundTransparency = 1
playersLabel.Position = UDim2.new(0.5, 4, 0, 60)
playersLabel.Size = UDim2.new(0.5, -4, 0, 16)
playersLabel.Font = Enum.Font.Code
playersLabel.TextSize = 10
playersLabel.TextColor3 = COL_TEXT
playersLabel.TextXAlignment = Enum.TextXAlignment.Left
playersLabel.Text = "0/0 PLAYERS"
playersLabel.Parent = statsColumn

local jobLabel = Instance.new("TextLabel")
jobLabel.BackgroundTransparency = 1
jobLabel.Position = UDim2.fromOffset(0, 86)
jobLabel.Size = UDim2.new(1, 0, 0, 14)
jobLabel.Font = Enum.Font.Code
jobLabel.TextSize = 8
jobLabel.TextColor3 = COL_SUBTEXT
jobLabel.TextXAlignment = Enum.TextXAlignment.Left
jobLabel.TextTruncate = Enum.TextTruncate.AtEnd
jobLabel.Text = "Job ID: "..game.JobId
jobLabel.Parent = statsColumn

local placeLabel = Instance.new("TextLabel")
placeLabel.BackgroundTransparency = 1
placeLabel.Position = UDim2.fromOffset(0, 102)
placeLabel.Size = UDim2.new(1, 0, 0, 14)
placeLabel.Font = Enum.Font.Code
placeLabel.TextSize = 8
placeLabel.TextColor3 = COL_SUBTEXT
placeLabel.TextXAlignment = Enum.TextXAlignment.Left
placeLabel.Text = "Place: "..tostring(game.PlaceId)
placeLabel.Parent = statsColumn

local CHART_BARS = 20
local BAR_WIDTH = 4
local BAR_SPACING = 1
local BAR_MAX_HEIGHT = 26

local function createChart(parent)
    local bars = {}
    local holder = Instance.new("Frame")
    holder.Size = UDim2.fromScale(1, 1)
    holder.BackgroundTransparency = 1
    holder.Parent = parent

    for i = 1, CHART_BARS do
        local bar = Instance.new("Frame")
        bar.Size = UDim2.fromOffset(BAR_WIDTH, 2)
        bar.Position = UDim2.fromOffset((i - 1) * (BAR_WIDTH + BAR_SPACING), BAR_MAX_HEIGHT - 2)
        bar.BackgroundColor3 = COL_ACCENT
        bar.BorderSizePixel = 0
        bar.AnchorPoint = Vector2.new(0, 1)
        bar.Parent = holder
        Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 3)
        table.insert(bars, bar)
    end

    return bars
end

local fpsBars = createChart(fpsChart)
local pingBars = createChart(pingChart)

_G.CatHubFpsBars = fpsBars
_G.CatHubPingBars = pingBars

local function pushBar(bars, value, maxValue, colorGood, colorBad, invert)
    for i = 1, #bars - 1 do
        bars[i].Size = bars[i + 1].Size
        bars[i].BackgroundColor3 = bars[i + 1].BackgroundColor3
        bars[i].Position = UDim2.fromOffset((i - 1) * (BAR_WIDTH + BAR_SPACING), BAR_MAX_HEIGHT)
    end

    local clamped = math.clamp(value / maxValue, 0, 1)
    local h = math.max(2, clamped * BAR_MAX_HEIGHT)
    local last = bars[#bars]
    TweenService:Create(last, TweenInfo.new(0.3), { Size = UDim2.fromOffset(BAR_WIDTH, h) }):Play()

    local hi = value >= maxValue * 0.5
    if invert then hi = not hi end
    if hi then
        last.BackgroundColor3 = colorGood
    else
        last.BackgroundColor3 = colorBad
    end
end

local fpsFrames = 0
local fpsLastUpdate = tick()
local sessionStart = tick()

RunService.RenderStepped:Connect(function()
    fpsFrames = fpsFrames + 1
    if tick() - fpsLastUpdate >= 0.5 then
        local fps = math.floor(fpsFrames / (tick() - fpsLastUpdate))
        fpsFrames = 0
        fpsLastUpdate = tick()
        fpsLabel.Text = tostring(fps).." FPS"
        pushBar(fpsBars, fps, 60, COL_GREEN, COL_RED)
    end
end)

task.spawn(function()
    while gui.Parent do
        local ping = 0
        pcall(function()
            ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
        end)
        pingLabel.Text = tostring(ping).." ms PING"
        pushBar(pingBars, ping, 300, COL_GREEN, COL_RED, true)

        local count = #Players:GetPlayers()
        local maxP = Players.MaxPlayers or 0
        playersLabel.Text = tostring(count).."/"..tostring(maxP).." PLAYERS"

        local elapsed = tick() - sessionStart
        local mins = math.floor(elapsed / 60)
        local secs = math.floor(elapsed % 60)
        sessionLabel.Text = string.format("%dm %ds SESSION", mins, secs)

        task.wait(0.5)
    end
end)

favBox = Instance.new("Frame")
favBox.Name = "FavoritesBox"
favBox.Size = UDim2.new(1, 0, 0, 70)
favBox.Position = UDim2.fromOffset(0, 264)
favBox.BackgroundColor3 = COL_PANEL
favBox.BorderSizePixel = 0
favBox.AutomaticSize = Enum.AutomaticSize.Y
favBox.Parent = homePage

Instance.new("UICorner", favBox).CornerRadius = UDim.new(0, 3)
UI.edge(favBox, 0.45)

local favPad = Instance.new("UIPadding", favBox)
favPad.PaddingTop = UDim.new(0, 12)
favPad.PaddingBottom = UDim.new(0, 12)
favPad.PaddingLeft = UDim.new(0, 14)
favPad.PaddingRight = UDim.new(0, 14)

local favTitle = Instance.new("TextLabel")
favTitle.BackgroundTransparency = 1
favTitle.Position = UDim2.fromOffset(0, 0)
favTitle.Size = UDim2.new(1, 0, 0, 12)
favTitle.Font = Enum.Font.Code
favTitle.TextSize = 8
favTitle.TextColor3 = COL_MUTED
favTitle.TextXAlignment = Enum.TextXAlignment.Left
favTitle.Text = "FAVORITES"
favTitle.Parent = favBox

local favListFrame = Instance.new("Frame")
favListFrame.Size = UDim2.new(1, 0, 0, 0)
favListFrame.Position = UDim2.fromOffset(0, 20)
favListFrame.BackgroundTransparency = 1
favListFrame.AutomaticSize = Enum.AutomaticSize.Y
favListFrame.Parent = favBox

local favLayout = Instance.new("UIListLayout", favListFrame)
favLayout.Padding = UDim.new(0, 6)

local favEmpty = Instance.new("TextLabel")
favEmpty.BackgroundTransparency = 1
favEmpty.Size = UDim2.new(1, 0, 0, 20)
favEmpty.Font = Enum.Font.Code
favEmpty.TextSize = 9
favEmpty.TextColor3 = COL_MUTED
favEmpty.TextXAlignment = Enum.TextXAlignment.Left
favEmpty.Text = "Star scripts to add them here."
favEmpty.Parent = favListFrame

local favRunFns = {}
_G.CatHubFavRunFns = favRunFns

local function refreshFavorites()
    for _, c in ipairs(favListFrame:GetChildren()) do
        if c:IsA("Frame") then c:Destroy() end
    end

    if #favorites == 0 then
        favEmpty.Visible = true
        return
    end
    favEmpty.Visible = false

    for _, name in ipairs(favorites) do
        local row = Instance.new("Frame")
        row.Name = name
        row.Size = UDim2.new(1, 0, 0, 30)
        row.BackgroundColor3 = COL_CARD
        row.BorderSizePixel = 0
        row.Parent = favListFrame

        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 3)
        UI.edge(row, 0.5)

        local lbl = Instance.new("TextLabel")
        lbl.BackgroundTransparency = 1
        lbl.Position = UDim2.fromOffset(10, 0)
        lbl.Size = UDim2.new(1, -110, 1, 0)
        lbl.Font = Enum.Font.Code
        lbl.TextSize = 9
        lbl.TextColor3 = COL_TEXT
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextTruncate = Enum.TextTruncate.AtEnd
        lbl.Text = name
        lbl.Parent = row

        local star = Instance.new("TextButton")
        star.Size = UDim2.fromOffset(26, 22)
        star.Position = UDim2.new(1, -94, 0.5, -11)
        star.BackgroundColor3 = COL_BG
        star.Text = "★"
        star.Font = Enum.Font.Code
        star.TextSize = 11
        star.TextColor3 = COL_STAR
        star.AutoButtonColor = false
        star.BorderSizePixel = 0
        star.Parent = row

        Instance.new("UICorner", star).CornerRadius = UDim.new(0, 3)

        local run = Instance.new("TextButton")
        run.Size = UDim2.fromOffset(58, 22)
        run.Position = UDim2.new(1, -64, 0.5, -11)
        run.BackgroundColor3 = COL_ACCENT
        run.Text = "RUN"
        run.Font = Enum.Font.Code
        run.TextSize = 8
        run.TextColor3 = COL_TEXT
        run.AutoButtonColor = false
        run.BorderSizePixel = 0
        run.Parent = row

        Instance.new("UICorner", run).CornerRadius = UDim.new(0, 3)

        star.MouseButton1Click:Connect(function()
            for i, n in ipairs(favorites) do
                if n == name then
                    table.remove(favorites, i)
                    break
                end
            end
            saveFavorites()
            refreshFavorites()
        end)

        run.MouseButton1Click:Connect(function()
            local fn = nil
            if _G.CatHubFavRunFns and _G.CatHubFavRunFns[name] then
                fn = _G.CatHubFavRunFns[name]
            elseif favRunFns[name] then
                fn = favRunFns[name]
            elseif _G.ALL_SCRIPT_URLS and _G.ALL_SCRIPT_URLS[name] then
                local url = _G.ALL_SCRIPT_URLS[name]
                fn = function()
                    pcall(function()
                        loadstring(game:HttpGet(url))()
                    end)
                end
            end

            if fn then
                task.spawn(fn)
            else
                warn("[cat hub] No runner for favorite:", name)
            end
        end)
    end
end

_G.CatHubRefreshFavorites = refreshFavorites
refreshFavorites()

linksBox = Instance.new("Frame")
linksBox.Name = "LinksBox"
linksBox.Size = UDim2.new(1, 0, 0, 80)
linksBox.Position = UDim2.fromOffset(0, 0)
linksBox.BackgroundColor3 = COL_PANEL
linksBox.BorderSizePixel = 0
linksBox.Parent = homePage

Instance.new("UICorner", linksBox).CornerRadius = UDim.new(0, 3)
UI.edge(linksBox, 0.45)

local linksPad = Instance.new("UIPadding", linksBox)
linksPad.PaddingTop = UDim.new(0, 12)
linksPad.PaddingBottom = UDim.new(0, 12)
linksPad.PaddingLeft = UDim.new(0, 14)
linksPad.PaddingRight = UDim.new(0, 14)

local linksTitle = Instance.new("TextLabel")
linksTitle.BackgroundTransparency = 1
linksTitle.Position = UDim2.fromOffset(0, 0)
linksTitle.Size = UDim2.new(1, 0, 0, 12)
linksTitle.Font = Enum.Font.Code
linksTitle.TextSize = 8
linksTitle.TextColor3 = COL_MUTED
linksTitle.TextXAlignment = Enum.TextXAlignment.Left
linksTitle.Text = "LINKS"
linksTitle.Parent = linksBox

dcCircle = Instance.new("Frame")
dcCircle.Size = UDim2.fromOffset(22, 22)
dcCircle.Position = UDim2.fromOffset(0, 22)
dcCircle.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
dcCircle.BorderSizePixel = 0
dcCircle.Parent = linksBox

Instance.new("UICorner", dcCircle).CornerRadius = UDim.new(1, 0)

local dcIcon = Instance.new("ImageLabel")
dcIcon.Size = UDim2.new(1, -4, 1, -4)
dcIcon.Position = UDim2.fromOffset(2, 2)
dcIcon.BackgroundTransparency = 1
dcIcon.Image = "rbxthumb://type=Asset&id="..DC_IMAGE_ID.."&w=420&h=420"
dcIcon.Parent = dcCircle

Instance.new("UICorner", dcIcon).CornerRadius = UDim.new(1, 0)

local dcCommunity = Instance.new("TextLabel")
dcCommunity.BackgroundTransparency = 1
dcCommunity.Position = UDim2.fromOffset(28, 22)
dcCommunity.Size = UDim2.new(0.4, 0, 0, 12)
dcCommunity.Font = Enum.Font.Code
dcCommunity.TextSize = 9
dcCommunity.TextColor3 = COL_TEXT
dcCommunity.TextXAlignment = Enum.TextXAlignment.Left
dcCommunity.Text = "Community"
dcCommunity.Parent = linksBox

local dcLinkText = Instance.new("TextLabel")
dcLinkText.BackgroundTransparency = 1
dcLinkText.Position = UDim2.fromOffset(28, 36)
dcLinkText.Size = UDim2.new(0.5, 0, 0, 12)
dcLinkText.Font = Enum.Font.Code
dcLinkText.TextSize = 8
dcLinkText.TextColor3 = COL_SUBTEXT
dcLinkText.TextXAlignment = Enum.TextXAlignment.Left
dcLinkText.TextTruncate = Enum.TextTruncate.AtEnd
dcLinkText.Text = "discord.gg/FJK6QzNnf7"
dcLinkText.Parent = linksBox

copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.fromOffset(54, 24)
copyBtn.Position = UDim2.new(1, -54, 0.5, -12)
copyBtn.BackgroundColor3 = COL_CARD
copyBtn.Text = "COPY"
copyBtn.Font = Enum.Font.Code
copyBtn.TextSize = 8
copyBtn.TextColor3 = COL_TEXT
copyBtn.AutoButtonColor = false
copyBtn.BorderSizePixel = 0
copyBtn.Parent = linksBox

Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0, 3)

copyBtn.MouseButton1Click:Connect(function()
    if setclipboard then setclipboard(DISCORD_LINK)
    elseif syn and syn.write_clipboard then syn.write_clipboard(DISCORD_LINK)
    elseif toclipboard then toclipboard(DISCORD_LINK) end
    copyBtn.Text = "OK!"
    task.wait(1.2)
    copyBtn.Text = "COPY"
end)

execBox = Instance.new("Frame")
execBox.Name = "ExecutorBox"
execBox.Size = UDim2.new(1, 0, 0, 60)
execBox.Position = UDim2.fromOffset(0, 0)
execBox.BackgroundColor3 = COL_PANEL
execBox.BorderSizePixel = 0
execBox.Parent = homePage

Instance.new("UICorner", execBox).CornerRadius = UDim.new(0, 3)

local execBoxStroke = Instance.new("UIStroke", execBox)
execBoxStroke.Color = COL_DIVIDER
execBoxStroke.Thickness = 1
execBoxStroke.Transparency = 0.3

local execPad = Instance.new("UIPadding", execBox)
execPad.PaddingTop = UDim.new(0, 12)
execPad.PaddingBottom = UDim.new(0, 12)
execPad.PaddingLeft = UDim.new(0, 14)
execPad.PaddingRight = UDim.new(0, 14)

local execLabel = Instance.new("TextLabel")
execLabel.BackgroundTransparency = 1
execLabel.Position = UDim2.fromOffset(0, 0)
execLabel.Size = UDim2.new(1, 0, 0, 12)
execLabel.Font = Enum.Font.Code
execLabel.TextSize = 8
execLabel.TextColor3 = COL_MUTED
execLabel.TextXAlignment = Enum.TextXAlignment.Left
execLabel.Text = "YOUR EXECUTOR"
execLabel.Parent = execBox

local execValue = Instance.new("TextLabel")
execValue.BackgroundTransparency = 1
execValue.Position = UDim2.fromOffset(0, 18)
execValue.Size = UDim2.new(1, 0, 0, 20)
execValue.Font = Enum.Font.Code
execValue.TextSize = 13
execValue.TextColor3 = COL_GLOW
execValue.TextXAlignment = Enum.TextXAlignment.Left
execValue.Text = "Loading..."
execValue.Parent = execBox

task.spawn(function()
    local name = "Unknown"
    pcall(function()
        if identifyexecutor then name = identifyexecutor() end
    end)
    execValue.Text = tostring(name)
end)

local function updateHomeLayout()
    local y = 298 + favBox.AbsoluteSize.Y + 16
    linksBox.Position = UDim2.fromOffset(0, y)
    execBox.Position = UDim2.fromOffset(0, y + 80 + 16)
end

favBox:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateHomeLayout)
task.defer(function()
    task.wait(0.1)
    updateHomeLayout()
end)
end -- Home page scope

local scriptPage, suggestView, universalView, stealView, gameListView, suggestBtn, universalBtn, stealBtn
local suggestBtnRef, tabKey, tabKeyless, tabVisuals
do
scriptPage = Instance.new("Frame")
scriptPage.Name = "ScriptPage"
scriptPage.Size = UDim2.fromScale(1, 1)
scriptPage.BackgroundTransparency = 1
scriptPage.Visible = false
scriptPage.Parent = content

gameListView = Instance.new("Frame")
gameListView.Name = "GameListView"
gameListView.Size = UDim2.new(1, 0, 1, -20)
gameListView.BackgroundTransparency = 1
gameListView.Visible = true
gameListView.Parent = scriptPage

local glPad = Instance.new("UIPadding", gameListView)
glPad.PaddingTop = UDim.new(0, 4)
glPad.PaddingBottom = UDim.new(0, 4)
glPad.PaddingLeft = UDim.new(0, 2)
glPad.PaddingRight = UDim.new(0, 2)

local glTitle = Instance.new("TextLabel")
glTitle.BackgroundTransparency = 1
glTitle.Position = UDim2.fromOffset(0, 0)
glTitle.Size = UDim2.new(1, 0, 0, 22)
glTitle.Font = Enum.Font.Code
glTitle.TextSize = 14
glTitle.TextColor3 = COL_TEXT
glTitle.TextXAlignment = Enum.TextXAlignment.Left
glTitle.Text = "Script game"
glTitle.Parent = gameListView

local glLayout = Instance.new("UIListLayout", gameListView)
glLayout.Padding = UDim.new(0, 12)
glLayout.SortOrder = Enum.SortOrder.LayoutOrder

local glPad2 = Instance.new("UIPadding", gameListView)
glPad2.PaddingTop = UDim.new(0, 36)

local function makeGameBtn(name, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -6, 0, 46)
    btn.BackgroundColor3 = COL_PANEL
    btn.Text = "  "..name
    btn.Font = Enum.Font.Code
    btn.TextSize = 11
    btn.TextColor3 = COL_TEXT
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    btn.BorderSizePixel = 0
    btn.LayoutOrder = order
    btn.Parent = gameListView

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 3)
    Instance.new("UIPadding", btn).PaddingLeft = UDim.new(0, 8)
    UI.edge(btn, 0.4)

    local arrow = Instance.new("TextLabel")
    arrow.BackgroundTransparency = 1
    arrow.Position = UDim2.new(1, -26, 0, 0)
    arrow.Size = UDim2.fromOffset(20, 46)
    arrow.Font = Enum.Font.Code
    arrow.TextSize = 14
    arrow.TextColor3 = COL_SUBTEXT
    arrow.Text = ">"
    arrow.Parent = btn

    return btn
end

-- Suggestions first (gold), then Universal, then Steal an Egg
suggestBtn   = makeGameBtn("Suggestions Script", 1)
universalBtn = makeGameBtn("Universal", 2)
stealBtn     = makeGameBtn("Steal an Egg", 3)

-- Gold style sa Suggest button
suggestBtn.BackgroundColor3 = Color3.fromRGB(38, 30, 22)
suggestBtn.TextColor3 = Color3.fromRGB(255, 220, 140)
local sgStroke = Instance.new("UIStroke", suggestBtn)
sgStroke.Color = Color3.fromRGB(255, 180, 60)
sgStroke.Thickness = 1.2
sgStroke.Transparency = 0.2
sgStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- ===== UNIVERSAL VIEW =====
universalView = Instance.new("Frame")
universalView.Name = "UniversalView"
universalView.Size = UDim2.fromScale(1, 1)
universalView.BackgroundTransparency = 1
universalView.Visible = false
universalView.Parent = scriptPage

local univPad = Instance.new("UIPadding", universalView)
univPad.PaddingTop = UDim.new(0, 4)
univPad.PaddingBottom = UDim.new(0, 4)
univPad.PaddingLeft = UDim.new(0, 2)
univPad.PaddingRight = UDim.new(0, 2)

local backUnivBtn = Instance.new("TextButton")
backUnivBtn.Size = UDim2.fromOffset(64, 26)
backUnivBtn.Position = UDim2.fromOffset(0, 0)
backUnivBtn.BackgroundColor3 = COL_CARD
backUnivBtn.Text = "< Back"
backUnivBtn.Font = Enum.Font.Code
backUnivBtn.TextSize = 10
backUnivBtn.TextColor3 = COL_TEXT
backUnivBtn.AutoButtonColor = false
backUnivBtn.BorderSizePixel = 0
backUnivBtn.Parent = universalView

Instance.new("UICorner", backUnivBtn).CornerRadius = UDim.new(0, 3)

local univTitle = Instance.new("TextLabel")
univTitle.BackgroundTransparency = 1
univTitle.Position = UDim2.fromOffset(74, 0)
univTitle.Size = UDim2.new(1, -74, 0, 26)
univTitle.Font = Enum.Font.Code
univTitle.TextSize = 12
univTitle.TextColor3 = COL_TEXT
univTitle.TextXAlignment = Enum.TextXAlignment.Left
univTitle.Text = "Universal"
univTitle.Parent = universalView

local univSearch = Instance.new("Frame")
univSearch.Size = UDim2.new(1, -6, 0, 30)
univSearch.Position = UDim2.fromOffset(0, 36)
univSearch.BackgroundColor3 = COL_CARD
univSearch.BorderSizePixel = 0
univSearch.Parent = universalView

Instance.new("UICorner", univSearch).CornerRadius = UDim.new(0, 3)

local univSearchPad = Instance.new("UIPadding", univSearch)
univSearchPad.PaddingLeft = UDim.new(0, 10)
univSearchPad.PaddingRight = UDim.new(0, 10)

local univBox = Instance.new("TextBox")
univBox.Size = UDim2.new(1, 0, 1, 0)
univBox.Position = UDim2.fromOffset(0, 0)
univBox.BackgroundTransparency = 1
univBox.Font = Enum.Font.Code
univBox.TextSize = 10
univBox.TextColor3 = COL_TEXT
univBox.PlaceholderText = "Search scripts..."
univBox.PlaceholderColor3 = COL_MUTED
univBox.Text = ""
univBox.TextXAlignment = Enum.TextXAlignment.Left
univBox.ClearTextOnFocus = false
univBox.Parent = univSearch

local univList = Instance.new("ScrollingFrame")
univList.Size = UDim2.new(1, -6, 1, -78)
univList.Position = UDim2.fromOffset(0, 74)
univList.BackgroundTransparency = 1
univList.BorderSizePixel = 0
univList.ScrollBarThickness = 3
univList.ScrollBarImageColor3 = COL_ACCENT
univList.CanvasSize = UDim2.fromOffset(0, 0)
univList.AutomaticCanvasSize = Enum.AutomaticSize.Y
univList.Parent = universalView

local univLayout = Instance.new("UIListLayout", univList)
univLayout.Padding = UDim.new(0, 8)

stealView = Instance.new("Frame")
stealView.Name = "StealView"
stealView.Size = UDim2.fromScale(1, 1)
stealView.BackgroundTransparency = 1
stealView.Visible = false
stealView.Parent = scriptPage

local stealPad = Instance.new("UIPadding", stealView)
stealPad.PaddingTop = UDim.new(0, 4)
stealPad.PaddingBottom = UDim.new(0, 4)
stealPad.PaddingLeft = UDim.new(0, 2)
stealPad.PaddingRight = UDim.new(0, 2)

local backStealBtn = Instance.new("TextButton")
backStealBtn.Size = UDim2.fromOffset(64, 26)
backStealBtn.Position = UDim2.fromOffset(0, 0)
backStealBtn.BackgroundColor3 = COL_CARD
backStealBtn.Text = "< Back"
backStealBtn.Font = Enum.Font.Code
backStealBtn.TextSize = 10
backStealBtn.TextColor3 = COL_TEXT
backStealBtn.AutoButtonColor = false
backStealBtn.BorderSizePixel = 0
backStealBtn.Parent = stealView

Instance.new("UICorner", backStealBtn).CornerRadius = UDim.new(0, 3)

local stealTitle = Instance.new("TextLabel")
stealTitle.BackgroundTransparency = 1
stealTitle.Position = UDim2.fromOffset(74, 0)
stealTitle.Size = UDim2.new(1, -74, 0, 26)
stealTitle.Font = Enum.Font.Code
stealTitle.TextSize = 12
stealTitle.TextColor3 = COL_TEXT
stealTitle.TextXAlignment = Enum.TextXAlignment.Left
stealTitle.Text = "Steal an Egg"
stealTitle.Parent = stealView

local stealSearch = Instance.new("Frame")
stealSearch.Size = UDim2.new(1, -6, 0, 30)
stealSearch.Position = UDim2.fromOffset(0, 36)
stealSearch.BackgroundColor3 = COL_CARD
stealSearch.BorderSizePixel = 0
stealSearch.Parent = stealView

Instance.new("UICorner", stealSearch).CornerRadius = UDim.new(0, 3)

local stealSearchPad = Instance.new("UIPadding", stealSearch)
stealSearchPad.PaddingLeft = UDim.new(0, 10)
stealSearchPad.PaddingRight = UDim.new(0, 10)

local stealBox = Instance.new("TextBox")
stealBox.Size = UDim2.new(1, 0, 1, 0)
stealBox.Position = UDim2.fromOffset(0, 0)
stealBox.BackgroundTransparency = 1
stealBox.Font = Enum.Font.Code
stealBox.TextSize = 10
stealBox.TextColor3 = COL_TEXT
stealBox.PlaceholderText = "Search scripts..."
stealBox.PlaceholderColor3 = COL_MUTED
stealBox.Text = ""
stealBox.TextXAlignment = Enum.TextXAlignment.Left
stealBox.ClearTextOnFocus = false
stealBox.Parent = stealSearch

local stealTabs = Instance.new("Frame")
stealTabs.Size = UDim2.new(1, -6, 0, 30)
stealTabs.Position = UDim2.fromOffset(0, 74)
stealTabs.BackgroundTransparency = 1
stealTabs.Parent = stealView

local function makeStealTab(text, x, w)
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(w, 30)
    b.Position = UDim2.fromOffset(x, 0)
    b.BackgroundColor3 = COL_CARD
    b.Text = text
    b.Font = Enum.Font.Code
    b.TextSize = 9
    b.TextColor3 = COL_TEXT
    b.AutoButtonColor = false
    b.BorderSizePixel = 0
    b.Parent = stealTabs

    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 3)
    return b
end

tabKey      = makeStealTab("KEY", 0, 74)
tabKeyless  = makeStealTab("KEYLESS", 80, 74)
tabVisuals  = makeStealTab("VISUALS", 160, 74)

tabKey.BackgroundColor3 = COL_ACCENT

local stealList = Instance.new("ScrollingFrame")
stealList.Size = UDim2.new(1, -6, 1, -118)
stealList.Position = UDim2.fromOffset(0, 114)
stealList.BackgroundTransparency = 1
stealList.BorderSizePixel = 0
stealList.ScrollBarThickness = 3
stealList.ScrollBarImageColor3 = COL_ACCENT
stealList.CanvasSize = UDim2.fromOffset(0, 0)
stealList.AutomaticCanvasSize = Enum.AutomaticSize.Y
stealList.Parent = stealView

local stealLayout = Instance.new("UIListLayout", stealList)
stealLayout.Padding = UDim.new(0, 8)

local UNIVERSAL_SCRIPTS = {
    {"Animation Changer", "https://rawscripts.net/raw/Universal-Script-Free-animations-112111"},
    {"Avatar Changer",    "https://raw.githubusercontent.com/Unknown-ugc/Unknown/refs/heads/main/Avatar%20change"},
    {"Shader",            "https://pastebin.com/raw/Zpaf00Nu"},
    {"Shader 1",          "https://raw.githubusercontent.com/randomstring0/pshade-ultimate/refs/heads/main/src/cd.lua"},
    {"Shader 2",          "https://rawscripts.net/raw/Universal-Script-Simple-Shader-37434"},
    {"Universal Graphics","https://raw.githubusercontent.com/Uranus197/-Univers-Hub-Graphics-Script-/refs/heads/main/UniversHub"},
}

local KEY_HUBS = {
    {"Clover Hub", "https://cloverhub.app/clover.lua"},
    {"Ajjans Hub", "https://api.luarmor.net/files/v4/loaders/359e97f8618e9008afe5f496184ebb7c.lua"},
    {"Big Foot", "https://raw.githubusercontent.com/hanniii1/Loader/refs/heads/main/BFLoader.lua"},
    {"Speed Hub", "https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua"},
    {"Zeroin Hub", "https://zeroinhub.com/api/script"},
    {"Quantumq Onyx", "https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/QuantumOnyx.lua"},
    {"Axonic", "https://raw.githubusercontent.com/Kenniel123/Steal-A-Egg/refs/heads/main/Steal%20A%20Egg"},
    {"Night Hub", "https://raw.githubusercontent.com/WhiteX1208/Scripts/refs/heads/main/StealAnEggs.luau"},
    {"On Hub", "https://raw.githubusercontent.com/davizin713/ONhub/refs/heads/main/script.lua"},
    {"NEOX HUB", "https://raw.githubusercontent.com/hassanxzayn-lua/NEOXHUBMAIN/refs/heads/main/loader"},
    {"RIFT GOHA", "https://raw.githubusercontent.com/Dodoyung24/script-core/main/Steal-An-Egg"},
    {"ATHER HUB", "https://api.luarmor.net/files/v3/loaders/2529a5f9dfddd5523ca4e22f21cceffa.lua"},
    {"VANITY HUB", "https://vanityscript.xyz/loader"},
    {"RONIX HUB", "https://api.luarmor.net/files/v3/loaders/fda9babd071d6b536a745774b6bc681c.lua"},
    {"UNREXL", "https://raw.githubusercontent.com/unrexl/Scripts/refs/heads/main/StealaEgg"},
    {"WADIDIS HUB", "https://api.jnkie.com/api/v1/luascripts/public/809c81e15814d1c016f44d9fe56587f5f38c55a97f203f11bc1a3f7cc3725c5f/download"},
    {"H4XSCRIPTS", "https://raw.githubusercontent.com/H4xScripts/Loader/refs/heads/main/loader.lua"},
    {"THAN HUB", "https://api.luarmor.net/files/v4/loaders/d1c82862a093e64c6bd82bb6d6f7a46b.lua"},
    {"YANTO HUB", "https://raw.githubusercontent.com/YantoRoblox/Script-Free-YantoHUB/refs/heads/main/YantoHUB"},
    {"CHIYO HUB", "https://raw.githubusercontent.com/kaisenlmao/loader/refs/heads/main/chiyo.lua"},
    {"OMG HUB", "https://raw.githubusercontent.com/Omgshit/Scripts/main/MainLoader.lua"},
    {"SOLIX HUB", "https://raw.githubusercontent.com/bao8jl/solixhub/main/loader"},
    {"SNOWY HUB", "https://flowauth.net/v1/ui/a87f00d9adf63658655fcd02ab86a4ef.lua"},
    {"ZHENN SPAWNER", "https://raw.githubusercontent.com/ZhennHub/PetSpawner/refs/heads/main/lua"},
    {"NOVA HUB", "https://raw.githubusercontent.com/NovaHubRBLX/NovaHub/refs/heads/main/novahub.lua"},
    {"SPORTSCLUB HUB", "https://loader.sportsclub.fun/loader.luau"},
    {"GS HUB", "https://gist.githubusercontent.com/spiritualgaming1123-beep/46ef55c5f8284e076aafc5ebd12233f4/raw/5b24749c3931c1838a76e64c9af508dcdd03700a/gistfile1.lua"},
    {"SAIOPS HUB", "https://api.saiops.cc/scripts/Steal-An-Egg-Script.lua"},
    {"NEVERLOSE", "https://raw.githubusercontent.com/inrate1337/NeverloseLoaderRoblox/refs/heads/main/main.luau"},
    {"OCTOPUS HUB", "https://www.octopushub.xyz/loader"},
    {"JINHUB", "https://jinhub.my.id/scripts/Universal.lua"},
    {"OVERFLOW", "https://overflow.cx/loader.lua"},
    {"SAKURA HUB", "https://flowauth.net/v1/ui/d00ec69382de97372fc9559efc722298.lua"},
    {"FORGE HUB", "https://cdn.forgehub.store/loader"},
    {"BASEMENT HUB", "https://thebsmt.xyz/BSMT"},
    {"KALI HUB", "https://kalihub.xyz/loader.lua"},
    {"CORE HUB", "https://getcore.lol/loader.lua"},
    {"APEL HUB", "https://apelhub.com/loader.lua"},
    {"FISHY", "https://jnkie.com/loaders/fishyhub"},
    {"VIVID LUA", "https://vivid.vividhub.workers.dev/loader.lua"},
    {"SHADOW HUB", "https://pastebin.com/raw/QAvDbBKa"},
    {"KING VYPER", "https://kingvypers.site/raw/TrialLoader"},
    {"HIP HUB", "https://hiphub.cloud/api/script-roblox/loader"},
    {"POTATO HUB", "https://raw.githubusercontent.com/potatohub67/potatoscripts/refs/heads/main/stealaegg.lua"},
}

local KEYLESS_HUBS = {
    {"Cat Hub Instant Egg", "https://raw.githubusercontent.com/showscript-hub/Script/refs/heads/main/Cat%20hub%20instant%20egg"},
    {"Bypass Speed", "https://rawscripts.net/raw/Steal-An-Egg-bypass-anti-cheat-224212"},
    {"Nasi Rendang", "https://www.nrlscript.com/raw/y9BUU6LkVW"},
    {"Miranda Hub", "https://api.luarmor.net/files/v4/loaders/7891557d7950ed56a7d1d8f57b66ad4d.lua"},
    {"Lennon Hub", "https://raw.githubusercontent.com/lennonxscripts/lennonhubv4/refs/heads/main/stealanegg"},
    {"Foxname", "https://raw.githubusercontent.com/caomod2077/Script/refs/heads/main/Fn-stealanegg.lua"},
    {"Mcrzhub", "https://flowauth.net/v1/loaders/3c4e87ed34813171b0f8d53a108a7d88.lua"},
    {"VXEZES", "https://vxezestudio.online/api/scripts/script_G5CGjqj2X3rOS/stream/init"},
    {"Anti Guard", "https://api.getpolsec.com/scripts/hosted/6582551b42d21c6b7eb55f1d76d8d50ce53cb35592093d6615b5e83437594dc0.lua"},
    {"Lkz", "https://api.luarmor.net/files/v4/loaders/65bf3459d87ba3ac46350e154b640929.lua"},
    {"Decode", "https://raw.githubusercontent.com/ItzYumi/Decode/refs/heads/main/DE%3ACODE.lua"},
    {"Blxyo Hub", "https://flowauth.net/v1/loaders/69d3463240384f3a73fbe32c178093a2.lua"},
    {"Hoshi Hub", "https://hoshihub.site/loader.lua"},
    {"Sena Hub", "https://senahub.xyz/raw/loader"},
    {"Vincetore", "https://raw.githubusercontent.com/idk953072-crypto/Steal-an-Egg/refs/heads/main/vincitore"},
    {"Chilli Hub", "https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua"},
    {"Tsuo", "https://raw.githubusercontent.com/Tsuo7/TsuoHub/main/stealanegg"},
    {"Ouroboros", "https://raw.githubusercontent.com/joustingmatch/Ouroboros/main/loader.lua"},
    {"VOIDHUB", "https://voidon.top/api/loader/main"},
    {"LIMBO HUB", "https://limbohub.my.id/loader.lua"},
    {"OXIDE HUB", "https://raw.githubusercontent.com/xulfo/Oxide-Loader/main/Main.lua"},
    {"PULSE HUB", "https://raw.githubusercontent.com/PulseZax/Loader/refs/heads/main/.lua"},
    {"YARHM HUB", "https://yarhm.com"},
    {"MONARCHH", "https://raw.githubusercontent.com/nobuxy/monarch.win/refs/heads/main/Monarch.lua"},
    {"DIVINE EGG", "https://raw.githubusercontent.com/SynergyNetworkz/VULN/refs/heads/main/STEALANEGG.lua"},
    {"TOKINU", "https://raw.githubusercontent.com/Tokinu-Scripts/Steal-An-Egg/refs/heads/main/Instant/Tp"},
    {"NEVA HUB", "https://raw.githubusercontent.com/VEZ2/NEVAHUB/main/2"},
    {"LEVON HUB", "https://pastefy.app/nasHhfko/raw"},
    {"PET SPAWNER", "https://raw.githubusercontent.com/bugxiefun/roblox-scripts/refs/heads/main/rblxscripts-stealanegg-spawner"},
    {"VALINC HUB", "https://api.valincsyndicate.com/v1/releases/5502cba03703f4a3628d522d396b80d8.lua"},
    {"CIAO HUB HOP", "https://pastefy.app/YoZocJ8O/raw"},
    {"RONNEI HUB", "https://raw.githubusercontent.com/elonmod/skibidi/refs/heads/main/Ronneihub-keyless.lua"},
    {"PROJECT-MADARA", "https://raw.githubusercontent.com/IsThisMe01/Project-Madara/refs/heads/main/stealanegg"},
    {"TOOLBOX", "https://raw.githubusercontent.com/Abdullahking20/loader-lua/main/loader"},
    {"CITRA HUB", "https://raw.githubusercontent.com/gilgameshfate59/ohbfoosk8tid/main/CitraLoader.lua"},
    {"VSN", "https://raw.githubusercontent.com/NetNullv1/VSN/refs/heads/main/HUB"},
    {"BK HUB", "https://api.luarmor.net/files/v4/loaders/9ee4edde227ac85f50872bf9e4226508.lua"},
    {"AXURS", "https://raw.githubusercontent.com/XE3Scripts/Axur-sGamesHub/refs/heads/main/StealAnEgg"},
    {"WIS HUB", "https://api.wishub.cloud/files/loader.lua"},
    {"SOFTKILLZ", "https://pastebin.com/raw/ZuEBwb5K"},
}

local VISUAL_HUBS = {
    {"Spawner1", "https://raw.githubusercontent.com/bugxiefun/roblox-scripts/refs/heads/main/rblxscripts-stealanegg-spawner"},
    {"Admin Panel", "https://api.jnkie.com/api/v1/luascripts/public/f6851ba0a3fc126430592a97d523d7c05b632f607eefb582f11353b9ef77a38f/download"},
    {"Pet Spawner", "https://api.luarmor.net/files/v4/loaders/d8f1c691a58edb11ef782849f80e9b61.lua"},
}

ALL_SCRIPT_URLS = {}
_G.ALL_SCRIPT_URLS = ALL_SCRIPT_URLS
for _, s in ipairs(UNIVERSAL_SCRIPTS) do ALL_SCRIPT_URLS[s[1]] = s[2] end
for _, s in ipairs(KEY_HUBS) do ALL_SCRIPT_URLS[s[1]] = s[2] end
for _, s in ipairs(KEYLESS_HUBS) do ALL_SCRIPT_URLS[s[1]] = s[2] end
for _, s in ipairs(VISUAL_HUBS) do ALL_SCRIPT_URLS[s[1]] = s[2] end

-- ===== SUGGEST VIEW =====
suggestView = Instance.new("Frame")
suggestView.Name = "SuggestView"
suggestView.Size = UDim2.fromScale(1, 1)
suggestView.BackgroundTransparency = 1
suggestView.Visible = false
suggestView.Parent = scriptPage

local sugPad = Instance.new("UIPadding", suggestView)
sugPad.PaddingTop = UDim.new(0, 4)
sugPad.PaddingBottom = UDim.new(0, 4)
sugPad.PaddingLeft = UDim.new(0, 2)
sugPad.PaddingRight = UDim.new(0, 2)

local backSuggestBtn = Instance.new("TextButton")
backSuggestBtn.Size = UDim2.fromOffset(64, 26)
backSuggestBtn.Position = UDim2.fromOffset(0, 0)
backSuggestBtn.BackgroundColor3 = COL_CARD
backSuggestBtn.Text = "< Back"
backSuggestBtn.Font = Enum.Font.Code
backSuggestBtn.TextSize = 10
backSuggestBtn.TextColor3 = COL_TEXT
backSuggestBtn.AutoButtonColor = false
backSuggestBtn.BorderSizePixel = 0
backSuggestBtn.Parent = suggestView

Instance.new("UICorner", backSuggestBtn).CornerRadius = UDim.new(0, 3)

local suggestTitle = Instance.new("TextLabel")
suggestTitle.BackgroundColor3 = Color3.fromRGB(255, 180, 60)
suggestTitle.BackgroundTransparency = 1
suggestTitle.Position = UDim2.fromOffset(74, 0)
suggestTitle.Size = UDim2.new(1, -80, 0, 26)
suggestTitle.Font = Enum.Font.Code
suggestTitle.TextSize = 12
suggestTitle.TextColor3 = Color3.fromRGB(255, 200, 80)
suggestTitle.TextXAlignment = Enum.TextXAlignment.Left
suggestTitle.Text = "Suggestions Script"
suggestTitle.Parent = suggestView

local suggestStatus = Instance.new("TextLabel")
suggestStatus.BackgroundTransparency = 1
suggestStatus.Position = UDim2.fromOffset(0, 29)
suggestStatus.Size = UDim2.new(1, -6, 0, 16)
suggestStatus.Font = Enum.Font.Code
suggestStatus.TextSize = 10
suggestStatus.TextColor3 = COL_MUTED
suggestStatus.TextXAlignment = Enum.TextXAlignment.Left
suggestStatus.Text = ""
suggestStatus.Parent = suggestView

local sugGameLbl = Instance.new("TextLabel")
sugGameLbl.BackgroundTransparency = 1
sugGameLbl.Position = UDim2.fromOffset(0, 46)
sugGameLbl.Size = UDim2.new(1, 0, 0, 12)
sugGameLbl.Font = Enum.Font.Code
sugGameLbl.TextSize = 9
sugGameLbl.TextColor3 = COL_MUTED
sugGameLbl.TextXAlignment = Enum.TextXAlignment.Left
sugGameLbl.Text = "GAME NAME *"
sugGameLbl.Parent = suggestView

local sugGameBox = Instance.new("TextBox")
sugGameBox.Size = UDim2.new(1, -6, 0, 28)
sugGameBox.Position = UDim2.fromOffset(0, 59)
sugGameBox.BackgroundColor3 = COL_CARD
sugGameBox.Font = Enum.Font.Code
sugGameBox.TextSize = 10
sugGameBox.TextColor3 = COL_TEXT
sugGameBox.PlaceholderText = "Enter game name..."
sugGameBox.PlaceholderColor3 = COL_MUTED
sugGameBox.Text = ""
sugGameBox.TextXAlignment = Enum.TextXAlignment.Left
sugGameBox.ClearTextOnFocus = false
sugGameBox.BorderSizePixel = 0
sugGameBox.Parent = suggestView

Instance.new("UICorner", sugGameBox).CornerRadius = UDim.new(0, 3)
Instance.new("UIPadding", sugGameBox).PaddingLeft = UDim.new(0, 10)

local sugScriptLbl = Instance.new("TextLabel")
sugScriptLbl.BackgroundTransparency = 1
sugScriptLbl.Position = UDim2.fromOffset(0, 91)
sugScriptLbl.Size = UDim2.new(1, 0, 0, 12)
sugScriptLbl.Font = Enum.Font.Code
sugScriptLbl.TextSize = 9
sugScriptLbl.TextColor3 = COL_MUTED
sugScriptLbl.TextXAlignment = Enum.TextXAlignment.Left
sugScriptLbl.Text = "SCRIPT NAME *"
sugScriptLbl.Parent = suggestView

local sugScriptBox = Instance.new("TextBox")
sugScriptBox.Size = UDim2.new(1, -6, 0, 28)
sugScriptBox.Position = UDim2.fromOffset(0, 104)
sugScriptBox.BackgroundColor3 = COL_CARD
sugScriptBox.Font = Enum.Font.Code
sugScriptBox.TextSize = 10
sugScriptBox.TextColor3 = COL_TEXT
sugScriptBox.PlaceholderText = "Enter script name..."
sugScriptBox.PlaceholderColor3 = COL_MUTED
sugScriptBox.Text = ""
sugScriptBox.TextXAlignment = Enum.TextXAlignment.Left
sugScriptBox.ClearTextOnFocus = false
sugScriptBox.BorderSizePixel = 0
sugScriptBox.Parent = suggestView

Instance.new("UICorner", sugScriptBox).CornerRadius = UDim.new(0, 3)
Instance.new("UIPadding", sugScriptBox).PaddingLeft = UDim.new(0, 10)

local sugDescLbl = Instance.new("TextLabel")
sugDescLbl.BackgroundTransparency = 1
sugDescLbl.Position = UDim2.fromOffset(0, 139)
sugDescLbl.Size = UDim2.new(1, -70, 0, 12)
sugDescLbl.Font = Enum.Font.Code
sugDescLbl.TextSize = 9
sugDescLbl.TextColor3 = COL_MUTED
sugDescLbl.TextXAlignment = Enum.TextXAlignment.Left
sugDescLbl.Text = "DESCRIPTION *"
sugDescLbl.Parent = suggestView

local sugDescCount = Instance.new("TextLabel")
sugDescCount.BackgroundTransparency = 1
sugDescCount.Position = UDim2.new(1, -66, 0, 139)
sugDescCount.Size = UDim2.fromOffset(60, 12)
sugDescCount.Font = Enum.Font.Code
sugDescCount.TextSize = 8
sugDescCount.TextColor3 = COL_MUTED
sugDescCount.TextXAlignment = Enum.TextXAlignment.Right
sugDescCount.Text = "0/200"
sugDescCount.Parent = suggestView

local sugDescBox = Instance.new("TextBox")
sugDescBox.Size = UDim2.new(1, -6, 0, 48)
sugDescBox.Position = UDim2.fromOffset(0, 154)
sugDescBox.BackgroundColor3 = COL_CARD
sugDescBox.Font = Enum.Font.Code
sugDescBox.TextSize = 10
sugDescBox.TextColor3 = COL_TEXT
sugDescBox.PlaceholderText = "What does this script do? Max 200 chars."
sugDescBox.PlaceholderColor3 = COL_MUTED
sugDescBox.Text = ""
sugDescBox.TextXAlignment = Enum.TextXAlignment.Left
sugDescBox.TextYAlignment = Enum.TextYAlignment.Top
sugDescBox.TextWrapped = true
sugDescBox.MultiLine = true
sugDescBox.ClearTextOnFocus = false
sugDescBox.BorderSizePixel = 0
sugDescBox.Parent = suggestView

Instance.new("UICorner", sugDescBox).CornerRadius = UDim.new(0, 3)

local sugDescPad = Instance.new("UIPadding", sugDescBox)
sugDescPad.PaddingLeft = UDim.new(0, 10)
sugDescPad.PaddingRight = UDim.new(0, 10)
sugDescPad.PaddingTop = UDim.new(0, 6)
sugDescPad.PaddingBottom = UDim.new(0, 6)

local sugLinkLbl = Instance.new("TextLabel")
sugLinkLbl.BackgroundTransparency = 1
sugLinkLbl.Position = UDim2.fromOffset(0, 215)
sugLinkLbl.Size = UDim2.new(1, 0, 0, 12)
sugLinkLbl.Font = Enum.Font.Code
sugLinkLbl.TextSize = 9
sugLinkLbl.TextColor3 = COL_MUTED
sugLinkLbl.TextXAlignment = Enum.TextXAlignment.Left
sugLinkLbl.Text = "LOADSTRING / URL (OPTIONAL)"
sugLinkLbl.Parent = suggestView

local sugLinkBox = Instance.new("TextBox")
sugLinkBox.Size = UDim2.new(1, -6, 0, 28)
sugLinkBox.Position = UDim2.fromOffset(0, 230)
sugLinkBox.BackgroundColor3 = COL_CARD
sugLinkBox.Font = Enum.Font.Code
sugLinkBox.TextSize = 9
sugLinkBox.TextColor3 = COL_TEXT
sugLinkBox.PlaceholderText = "loadstring(game:HttpGet(...))()"
sugLinkBox.PlaceholderColor3 = COL_MUTED
sugLinkBox.Text = ""
sugLinkBox.TextXAlignment = Enum.TextXAlignment.Left
sugLinkBox.ClearTextOnFocus = false
sugLinkBox.BorderSizePixel = 0
sugLinkBox.Parent = suggestView

Instance.new("UICorner", sugLinkBox).CornerRadius = UDim.new(0, 3)
Instance.new("UIPadding", sugLinkBox).PaddingLeft = UDim.new(0, 10)

local sugSendBtn = Instance.new("TextButton")
sugSendBtn.Size = UDim2.new(1, -6, 0, 30)
sugSendBtn.Position = UDim2.fromOffset(0, 264)
sugSendBtn.BackgroundColor3 = Color3.fromRGB(255, 180, 60)
sugSendBtn.Text = "SEND SUGGESTION"
sugSendBtn.Font = Enum.Font.Code
sugSendBtn.TextSize = 11
sugSendBtn.TextColor3 = Color3.fromRGB(40, 25, 5)
sugSendBtn.AutoButtonColor = false
sugSendBtn.BorderSizePixel = 0
sugSendBtn.Parent = suggestView

Instance.new("UICorner", sugSendBtn).CornerRadius = UDim.new(0, 3)

local sugCooldownLbl = Instance.new("TextLabel")
sugCooldownLbl.BackgroundTransparency = 1
sugCooldownLbl.Position = UDim2.fromOffset(0, 300)
sugCooldownLbl.Size = UDim2.new(1, -6, 0, 14)
sugCooldownLbl.Font = Enum.Font.Code
sugCooldownLbl.TextSize = 9
sugCooldownLbl.TextColor3 = COL_MUTED
sugCooldownLbl.TextXAlignment = Enum.TextXAlignment.Center
sugCooldownLbl.Text = ""
sugCooldownLbl.Parent = suggestView

-- ===== SUGGEST: Config + Cooldown =====
local SUGGEST_CD_FILE = "cathub_suggest_cd_" .. localPlayer.UserId .. ".txt"
local SUGGEST_COOLDOWN = 12 * 3600
local DESC_MAX = 200

sugDescBox:GetPropertyChangedSignal("Text"):Connect(function()
    local text = sugDescBox.Text or ""
    if #text > DESC_MAX then
        sugDescBox.Text = string.sub(text, 1, DESC_MAX)
    end
    sugDescCount.Text = #sugDescBox.Text .. "/" .. DESC_MAX
end)

local function getSuggestCooldownRemaining()
    if not (readfile and isfile) then return 0 end
    local ok, exists = pcall(function() return isfile(SUGGEST_CD_FILE) end)
    if not ok or not exists then return 0 end
    local ok2, content = pcall(function() return readfile(SUGGEST_CD_FILE) end)
    if not ok2 or not content then return 0 end
    local last = tonumber(content) or 0
    local remaining = (last + SUGGEST_COOLDOWN) - os.time()
    if remaining < 0 then remaining = 0 end
    return remaining
end

local function markSuggestSent()
    if writefile then
        pcall(function()
            writefile(SUGGEST_CD_FILE, tostring(os.time()))
        end)
    end
end

local function formatCooldownVerbose(seconds)
    local h = math.floor(seconds / 3600)
    local m = math.floor((seconds % 3600) / 60)
    local s = math.floor(seconds % 60)
    return string.format("%dh %dm %ds", h, m, s)
end

local sugCdConnection = nil

local function setSuggestFormDisabled(disabled)
    sugGameBox.TextEditable = not disabled
    sugScriptBox.TextEditable = not disabled
    sugDescBox.TextEditable = not disabled
    sugLinkBox.TextEditable = not disabled
    sugSendBtn.Active = not disabled
    if disabled then
        sugSendBtn.BackgroundColor3 = Color3.fromRGB(90, 75, 45)
        sugSendBtn.TextColor3 = Color3.fromRGB(180, 160, 120)
        sugSendBtn.Text = "COOLDOWN ACTIVE"
    else
        sugSendBtn.BackgroundColor3 = Color3.fromRGB(255, 180, 60)
        sugSendBtn.TextColor3 = Color3.fromRGB(40, 25, 5)
        sugSendBtn.Text = "SEND SUGGESTION"
    end
end

local function refreshSuggestCooldownUI()
    if sugCdConnection then
        sugCdConnection:Disconnect()
        sugCdConnection = nil
    end

    local remaining = getSuggestCooldownRemaining()

    if remaining > 0 then
        setSuggestFormDisabled(true)
        suggestStatus.TextColor3 = Color3.fromRGB(255, 200, 80)
        suggestStatus.Text = "You already sent a suggestion. Please wait."
        sugCooldownLbl.Text = "Cooldown: " .. formatCooldownVerbose(remaining) .. " until next suggest"

        sugCdConnection = RunService.Heartbeat:Connect(function()
            local rem = getSuggestCooldownRemaining()
            if rem <= 0 then
                if sugCdConnection then
                    sugCdConnection:Disconnect()
                    sugCdConnection = nil
                end
                setSuggestFormDisabled(false)
                suggestStatus.TextColor3 = COL_MUTED
                suggestStatus.Text = ""
                sugCooldownLbl.Text = ""
            else
                sugCooldownLbl.Text = "Cooldown: " .. formatCooldownVerbose(rem) .. " until next suggest"
            end
        end)
    else
        setSuggestFormDisabled(false)
        suggestStatus.TextColor3 = COL_MUTED
        suggestStatus.Text = ""
        sugCooldownLbl.Text = ""
    end
end

local function buildSuggestEmbed(gameName, scriptName, description, loadstringText)
    local phtTime = getPHTTimestamp()
    local payload = {
        username = "Cat Hub — Suggestions",
        embeds = {{
            title = "New Script Suggestion",
            color = 16765756,
            fields = {
                { name = "User:",        value = localPlayer.Name .. " (`" .. tostring(localPlayer.UserId) .. "`)", inline = false },
                { name = "Game:",        value = gameName,    inline = true },
                { name = "Script:",      value = scriptName,  inline = true },
                { name = "Description:", value = description, inline = false }
            },
            footer = { text = "Cat Hub v2.1 | " .. phtTime }
        }}
    }
    if loadstringText and loadstringText ~= "" then
        table.insert(payload.embeds[1].fields, {
            name = "Loadstring / URL:",
            value = "```"..loadstringText.."```",
            inline = false
        })
    end
    return payload
end

sugSendBtn.MouseButton1Click:Connect(function()
    if getSuggestCooldownRemaining() > 0 then
        refreshSuggestCooldownUI()
        return
    end

    local g = sugGameBox.Text:gsub("^%s+", ""):gsub("%s+$", "")
    local s = sugScriptBox.Text:gsub("^%s+", ""):gsub("%s+$", "")
    local d = sugDescBox.Text:gsub("^%s+", ""):gsub("%s+$", "")
    local l = sugLinkBox.Text:gsub("^%s+", ""):gsub("%s+$", "")

    if g == "" then
        suggestStatus.TextColor3 = COL_RED
        suggestStatus.Text = "Please enter the game name."
        return
    end
    if s == "" then
        suggestStatus.TextColor3 = COL_RED
        suggestStatus.Text = "Please enter the script name."
        return
    end
    if d == "" then
        suggestStatus.TextColor3 = COL_RED
        suggestStatus.Text = "Please enter a description."
        return
    end

    sendSuggestWebhook(buildSuggestEmbed(g, s, d, l))
    markSuggestSent()

    sugGameBox.Text = ""
    sugScriptBox.Text = ""
    sugDescBox.Text = ""
    sugLinkBox.Text = ""

    suggestStatus.TextColor3 = COL_GREEN
    suggestStatus.Text = "Suggestion sent! Thank you for contributing to Cat Hub."

    refreshSuggestCooldownUI()
end)

backSuggestBtn.MouseButton1Click:Connect(function()
    suggestView.Visible = false
    gameListView.Visible = true
    if sugCdConnection then
        sugCdConnection:Disconnect()
        sugCdConnection = nil
    end
end)

suggestBtn.MouseButton1Click:Connect(function()
    gameListView.Visible = false
    universalView.Visible = false
    stealView.Visible = false
    suggestView.Visible = true
    refreshSuggestCooldownUI()
end)

-- ===== ROW BUILDER =====
local favRunFunctions = {}

local function makeScriptRow(parentFrame, name, url)
    local row = Instance.new("Frame")
    row.Name = name
    row.Size = UDim2.new(1, -6, 0, 40)
    row.BackgroundColor3 = COL_PANEL
    row.BorderSizePixel = 0
    row.Parent = parentFrame

    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 3)
    UI.edge(row, 0.45)

    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 2, 1, -14)
    accentBar.Position = UDim2.fromOffset(0, 7)
    accentBar.BackgroundColor3 = COL_ACCENT
    accentBar.BorderSizePixel = 0
    accentBar.Parent = row

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.fromOffset(14, 0)
    label.Size = UDim2.new(1, -120, 1, 0)
    label.Font = Enum.Font.Code
    label.TextSize = 9
    label.TextColor3 = COL_TEXT
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextTruncate = Enum.TextTruncate.AtEnd
    label.Text = name
    label.Parent = row

    local star = Instance.new("TextButton")
    star.Size = UDim2.fromOffset(28, 24)
    star.Position = UDim2.new(1, -100, 0.5, -12)
    star.BackgroundColor3 = COL_BG
    star.Text = "★"
    star.Font = Enum.Font.Code
    star.TextSize = 12
    star.AutoButtonColor = false
    star.BorderSizePixel = 0
    star.Parent = row

    Instance.new("UICorner", star).CornerRadius = UDim.new(0, 3)

    local isFav = table.find(favorites, name) ~= nil
    star.TextColor3 = isFav and COL_STAR or COL_MUTED

    star.MouseButton1Click:Connect(function()
        local found = table.find(favorites, name)
        if found then
            table.remove(favorites, found)
            star.TextColor3 = COL_MUTED
        else
            table.insert(favorites, name)
            star.TextColor3 = COL_STAR
        end
        saveFavorites()
        if _G.CatHubRefreshFavorites then _G.CatHubRefreshFavorites() end
    end)

    local run = Instance.new("TextButton")
    run.Size = UDim2.fromOffset(60, 24)
    run.Position = UDim2.new(1, -68, 0.5, -12)
    run.BackgroundColor3 = COL_ACCENT
    run.Text = "RUN"
    run.Font = Enum.Font.Code
    run.TextSize = 9
    run.TextColor3 = COL_TEXT
    run.AutoButtonColor = false
    run.BorderSizePixel = 0
    run.Parent = row

    Instance.new("UICorner", run).CornerRadius = UDim.new(0, 3)

    local function runFn()
        pcall(function()
            loadstring(game:HttpGet(url))()
        end)
    end

    run.MouseButton1Click:Connect(function()
        task.spawn(runFn)
    end)

    favRunFunctions[name] = runFn
    if _G.CatHubFavRunFns then
        _G.CatHubFavRunFns[name] = runFn
    end

    if _G.CatHubRefreshFavorites then
        _G.CatHubRefreshFavorites()
    end
end

local function clearList(frame)
    for _, c in ipairs(frame:GetChildren()) do
        if c:IsA("Frame") then c:Destroy() end
    end
end

local function showUniversalList()
    clearList(univList)
    for _, item in ipairs(UNIVERSAL_SCRIPTS) do
        makeScriptRow(univList, item[1], item[2])
    end
    if _G.CatHubRefreshFavorites then _G.CatHubRefreshFavorites() end
end

local function showStealList(list)
    clearList(stealList)
    for _, item in ipairs(list) do
        makeScriptRow(stealList, item[1], item[2])
    end
    if _G.CatHubRefreshFavorites then _G.CatHubRefreshFavorites() end
end

tabKey.MouseButton1Click:Connect(function()
    tabKey.BackgroundColor3 = COL_ACCENT
    tabKeyless.BackgroundColor3 = COL_CARD
    tabVisuals.BackgroundColor3 = COL_CARD
    showStealList(KEY_HUBS)
    stealBox.Text = ""
end)

tabKeyless.MouseButton1Click:Connect(function()
    tabKeyless.BackgroundColor3 = COL_ACCENT
    tabKey.BackgroundColor3 = COL_CARD
    tabVisuals.BackgroundColor3 = COL_CARD
    showStealList(KEYLESS_HUBS)
    stealBox.Text = ""
end)

tabVisuals.MouseButton1Click:Connect(function()
    tabVisuals.BackgroundColor3 = COL_ACCENT
    tabKey.BackgroundColor3 = COL_CARD
    tabKeyless.BackgroundColor3 = COL_CARD
    showStealList(VISUAL_HUBS)
    stealBox.Text = ""
end)

univBox:GetPropertyChangedSignal("Text"):Connect(function()
    local q = string.lower(univBox.Text or "")
    for _, row in ipairs(univList:GetChildren()) do
        if row:IsA("Frame") then
            local nameLower = string.lower(row.Name)
            row.Visible = (q == "" or string.find(nameLower, q, 1, true) ~= nil)
        end
    end
end)

stealBox:GetPropertyChangedSignal("Text"):Connect(function()
    local q = string.lower(stealBox.Text or "")
    for _, row in ipairs(stealList:GetChildren()) do
        if row:IsA("Frame") then
            local nameLower = string.lower(row.Name)
            row.Visible = (q == "" or string.find(nameLower, q, 1, true) ~= nil)
        end
    end
end)

universalBtn.MouseButton1Click:Connect(function()
    gameListView.Visible = false
    universalView.Visible = true
    stealView.Visible = false
    suggestView.Visible = false
    showUniversalList()
end)

stealBtn.MouseButton1Click:Connect(function()
    gameListView.Visible = false
    universalView.Visible = false
    stealView.Visible = true
    suggestView.Visible = false
    showStealList(KEY_HUBS)
end)

backUnivBtn.MouseButton1Click:Connect(function()
    universalView.Visible = false
    gameListView.Visible = true
end)

backStealBtn.MouseButton1Click:Connect(function()
    stealView.Visible = false
    gameListView.Visible = true
end)
end -- Script page scope

local settingsPage, creditPage, aboutPage

local function __buildPages()

-- ===== SETTINGS PAGE =====
settingsPage = Instance.new("ScrollingFrame")
settingsPage.Name = "SettingsPage"
settingsPage.Size = UDim2.fromScale(1, 1)
settingsPage.BackgroundTransparency = 1
settingsPage.BorderSizePixel = 0
settingsPage.ScrollBarThickness = 4
settingsPage.ScrollBarImageColor3 = COL_ACCENT
settingsPage.ScrollBarImageTransparency = 0.3
settingsPage.CanvasSize = UDim2.fromOffset(0, 0)
settingsPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
settingsPage.ScrollingDirection = Enum.ScrollingDirection.Y
settingsPage.Visible = false
settingsPage.Parent = content
settingsPage.ZIndex = 2

local stPad = Instance.new("UIPadding", settingsPage)
stPad.PaddingTop = UDim.new(0, 4)
stPad.PaddingBottom = UDim.new(0, 4)
stPad.PaddingLeft = UDim.new(0, 2)
stPad.PaddingRight = UDim.new(0, 2)

local stTitle = Instance.new("TextLabel")
stTitle.BackgroundTransparency = 1
stTitle.Position = UDim2.fromOffset(0, 0)
stTitle.Size = UDim2.new(1, 0, 0, 22)
stTitle.Font = Enum.Font.Code
stTitle.TextSize = 14
stTitle.TextColor3 = COL_TEXT
stTitle.TextXAlignment = Enum.TextXAlignment.Left
stTitle.Text = "Settings"
stTitle.Parent = settingsPage

local colorTitle = Instance.new("TextLabel")
colorTitle.BackgroundTransparency = 1
colorTitle.Position = UDim2.fromOffset(0, 36)
colorTitle.Size = UDim2.new(1, 0, 0, 14)
colorTitle.Font = Enum.Font.Code
colorTitle.TextSize = 9
colorTitle.TextColor3 = COL_MUTED
colorTitle.TextXAlignment = Enum.TextXAlignment.Left
colorTitle.Text = "COLOR CHANGE"
colorTitle.Parent = settingsPage

local colorBtn = Instance.new("TextButton")
colorBtn.Size = UDim2.new(1, -6, 0, 30)
colorBtn.Position = UDim2.fromOffset(0, 46)
colorBtn.BackgroundColor3 = COL_PANEL
colorBtn.Text = "Color Change"
colorBtn.Font = Enum.Font.Code
colorBtn.TextSize = 10
colorBtn.TextColor3 = COL_TEXT
colorBtn.TextXAlignment = Enum.TextXAlignment.Left
colorBtn.AutoButtonColor = false
colorBtn.BorderSizePixel = 0
colorBtn.Parent = settingsPage

Instance.new("UICorner", colorBtn).CornerRadius = UDim.new(0, 3)
Instance.new("UIPadding", colorBtn).PaddingLeft = UDim.new(0, 14)

local colorPanel = Instance.new("Frame")
colorPanel.Size = UDim2.new(1, -6, 0, 130)
colorPanel.Position = UDim2.fromOffset(0, 94)
colorPanel.BackgroundColor3 = COL_PANEL
colorPanel.BorderSizePixel = 0
colorPanel.Visible = false
colorPanel.Parent = settingsPage

Instance.new("UICorner", colorPanel).CornerRadius = UDim.new(0, 3)

local colorPad = Instance.new("UIPadding", colorPanel)
colorPad.PaddingTop = UDim.new(0, 8)
colorPad.PaddingBottom = UDim.new(0, 8)
colorPad.PaddingLeft = UDim.new(0, 8)
colorPad.PaddingRight = UDim.new(0, 8)

local colorGrid = Instance.new("UIGridLayout", colorPanel)
colorGrid.CellSize = UDim2.fromOffset(80, 30)
colorGrid.CellPadding = UDim2.fromOffset(6, 6)

local playBtn
local transBar, transDot

local COLOR_COMBOS = {
    { name = "Midnight", bg = Color3.fromRGB(8, 12, 22), panel = Color3.fromRGB(13, 19, 34), card = Color3.fromRGB(19, 28, 48), divider = Color3.fromRGB(34, 52, 92),
      accent = Color3.fromRGB(50, 120, 255), glow = Color3.fromRGB(90, 160, 255), text = Color3.fromRGB(232, 240, 255), subtext = Color3.fromRGB(130, 150, 185), muted = Color3.fromRGB(82, 98, 128) },
    { name = "Cobalt", bg = Color3.fromRGB(6, 9, 26), panel = Color3.fromRGB(11, 15, 40), card = Color3.fromRGB(17, 23, 62), divider = Color3.fromRGB(32, 44, 104),
      accent = Color3.fromRGB(70, 100, 255), glow = Color3.fromRGB(120, 145, 255), text = Color3.fromRGB(232, 236, 255), subtext = Color3.fromRGB(128, 138, 190), muted = Color3.fromRGB(80, 88, 134) },
    { name = "Azure", bg = Color3.fromRGB(7, 14, 22), panel = Color3.fromRGB(12, 22, 34), card = Color3.fromRGB(18, 34, 50), divider = Color3.fromRGB(32, 62, 92),
      accent = Color3.fromRGB(36, 168, 255), glow = Color3.fromRGB(100, 205, 255), text = Color3.fromRGB(230, 244, 255), subtext = Color3.fromRGB(126, 160, 188), muted = Color3.fromRGB(78, 104, 126) },
    { name = "Steel", bg = Color3.fromRGB(10, 12, 18), panel = Color3.fromRGB(16, 19, 28), card = Color3.fromRGB(24, 28, 40), divider = Color3.fromRGB(42, 48, 68),
      accent = Color3.fromRGB(96, 128, 200), glow = Color3.fromRGB(140, 168, 230), text = Color3.fromRGB(234, 238, 248), subtext = Color3.fromRGB(136, 144, 166), muted = Color3.fromRGB(88, 94, 114) },
    { name = "Crimson", bg = Color3.fromRGB(14, 8, 12), panel = Color3.fromRGB(26, 14, 20), card = Color3.fromRGB(40, 22, 30), divider = Color3.fromRGB(90, 35, 55),
      accent = Color3.fromRGB(230, 70, 100), glow = Color3.fromRGB(255, 120, 150), text = Color3.fromRGB(255, 240, 245), subtext = Color3.fromRGB(200, 150, 170), muted = Color3.fromRGB(130, 90, 110) },
    { name = "Emerald", bg = Color3.fromRGB(8, 16, 12), panel = Color3.fromRGB(14, 28, 22), card = Color3.fromRGB(22, 42, 34), divider = Color3.fromRGB(40, 90, 70),
      accent = Color3.fromRGB(60, 210, 130), glow = Color3.fromRGB(100, 240, 170), text = Color3.fromRGB(235, 255, 245), subtext = Color3.fromRGB(150, 200, 175), muted = Color3.fromRGB(95, 135, 115) },
    { name = "Royal", bg = Color3.fromRGB(14, 10, 24), panel = Color3.fromRGB(24, 18, 38), card = Color3.fromRGB(36, 28, 54), divider = Color3.fromRGB(80, 55, 120),
      accent = Color3.fromRGB(165, 100, 255), glow = Color3.fromRGB(200, 150, 255), text = Color3.fromRGB(245, 240, 255), subtext = Color3.fromRGB(180, 165, 210), muted = Color3.fromRGB(120, 105, 150) },
    { name = "Amber", bg = Color3.fromRGB(16, 12, 8), panel = Color3.fromRGB(28, 21, 12), card = Color3.fromRGB(44, 33, 18), divider = Color3.fromRGB(100, 76, 30),
      accent = Color3.fromRGB(240, 170, 50), glow = Color3.fromRGB(255, 205, 100), text = Color3.fromRGB(255, 248, 235), subtext = Color3.fromRGB(210, 188, 150), muted = Color3.fromRGB(140, 118, 84) },
}

local function swapCol(c, list)
    for _, p in ipairs(list) do
        if c == p[1] then return p[2] end
    end
    return nil
end

local function applyTheme(combo)
    local bgList = {
        {COL_BG, combo.bg}, {COL_PANEL, combo.panel}, {COL_CARD, combo.card},
        {COL_DIVIDER, combo.divider}, {COL_ACCENT, combo.accent}, {COL_GLOW, combo.glow},
    }
    local txList = {
        {COL_TEXT, combo.text}, {COL_SUBTEXT, combo.subtext}, {COL_MUTED, combo.muted},
        {COL_GLOW, combo.glow}, {COL_ACCENT, combo.accent}, {COL_DIVIDER, combo.divider},
    }

    for _, v in ipairs(gui:GetDescendants()) do
        if v:IsA("GuiObject") then
            local n = swapCol(v.BackgroundColor3, bgList)
            if n then v.BackgroundColor3 = n end

            if v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("TextBox") then
                n = swapCol(v.TextColor3, txList)
                if n then v.TextColor3 = n end
            end
            if v:IsA("TextBox") then
                n = swapCol(v.PlaceholderColor3, txList)
                if n then v.PlaceholderColor3 = n end
            end
            if v:IsA("ScrollingFrame") then
                n = swapCol(v.ScrollBarImageColor3, bgList)
                if n then v.ScrollBarImageColor3 = n end
            end
        elseif v:IsA("UIStroke") then
            local n = swapCol(v.Color, bgList)
            if n then v.Color = n end
        end
    end

    COL_BG      = combo.bg
    COL_PANEL   = combo.panel
    COL_CARD    = combo.card
    COL_DIVIDER = combo.divider
    COL_ACCENT  = combo.accent
    COL_GLOW    = combo.glow
    COL_TEXT    = combo.text
    COL_SUBTEXT = combo.subtext
    COL_MUTED   = combo.muted
end

for _, combo in ipairs(COLOR_COMBOS) do
    local btn = Instance.new("TextButton")
    btn.BackgroundColor3 = combo.accent
    btn.Text = combo.name
    btn.Font = Enum.Font.Code
    btn.TextSize = 9
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.AutoButtonColor = false
    btn.BorderSizePixel = 0
    btn.Parent = colorPanel

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 3)

    btn.MouseButton1Click:Connect(function()
        applyTheme(combo)
        colorPanel.Visible = false
    end)
end

colorBtn.MouseButton1Click:Connect(function()
    colorPanel.Visible = not colorPanel.Visible
end)

local songTitle = Instance.new("TextLabel")
songTitle.BackgroundTransparency = 1
songTitle.Position = UDim2.fromOffset(0, 236)
songTitle.Size = UDim2.new(1, 0, 0, 14)
songTitle.Font = Enum.Font.Code
songTitle.TextSize = 9
songTitle.TextColor3 = COL_MUTED
songTitle.TextXAlignment = Enum.TextXAlignment.Left
songTitle.Text = "SONG ID"
songTitle.Parent = settingsPage

local songBox = Instance.new("TextBox")
songBox.Size = UDim2.new(1, -124, 0, 32)
songBox.Position = UDim2.fromOffset(0, 256)
songBox.BackgroundColor3 = COL_PANEL
songBox.Font = Enum.Font.Code
songBox.TextSize = 10
songBox.TextColor3 = COL_TEXT
songBox.PlaceholderText = "Enter Song ID"
songBox.PlaceholderColor3 = COL_MUTED
songBox.Text = ""
songBox.TextXAlignment = Enum.TextXAlignment.Left
songBox.ClearTextOnFocus = false
songBox.BorderSizePixel = 0
songBox.Parent = settingsPage

Instance.new("UICorner", songBox).CornerRadius = UDim.new(0, 3)
Instance.new("UIPadding", songBox).PaddingLeft = UDim.new(0, 12)

playBtn = Instance.new("TextButton")
playBtn.Size = UDim2.fromOffset(56, 32)
playBtn.Position = UDim2.new(1, -118, 0, 256)
playBtn.BackgroundColor3 = COL_ACCENT
playBtn.Text = "PLAY"
playBtn.Font = Enum.Font.Code
playBtn.TextSize = 9
playBtn.TextColor3 = COL_TEXT
playBtn.AutoButtonColor = false
playBtn.BorderSizePixel = 0
playBtn.Parent = settingsPage

Instance.new("UICorner", playBtn).CornerRadius = UDim.new(0, 3)

local stopBtn = Instance.new("TextButton")
stopBtn.Size = UDim2.fromOffset(56, 32)
stopBtn.Position = UDim2.new(1, -56, 0, 256)
stopBtn.BackgroundColor3 = COL_PANEL
stopBtn.Text = "STOP"
stopBtn.Font = Enum.Font.Code
stopBtn.TextSize = 9
stopBtn.TextColor3 = COL_TEXT
stopBtn.AutoButtonColor = false
stopBtn.BorderSizePixel = 0
stopBtn.Parent = settingsPage

Instance.new("UICorner", stopBtn).CornerRadius = UDim.new(0, 3)

local song = Instance.new("Sound")
song.Volume = 0.5
song.Looped = true
song.Parent = SoundService

playBtn.MouseButton1Click:Connect(function()
    local id = songBox.Text:gsub("%D", "")
    if id ~= "" then
        song.SoundId = "rbxassetid://"..id
        song:Play()
    end
end)

stopBtn.MouseButton1Click:Connect(function()
    song:Stop()
end)

local transTitle = Instance.new("TextLabel")
transTitle.BackgroundTransparency = 1
transTitle.Position = UDim2.fromOffset(0, 302)
transTitle.Size = UDim2.new(1, 0, 0, 14)
transTitle.Font = Enum.Font.Code
transTitle.TextSize = 9
transTitle.TextColor3 = COL_MUTED
transTitle.TextXAlignment = Enum.TextXAlignment.Left
transTitle.Text = "TRANSPARENCY 0%"
transTitle.Parent = settingsPage

transBar = Instance.new("Frame")
transBar.Position = UDim2.fromOffset(0, 326)
transBar.Size = UDim2.new(1, -6, 0, 8)
transBar.BackgroundColor3 = COL_PANEL
transBar.BorderSizePixel = 0
transBar.Parent = settingsPage

Instance.new("UICorner", transBar).CornerRadius = UDim.new(1, 0)

transDot = Instance.new("TextButton")
transDot.Size = UDim2.fromOffset(16, 16)
transDot.Position = UDim2.new(0, -8, 0.5, -8)
transDot.BackgroundColor3 = COL_ACCENT
transDot.Text = ""
transDot.BorderSizePixel = 0
transDot.AutoButtonColor = false
transDot.Parent = transBar

Instance.new("UICorner", transDot).CornerRadius = UDim.new(1, 0)

local transDragging = false
local transOriginals = nil

local function applyTransparency(percent)
    percent = math.clamp(percent, 0, 0.85)

    if not transOriginals then
        transOriginals = {}
        for _, v in ipairs(gui:GetDescendants()) do
            if v:IsA("GuiObject") then
                if v ~= transBar
                   and v ~= transDot
                   and not v:IsDescendantOf(transBar) then
                    transOriginals[v] = v.BackgroundTransparency
                end
            end
        end
    end

    for obj, orig in pairs(transOriginals) do
        if obj.Parent then
            obj.BackgroundTransparency = math.clamp(
                orig + percent * (1 - orig), 0, 1)
        end
    end
end

local function setTransFromX(xPos)
    local percent = math.clamp(
        (xPos - transBar.AbsolutePosition.X) /
        transBar.AbsoluteSize.X, 0, 1)
    transDot.Position = UDim2.new(percent, -8, 0.5, -8)
    transTitle.Text = "TRANSPARENCY "..math.floor(percent*100).."%"
    applyTransparency(percent)
end

transDot.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        transDragging = true
    end
end)

transBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        setTransFromX(input.Position.X)
    end
end)

UIS.InputChanged:Connect(function(input)
    if transDragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        setTransFromX(input.Position.X)
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        transDragging = false
    end
end)

-- ===== CREDIT PAGE =====
creditPage = Instance.new("ScrollingFrame")
creditPage.Name = "CreditPage"
creditPage.Size = UDim2.fromScale(1, 1)
creditPage.BackgroundTransparency = 1
creditPage.BorderSizePixel = 0
creditPage.ScrollBarThickness = 4
creditPage.ScrollBarImageColor3 = COL_ACCENT
creditPage.ScrollBarImageTransparency = 0.3
creditPage.CanvasSize = UDim2.fromOffset(0, 0)
creditPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
creditPage.ScrollingDirection = Enum.ScrollingDirection.Y
creditPage.Visible = false
creditPage.Parent = content
creditPage.ZIndex = 2

local crPad = Instance.new("UIPadding", creditPage)
crPad.PaddingTop = UDim.new(0, 4)
crPad.PaddingBottom = UDim.new(0, 4)
crPad.PaddingLeft = UDim.new(0, 2)
crPad.PaddingRight = UDim.new(0, 2)

local crTitle = Instance.new("TextLabel")
crTitle.BackgroundTransparency = 1
crTitle.Position = UDim2.fromOffset(0, 0)
crTitle.Size = UDim2.new(1, 0, 0, 22)
crTitle.Font = Enum.Font.Code
crTitle.TextSize = 14
crTitle.TextColor3 = COL_TEXT
crTitle.TextXAlignment = Enum.TextXAlignment.Left
crTitle.Text = "Credit"
crTitle.Parent = creditPage

local crThank = Instance.new("TextLabel")
crThank.BackgroundTransparency = 1
crThank.Position = UDim2.fromOffset(0, 36)
crThank.Size = UDim2.new(1, 0, 0, 40)
crThank.Font = Enum.Font.Code
crThank.TextSize = 10
crThank.TextColor3 = COL_TEXT
crThank.TextXAlignment = Enum.TextXAlignment.Left
crThank.TextYAlignment = Enum.TextYAlignment.Top
crThank.Text = "THANK YOU\nThank you for using cat hub!"
crThank.Parent = creditPage

local crSpecial = Instance.new("TextLabel")
crSpecial.BackgroundTransparency = 1
crSpecial.Position = UDim2.fromOffset(0, 84)
crSpecial.Size = UDim2.new(1, 0, 0, 14)
crSpecial.Font = Enum.Font.Code
crSpecial.TextSize = 9
crSpecial.TextColor3 = COL_MUTED
crSpecial.TextXAlignment = Enum.TextXAlignment.Left
crSpecial.Text = "SPECIAL THANKS TO"
crSpecial.Parent = creditPage

local tiktokList = {
    {"@official_mneil", "https://www.tiktok.com/@official_mneil"},
    {"@noah_dump5", "https://www.tiktok.com/@noah_dump5"},
    {"@_johnxines", "https://www.tiktok.com/@_johnxines"},
    {"@kenn50921", "https://www.tiktok.com/@kenn50921"},
}

for i, tk in ipairs(tiktokList) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -6, 0, 28)
    btn.Position = UDim2.fromOffset(0, 108 + (i - 1) * 34)
    btn.BackgroundColor3 = COL_PANEL
    btn.Text = tk[1]
    btn.Font = Enum.Font.Code
    btn.TextSize = 9
    btn.TextColor3 = COL_GLOW
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    btn.BorderSizePixel = 0
    btn.Parent = creditPage

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 3)
    Instance.new("UIPadding", btn).PaddingLeft = UDim.new(0, 14)

    btn.MouseButton1Click:Connect(function()
        if setclipboard then setclipboard(tk[2]) end
        btn.Text = "Copied!"
        task.wait(1.2)
        btn.Text = tk[1]
    end)
end

local crOwnerLabel = Instance.new("TextLabel")
crOwnerLabel.BackgroundTransparency = 1
crOwnerLabel.Position = UDim2.fromOffset(0, 254)
crOwnerLabel.Size = UDim2.new(1, 0, 0, 14)
crOwnerLabel.Font = Enum.Font.Code
crOwnerLabel.TextSize = 9
crOwnerLabel.TextColor3 = COL_MUTED
crOwnerLabel.TextXAlignment = Enum.TextXAlignment.Left
crOwnerLabel.Text = "OWNER"
crOwnerLabel.Parent = creditPage

local crOwner = Instance.new("TextLabel")
crOwner.BackgroundTransparency = 1
crOwner.Position = UDim2.fromOffset(0, 274)
crOwner.Size = UDim2.new(1, 0, 0, 22)
crOwner.Font = Enum.Font.Code
crOwner.TextSize = 12
crOwner.TextColor3 = COL_GLOW
crOwner.TextXAlignment = Enum.TextXAlignment.Left
crOwner.Text = "CHRIS"
crOwner.Parent = creditPage

-- ===== ABOUT PAGE =====
aboutPage = Instance.new("ScrollingFrame")
aboutPage.Name = "AboutPage"
aboutPage.Size = UDim2.fromScale(1, 1)
aboutPage.BackgroundTransparency = 1
aboutPage.BorderSizePixel = 0
aboutPage.ScrollBarThickness = 4
aboutPage.ScrollBarImageColor3 = COL_ACCENT
aboutPage.ScrollBarImageTransparency = 0.3
aboutPage.CanvasSize = UDim2.fromOffset(0, 0)
aboutPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
aboutPage.ScrollingDirection = Enum.ScrollingDirection.Y
aboutPage.Visible = false
aboutPage.Parent = content
aboutPage.ZIndex = 2

local abPad = Instance.new("UIPadding", aboutPage)
abPad.PaddingTop = UDim.new(0, 4)
abPad.PaddingBottom = UDim.new(0, 4)
abPad.PaddingLeft = UDim.new(0, 2)
abPad.PaddingRight = UDim.new(0, 2)

local abTitle = Instance.new("TextLabel")
abTitle.BackgroundTransparency = 1
abTitle.Position = UDim2.fromOffset(0, 0)
abTitle.Size = UDim2.new(1, 0, 0, 22)
abTitle.Font = Enum.Font.Code
abTitle.TextSize = 14
abTitle.TextColor3 = COL_TEXT
abTitle.TextXAlignment = Enum.TextXAlignment.Left
abTitle.Text = "About"
abTitle.Parent = aboutPage

local abVer = Instance.new("Frame")
abVer.Position = UDim2.fromOffset(0, 36)
abVer.Size = UDim2.new(1, -6, 0, 190)
abVer.BackgroundColor3 = COL_PANEL
abVer.BorderSizePixel = 0
abVer.Parent = aboutPage

Instance.new("UICorner", abVer).CornerRadius = UDim.new(0, 3)

local abVerStroke = Instance.new("UIStroke", abVer)
abVerStroke.Color = COL_ACCENT
abVerStroke.Thickness = 1
abVerStroke.Transparency = 0.4

local abVerPad = Instance.new("UIPadding", abVer)
abVerPad.PaddingTop = UDim.new(0, 12)
abVerPad.PaddingBottom = UDim.new(0, 12)
abVerPad.PaddingLeft = UDim.new(0, 14)
abVerPad.PaddingRight = UDim.new(0, 14)

local abVerTitle = Instance.new("TextLabel")
abVerTitle.BackgroundTransparency = 1
abVerTitle.Position = UDim2.fromOffset(0, 0)
abVerTitle.Size = UDim2.new(1, 0, 0, 16)
abVerTitle.Font = Enum.Font.Code
abVerTitle.TextSize = 11
abVerTitle.TextColor3 = COL_GLOW
abVerTitle.TextXAlignment = Enum.TextXAlignment.Left
abVerTitle.Text = "v2.1 UPDATE"
abVerTitle.Parent = abVer

local abChangelog = Instance.new("TextLabel")
abChangelog.BackgroundTransparency = 1
abChangelog.Position = UDim2.fromOffset(0, 26)
abChangelog.Size = UDim2.new(1, 0, 0, 130)
abChangelog.Font = Enum.Font.Code
abChangelog.TextSize = 9
abChangelog.TextColor3 = COL_TEXT
abChangelog.TextXAlignment = Enum.TextXAlignment.Left
abChangelog.TextYAlignment = Enum.TextYAlignment.Top
abChangelog.TextWrapped = true
abChangelog.Text = "- Dark blue theme back, flatter layout\n- Player tab: speed, inf jump, noclip, gravity\n- Teleport, spectate, freeze / unfreeze\n- 1st / 3rd person camera, reset player\n- ESP with team check\n- Force R6 / R15 (local only)\n- Avatar tab: id or username, live preview\n- Avatar favorites (star) + reset to main\n- Animation changer packs\n- Fixed theme switching and ping bars"
abChangelog.Parent = abVer

local abFree = Instance.new("Frame")
abFree.Position = UDim2.fromOffset(0, 240)
abFree.Size = UDim2.new(1, -6, 0, 80)
abFree.BackgroundColor3 = Color3.fromRGB(38, 30, 22)
abFree.BorderSizePixel = 0
abFree.Parent = aboutPage

Instance.new("UICorner", abFree).CornerRadius = UDim.new(0, 3)

local afStroke = Instance.new("UIStroke", abFree)
afStroke.Color = Color3.fromRGB(255, 180, 60)
afStroke.Thickness = 1.2
afStroke.Transparency = 0.3

local abFreePad = Instance.new("UIPadding", abFree)
abFreePad.PaddingTop = UDim.new(0, 12)
abFreePad.PaddingBottom = UDim.new(0, 12)
abFreePad.PaddingLeft = UDim.new(0, 14)
abFreePad.PaddingRight = UDim.new(0, 14)

local abFreeTitle = Instance.new("TextLabel")
abFreeTitle.BackgroundTransparency = 1
abFreeTitle.Position = UDim2.fromOffset(0, 0)
abFreeTitle.Size = UDim2.new(1, 0, 0, 16)
abFreeTitle.Font = Enum.Font.Code
abFreeTitle.TextSize = 11
abFreeTitle.TextColor3 = Color3.fromRGB(255, 200, 80)
abFreeTitle.TextXAlignment = Enum.TextXAlignment.Left
abFreeTitle.Text = "This script is 100% FREE!"
abFreeTitle.Parent = abFree

local abFreeMsg = Instance.new("TextLabel")
abFreeMsg.BackgroundTransparency = 1
abFreeMsg.Position = UDim2.fromOffset(0, 26)
abFreeMsg.Size = UDim2.new(1, 0, 0, 40)
abFreeMsg.Font = Enum.Font.Code
abFreeMsg.TextSize = 9
abFreeMsg.TextColor3 = Color3.fromRGB(230, 200, 150)
abFreeMsg.TextXAlignment = Enum.TextXAlignment.Left
abFreeMsg.TextYAlignment = Enum.TextYAlignment.Top
abFreeMsg.TextWrapped = true
abFreeMsg.Text = "If you PAID for it, you got scammed.\nReport the seller on Discord."
abFreeMsg.Parent = abFree

local abThanks = Instance.new("Frame")
abThanks.Position = UDim2.fromOffset(0, 334)
abThanks.Size = UDim2.new(1, -6, 0, 55)
abThanks.BackgroundColor3 = COL_PANEL
abThanks.BorderSizePixel = 0
abThanks.Parent = aboutPage

Instance.new("UICorner", abThanks).CornerRadius = UDim.new(0, 3)

local abThanksPad = Instance.new("UIPadding", abThanks)
abThanksPad.PaddingTop = UDim.new(0, 12)
abThanksPad.PaddingBottom = UDim.new(0, 12)
abThanksPad.PaddingLeft = UDim.new(0, 14)
abThanksPad.PaddingRight = UDim.new(0, 14)

local abThanksText = Instance.new("TextLabel")
abThanksText.BackgroundTransparency = 1
abThanksText.Position = UDim2.fromOffset(0, 0)
abThanksText.Size = UDim2.new(1, 0, 1, 0)
abThanksText.Font = Enum.Font.Code
abThanksText.TextSize = 11
abThanksText.TextColor3 = COL_TEXT
abThanksText.TextXAlignment = Enum.TextXAlignment.Left
abThanksText.TextYAlignment = Enum.TextYAlignment.Center
abThanksText.Text = "Thank you for using cat hub."
abThanksText.Parent = abThanks

end

__buildPages()

-- ===== PLAYER + AVATAR TABS =====
UI.buildTools = function()
    local LP = localPlayer
    local conns = {}
    local S = { speed = 16, keep = false, jump = false, noclip = false, esp = false, team = false, dirty = false }
    local defGravity = workspace.Gravity
    local origMin, origMax = LP.CameraMinZoomDistance, LP.CameraMaxZoomDistance
    local ord = 0

    local function track(c) table.insert(conns, c); return c end
    local function nextOrd() ord = ord + 1; return ord end
    local function hum()
        local c = LP.Character
        return c and c:FindFirstChildOfClass("Humanoid")
    end
    local function root()
        local c = LP.Character
        return c and c:FindFirstChild("HumanoidRootPart")
    end

    -- ---------- ui helpers ----------
    local function newPage(name)
        local p = Instance.new("ScrollingFrame")
        p.Name = name
        p.Size = UDim2.fromScale(1, 1)
        p.BackgroundTransparency = 1
        p.BorderSizePixel = 0
        p.ScrollBarThickness = 3
        p.ScrollBarImageColor3 = COL_ACCENT
        p.CanvasSize = UDim2.fromOffset(0, 0)
        p.AutomaticCanvasSize = Enum.AutomaticSize.Y
        p.ScrollingDirection = Enum.ScrollingDirection.Y
        p.Visible = false
        p.ZIndex = 2
        p.Parent = content
        local pad = Instance.new("UIPadding", p)
        pad.PaddingTop = UDim.new(0, 4)
        pad.PaddingBottom = UDim.new(0, 8)
        pad.PaddingLeft = UDim.new(0, 2)
        pad.PaddingRight = UDim.new(0, 8)
        local lay = Instance.new("UIListLayout", p)
        lay.Padding = UDim.new(0, 8)
        lay.SortOrder = Enum.SortOrder.LayoutOrder
        return p
    end

    local function label(parent, text, size, color, h)
        local l = Instance.new("TextLabel")
        l.BackgroundTransparency = 1
        l.Size = UDim2.new(1, 0, 0, h or 14)
        l.Font = Enum.Font.Code
        l.TextSize = size or 10
        l.TextColor3 = color or COL_TEXT
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.TextTruncate = Enum.TextTruncate.AtEnd
        l.Text = text
        l.LayoutOrder = #parent:GetChildren()
        l.Parent = parent
        return l
    end

    local function section(page, title)
        local card = Instance.new("Frame")
        card.Name = "Section"
        card.Size = UDim2.new(1, 0, 0, 0)
        card.AutomaticSize = Enum.AutomaticSize.Y
        card.BackgroundColor3 = COL_PANEL
        card.BorderSizePixel = 0
        card.LayoutOrder = nextOrd()
        card.Parent = page
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 3)
        UI.edge(card, 0.45)
        local pad = Instance.new("UIPadding", card)
        pad.PaddingTop = UDim.new(0, 10)
        pad.PaddingBottom = UDim.new(0, 10)
        pad.PaddingLeft = UDim.new(0, 12)
        pad.PaddingRight = UDim.new(0, 12)
        local lay = Instance.new("UIListLayout", card)
        lay.Padding = UDim.new(0, 6)
        lay.SortOrder = Enum.SortOrder.LayoutOrder
        label(card, title, 9, COL_MUTED, 12)
        return card
    end

    local function btnRow(parent, specs)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 26)
        row.BackgroundTransparency = 1
        row.LayoutOrder = #parent:GetChildren()
        row.Parent = parent
        local lay = Instance.new("UIListLayout", row)
        lay.FillDirection = Enum.FillDirection.Horizontal
        lay.Padding = UDim.new(0, 6)
        lay.SortOrder = Enum.SortOrder.LayoutOrder
        local n = #specs
        for i, sp in ipairs(specs) do
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1 / n, -6 * (n - 1) / n, 1, 0)
            b.BackgroundColor3 = sp[3] and COL_ACCENT or COL_CARD
            b.Text = sp[1]
            b.Font = Enum.Font.Code
            b.TextSize = 10
            b.TextColor3 = COL_TEXT
            b.AutoButtonColor = false
            b.BorderSizePixel = 0
            b.LayoutOrder = i
            b.Parent = row
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 3)
            if not sp[3] then UI.edge(b, 0.5) end
            b.MouseButton1Click:Connect(function() sp[2](b) end)
        end
        return row
    end

    local function inputRow(parent, placeholder, default, specs)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 28)
        row.BackgroundTransparency = 1
        row.LayoutOrder = #parent:GetChildren()
        row.Parent = parent
        local lay = Instance.new("UIListLayout", row)
        lay.FillDirection = Enum.FillDirection.Horizontal
        lay.Padding = UDim.new(0, 6)
        lay.SortOrder = Enum.SortOrder.LayoutOrder
        local n = #specs
        local box = Instance.new("TextBox")
        box.Size = UDim2.new(1, -(n * 64), 1, 0)
        box.BackgroundColor3 = COL_CARD
        box.Font = Enum.Font.Code
        box.TextSize = 10
        box.TextColor3 = COL_TEXT
        box.PlaceholderText = placeholder
        box.PlaceholderColor3 = COL_MUTED
        box.Text = default or ""
        box.TextXAlignment = Enum.TextXAlignment.Left
        box.ClearTextOnFocus = false
        box.BorderSizePixel = 0
        box.LayoutOrder = 0
        box.Parent = row
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, 3)
        Instance.new("UIPadding", box).PaddingLeft = UDim.new(0, 8)
        UI.edge(box, 0.5)
        for i, sp in ipairs(specs) do
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(0, 58, 1, 0)
            b.BackgroundColor3 = sp[3] and COL_ACCENT or COL_CARD
            b.Text = sp[1]
            b.Font = Enum.Font.Code
            b.TextSize = 9
            b.TextColor3 = COL_TEXT
            b.AutoButtonColor = false
            b.BorderSizePixel = 0
            b.LayoutOrder = i
            b.Parent = row
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 3)
            if not sp[3] then UI.edge(b, 0.5) end
            b.MouseButton1Click:Connect(function() sp[2](box) end)
        end
        return box
    end

    local function toggleRow(parent, text, onChange)
        local row = Instance.new("TextButton")
        row.Size = UDim2.new(1, 0, 0, 30)
        row.BackgroundColor3 = COL_CARD
        row.Text = ""
        row.AutoButtonColor = false
        row.BorderSizePixel = 0
        row.LayoutOrder = #parent:GetChildren()
        row.Parent = parent
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 3)
        UI.edge(row, 0.5)

        local lbl = Instance.new("TextLabel")
        lbl.BackgroundTransparency = 1
        lbl.Position = UDim2.fromOffset(12, 0)
        lbl.Size = UDim2.new(1, -70, 1, 0)
        lbl.Font = Enum.Font.Code
        lbl.TextSize = 10
        lbl.TextColor3 = COL_TEXT
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextTruncate = Enum.TextTruncate.AtEnd
        lbl.Text = text
        lbl.Parent = row

        local box = Instance.new("Frame")
        box.Size = UDim2.fromOffset(30, 14)
        box.Position = UDim2.new(1, -42, 0.5, -7)
        box.BackgroundColor3 = COL_PANEL
        box.BorderSizePixel = 0
        box.Parent = row
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, 3)
        UI.edge(box, 0.3)

        local knob = Instance.new("Frame")
        knob.Size = UDim2.fromOffset(10, 10)
        knob.Position = UDim2.new(0, 2, 0.5, -5)
        knob.BackgroundColor3 = COL_MUTED
        knob.BorderSizePixel = 0
        knob.Parent = box
        Instance.new("UICorner", knob).CornerRadius = UDim.new(0, 2)

        local state = false
        row.MouseButton1Click:Connect(function()
            state = not state
            box.BackgroundColor3 = state and COL_ACCENT or COL_PANEL
            knob.BackgroundColor3 = state and COL_TEXT or COL_MUTED
            TweenService:Create(knob, TweenInfo.new(0.12), {
                Position = state and UDim2.new(1, -12, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)
            }):Play()
            onChange(state)
        end)
        return row
    end

    local refreshers = {}
    local function playerList(parent, onPick, height)
        local list = Instance.new("ScrollingFrame")
        list.Size = UDim2.new(1, 0, 0, height or 110)
        list.BackgroundColor3 = COL_CARD
        list.BorderSizePixel = 0
        list.ScrollBarThickness = 3
        list.ScrollBarImageColor3 = COL_ACCENT
        list.CanvasSize = UDim2.fromOffset(0, 0)
        list.AutomaticCanvasSize = Enum.AutomaticSize.Y
        list.LayoutOrder = #parent:GetChildren()
        list.Parent = parent
        Instance.new("UICorner", list).CornerRadius = UDim.new(0, 3)
        UI.edge(list, 0.5)
        local lp = Instance.new("UIPadding", list)
        lp.PaddingTop = UDim.new(0, 4)
        lp.PaddingBottom = UDim.new(0, 4)
        lp.PaddingLeft = UDim.new(0, 4)
        lp.PaddingRight = UDim.new(0, 6)
        local lay = Instance.new("UIListLayout", list)
        lay.Padding = UDim.new(0, 3)
        lay.SortOrder = Enum.SortOrder.LayoutOrder

        local empty = Instance.new("TextLabel")
        empty.BackgroundTransparency = 1
        empty.Size = UDim2.new(1, 0, 0, 22)
        empty.Font = Enum.Font.Code
        empty.TextSize = 10
        empty.TextColor3 = COL_MUTED
        empty.TextXAlignment = Enum.TextXAlignment.Left
        empty.Text = "  No other players in this server."
        empty.LayoutOrder = 0
        empty.Parent = list

        local function refresh()
            for _, c in ipairs(list:GetChildren()) do
                if c:IsA("TextButton") then c:Destroy() end
            end
            local n = 0
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP then
                    n = n + 1
                    local b = Instance.new("TextButton")
                    b.Size = UDim2.new(1, 0, 0, 24)
                    b.BackgroundColor3 = COL_PANEL
                    b.Text = "  " .. p.DisplayName .. "  @" .. p.Name
                    b.Font = Enum.Font.Code
                    b.TextSize = 10
                    b.TextColor3 = COL_TEXT
                    b.TextXAlignment = Enum.TextXAlignment.Left
                    b.TextTruncate = Enum.TextTruncate.AtEnd
                    b.AutoButtonColor = false
                    b.BorderSizePixel = 0
                    b.LayoutOrder = n
                    b.Parent = list
                    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 3)
                    b.MouseEnter:Connect(function() b.BackgroundColor3 = COL_ACCENT end)
                    b.MouseLeave:Connect(function() b.BackgroundColor3 = COL_PANEL end)
                    b.MouseButton1Click:Connect(function() onPick(p) end)
                end
            end
            empty.Visible = (n == 0)
        end
        table.insert(refreshers, refresh)
        refresh()
        return list
    end

    local function refreshAll()
        for _, f in ipairs(refreshers) do pcall(f) end
    end
    track(Players.PlayerAdded:Connect(function() task.wait(0.3); refreshAll() end))
    track(Players.PlayerRemoving:Connect(function() task.wait(0.15); refreshAll() end))

    -- ---------- runtime loops ----------
    track(RunService.Heartbeat:Connect(function()
        if S.keep then
            local h = hum()
            if h and h.WalkSpeed ~= S.speed then h.WalkSpeed = S.speed end
        end
    end))

    track(UIS.JumpRequest:Connect(function()
        if S.jump then
            local h = hum()
            if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end))

    track(RunService.Stepped:Connect(function()
        if S.noclip then
            local c = LP.Character
            if c then
                for _, p in ipairs(c:GetDescendants()) do
                    if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
                end
            end
        end
    end))

    -- ---------- esp ----------
    local function espStep()
        local myHead = LP.Character and LP.Character:FindFirstChild("Head")
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP then
                local c = p.Character
                if c then
                    local mate = (LP.Team ~= nil) and (p.Team == LP.Team)
                    local show = S.esp and not (S.team and mate)
                    local hl = c:FindFirstChild("CH_HL")
                    local head = c:FindFirstChild("Head")
                    local tag = head and head:FindFirstChild("CH_TAG")
                    if show and head then
                        local col = mate and COL_GREEN or Color3.fromRGB(255, 70, 90)
                        if not hl then
                            hl = Instance.new("Highlight")
                            hl.Name = "CH_HL"
                            hl.FillTransparency = 0.8
                            hl.OutlineTransparency = 0
                            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            hl.Adornee = c
                            hl.Parent = c
                        end
                        hl.FillColor = col
                        hl.OutlineColor = col
                        if not tag then
                            tag = Instance.new("BillboardGui")
                            tag.Name = "CH_TAG"
                            tag.Size = UDim2.fromOffset(140, 18)
                            tag.StudsOffset = Vector3.new(0, 2.6, 0)
                            tag.AlwaysOnTop = true
                            tag.Adornee = head
                            local t0 = Instance.new("TextLabel")
                            t0.Name = "T"
                            t0.Size = UDim2.fromScale(1, 1)
                            t0.BackgroundTransparency = 1
                            t0.Font = Enum.Font.Code
                            t0.TextSize = 12
                            t0.TextStrokeTransparency = 0.4
                            t0.Parent = tag
                            tag.Parent = head
                        end
                        local t = tag:FindFirstChild("T")
                        if t then
                            t.TextColor3 = col
                            local d = myHead and math.floor((head.Position - myHead.Position).Magnitude) or 0
                            t.Text = p.DisplayName .. " [" .. d .. "m]"
                        end
                    else
                        if hl then hl:Destroy() end
                        if tag then tag:Destroy() end
                    end
                end
            end
        end
    end

    task.spawn(function()
        while gui.Parent do
            if S.esp or S.dirty then
                pcall(espStep)
                S.dirty = false
            end
            task.wait(0.3)
        end
    end)

    -- ---------- actions ----------
    local function tpTo(plr)
        local r = root()
        local t = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if r and t then r.CFrame = t.CFrame * CFrame.new(0, 0, 3) end
    end

    local specLabel
    local function spectate(plr)
        local h = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
        if h then
            workspace.CurrentCamera.CameraSubject = h
            if specLabel then specLabel.Text = "Spectating @" .. plr.Name end
        end
    end
    local function stopSpectate()
        local h = hum()
        if h then workspace.CurrentCamera.CameraSubject = h end
        if specLabel then specLabel.Text = "Not spectating." end
    end

    local function forceRig(rigType)
        pcall(function()
            local c = LP.Character
            local h = hum()
            local r = root()
            if not (c and h and r) then return end
            if h.RigType == rigType then return end
            local desc = Players:GetHumanoidDescriptionFromUserId(LP.UserId)
            local model = Players:CreateHumanoidModelFromDescription(desc, rigType)
            model.Name = LP.Name
            model:PivotTo(r.CFrame)
            local animate = c:FindFirstChild("Animate")
            if animate then animate:Clone().Parent = model end
            model.Parent = workspace
            LP.Character = model
            workspace.CurrentCamera.CameraSubject = model:FindFirstChildOfClass("Humanoid")
            c:Destroy()
        end)
    end

    -- ---------- animation packs ----------
    local ANIM_PACKS = {
        {"Ninja",      {656117400, 656118341, 656121766, 656118852, 656117878, 656115606, 656114359}},
        {"Zombie",     {616158929, 616160636, 616168032, 616163682, 616161997, 616157476, 616156119}},
        {"Levitation", {616006778, 616008087, 616013216, 616010382, 616008936, 616005863, 616003713}},
        {"Mage",       {707742142, 707855907, 707897309, 707861613, 707853694, 707829716, 707826056}},
        {"Cartoony",   {742637544, 742638445, 742640026, 742638842, 742637942, 742637151, 742636889}},
        {"Robot",      {616088211, 616089559, 616095330, 616091570, 616090535, 616087089, 616086039}},
        {"Superhero",  {616111295, 616113536, 616122287, 616117076, 616115533, 616108001, 616104706}},
        {"Toy",        {782841498, 782845736, 782843345, 782842708, 782847020, 782846423, 782843869}},
        {"Vampire",    {1083445855, 1083450166, 1083473930, 1083462077, 1083455352, 1083443587, 1083439238}},
        {"Werewolf",   {1083195517, 1083214717, 1083178339, 1083216690, 1083218792, 1083189019, 1083182000}},
        {"Pirate",     {750781874, 750782770, 750785693, 750783738, 750782230, 750780242, 750779899}},
        {"Knight",     {657595757, 657568135, 657552124, 657564596, 658409194, 657600338, 658360781}},
        {"Elder",      {845397899, 845400520, 845403856, 845386501, 845398858, 845396048, 845392038}},
        {"Bubbly",     {910004836, 910009958, 910034870, 910025107, 910016857, 910001910, 909997997}},
        {"Astronaut",  {891621366, 891633237, 891667138, 891636393, 891627522, 891617961, 891609353}},
        {"Stylish",    {616136790, 616138447, 616146177, 616140816, 616139451, 616134815, 616133594}},
        {"Oldschool",  {5319828216, 5319831086, 5319847204, 5319844329, 5319841935, 5319839762, 5319816685}},
    }
    local ANIM_SLOTS = {
        {"idle", "Animation1"}, {"idle", "Animation2"}, {"walk", "WalkAnim"},
        {"run", "RunAnim"}, {"jump", "JumpAnim"}, {"fall", "FallAnim"}, {"climb", "ClimbAnim"},
    }
    local origAnims, origChar = {}, nil

    local function stopTracks(c)
        local h = c:FindFirstChildOfClass("Humanoid")
        local a = h and h:FindFirstChildOfClass("Animator")
        if a then
            for _, t in ipairs(a:GetPlayingAnimationTracks()) do t:Stop() end
        end
    end

    local function captureOriginals(c)
        if origChar == c then return end
        origChar = c
        origAnims = {}
        local animate = c:FindFirstChild("Animate")
        if not animate then return end
        for _, sl in ipairs(ANIM_SLOTS) do
            local f = animate:FindFirstChild(sl[1])
            local a = f and f:FindFirstChild(sl[2])
            if a then origAnims[sl[1] .. "/" .. sl[2]] = a.AnimationId end
        end
    end

    local function applyPack(pack)
        local c = LP.Character
        local animate = c and c:FindFirstChild("Animate")
        if not animate then return false end
        captureOriginals(c)
        for i, sl in ipairs(ANIM_SLOTS) do
            local f = animate:FindFirstChild(sl[1])
            local a = f and f:FindFirstChild(sl[2])
            if a then a.AnimationId = "rbxassetid://" .. tostring(pack[i]) end
        end
        stopTracks(c)
        return true
    end

    local function resetAnims()
        local c = LP.Character
        local animate = c and c:FindFirstChild("Animate")
        if not animate or origChar ~= c then return false end
        for _, sl in ipairs(ANIM_SLOTS) do
            local f = animate:FindFirstChild(sl[1])
            local a = f and f:FindFirstChild(sl[2])
            local o = origAnims[sl[1] .. "/" .. sl[2]]
            if a and o then a.AnimationId = o end
        end
        stopTracks(c)
        return true
    end

    -- ================= PLAYER PAGE =================
    local pp = newPage("PlayerPage")

    local sMove = section(pp, "MOVEMENT")
    inputRow(sMove, "WalkSpeed", "16", {
        {"SET", function(box)
            local v = tonumber(box.Text)
            if v then
                S.speed = math.clamp(v, 0, 500)
                local h = hum()
                if h then h.WalkSpeed = S.speed end
            end
        end, true},
        {"RESET", function(box)
            S.speed = 16
            box.Text = "16"
            local h = hum()
            if h then h.WalkSpeed = 16 end
        end},
    })
    toggleRow(sMove, "Keep speed (re-apply every frame)", function(v) S.keep = v end)
    toggleRow(sMove, "Infinite jump", function(v) S.jump = v end)
    toggleRow(sMove, "Noclip", function(v) S.noclip = v end)
    inputRow(sMove, "Gravity", tostring(math.floor(defGravity * 10) / 10), {
        {"SET", function(box)
            local v = tonumber(box.Text)
            if v then workspace.Gravity = math.clamp(v, 0, 1000) end
        end, true},
        {"RESET", function(box)
            workspace.Gravity = defGravity
            box.Text = tostring(math.floor(defGravity * 10) / 10)
        end},
    })

    local sChar = section(pp, "CHARACTER")
    btnRow(sChar, {
        {"FREEZE", function()
            local r = root()
            if r then r.Anchored = true end
        end, true},
        {"UNFREEZE", function()
            local r = root()
            if r then r.Anchored = false end
        end},
        {"RESET", function()
            local h = hum()
            if h then h.Health = 0 end
        end},
    })
    btnRow(sChar, {
        {"FORCE R6", function() forceRig(Enum.HumanoidRigType.R6) end},
        {"FORCE R15", function() forceRig(Enum.HumanoidRigType.R15) end},
    })
    btnRow(sChar, {
        {"1ST PERSON", function() LP.CameraMode = Enum.CameraMode.LockFirstPerson end},
        {"3RD PERSON", function()
            LP.CameraMode = Enum.CameraMode.Classic
            LP.CameraMinZoomDistance = 12
            LP.CameraMaxZoomDistance = math.max(origMax, 24)
        end},
        {"DEFAULT", function()
            LP.CameraMode = Enum.CameraMode.Classic
            LP.CameraMinZoomDistance = origMin
            LP.CameraMaxZoomDistance = origMax
        end},
    })

    local sTp = section(pp, "TELEPORT TO PLAYER")
    playerList(sTp, tpTo, 110)

    local sSpec = section(pp, "SPECTATE")
    specLabel = label(sSpec, "Not spectating.", 10, COL_SUBTEXT, 14)
    playerList(sSpec, spectate, 110)
    btnRow(sSpec, { {"STOP SPECTATING", stopSpectate} })

    local sEsp = section(pp, "ESP")
    toggleRow(sEsp, "ESP (highlight + name + distance)", function(v)
        S.esp = v
        S.dirty = true
    end)
    toggleRow(sEsp, "Team check (hide teammates)", function(v)
        S.team = v
        S.dirty = true
    end)

    local sAnim = section(pp, "ANIMATION CHANGER (R15)")
    local animStatus = label(sAnim, "Pick a pack.", 10, COL_SUBTEXT, 14)
    local animSearch = inputRow(sAnim, "Search packs...", "", {})
    local animList = Instance.new("ScrollingFrame")
    animList.Size = UDim2.new(1, 0, 0, 130)
    animList.BackgroundColor3 = COL_CARD
    animList.BorderSizePixel = 0
    animList.ScrollBarThickness = 3
    animList.ScrollBarImageColor3 = COL_ACCENT
    animList.CanvasSize = UDim2.fromOffset(0, 0)
    animList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    animList.LayoutOrder = #sAnim:GetChildren()
    animList.Parent = sAnim
    Instance.new("UICorner", animList).CornerRadius = UDim.new(0, 3)
    UI.edge(animList, 0.5)
    local alp = Instance.new("UIPadding", animList)
    alp.PaddingTop = UDim.new(0, 4)
    alp.PaddingBottom = UDim.new(0, 4)
    alp.PaddingLeft = UDim.new(0, 4)
    alp.PaddingRight = UDim.new(0, 6)
    local alay = Instance.new("UIListLayout", animList)
    alay.Padding = UDim.new(0, 3)
    alay.SortOrder = Enum.SortOrder.LayoutOrder

    for i, pack in ipairs(ANIM_PACKS) do
        local b = Instance.new("TextButton")
        b.Name = pack[1]
        b.Size = UDim2.new(1, 0, 0, 24)
        b.BackgroundColor3 = COL_PANEL
        b.Text = "  " .. pack[1]
        b.Font = Enum.Font.Code
        b.TextSize = 10
        b.TextColor3 = COL_TEXT
        b.TextXAlignment = Enum.TextXAlignment.Left
        b.AutoButtonColor = false
        b.BorderSizePixel = 0
        b.LayoutOrder = i
        b.Parent = animList
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 3)
        b.MouseEnter:Connect(function() b.BackgroundColor3 = COL_ACCENT end)
        b.MouseLeave:Connect(function() b.BackgroundColor3 = COL_PANEL end)
        b.MouseButton1Click:Connect(function()
            if applyPack(pack[2]) then
                animStatus.Text = "Applied: " .. pack[1]
            else
                animStatus.Text = "No Animate script on your character."
            end
        end)
    end

    animSearch:GetPropertyChangedSignal("Text"):Connect(function()
        local q = string.lower(animSearch.Text or "")
        for _, b in ipairs(animList:GetChildren()) do
            if b:IsA("TextButton") then
                b.Visible = (q == "" or string.find(string.lower(b.Name), q, 1, true) ~= nil)
            end
        end
    end)

    btnRow(sAnim, {
        {"RESET ANIMATIONS", function()
            animStatus.Text = resetAnims() and "Animations restored." or "Nothing to restore."
        end},
    })

    -- ================= AVATAR PAGE =================
    local av = newPage("AvatarPage")
    local favFile = "cathub_avfav_" .. LP.UserId .. ".json"
    local avFavs = {}
    pcall(function()
        if isfile and readfile and isfile(favFile) then
            local d = HttpService:JSONDecode(readfile(favFile))
            if type(d) == "table" then avFavs = d end
        end
    end)
    local function saveAv()
        if writefile then
            pcall(function() writefile(favFile, HttpService:JSONEncode(avFavs)) end)
        end
    end
    local function favIndex(id)
        for i, f in ipairs(avFavs) do
            if f.id == id then return i end
        end
        return nil
    end

    local current = nil
    local lookup, show, refreshFav

    local sLook = section(av, "AVATAR LOOKUP")
    inputRow(sLook, "Username or user ID", "", {
        {"LOOKUP", function(box) lookup(box.Text) end, true},
    })

    local sPrev = section(av, "PREVIEW")
    local pv = Instance.new("Frame")
    pv.Size = UDim2.new(1, 0, 0, 116)
    pv.BackgroundColor3 = COL_CARD
    pv.BorderSizePixel = 0
    pv.LayoutOrder = #sPrev:GetChildren()
    pv.Parent = sPrev
    Instance.new("UICorner", pv).CornerRadius = UDim.new(0, 3)
    UI.edge(pv, 0.5)

    local img = Instance.new("ImageLabel")
    img.Size = UDim2.fromOffset(100, 100)
    img.Position = UDim2.fromOffset(8, 8)
    img.BackgroundColor3 = COL_PANEL
    img.BorderSizePixel = 0
    img.ScaleType = Enum.ScaleType.Crop
    img.Image = ""
    img.Parent = pv
    Instance.new("UICorner", img).CornerRadius = UDim.new(0, 3)

    local nameL = Instance.new("TextLabel")
    nameL.BackgroundTransparency = 1
    nameL.Position = UDim2.fromOffset(118, 10)
    nameL.Size = UDim2.new(1, -164, 0, 16)
    nameL.Font = Enum.Font.Code
    nameL.TextSize = 12
    nameL.TextColor3 = COL_TEXT
    nameL.TextXAlignment = Enum.TextXAlignment.Left
    nameL.TextTruncate = Enum.TextTruncate.AtEnd
    nameL.Text = "No avatar loaded"
    nameL.Parent = pv

    local dispL = Instance.new("TextLabel")
    dispL.BackgroundTransparency = 1
    dispL.Position = UDim2.fromOffset(118, 28)
    dispL.Size = UDim2.new(1, -126, 0, 14)
    dispL.Font = Enum.Font.Code
    dispL.TextSize = 10
    dispL.TextColor3 = COL_SUBTEXT
    dispL.TextXAlignment = Enum.TextXAlignment.Left
    dispL.TextTruncate = Enum.TextTruncate.AtEnd
    dispL.Text = ""
    dispL.Parent = pv

    local idL = Instance.new("TextLabel")
    idL.BackgroundTransparency = 1
    idL.Position = UDim2.fromOffset(118, 44)
    idL.Size = UDim2.new(1, -126, 0, 14)
    idL.Font = Enum.Font.Code
    idL.TextSize = 10
    idL.TextColor3 = COL_MUTED
    idL.TextXAlignment = Enum.TextXAlignment.Left
    idL.Text = ""
    idL.Parent = pv

    local statusL = Instance.new("TextLabel")
    statusL.BackgroundTransparency = 1
    statusL.Position = UDim2.fromOffset(118, 66)
    statusL.Size = UDim2.new(1, -126, 0, 40)
    statusL.Font = Enum.Font.Code
    statusL.TextSize = 10
    statusL.TextColor3 = COL_SUBTEXT
    statusL.TextXAlignment = Enum.TextXAlignment.Left
    statusL.TextYAlignment = Enum.TextYAlignment.Top
    statusL.TextWrapped = true
    statusL.Text = "Type a username or ID, then LOOKUP."
    statusL.Parent = pv

    local star = Instance.new("TextButton")
    star.Size = UDim2.fromOffset(28, 26)
    star.Position = UDim2.new(1, -36, 0, 8)
    star.BackgroundColor3 = COL_PANEL
    star.Text = "★"
    star.Font = Enum.Font.GothamBold
    star.TextSize = 14
    star.TextColor3 = COL_MUTED
    star.AutoButtonColor = false
    star.BorderSizePixel = 0
    star.Parent = pv
    Instance.new("UICorner", star).CornerRadius = UDim.new(0, 3)
    UI.edge(star, 0.4)

    local function paintStar()
        local on = current and favIndex(current.id) ~= nil
        star.TextColor3 = on and COL_STAR or COL_MUTED
    end

    star.MouseButton1Click:Connect(function()
        if not current then
            statusL.Text = "Look up an avatar first."
            return
        end
        local i = favIndex(current.id)
        if i then
            table.remove(avFavs, i)
        else
            table.insert(avFavs, { id = current.id, name = current.name })
        end
        saveAv()
        paintStar()
        refreshFav()
    end)

    show = function(data)
        current = data
        nameL.Text = "@" .. data.name
        dispL.Text = data.display or ""
        idL.Text = "ID: " .. tostring(data.id)
        img.Image = ""
        paintStar()
        task.spawn(function()
            local ok, thumb = pcall(function()
                return Players:GetUserThumbnailAsync(data.id, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size420x420)
            end)
            if ok and current == data then img.Image = thumb end
        end)
        if not data.display then
            task.spawn(function()
                local ok, info = pcall(function()
                    return game:GetService("UserService"):GetUserInfosByUserIdsAsync({ data.id })
                end)
                if ok and info and info[1] and current == data then
                    data.display = info[1].DisplayName
                    dispL.Text = data.display
                end
            end)
        end
    end

    lookup = function(q)
        q = tostring(q or ""):gsub("%s", "")
        if q == "" then
            statusL.Text = "Enter a username or user ID."
            return
        end
        statusL.Text = "Looking up..."
        task.spawn(function()
            local id, name
            if tonumber(q) then
                id = tonumber(q)
                local ok, n = pcall(function() return Players:GetNameFromUserIdAsync(id) end)
                if not ok then
                    statusL.Text = "No user with that ID."
                    return
                end
                name = n
            else
                local ok, uid = pcall(function() return Players:GetUserIdFromNameAsync(q) end)
                if not ok then
                    statusL.Text = "No user with that name."
                    return
                end
                id = uid
                name = q
            end
            show({ id = id, name = name })
            statusL.Text = "Loaded. CHANGE to wear it."
        end)
    end

    local function wear(userId, okText)
        statusL.Text = "Applying..."
        task.spawn(function()
            local ok, err = pcall(function()
                local h = hum()
                if not h then error("no character") end
                h:ApplyDescription(Players:GetHumanoidDescriptionFromUserId(userId))
            end)
            statusL.Text = ok and okText or ("Failed: " .. tostring(err))
        end)
    end

    btnRow(sPrev, {
        {"CHANGE", function()
            if not current then
                statusL.Text = "Look up an avatar first."
                return
            end
            wear(current.id, "Wearing @" .. current.name .. " (local).")
        end, true},
        {"RESET TO MAIN", function()
            wear(LP.UserId, "Back to your main avatar.")
        end},
    })

    local sFav = section(av, "FAVORITES")
    local favHolder = Instance.new("Frame")
    favHolder.Size = UDim2.new(1, 0, 0, 0)
    favHolder.AutomaticSize = Enum.AutomaticSize.Y
    favHolder.BackgroundTransparency = 1
    favHolder.LayoutOrder = #sFav:GetChildren()
    favHolder.Parent = sFav
    local fhl = Instance.new("UIListLayout", favHolder)
    fhl.Padding = UDim.new(0, 4)
    fhl.SortOrder = Enum.SortOrder.LayoutOrder

    refreshFav = function()
        for _, c in ipairs(favHolder:GetChildren()) do
            if c:IsA("GuiObject") then c:Destroy() end
        end
        if #avFavs == 0 then
            local e = Instance.new("TextLabel")
            e.BackgroundTransparency = 1
            e.Size = UDim2.new(1, 0, 0, 20)
            e.Font = Enum.Font.Code
            e.TextSize = 10
            e.TextColor3 = COL_MUTED
            e.TextXAlignment = Enum.TextXAlignment.Left
            e.Text = "Star an avatar to save it here."
            e.Parent = favHolder
            return
        end
        for i, f in ipairs(avFavs) do
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, 0, 0, 26)
            b.BackgroundColor3 = COL_CARD
            b.Text = "  " .. tostring(f.name)
            b.Font = Enum.Font.Code
            b.TextSize = 10
            b.TextColor3 = COL_TEXT
            b.TextXAlignment = Enum.TextXAlignment.Left
            b.TextTruncate = Enum.TextTruncate.AtEnd
            b.AutoButtonColor = false
            b.BorderSizePixel = 0
            b.LayoutOrder = i
            b.Parent = favHolder
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 3)
            UI.edge(b, 0.5)
            b.MouseEnter:Connect(function() b.BackgroundColor3 = COL_ACCENT end)
            b.MouseLeave:Connect(function() b.BackgroundColor3 = COL_CARD end)
            b.MouseButton1Click:Connect(function()
                show({ id = f.id, name = f.name })
                statusL.Text = "Loaded from favorites."
            end)
        end
    end
    refreshFav()

    -- ---------- cleanup ----------
    gui.Destroying:Connect(function()
        S.esp = false
        S.keep = false
        S.jump = false
        S.noclip = false
        pcall(espStep)
        for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
        pcall(function()
            local h = hum()
            if h then workspace.CurrentCamera.CameraSubject = h end
        end)
    end)

    UI.playerPage = pp
    UI.avatarPage = av
end

UI.buildTools()

local allPages = {
    [homeBtn]       = homePage,
    [scriptBtn]     = scriptPage,
    [UI.playerBtn]  = UI.playerPage,
    [UI.avatarBtn]  = UI.avatarPage,
    [settingsBtn]   = settingsPage,
    [creditBtn]     = creditPage,
    [aboutBtn]      = aboutPage,
}

local allNavs = {homeBtn, scriptBtn, UI.playerBtn, UI.avatarBtn, settingsBtn, creditBtn, aboutBtn}

local function setActive(activeBtn)
    for _, b in ipairs(allNavs) do
        UI.paintNav(b, false)
    end
    UI.paintNav(activeBtn, true)
end

local function showPage(page)
    for _, c in ipairs(content:GetChildren()) do
        if c:IsA("GuiObject") then c.Visible = false end
    end
    page.Visible = true
end

for btn, page in pairs(allPages) do
    btn.MouseButton1Click:Connect(function()
        setActive(btn)
        showPage(page)

        if page == scriptPage then
            gameListView.Visible = true
            universalView.Visible = false
            stealView.Visible = false
            suggestView.Visible = false
        end
    end)
end

for _, b in ipairs(allNavs) do
    b.MouseEnter:Connect(function()
        if not b.Bar.Visible then
            b.BackgroundTransparency = 0.6
            b.TextColor3 = COL_TEXT
        end
    end)
    b.MouseLeave:Connect(function()
        if not b.Bar.Visible then
            b.BackgroundTransparency = 1
            b.TextColor3 = COL_SUBTEXT
        end
    end)
end

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

closeBtn.MouseEnter:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.15), { BackgroundColor3 = COL_RED, BackgroundTransparency = 0.3 }):Play()
end)

closeBtn.MouseLeave:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.15), { BackgroundTransparency = 1 }):Play()
end)

minimizeBtn.MouseEnter:Connect(function()
    TweenService:Create(minimizeBtn, TweenInfo.new(0.15), { BackgroundColor3 = COL_CARD, BackgroundTransparency = 0.3 }):Play()
end)

minimizeBtn.MouseLeave:Connect(function()
    TweenService:Create(minimizeBtn, TweenInfo.new(0.15), { BackgroundTransparency = 1 }):Play()
end)

local dragging = false
local dragStart, startPos

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

uiScale.Scale = scaleVal * 0.94
TweenService:Create(uiScale, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Scale = scaleVal }):Play()

main.BackgroundTransparency = 1
header.BackgroundTransparency = 1
sidebar.BackgroundTransparency = 1

TweenService:Create(main, TweenInfo.new(0.5), { BackgroundTransparency = 0 }):Play()
TweenService:Create(header, TweenInfo.new(0.5), { BackgroundTransparency = 0 }):Play()
TweenService:Create(sidebar, TweenInfo.new(0.5), { BackgroundTransparency = 0 }):Play()

print("[cat hub] v2.1 loaded.")