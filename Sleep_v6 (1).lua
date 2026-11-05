local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local SoundService = game:GetService("SoundService")
local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

-- This experience does not expose CAT HUB player controls.
local PLAYER_TOOLS_DISABLED = (game.PlaceId == 107778070777162)

local HTTP_REQUEST = request or http_request

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
    b:SetAttribute("on", on)
    b.BackgroundColor3 = on and COL_ACCENT or COL_CARD
    b.BackgroundTransparency = on and 0 or 1
    b.TextColor3 = on and Color3.fromRGB(255, 255, 255) or COL_SUBTEXT
    local g = b:FindFirstChild("Shade")
    if g then g.Enabled = on end
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

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

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

Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12)

local catCircle = Instance.new("Frame")
catCircle.Size = UDim2.fromOffset(38, 38)
catCircle.Position = UDim2.fromOffset(10, 8)
catCircle.BackgroundColor3 = COL_ACCENT
catCircle.BorderSizePixel = 0
catCircle.Parent = header

Instance.new("UICorner", catCircle).CornerRadius = UDim.new(1, 0)

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

Instance.new("UICorner", catImage).CornerRadius = UDim.new(1, 0)

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Position = UDim2.fromOffset(62, 6)
title.Size = UDim2.new(0.5, 0, 0, 20)
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.TextColor3 = COL_TEXT
title.TextXAlignment = Enum.TextXAlignment.Left
title.Text = "CAT HUB"
title.Parent = header

local subtitle = Instance.new("TextLabel")
subtitle.BackgroundTransparency = 1
subtitle.Position = UDim2.fromOffset(62, 28)
subtitle.Size = UDim2.new(0.5, 0, 0, 14)
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 9
subtitle.TextColor3 = COL_SUBTEXT
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Text = "universal  |  v2.3"
subtitle.Parent = header

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.fromOffset(26, 26)
minimizeBtn.Position = UDim2.new(1, -68, 0, 15)
minimizeBtn.BackgroundTransparency = 1
minimizeBtn.Text = "-"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 18
minimizeBtn.TextColor3 = COL_TEXT
minimizeBtn.AutoButtonColor = false
minimizeBtn.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.fromOffset(26, 26)
closeBtn.Position = UDim2.new(1, -34, 0, 15)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
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
local GITHUB_TOKEN = "" -- Add a newly generated token here; do not reuse an exposed token.
local GIST_API = "https://api.github.com/gists/"..GIST_ID
local GIST_FILENAME = "gistfile1.txt"

local WEBHOOK_URL = "" -- Add a newly regenerated Discord webhook URL here.
local SUGGEST_WEBHOOK = "" -- Add a newly regenerated suggestion webhook URL here.

local function gistRead()
    if not HTTP_REQUEST or GITHUB_TOKEN == "" then
        return nil
    end
    local ok, res = pcall(function()
        return HTTP_REQUEST({
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
    if not HTTP_REQUEST or GITHUB_TOKEN == "" then
        return false
    end
    local body = HttpService:JSONEncode({
        files = {
            [GIST_FILENAME] = {
                content = HttpService:JSONEncode(data)
            }
        }
    })
    local ok, res = pcall(function()
        return HTTP_REQUEST({
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
    if not HTTP_REQUEST or WEBHOOK_URL == "" then return end
    pcall(function()
        HTTP_REQUEST({
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode(payload)
        })
    end)
end

local function sendSuggestWebhook(payload)
    if not HTTP_REQUEST or SUGGEST_WEBHOOK == "" then return end
    pcall(function()
        HTTP_REQUEST({
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
            footer = { text = "Cat Hub v2.0 | "..phtTime }
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

Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 10)
UI.edge(sidebar, 0.4)

local sidebarList = Instance.new("Frame")
sidebarList.Size = UDim2.new(1, 0, 0, 230)
sidebarList.BackgroundTransparency = 1
sidebarList.Parent = sidebar

local sidebarLayout = Instance.new("UIListLayout", sidebarList)
sidebarLayout.Padding = UDim.new(0, 5)
sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
sidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

Instance.new("UIPadding", sidebarList).PaddingTop = UDim.new(0, 8)

local function makeNavButton(text, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -16, 0, 34)
    btn.BackgroundColor3 = COL_CARD
    btn.BackgroundTransparency = 1
    btn.Text = text
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 12
    btn.TextColor3 = COL_SUBTEXT
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    btn.BorderSizePixel = 0
    btn.LayoutOrder = order
    btn.Parent = sidebarList

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    Instance.new("UIPadding", btn).PaddingLeft = UDim.new(0, 16)

    local g = Instance.new("UIGradient")
    g.Name = "Shade"
    g.Rotation = 90
    g.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(185, 200, 238))
    g.Enabled = false
    g.Parent = btn

    btn:SetAttribute("on", false)
    return btn
end

local homeBtn     = makeNavButton("home", 1)
local scriptBtn   = makeNavButton("scripts", 2)
if not PLAYER_TOOLS_DISABLED then
    UI.playerBtn = makeNavButton("player", 3)
end
local settingsBtn = makeNavButton("settings", 4)
local creditBtn   = makeNavButton("credits", 5)
local aboutBtn    = makeNavButton("about", 6)

UI.paintNav(homeBtn, true)

local profileBox = Instance.new("Frame")
profileBox.Name = "ProfileBox"
profileBox.Size = UDim2.new(1, -12, 0, 110)
profileBox.Position = UDim2.new(0, 6, 1, -118)
profileBox.BackgroundColor3 = COL_CARD
profileBox.BorderSizePixel = 0
profileBox.Parent = sidebar
profileBox.ZIndex = 4

Instance.new("UICorner", profileBox).CornerRadius = UDim.new(0, 8)

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
pName.Font = Enum.Font.GothamBold
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
pHandle.Font = Enum.Font.Gotham
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
pPlayingLabel.Font = Enum.Font.Gotham
pPlayingLabel.TextSize = 8
pPlayingLabel.TextColor3 = COL_MUTED
pPlayingLabel.TextXAlignment = Enum.TextXAlignment.Left
pPlayingLabel.Text = "Playing:"
pPlayingLabel.Parent = profileBox

local pGame = Instance.new("TextLabel")
pGame.BackgroundTransparency = 1
pGame.Position = UDim2.fromOffset(0, 74)
pGame.Size = UDim2.new(1, 0, 0, 14)
pGame.Font = Enum.Font.GothamBold
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
wText.Font = Enum.Font.GothamBold
wText.TextSize = 9
wText.TextColor3 = COL_MUTED
wText.TextXAlignment = Enum.TextXAlignment.Left
wText.Text = "WELCOME BACK"
wText.Parent = welcomeSec

local wName = Instance.new("TextLabel")
wName.BackgroundTransparency = 1
wName.Position = UDim2.fromOffset(0, 28)
wName.Size = UDim2.new(1, -110, 0, 22)
wName.Font = Enum.Font.GothamBold
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
wHandle.Font = Enum.Font.Gotham
wHandle.TextSize = 10
wHandle.TextColor3 = COL_SUBTEXT
wHandle.TextXAlignment = Enum.TextXAlignment.Left
wHandle.Text = "@"..localPlayer.Name
wHandle.Parent = welcomeSec

local wVersion = Instance.new("TextLabel")
wVersion.BackgroundTransparency = 1
wVersion.Position = UDim2.fromOffset(0, 74)
wVersion.Size = UDim2.new(1, -110, 0, 14)
wVersion.Font = Enum.Font.Gotham
wVersion.TextSize = 9
wVersion.TextColor3 = COL_ACCENT
wVersion.TextXAlignment = Enum.TextXAlignment.Left
wVersion.Text = "v2.3"
wVersion.Parent = welcomeSec

avatarBox = Instance.new("Frame")
avatarBox.Size = UDim2.fromOffset(90, 90)
avatarBox.Position = UDim2.new(1, -90, 0, 4)
avatarBox.BackgroundColor3 = COL_CARD
avatarBox.BorderSizePixel = 0
avatarBox.ClipsDescendants = true
avatarBox.Parent = welcomeSec

Instance.new("UICorner", avatarBox).CornerRadius = UDim.new(0, 10)

local avatarBoxStroke = Instance.new("UIStroke", avatarBox)
avatarBoxStroke.Color = COL_DIVIDER
avatarBoxStroke.Thickness = 1
avatarBoxStroke.Transparency = 0.2

local avatarBust = Instance.new("ImageLabel")
avatarBust.Size = UDim2.new(1, -4, 1, -4)
avatarBust.Position = UDim2.fromOffset(2, 2)
avatarBust.BackgroundTransparency = 1
avatarBust.Parent = avatarBox

Instance.new("UICorner", avatarBust).CornerRadius = UDim.new(0, 8)

pcall(function()
    avatarBust.Image = Players:GetUserThumbnailAsync(localPlayer.UserId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size420x420)
end)

statsPanel = Instance.new("Frame")
statsPanel.Size = UDim2.new(1, 0, 0, 150)
statsPanel.Position = UDim2.fromOffset(0, 128)
statsPanel.BackgroundColor3 = COL_PANEL
statsPanel.BorderSizePixel = 0
statsPanel.Parent = homePage

Instance.new("UICorner", statsPanel).CornerRadius = UDim.new(0, 8)
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
    b.Font = Enum.Font.GothamBold
    b.TextSize = 9
    b.TextColor3 = COL_TEXT
    b.AutoButtonColor = false
    b.BorderSizePixel = 0
    b.LayoutOrder = order
    b.Parent = btnColumn
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
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

Instance.new("UICorner", joinIdInput).CornerRadius = UDim.new(0, 5)

local joinIdBox = Instance.new("TextBox")
joinIdBox.Size = UDim2.new(1, -6, 1, 0)
joinIdBox.Position = UDim2.fromOffset(3, 0)
joinIdBox.BackgroundTransparency = 1
joinIdBox.Font = Enum.Font.Gotham
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
fpsLabel.Font = Enum.Font.GothamBold
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
pingLabel.Font = Enum.Font.GothamBold
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
sessionLabel.Font = Enum.Font.GothamBold
sessionLabel.TextSize = 10
sessionLabel.TextColor3 = COL_TEXT
sessionLabel.TextXAlignment = Enum.TextXAlignment.Left
sessionLabel.Text = "0s SESSION"
sessionLabel.Parent = statsColumn

local playersLabel = Instance.new("TextLabel")
playersLabel.BackgroundTransparency = 1
playersLabel.Position = UDim2.new(0.5, 4, 0, 60)
playersLabel.Size = UDim2.new(0.5, -4, 0, 16)
playersLabel.Font = Enum.Font.GothamBold
playersLabel.TextSize = 10
playersLabel.TextColor3 = COL_TEXT
playersLabel.TextXAlignment = Enum.TextXAlignment.Left
playersLabel.Text = "0/0 PLAYERS"
playersLabel.Parent = statsColumn

local jobLabel = Instance.new("TextLabel")
jobLabel.BackgroundTransparency = 1
jobLabel.Position = UDim2.fromOffset(0, 86)
jobLabel.Size = UDim2.new(1, 0, 0, 14)
jobLabel.Font = Enum.Font.Gotham
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
placeLabel.Font = Enum.Font.Gotham
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
        Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 1)
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

Instance.new("UICorner", favBox).CornerRadius = UDim.new(0, 8)
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
favTitle.Font = Enum.Font.GothamBold
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
favEmpty.Font = Enum.Font.Gotham
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

        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 5)
        UI.edge(row, 0.5)

        local lbl = Instance.new("TextLabel")
        lbl.BackgroundTransparency = 1
        lbl.Position = UDim2.fromOffset(10, 0)
        lbl.Size = UDim2.new(1, -110, 1, 0)
        lbl.Font = Enum.Font.GothamBold
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
        star.Font = Enum.Font.GothamBold
        star.TextSize = 11
        star.TextColor3 = COL_STAR
        star.AutoButtonColor = false
        star.BorderSizePixel = 0
        star.Parent = row

        Instance.new("UICorner", star).CornerRadius = UDim.new(0, 4)

        local run = Instance.new("TextButton")
        run.Size = UDim2.fromOffset(58, 22)
        run.Position = UDim2.new(1, -64, 0.5, -11)
        run.BackgroundColor3 = COL_ACCENT
        run.Text = "RUN"
        run.Font = Enum.Font.GothamBold
        run.TextSize = 8
        run.TextColor3 = COL_TEXT
        run.AutoButtonColor = false
        run.BorderSizePixel = 0
        run.Parent = row

        Instance.new("UICorner", run).CornerRadius = UDim.new(0, 4)

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
                    local ok, response = pcall(function()
                        return game:HttpGet(url)
                    end)
                    if not ok or type(response) ~= "string" or response == "" or string.find(string.lower(response), "<html", 1, true) then
                        warn("[cat hub] Favorite script download failed:", name)
                        return
                    end
                    local compiler = loadstring
                    if type(compiler) ~= "function" then
                        warn("[cat hub] loadstring is unavailable:", name)
                        return
                    end
                    local compileOK, compiled = pcall(compiler, response)
                    if not compileOK or type(compiled) ~= "function" then
                        warn("[cat hub] Favorite script compilation failed:", name, compiled)
                        return
                    end
                    local runOK, runError = pcall(compiled)
                    if not runOK then
                        warn("[cat hub] Favorite script runtime error:", name, runError)
                    end
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
linksBox.Size = UDim2.new(1, 0, 0, 136)
linksBox.Position = UDim2.fromOffset(0, 0)
linksBox.BackgroundColor3 = COL_PANEL
linksBox.BorderSizePixel = 0
linksBox.Parent = homePage

Instance.new("UICorner", linksBox).CornerRadius = UDim.new(0, 8)
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
linksTitle.Font = Enum.Font.GothamBold
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
dcCommunity.Font = Enum.Font.GothamBold
dcCommunity.TextSize = 9
dcCommunity.TextColor3 = COL_TEXT
dcCommunity.TextXAlignment = Enum.TextXAlignment.Left
dcCommunity.Text = "Community"
dcCommunity.Parent = linksBox

local dcLinkText = Instance.new("TextLabel")
dcLinkText.BackgroundTransparency = 1
dcLinkText.Position = UDim2.fromOffset(28, 36)
dcLinkText.Size = UDim2.new(0.5, 0, 0, 12)
dcLinkText.Font = Enum.Font.Gotham
dcLinkText.TextSize = 8
dcLinkText.TextColor3 = COL_SUBTEXT
dcLinkText.TextXAlignment = Enum.TextXAlignment.Left
dcLinkText.TextTruncate = Enum.TextTruncate.AtEnd
dcLinkText.Text = "discord.gg/FJK6QzNnf7"
dcLinkText.Parent = linksBox

copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.fromOffset(54, 24)
copyBtn.Position = UDim2.new(1, -54, 0, 21)
copyBtn.BackgroundColor3 = COL_CARD
copyBtn.Text = "COPY"
copyBtn.Font = Enum.Font.GothamBold
copyBtn.TextSize = 8
copyBtn.TextColor3 = COL_TEXT
copyBtn.AutoButtonColor = false
copyBtn.BorderSizePixel = 0
copyBtn.Parent = linksBox

Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0, 5)

copyBtn.MouseButton1Click:Connect(function()
    if setclipboard then setclipboard(DISCORD_LINK)
    elseif syn and syn.write_clipboard then syn.write_clipboard(DISCORD_LINK)
    elseif toclipboard then toclipboard(DISCORD_LINK) end
    copyBtn.Text = "OK!"
    task.wait(1.2)
    copyBtn.Text = "COPY"
end)

do
    local socials = {
        { "YouTube", "134161507359192", "https://youtube.com/@unknown_cathub?si=HpYsZTfBsIbCwIYA", "@unknown_cathub" },
        { "TikTok",  "72811524098589",  "https://www.tiktok.com/@randomperson5142?_r=1&_t=ZS-9B5pbVcALeD", "@randomperson5142" },
    }
    for i, so in ipairs(socials) do
        local y = 22 + i * 30

        local icon = Instance.new("ImageLabel")
        icon.Size = UDim2.fromOffset(22, 22)
        icon.Position = UDim2.fromOffset(0, y)
        icon.BackgroundColor3 = COL_CARD
        icon.BorderSizePixel = 0
        icon.Image = "rbxassetid://" .. so[2]
        icon.ScaleType = Enum.ScaleType.Fit
        icon.Parent = linksBox
        Instance.new("UICorner", icon).CornerRadius = UDim.new(0, 6)

        local nm = Instance.new("TextLabel")
        nm.BackgroundTransparency = 1
        nm.Position = UDim2.fromOffset(32, y - 1)
        nm.Size = UDim2.new(1, -100, 0, 14)
        nm.Font = Enum.Font.GothamBold
        nm.TextSize = 11
        nm.TextColor3 = COL_TEXT
        nm.TextXAlignment = Enum.TextXAlignment.Left
        nm.Text = so[1]
        nm.Parent = linksBox

        local hd = Instance.new("TextLabel")
        hd.BackgroundTransparency = 1
        hd.Position = UDim2.fromOffset(32, y + 12)
        hd.Size = UDim2.new(1, -100, 0, 12)
        hd.Font = Enum.Font.GothamMedium
        hd.TextSize = 10
        hd.TextColor3 = COL_GLOW
        hd.TextXAlignment = Enum.TextXAlignment.Left
        hd.TextTruncate = Enum.TextTruncate.AtEnd
        hd.Text = so[4]
        hd.Parent = linksBox

        local cb = Instance.new("TextButton")
        cb.Size = UDim2.fromOffset(54, 24)
        cb.Position = UDim2.new(1, -54, 0, y - 1)
        cb.BackgroundColor3 = COL_CARD
        cb.Text = "COPY"
        cb.Font = Enum.Font.GothamBold
        cb.TextSize = 9
        cb.TextColor3 = COL_TEXT
        cb.AutoButtonColor = false
        cb.BorderSizePixel = 0
        cb.Parent = linksBox
        Instance.new("UICorner", cb).CornerRadius = UDim.new(0, 6)
        cb.MouseButton1Click:Connect(function()
            if setclipboard then setclipboard(so[3])
            elseif syn and syn.write_clipboard then syn.write_clipboard(so[3])
            elseif toclipboard then toclipboard(so[3]) end
            cb.Text = "OK!"
            task.wait(1.2)
            cb.Text = "COPY"
        end)
    end
end

execBox = Instance.new("Frame")
execBox.Name = "ExecutorBox"
execBox.Size = UDim2.new(1, 0, 0, 60)
execBox.Position = UDim2.fromOffset(0, 0)
execBox.BackgroundColor3 = COL_PANEL
execBox.BorderSizePixel = 0
execBox.Parent = homePage

Instance.new("UICorner", execBox).CornerRadius = UDim.new(0, 8)

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
execLabel.Font = Enum.Font.GothamBold
execLabel.TextSize = 8
execLabel.TextColor3 = COL_MUTED
execLabel.TextXAlignment = Enum.TextXAlignment.Left
execLabel.Text = "YOUR EXECUTOR"
execLabel.Parent = execBox

local execValue = Instance.new("TextLabel")
execValue.BackgroundTransparency = 1
execValue.Position = UDim2.fromOffset(0, 18)
execValue.Size = UDim2.new(1, 0, 0, 20)
execValue.Font = Enum.Font.GothamBold
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
    execBox.Position = UDim2.fromOffset(0, y + 136 + 16)
end

favBox:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateHomeLayout)
task.defer(function()
    task.wait(0.1)
    updateHomeLayout()
end)
end -- Home page scope

local scriptPage, suggestView, universalView, stealView, gameListView, suggestBtn, universalBtn, stealBtn, gameHubView
local suggestBtnRef, tabKey, tabKeyless, tabVisuals
do
local moreScriptsView
scriptPage = Instance.new("Frame")
scriptPage.Name = "ScriptPage"
scriptPage.Size = UDim2.fromScale(1, 1)
scriptPage.BackgroundTransparency = 1
scriptPage.Visible = false
scriptPage.Parent = content

gameListView = Instance.new("ScrollingFrame")
gameListView.Name = "GameListView"
gameListView.Size = UDim2.new(1, 0, 1, -20)
gameListView.BackgroundTransparency = 1
gameListView.BorderSizePixel = 0
gameListView.ScrollBarThickness = 3
gameListView.ScrollBarImageColor3 = COL_ACCENT
gameListView.CanvasSize = UDim2.fromOffset(0, 0)
gameListView.AutomaticCanvasSize = Enum.AutomaticSize.Y
gameListView.ScrollingDirection = Enum.ScrollingDirection.Y
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
glTitle.Font = Enum.Font.GothamBold
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
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.TextColor3 = COL_TEXT
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    btn.BorderSizePixel = 0
    btn.LayoutOrder = order
    btn.Parent = gameListView

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    Instance.new("UIPadding", btn).PaddingLeft = UDim.new(0, 8)
    UI.edge(btn, 0.4)

    local arrow = Instance.new("TextLabel")
    arrow.BackgroundTransparency = 1
    arrow.Position = UDim2.new(1, -26, 0, 0)
    arrow.Size = UDim2.fromOffset(20, 46)
    arrow.Font = Enum.Font.GothamBold
    arrow.TextSize = 14
    arrow.TextColor3 = COL_SUBTEXT
    arrow.Text = ">"
    arrow.Parent = btn

    return btn
end

-- Suggestions first, followed by Bypass Link
suggestBtn   = makeGameBtn("Suggestions Script", 1)
local bypassLinkBtn = makeGameBtn("Bypass Link", 2)
universalBtn = makeGameBtn("Universal", 3)
stealBtn     = makeGameBtn("Steal an Egg", 4)
local bloxFruitsBtn = makeGameBtn("Blox Fruits", 5)
local mm2Btn = makeGameBtn("MM2", 6)
local fischBtn = makeGameBtn("Fisch", 7)
local fishItBtn = makeGameBtn("Fish It", 8)
local beeSwarmBtn = makeGameBtn("Bee Swarm", 9)
local moreScriptsBtn = makeGameBtn("Search More Scripts", 10)

-- Gold style sa Suggest button
suggestBtn.BackgroundColor3 = Color3.fromRGB(38, 30, 22)
suggestBtn.TextColor3 = Color3.fromRGB(255, 220, 140)
local sgStroke = Instance.new("UIStroke", suggestBtn)
sgStroke.Color = Color3.fromRGB(255, 180, 60)
sgStroke.Thickness = 1.2
sgStroke.Transparency = 0.2
sgStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- ===== BYPASS LINK VIEW =====
local bypassView = Instance.new("Frame")
bypassView.Name = "BypassLinkView"
bypassView.Size = UDim2.fromScale(1, 1)
bypassView.BackgroundTransparency = 1
bypassView.Visible = false
bypassView.Parent = scriptPage

local bypassBack = Instance.new("TextButton")
bypassBack.Size = UDim2.fromOffset(64, 26)
bypassBack.BackgroundColor3 = COL_CARD
bypassBack.Text = "< Back"
bypassBack.Font = Enum.Font.GothamBold
bypassBack.TextSize = 10
bypassBack.TextColor3 = COL_TEXT
bypassBack.AutoButtonColor = false
bypassBack.BorderSizePixel = 0
bypassBack.Parent = bypassView
Instance.new("UICorner", bypassBack).CornerRadius = UDim.new(0, 6)

local bypassTitle = Instance.new("TextLabel")
bypassTitle.BackgroundTransparency = 1
bypassTitle.Position = UDim2.fromOffset(74, 0)
bypassTitle.Size = UDim2.new(1, -80, 0, 26)
bypassTitle.Font = Enum.Font.GothamBold
bypassTitle.TextSize = 12
bypassTitle.TextColor3 = COL_GLOW
bypassTitle.TextXAlignment = Enum.TextXAlignment.Left
bypassTitle.Text = "BYPASS LINK"
bypassTitle.Parent = bypassView

local bypassInput = Instance.new("TextBox")
bypassInput.Position = UDim2.fromOffset(0, 38)
bypassInput.Size = UDim2.new(1, -6, 0, 36)
bypassInput.BackgroundColor3 = COL_CARD
bypassInput.Font = Enum.Font.Gotham
bypassInput.TextSize = 10
bypassInput.TextColor3 = COL_TEXT
bypassInput.PlaceholderText = "Paste link here..."
bypassInput.PlaceholderColor3 = COL_MUTED
bypassInput.Text = ""
bypassInput.ClearTextOnFocus = false
bypassInput.TextXAlignment = Enum.TextXAlignment.Left
bypassInput.BorderSizePixel = 0
bypassInput.Parent = bypassView
Instance.new("UICorner", bypassInput).CornerRadius = UDim.new(0, 6)
local bypassInputPad = Instance.new("UIPadding", bypassInput)
bypassInputPad.PaddingLeft = UDim.new(0, 10)
bypassInputPad.PaddingRight = UDim.new(0, 8)

local bypassAction = Instance.new("TextButton")
bypassAction.Position = UDim2.fromOffset(0, 82)
bypassAction.Size = UDim2.new(1, -6, 0, 34)
bypassAction.BackgroundColor3 = COL_ACCENT
bypassAction.Text = "BYPASS"
bypassAction.Font = Enum.Font.GothamBold
bypassAction.TextSize = 11
bypassAction.TextColor3 = Color3.new(1, 1, 1)
bypassAction.AutoButtonColor = false
bypassAction.BorderSizePixel = 0
bypassAction.Parent = bypassView
Instance.new("UICorner", bypassAction).CornerRadius = UDim.new(0, 6)

local bypassStatus = Instance.new("TextLabel")
bypassStatus.Position = UDim2.fromOffset(0, 122)
bypassStatus.Size = UDim2.new(1, -6, 0, 30)
bypassStatus.BackgroundTransparency = 1
bypassStatus.Font = Enum.Font.Gotham
bypassStatus.TextSize = 9
bypassStatus.TextColor3 = COL_MUTED
bypassStatus.TextWrapped = true
bypassStatus.TextXAlignment = Enum.TextXAlignment.Left
bypassStatus.TextYAlignment = Enum.TextYAlignment.Top
bypassStatus.Text = "Paste a supported link, then tap BYPASS."
bypassStatus.Parent = bypassView

local bypassResult = Instance.new("TextBox")
bypassResult.Position = UDim2.fromOffset(0, 156)
bypassResult.Size = UDim2.new(1, -6, 0, 44)
bypassResult.BackgroundColor3 = COL_CARD
bypassResult.Font = Enum.Font.Gotham
bypassResult.TextSize = 9
bypassResult.TextColor3 = COL_TEXT
bypassResult.PlaceholderText = "Result link will appear here..."
bypassResult.PlaceholderColor3 = COL_MUTED
bypassResult.Text = ""
bypassResult.ClearTextOnFocus = false
bypassResult.TextWrapped = true
bypassResult.TextXAlignment = Enum.TextXAlignment.Left
bypassResult.TextYAlignment = Enum.TextYAlignment.Center
bypassResult.BorderSizePixel = 0
bypassResult.Parent = bypassView
Instance.new("UICorner", bypassResult).CornerRadius = UDim.new(0, 6)
local bypassResultPad = Instance.new("UIPadding", bypassResult)
bypassResultPad.PaddingLeft = UDim.new(0, 8)
bypassResultPad.PaddingRight = UDim.new(0, 8)

local bypassCopy = Instance.new("TextButton")
bypassCopy.Position = UDim2.fromOffset(0, 207)
bypassCopy.Size = UDim2.new(1, -6, 0, 30)
bypassCopy.BackgroundColor3 = COL_PANEL
bypassCopy.Text = "COPY RESULT"
bypassCopy.Font = Enum.Font.GothamBold
bypassCopy.TextSize = 10
bypassCopy.TextColor3 = COL_TEXT
bypassCopy.AutoButtonColor = false
bypassCopy.BorderSizePixel = 0
bypassCopy.Parent = bypassView
Instance.new("UICorner", bypassCopy).CornerRadius = UDim.new(0, 6)
UI.edge(bypassCopy, 0.4)

local supportedLinks = Instance.new("TextLabel")
supportedLinks.Position = UDim2.fromOffset(0, 246)
supportedLinks.Size = UDim2.new(1, -6, 0, 100)
supportedLinks.BackgroundTransparency = 1
supportedLinks.Font = Enum.Font.Gotham
supportedLinks.TextSize = 9
supportedLinks.TextColor3 = COL_MUTED
supportedLinks.TextWrapped = true
supportedLinks.TextXAlignment = Enum.TextXAlignment.Left
supportedLinks.TextYAlignment = Enum.TextYAlignment.Top
supportedLinks.Text = "SUPPORTED LINKS\nLinkvertise • LootLabs • LootLinks • Work.ink • Adfly • Shrtfly • Short-jambo • Cuty • Shrinkearn • Lockr • Rinku\n\nSupport depends on the bypass service; some links may not work."
supportedLinks.Parent = bypassView

local function encodeBypassUrl(value)
    return (string.gsub(value, "([^%w%-_%.~])", function(c)
        return string.format("%%%02X", string.byte(c))
    end))
end

local function performLinkBypass()
    local inputUrl = string.gsub(bypassInput.Text or "", "^%s*(.-)%s*$", "%1")
    if inputUrl == "" then
        bypassStatus.TextColor3 = COL_RED
        bypassStatus.Text = "Paste a link first."
        return
    end
    if not string.match(string.lower(inputUrl), "^https?://") then
        bypassStatus.TextColor3 = COL_RED
        bypassStatus.Text = "Enter a valid link beginning with http:// or https://."
        return
    end

    local httpRequest = HTTP_REQUEST
    if not httpRequest then
        bypassStatus.TextColor3 = COL_RED
        bypassStatus.Text = "HTTP request is not available in this executor."
        return
    end

    bypassAction.Text = "BYPASSING..."
    bypassAction.Active = false
    bypassStatus.TextColor3 = COL_MUTED
    bypassStatus.Text = "Contacting bypass service..."
    bypassResult.Text = ""

    task.spawn(function()
        -- ============================================================
        -- PASTE YOUR TRW BYPASS API KEY BETWEEN THE QUOTES BELOW
        -- example: local apiKey = "TRW_xxxxxxxx"
        -- ============================================================
        local apiKey = "TRW_FREE-GAY-15a92945-9b04-4c75-8337-f2a6007281e9"
        if apiKey == "" then
            bypassStatus.TextColor3 = COL_RED
            bypassStatus.Text = "Bypass API key needs to be configured."
            bypassAction.Text = "BYPASS"
            bypassAction.Active = true
            return
        end
        local apiUrl = "https://trw.lat/api/bypass?apikey=" .. apiKey .. "&url=" .. encodeBypassUrl(inputUrl)
        local ok, response = pcall(function()
            return httpRequest({
                Url = apiUrl,
                Method = "GET",
                Headers = {
                    ["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/120.0.0.0",
                    ["Accept"] = "application/json"
                }
            })
        end)

        local finalUrl
        if ok and response and response.StatusCode == 200 and response.Body then
            local decodedOk, data = pcall(function()
                return HttpService:JSONDecode(response.Body)
            end)
            if decodedOk and type(data) == "table" and data.success and type(data.result) == "string" then
                finalUrl = data.result
            end
        end

        if finalUrl and string.match(string.lower(finalUrl), "^https?://") then
            bypassResult.Text = finalUrl
            bypassStatus.TextColor3 = COL_GREEN
            bypassStatus.Text = "Bypass successful. Tap COPY RESULT."
        else
            bypassStatus.TextColor3 = COL_RED
            bypassStatus.Text = "Bypass failed. The API may not support this link or may be unavailable."
        end
        bypassAction.Text = "BYPASS"
        bypassAction.Active = true
    end)
end

bypassAction.MouseButton1Click:Connect(performLinkBypass)
bypassInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then performLinkBypass() end
end)
bypassCopy.MouseButton1Click:Connect(function()
    if bypassResult.Text ~= "" then
        local clipboard = setclipboard or toclipboard
        if clipboard then
            local copied = pcall(clipboard, bypassResult.Text)
            bypassStatus.TextColor3 = copied and COL_GREEN or COL_RED
            bypassStatus.Text = copied and "Result copied." or "Could not copy the result."
        else
            bypassStatus.TextColor3 = COL_RED
            bypassStatus.Text = "Clipboard is not supported. Select and copy the result."
        end
    end
end)

bypassLinkBtn.MouseButton1Click:Connect(function()
    gameListView.Visible = false
    universalView.Visible = false
    stealView.Visible = false
    suggestView.Visible = false
    gameHubView.Visible = false
    moreScriptsView.Visible = false
    bypassView.Visible = true
end)

bypassBack.MouseButton1Click:Connect(function()
    bypassView.Visible = false
    gameListView.Visible = true
end)

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
backUnivBtn.Font = Enum.Font.GothamBold
backUnivBtn.TextSize = 10
backUnivBtn.TextColor3 = COL_TEXT
backUnivBtn.AutoButtonColor = false
backUnivBtn.BorderSizePixel = 0
backUnivBtn.Parent = universalView

Instance.new("UICorner", backUnivBtn).CornerRadius = UDim.new(0, 6)

local univTitle = Instance.new("TextLabel")
univTitle.BackgroundTransparency = 1
univTitle.Position = UDim2.fromOffset(74, 0)
univTitle.Size = UDim2.new(1, -74, 0, 26)
univTitle.Font = Enum.Font.GothamBold
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

Instance.new("UICorner", univSearch).CornerRadius = UDim.new(0, 6)

local univSearchPad = Instance.new("UIPadding", univSearch)
univSearchPad.PaddingLeft = UDim.new(0, 10)
univSearchPad.PaddingRight = UDim.new(0, 10)

local univBox = Instance.new("TextBox")
univBox.Size = UDim2.new(1, 0, 1, 0)
univBox.Position = UDim2.fromOffset(0, 0)
univBox.BackgroundTransparency = 1
univBox.Font = Enum.Font.Gotham
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
backStealBtn.Font = Enum.Font.GothamBold
backStealBtn.TextSize = 10
backStealBtn.TextColor3 = COL_TEXT
backStealBtn.AutoButtonColor = false
backStealBtn.BorderSizePixel = 0
backStealBtn.Parent = stealView

Instance.new("UICorner", backStealBtn).CornerRadius = UDim.new(0, 6)

local stealTitle = Instance.new("TextLabel")
stealTitle.BackgroundTransparency = 1
stealTitle.Position = UDim2.fromOffset(74, 0)
stealTitle.Size = UDim2.new(1, -74, 0, 26)
stealTitle.Font = Enum.Font.GothamBold
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

Instance.new("UICorner", stealSearch).CornerRadius = UDim.new(0, 6)

local stealSearchPad = Instance.new("UIPadding", stealSearch)
stealSearchPad.PaddingLeft = UDim.new(0, 10)
stealSearchPad.PaddingRight = UDim.new(0, 10)

local stealBox = Instance.new("TextBox")
stealBox.Size = UDim2.new(1, 0, 1, 0)
stealBox.Position = UDim2.fromOffset(0, 0)
stealBox.BackgroundTransparency = 1
stealBox.Font = Enum.Font.Gotham
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
    b.Font = Enum.Font.GothamBold
    b.TextSize = 9
    b.TextColor3 = COL_TEXT
    b.AutoButtonColor = false
    b.BorderSizePixel = 0
    b.Parent = stealTabs

    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
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
    {"Fly",               "https://pastefy.app/Ysk3q916/raw"},
    {"Aimbot",            "https://pastefy.app/guVGymFl/raw"},
    {"Hitbox Changer",    "https://pastefy.app/pHSqORvx/raw"},
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

do -- suggest scope
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
backSuggestBtn.Font = Enum.Font.GothamBold
backSuggestBtn.TextSize = 10
backSuggestBtn.TextColor3 = COL_TEXT
backSuggestBtn.AutoButtonColor = false
backSuggestBtn.BorderSizePixel = 0
backSuggestBtn.Parent = suggestView

Instance.new("UICorner", backSuggestBtn).CornerRadius = UDim.new(0, 6)

local suggestTitle = Instance.new("TextLabel")
suggestTitle.BackgroundColor3 = Color3.fromRGB(255, 180, 60)
suggestTitle.BackgroundTransparency = 1
suggestTitle.Position = UDim2.fromOffset(74, 0)
suggestTitle.Size = UDim2.new(1, -80, 0, 26)
suggestTitle.Font = Enum.Font.GothamBold
suggestTitle.TextSize = 12
suggestTitle.TextColor3 = Color3.fromRGB(255, 200, 80)
suggestTitle.TextXAlignment = Enum.TextXAlignment.Left
suggestTitle.Text = "Suggestions Script"
suggestTitle.Parent = suggestView

local suggestStatus = Instance.new("TextLabel")
suggestStatus.BackgroundTransparency = 1
suggestStatus.Position = UDim2.fromOffset(0, 29)
suggestStatus.Size = UDim2.new(1, -6, 0, 16)
suggestStatus.Font = Enum.Font.Gotham
suggestStatus.TextSize = 10
suggestStatus.TextColor3 = COL_MUTED
suggestStatus.TextXAlignment = Enum.TextXAlignment.Left
suggestStatus.Text = ""
suggestStatus.Parent = suggestView

local sugGameLbl = Instance.new("TextLabel")
sugGameLbl.BackgroundTransparency = 1
sugGameLbl.Position = UDim2.fromOffset(0, 46)
sugGameLbl.Size = UDim2.new(1, 0, 0, 12)
sugGameLbl.Font = Enum.Font.GothamBold
sugGameLbl.TextSize = 9
sugGameLbl.TextColor3 = COL_MUTED
sugGameLbl.TextXAlignment = Enum.TextXAlignment.Left
sugGameLbl.Text = "GAME NAME *"
sugGameLbl.Parent = suggestView

local sugGameBox = Instance.new("TextBox")
sugGameBox.Size = UDim2.new(1, -6, 0, 28)
sugGameBox.Position = UDim2.fromOffset(0, 59)
sugGameBox.BackgroundColor3 = COL_CARD
sugGameBox.Font = Enum.Font.Gotham
sugGameBox.TextSize = 10
sugGameBox.TextColor3 = COL_TEXT
sugGameBox.PlaceholderText = "Enter game name..."
sugGameBox.PlaceholderColor3 = COL_MUTED
sugGameBox.Text = ""
sugGameBox.TextXAlignment = Enum.TextXAlignment.Left
sugGameBox.ClearTextOnFocus = false
sugGameBox.BorderSizePixel = 0
sugGameBox.Parent = suggestView

Instance.new("UICorner", sugGameBox).CornerRadius = UDim.new(0, 6)
Instance.new("UIPadding", sugGameBox).PaddingLeft = UDim.new(0, 10)

local sugScriptLbl = Instance.new("TextLabel")
sugScriptLbl.BackgroundTransparency = 1
sugScriptLbl.Position = UDim2.fromOffset(0, 91)
sugScriptLbl.Size = UDim2.new(1, 0, 0, 12)
sugScriptLbl.Font = Enum.Font.GothamBold
sugScriptLbl.TextSize = 9
sugScriptLbl.TextColor3 = COL_MUTED
sugScriptLbl.TextXAlignment = Enum.TextXAlignment.Left
sugScriptLbl.Text = "SCRIPT NAME *"
sugScriptLbl.Parent = suggestView

local sugScriptBox = Instance.new("TextBox")
sugScriptBox.Size = UDim2.new(1, -6, 0, 28)
sugScriptBox.Position = UDim2.fromOffset(0, 104)
sugScriptBox.BackgroundColor3 = COL_CARD
sugScriptBox.Font = Enum.Font.Gotham
sugScriptBox.TextSize = 10
sugScriptBox.TextColor3 = COL_TEXT
sugScriptBox.PlaceholderText = "Enter script name..."
sugScriptBox.PlaceholderColor3 = COL_MUTED
sugScriptBox.Text = ""
sugScriptBox.TextXAlignment = Enum.TextXAlignment.Left
sugScriptBox.ClearTextOnFocus = false
sugScriptBox.BorderSizePixel = 0
sugScriptBox.Parent = suggestView

Instance.new("UICorner", sugScriptBox).CornerRadius = UDim.new(0, 6)
Instance.new("UIPadding", sugScriptBox).PaddingLeft = UDim.new(0, 10)

local sugDescLbl = Instance.new("TextLabel")
sugDescLbl.BackgroundTransparency = 1
sugDescLbl.Position = UDim2.fromOffset(0, 139)
sugDescLbl.Size = UDim2.new(1, -70, 0, 12)
sugDescLbl.Font = Enum.Font.GothamBold
sugDescLbl.TextSize = 9
sugDescLbl.TextColor3 = COL_MUTED
sugDescLbl.TextXAlignment = Enum.TextXAlignment.Left
sugDescLbl.Text = "DESCRIPTION *"
sugDescLbl.Parent = suggestView

local sugDescCount = Instance.new("TextLabel")
sugDescCount.BackgroundTransparency = 1
sugDescCount.Position = UDim2.new(1, -66, 0, 139)
sugDescCount.Size = UDim2.fromOffset(60, 12)
sugDescCount.Font = Enum.Font.Gotham
sugDescCount.TextSize = 8
sugDescCount.TextColor3 = COL_MUTED
sugDescCount.TextXAlignment = Enum.TextXAlignment.Right
sugDescCount.Text = "0/200"
sugDescCount.Parent = suggestView

local sugDescBox = Instance.new("TextBox")
sugDescBox.Size = UDim2.new(1, -6, 0, 48)
sugDescBox.Position = UDim2.fromOffset(0, 154)
sugDescBox.BackgroundColor3 = COL_CARD
sugDescBox.Font = Enum.Font.Gotham
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

Instance.new("UICorner", sugDescBox).CornerRadius = UDim.new(0, 6)

local sugDescPad = Instance.new("UIPadding", sugDescBox)
sugDescPad.PaddingLeft = UDim.new(0, 10)
sugDescPad.PaddingRight = UDim.new(0, 10)
sugDescPad.PaddingTop = UDim.new(0, 6)
sugDescPad.PaddingBottom = UDim.new(0, 6)

local sugLinkLbl = Instance.new("TextLabel")
sugLinkLbl.BackgroundTransparency = 1
sugLinkLbl.Position = UDim2.fromOffset(0, 215)
sugLinkLbl.Size = UDim2.new(1, 0, 0, 12)
sugLinkLbl.Font = Enum.Font.GothamBold
sugLinkLbl.TextSize = 9
sugLinkLbl.TextColor3 = COL_MUTED
sugLinkLbl.TextXAlignment = Enum.TextXAlignment.Left
sugLinkLbl.Text = "LOADSTRING / URL (OPTIONAL)"
sugLinkLbl.Parent = suggestView

local sugLinkBox = Instance.new("TextBox")
sugLinkBox.Size = UDim2.new(1, -6, 0, 28)
sugLinkBox.Position = UDim2.fromOffset(0, 230)
sugLinkBox.BackgroundColor3 = COL_CARD
sugLinkBox.Font = Enum.Font.Gotham
sugLinkBox.TextSize = 9
sugLinkBox.TextColor3 = COL_TEXT
sugLinkBox.PlaceholderText = "loadstring(game:HttpGet(...))()"
sugLinkBox.PlaceholderColor3 = COL_MUTED
sugLinkBox.Text = ""
sugLinkBox.TextXAlignment = Enum.TextXAlignment.Left
sugLinkBox.ClearTextOnFocus = false
sugLinkBox.BorderSizePixel = 0
sugLinkBox.Parent = suggestView

Instance.new("UICorner", sugLinkBox).CornerRadius = UDim.new(0, 6)
Instance.new("UIPadding", sugLinkBox).PaddingLeft = UDim.new(0, 10)

local sugSendBtn = Instance.new("TextButton")
sugSendBtn.Size = UDim2.new(1, -6, 0, 30)
sugSendBtn.Position = UDim2.fromOffset(0, 264)
sugSendBtn.BackgroundColor3 = Color3.fromRGB(255, 180, 60)
sugSendBtn.Text = "SEND SUGGESTION"
sugSendBtn.Font = Enum.Font.GothamBold
sugSendBtn.TextSize = 11
sugSendBtn.TextColor3 = Color3.fromRGB(40, 25, 5)
sugSendBtn.AutoButtonColor = false
sugSendBtn.BorderSizePixel = 0
sugSendBtn.Parent = suggestView

Instance.new("UICorner", sugSendBtn).CornerRadius = UDim.new(0, 6)

local sugCooldownLbl = Instance.new("TextLabel")
sugCooldownLbl.BackgroundTransparency = 1
sugCooldownLbl.Position = UDim2.fromOffset(0, 300)
sugCooldownLbl.Size = UDim2.new(1, -6, 0, 14)
sugCooldownLbl.Font = Enum.Font.Gotham
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
            footer = { text = "Cat Hub v2.0 | " .. phtTime }
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
    gameHubView.Visible = false
    bypassView.Visible = false
    refreshSuggestCooldownUI()
end)
end -- suggest scope

do -- game hubs scope
local GAME_HUBS = {
    ["Blox Fruits"] = {
        Keyless = {
            {"Redz Hub", "https://raw.githubusercontent.com/bloxfruitsnokey/Redz/refs/heads/main/Redz/update30.luau"},
            {"Moonlight Hub", "https://raw.githubusercontent.com/Dev-Moonlight/Moonlight/refs/heads/main/Main"},
            {"Night Hub", "https://raw.githubusercontent.com/WhiteX1208/Scripts/refs/heads/main/BF-Beta.lua"},
            {"Bear Hub", "https://raw.githubusercontent.com/Huylovemy/Bearhudz/refs/heads/main/Bearhudlua"},
            {"Axonic", "https://raw.githubusercontent.com/Kenniel123/BloxFruits/refs/heads/main/BloxFruits"},
            {"Black V Hub", "https://raw.githubusercontent.com/nvb201112/Black-V-Hub/refs/heads/main/KaitunBF.luau"},
            {"Teddy Hub", "https://raw.githubusercontent.com/Teddyseetink/Haidepzai/refs/heads/main/TEDDYHUB-FREEMIUM"},
            {"ARC Hub", "https://raw.githubusercontent.com/bloxfruitsnokey/Arcylic/refs/heads/main/ARC/update.luau"},
            {"Mango Hub", "https://raw.githubusercontent.com/Mango-Hub/BloxFruits/main/Mango.lua"},
            {"Comet Hub", "https://raw.githubusercontent.com/Comet-Hub/BloxFruits/main/Comet"},
            {"Velocity Hub", "https://raw.githubusercontent.com/Velocity-Hub/BloxFruits/main/Velocity.lua"}
        },
        Key = {
            {"HoHo Hub (Top 1)", "https://raw.githubusercontent.com/acsu123/HOHO_H/main/Loading_UI"},
            {"Mukuro Hub", "https://raw.githubusercontent.com/xQuartyx/DonateMe/main/ScriptLoader"},
            {"Thunder Z Hub", "https://raw.githubusercontent.com/ThunderZ-05/HUB/main/MobileV2"},
            {"Tsuo Hub", "https://raw.githubusercontent.com/Tsuo7/TsuoHub/main/bloxfruits"},
            {"Solix Hub", "https://raw.githubusercontent.com/debunked69/Solixreworkkeysystem/refs/heads/main/solix%20new%20keyui.lua"},
            {"Primo Hub", "https://raw.githubusercontent.com/LOLking123456/Primo/main/BloxFruit"},
            {"Speed Hub X", "https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua"},
            {"Minh Hub", "https://raw.githubusercontent.com/RealMinh/MinhHub/main/MinhHub"},
            {"Wally Hub", "https://raw.githubusercontent.com/WallyHub/Wally/main/Main.lua"},
            {"Vanity Hub", "https://vanityscript.xyz/loader"},
            {"Rift Hub", "https://raw.githubusercontent.com/Rift-Hub/BloxFruits/main/Rift"},
            {"Nihon Hub", "https://raw.githubusercontent.com/NihonHub/Nihon/main/BF"}
        }
    },
    ["MM2"] = {
        Keyless = {
            {"Yarhm Hub", "https://raw.githubusercontent.com/Joystickplays/psychic-octo-invention/main/source/yarhm/1.21/yarhm.lua"},
            {"Forge Hub", "https://cdn.forgehub.store/loader"},
            {"Zenith Pro", "https://raw.githubusercontent.com/Zenith-Hub/Zenith/main/Zenith.lua"},
            {"XadedHub", "https://raw.githubusercontent.com/XadedHub/XadedHub/main/Main.lua"},
            {"Vertex Hub", "https://raw.githubusercontent.com/Vertex-Hub/MM2/main/Main.lua"},
            {"Void Hub", "https://raw.githubusercontent.com/Void-Hub/MM2/main/Main.lua"},
            {"Rayfield Hub", "https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua"},
            {"Speed Hub X", "https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua"}
        },
        Key = {
            {"Tbao Hub", "https://raw.githubusercontent.com/Tbao143/thaibao/main/MurderMystery2"},
            {"HoHo Hub", "https://raw.githubusercontent.com/acsu123/HOHO_H/main/MurderMystery2"},
            {"Solix Hub", "https://raw.githubusercontent.com/debunked69/Solixreworkkeysystem/refs/heads/main/solix%20new%20keyui.lua"},
            {"Mukuro Hub", "https://raw.githubusercontent.com/xQuartyx/DonateMe/main/ScriptLoader"}
        }
    },
    ["Fisch"] = {
        Keyless = {
            {"Redz Hub", "https://raw.githubusercontent.com/huy384/redzHub/refs/heads/main/redzHub.lua"},
            {"Average Hub", "https://gist.githubusercontent.com/AverageHub/1980eccce4133d77fb24d166dc296125/raw/2d9c88acc21a302d92aed0e8b6f0dcd287c8b96b/gistfile1.txt"},
            {"MUR4 Hub", "https://gist.githubusercontent.com/Mur4exe/af4ce068bd4910ff0e5715cd0215c143/raw/f3f36618e23d29d064618d1c573ab29e2e407f71/F%25C4%25B0SHv2.lua"},
            {"Instant Auto Fish", "https://rblxscripts.net/raw/new-fisch-op-auto-farm-script-fast-auto-fishing-auto-sell-no-e257381e"},
            {"Vex Hub", "https://rscripts.net/raw/keyless-best-auto-farm-auto-sell-teleports-and-many-more_1759232187425_aHCNCslCpm.txt"},
            {"Lunaris Hub", "https://rscripts.net/raw/fisch-script-or-lunaris-hub_1780567349744_SUco6Lm1dj.txt"},
            {"Lunor Hub", "https://raw.githubusercontent.com/Just3itx/Lunor-Loadstrings/refs/heads/main/Loader"},
            {"Meng Hub", "https://raw.githubusercontent.com/Meng-Hub/Fisch/main/Main.lua"},
            {"Speed Hub X", "https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua"}
        },
        Key = {
            {"Ronix Hub", "https://api.luarmor.net/files/v3/loaders/fda9babd071d6b536a745774b6bc681c.lua"},
            {"Poseidon Engine", "https://gist.githubusercontent.com/asdasdasd1214/ba29c361c7c532a33d7c55c7dda59895/raw/gistfile1.txt"},
            {"Zenith Hub", "https://raw.githubusercontent.com/Zenith-Hub/Zenith/main/Zenith.lua"},
            {"Lunaris Hub (Keyed)", "https://api.jnkie.com/api/v1/luascripts/public/1d941d315f5df42799aaddc32975bc49021dd87e9c32c84c7ef37ac29330e0ae/download"}
        }
    },
    ["Bee Swarm"] = {
        Keyless = {
            {"Rayfield Hub", "https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua"},
            {"Speed Hub X", "https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua"},
            {"Matrix Hub", "https://raw.githubusercontent.com/MatrixHubRoblox/Matrix-Hub/main/Main.lua"},
            {"Bedol Hub", "https://raw.githubusercontent.com/BedolHub/BedolHub/main/Main.lua"},
            {"Pando Hub", "https://raw.githubusercontent.com/Pando-Hub/Pando/main/Main.lua"},
            {"Fluxus Hub", "https://raw.githubusercontent.com/Fluxus-Hub/Fluxus/main/Loader.lua"},
            {"Hydrogen", "https://raw.githubusercontent.com/Hydrogen-Hub/BeeSwarmSimulator/main/Main.lua"},
            {"Zyrex Hub", "https://raw.githubusercontent.com/Zyrex-Hub/BeeSwarm/main/Zyrex.lua"},
            {"Nihon Hub", "https://raw.githubusercontent.com/NihonHub/Nihon/main/BSS"},
            {"Comet Hub", "https://raw.githubusercontent.com/Comet-Hub/BeeSwarm/main/Comet"},
            {"Owl Hub (Keyless)", "https://raw.githubusercontent.com/Owl-Hub/Owl-Hub/main/OwlHub.lua"}
        },
        Key = {
            {"Tbao Hub (Top 1)", "https://raw.githubusercontent.com/Tbao143/thaibao/main/BeeSwarmSimulator"},
            {"HoHo Hub", "https://raw.githubusercontent.com/acsu123/HOHO_H/main/BeeSwarmSimulator"},
            {"Mukuro Hub", "https://raw.githubusercontent.com/xQuartyx/DonateMe/main/ScriptLoader"},
            {"Solix Hub", "https://raw.githubusercontent.com/debunked69/Solixreworkkeysystem/refs/heads/main/solix%20new%20keyui.lua"},
            {"Zenith Hub", "https://raw.githubusercontent.com/Zenith-Hub/Zenith/main/Zenith.lua"},
            {"Valyse", "https://raw.githubusercontent.com/Valyse/Valyse/main/Main.lua"},
            {"Wally Hub", "https://raw.githubusercontent.com/WallyHub/Wally/main/Main.lua"},
            {"Flames Hub", "https://raw.githubusercontent.com/Flames-Hub/BeeSwarm/main/Flames.lua"},
            {"Nightfall", "https://raw.githubusercontent.com/Nightfall-Hub/BeeSwarm/main/Nightfall.lua"},
            {"Mango Hub", "https://raw.githubusercontent.com/Mango-Hub/BeeSwarm/main/Mango.lua"}
        }
    },
    ["Fish It"] = {
        Keyless = {
            {"Fish It Auto Catch", "https://pastebin.com/raw/WrbNv3Ns"},
            {"NOCTIS Hub", "https://rscripts.net/raw/noctis-fish-it-keyless-noctishub_1761052346566_maNHqY6YV3.txt"},
            {"Fish It OP Script", "https://raw.githubusercontent.com/MajestySkie/list/refs/heads/main/games"},
            {"Euphoria Hub", "https://raw.githubusercontent.com/bimoraa/Euphoria/refs/heads/main/loader.luau"},
            {"Meng Hub", "https://raw.githubusercontent.com/GrexXMeng/Mengs/refs/heads/main/FishIt.lua"},
            {"FourHub Premium", "https://raw.githubusercontent.com/jokerbiel13/FourHub/refs/heads/main/Premium.lua"},
            {"PoopHub", "https://raw.githubusercontent.com/sylolua/PoopHub/refs/heads/main/Loader"},
            {"Auto Perfect Catch", "https://gist.githubusercontent.com/nandafjng/3bfcba477c5ff48f10bc59b02526e98a/raw/8474851fa3aa831a3c9708da696221a4e3e9a982/gistfile1.txt"},
            {"Synthora Hub", "https://raw.githubusercontent.com/Wenarch/Library/refs/heads/main/Script"},
            {"SansMobaHub", "https://raw.githubusercontent.com/DyyITT/SansMobaHub/refs/heads/main/Fishit-Free"},
            {"Blessed Hub X", "https://raw.githubusercontent.com/nandafjng/3bfcba477c5ff48f10bc59b02526e98a/raw/8474851fa3aa831a3c9708da696221a4e3e9a982/gistfile1.txt"}
        },
        Key = {
            {"GLUA Hub", "https://raw.githubusercontent.com/gevriel66/Gev/refs/heads/main/GTrial.lua"},
            {"Fish It AutoFarm", "https://api.luarmor.net/files/v3/loaders/d29f750a5d2c74070b792230ccde0f69.lua"},
            {"Fish It OP Script", "https://api.junkie-development.de/api/v1/luascripts/public/8e08cda5c530a6529a71a14b94a33734eccc870e9f28220410eb21d719f66da9/download"},
            {"Chiyo Hub", "https://raw.githubusercontent.com/kaisenlmao/loader/refs/heads/main/chiyo.lua"}
        }
    }
}

gameHubView = Instance.new("Frame")
gameHubView.Name = "GameHubView"
gameHubView.Size = UDim2.fromScale(1, 1)
gameHubView.BackgroundTransparency = 1
gameHubView.Visible = false
gameHubView.Parent = scriptPage

local ghBack = Instance.new("TextButton")
ghBack.Size = UDim2.fromOffset(64, 26)
ghBack.BackgroundColor3 = COL_CARD
ghBack.Text = "< Back"
ghBack.Font = Enum.Font.GothamBold
ghBack.TextSize = 10
ghBack.TextColor3 = COL_TEXT
ghBack.BorderSizePixel = 0
ghBack.Parent = gameHubView
Instance.new("UICorner", ghBack).CornerRadius = UDim.new(0, 6)

local ghTitle = Instance.new("TextLabel")
ghTitle.BackgroundTransparency = 1
ghTitle.Position = UDim2.fromOffset(74, 0)
ghTitle.Size = UDim2.new(1, -74, 0, 26)
ghTitle.Font = Enum.Font.GothamBold
ghTitle.TextSize = 12
ghTitle.TextColor3 = COL_TEXT
ghTitle.TextXAlignment = Enum.TextXAlignment.Left
ghTitle.Text = "Game scripts"
ghTitle.Parent = gameHubView

local ghKeyless = Instance.new("TextButton")
ghKeyless.Size = UDim2.new(0.5, -4, 0, 28)
ghKeyless.Position = UDim2.fromOffset(0, 34)
ghKeyless.BackgroundColor3 = COL_ACCENT
ghKeyless.Text = "KEYLESS"
ghKeyless.Font = Enum.Font.GothamBold
ghKeyless.TextSize = 10
ghKeyless.TextColor3 = COL_TEXT
ghKeyless.BorderSizePixel = 0
ghKeyless.Parent = gameHubView
Instance.new("UICorner", ghKeyless).CornerRadius = UDim.new(0, 6)

local ghKey = Instance.new("TextButton")
ghKey.Size = UDim2.new(0.5, -4, 0, 28)
ghKey.Position = UDim2.new(0.5, 4, 0, 34)
ghKey.BackgroundColor3 = COL_CARD
ghKey.Text = "KEY"
ghKey.Font = Enum.Font.GothamBold
ghKey.TextSize = 10
ghKey.TextColor3 = COL_TEXT
ghKey.BorderSizePixel = 0
ghKey.Parent = gameHubView
Instance.new("UICorner", ghKey).CornerRadius = UDim.new(0, 6)

local ghList = Instance.new("ScrollingFrame")
ghList.Size = UDim2.new(1, -4, 1, -72)
ghList.Position = UDim2.fromOffset(0, 70)
ghList.BackgroundTransparency = 1
ghList.BorderSizePixel = 0
ghList.ScrollBarThickness = 3
ghList.ScrollBarImageColor3 = COL_ACCENT
ghList.CanvasSize = UDim2.fromOffset(0, 0)
ghList.AutomaticCanvasSize = Enum.AutomaticSize.Y
ghList.Parent = gameHubView
local ghLayout = Instance.new("UIListLayout", ghList)
ghLayout.Padding = UDim.new(0, 7)

local selectedGameHub = nil
local selectedHubType = "Keyless"
local function renderGameHubList()
    for _, child in ipairs(ghList:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    local groups = GAME_HUBS[selectedGameHub]
    local entries = groups and groups[selectedHubType] or {}
    for _, entry in ipairs(entries) do
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -6, 0, 40)
        row.BackgroundColor3 = COL_PANEL
        row.BorderSizePixel = 0
        row.Parent = ghList
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)
        UI.edge(row, 0.45)

        local nameLabel = Instance.new("TextLabel")
        nameLabel.BackgroundTransparency = 1
        nameLabel.Position = UDim2.fromOffset(10, 0)
        nameLabel.Size = UDim2.new(1, -94, 1, 0)
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 10
        nameLabel.TextColor3 = COL_TEXT
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
        nameLabel.Text = entry[1]
        nameLabel.Parent = row

        local runBtn = Instance.new("TextButton")
        runBtn.Size = UDim2.fromOffset(68, 25)
        runBtn.Position = UDim2.new(1, -76, 0.5, -12)
        runBtn.BackgroundColor3 = COL_ACCENT
        runBtn.Text = "RUN"
        runBtn.Font = Enum.Font.GothamBold
        runBtn.TextSize = 9
        runBtn.TextColor3 = COL_TEXT
        runBtn.AutoButtonColor = false
        runBtn.BorderSizePixel = 0
        runBtn.Parent = row
        Instance.new("UICorner", runBtn).CornerRadius = UDim.new(0, 5)
        runBtn.MouseButton1Click:Connect(function()
            if runBtn:GetAttribute("Running") then return end
            runBtn:SetAttribute("Running", true)
            runBtn.Text = "..."
            task.spawn(function()
                local function finish(label, color)
                    if runBtn and runBtn.Parent then
                        runBtn.Text = label
                        runBtn.BackgroundColor3 = color
                        runBtn:SetAttribute("Running", false)
                    end
                    task.delay(2, function()
                        if runBtn and runBtn.Parent and not runBtn:GetAttribute("Running") then
                            runBtn.Text = "RUN"
                            runBtn.BackgroundColor3 = COL_ACCENT
                        end
                    end)
                end

                local ok, source = pcall(function()
                    if type(game.HttpGet) ~= "function" then error("HttpGet unavailable") end
                    return game:HttpGet(entry[2])
                end)
                if not ok or type(source) ~= "string" or source == "" or string.find(string.lower(source), "<html", 1, true) then
                    finish("DEAD", COL_RED)
                    return
                end
                if type(loadstring) ~= "function" then
                    finish("ERR", COL_RED)
                    return
                end
                local compiled, chunk = pcall(loadstring, source)
                if not compiled or type(chunk) ~= "function" then
                    finish("ERR", COL_RED)
                    return
                end
                local executed = pcall(chunk)
                if executed then
                    finish("DONE", COL_ACCENT)
                else
                    finish("ERR", COL_RED)
                end
            end)
        end)
    end
end

local function openGameHub(gameName)
    selectedGameHub = gameName
    selectedHubType = "Keyless"
    ghTitle.Text = gameName
    ghKeyless.BackgroundColor3 = COL_ACCENT
    ghKey.BackgroundColor3 = COL_CARD
    gameListView.Visible = false
    universalView.Visible = false
    stealView.Visible = false
    suggestView.Visible = false
    gameHubView.Visible = true
    renderGameHubList()
end

bloxFruitsBtn.MouseButton1Click:Connect(function() openGameHub("Blox Fruits") end)
mm2Btn.MouseButton1Click:Connect(function() openGameHub("MM2") end)
fischBtn.MouseButton1Click:Connect(function() openGameHub("Fisch") end)
fishItBtn.MouseButton1Click:Connect(function() openGameHub("Fish It") end)
beeSwarmBtn.MouseButton1Click:Connect(function() openGameHub("Bee Swarm") end)
ghKeyless.MouseButton1Click:Connect(function()
    selectedHubType = "Keyless"
    ghKeyless.BackgroundColor3 = COL_ACCENT
    ghKey.BackgroundColor3 = COL_CARD
    renderGameHubList()
end)
ghKey.MouseButton1Click:Connect(function()
    selectedHubType = "Key"
    ghKey.BackgroundColor3 = COL_ACCENT
    ghKeyless.BackgroundColor3 = COL_CARD
    renderGameHubList()
end)
ghBack.MouseButton1Click:Connect(function()
    gameHubView.Visible = false
    gameListView.Visible = true
end)
end -- game hubs scope

do -- more scripts scope
moreScriptsView = Instance.new("Frame")
moreScriptsView.Name = "MoreScriptsView"
moreScriptsView.Size = UDim2.fromScale(1, 1)
moreScriptsView.BackgroundTransparency = 1
moreScriptsView.Visible = false
moreScriptsView.Parent = scriptPage

local msBack = Instance.new("TextButton")
msBack.Size = UDim2.fromOffset(64, 26)
msBack.BackgroundColor3 = COL_CARD
msBack.Text = "< Back"
msBack.Font = Enum.Font.GothamBold
msBack.TextSize = 10
msBack.TextColor3 = COL_TEXT
msBack.BorderSizePixel = 0
msBack.Parent = moreScriptsView
Instance.new("UICorner", msBack).CornerRadius = UDim.new(0, 6)

local msTitle = Instance.new("TextLabel")
msTitle.BackgroundTransparency = 1
msTitle.Position = UDim2.fromOffset(74, 0)
msTitle.Size = UDim2.new(1, -74, 0, 26)
msTitle.Font = Enum.Font.GothamBold
msTitle.TextSize = 12
msTitle.TextColor3 = COL_TEXT
msTitle.TextXAlignment = Enum.TextXAlignment.Left
msTitle.Text = "Search Roblox Scripts"
msTitle.Parent = moreScriptsView

local msSearchBox = Instance.new("TextBox")
msSearchBox.Size = UDim2.new(1, -88, 0, 34)
msSearchBox.Position = UDim2.fromOffset(0, 34)
msSearchBox.BackgroundColor3 = COL_PANEL
msSearchBox.PlaceholderText = "Search script name..."
msSearchBox.PlaceholderColor3 = COL_SUBTEXT
msSearchBox.Text = ""
msSearchBox.ClearTextOnFocus = false
msSearchBox.Font = Enum.Font.Gotham
msSearchBox.TextSize = 11
msSearchBox.TextColor3 = COL_TEXT
msSearchBox.TextXAlignment = Enum.TextXAlignment.Left
msSearchBox.BorderSizePixel = 0
msSearchBox.Parent = moreScriptsView
Instance.new("UICorner", msSearchBox).CornerRadius = UDim.new(0, 6)
local msSearchPad = Instance.new("UIPadding", msSearchBox)
msSearchPad.PaddingLeft = UDim.new(0, 9)
msSearchPad.PaddingRight = UDim.new(0, 7)

local msSearchBtn = Instance.new("TextButton")
msSearchBtn.Size = UDim2.fromOffset(80, 34)
msSearchBtn.Position = UDim2.new(1, -80, 0, 34)
msSearchBtn.BackgroundColor3 = COL_ACCENT
msSearchBtn.Text = "SEARCH"
msSearchBtn.Font = Enum.Font.GothamBold
msSearchBtn.TextSize = 9
msSearchBtn.TextColor3 = COL_TEXT
msSearchBtn.BorderSizePixel = 0
msSearchBtn.Parent = moreScriptsView
Instance.new("UICorner", msSearchBtn).CornerRadius = UDim.new(0, 6)

local msPowered = Instance.new("TextLabel")
msPowered.BackgroundTransparency = 1
msPowered.Position = UDim2.fromOffset(0, 70)
msPowered.Size = UDim2.new(1, 0, 0, 16)
msPowered.Font = Enum.Font.Gotham
msPowered.TextSize = 8
msPowered.TextColor3 = COL_SUBTEXT
msPowered.TextXAlignment = Enum.TextXAlignment.Left
msPowered.Text = "Powered by ScriptBlox.com"
msPowered.Parent = moreScriptsView

local msStatus = Instance.new("TextLabel")
msStatus.BackgroundTransparency = 1
msStatus.Position = UDim2.fromOffset(0, 88)
msStatus.Size = UDim2.new(1, 0, 0, 20)
msStatus.Font = Enum.Font.Gotham
msStatus.TextSize = 9
msStatus.TextColor3 = COL_SUBTEXT
msStatus.TextXAlignment = Enum.TextXAlignment.Left
msStatus.Text = "Enter a Roblox script name and press SEARCH"
msStatus.Parent = moreScriptsView

local msResults = Instance.new("ScrollingFrame")
msResults.Size = UDim2.new(1, -4, 1, -116)
msResults.Position = UDim2.fromOffset(0, 112)
msResults.BackgroundTransparency = 1
msResults.BorderSizePixel = 0
msResults.ScrollBarThickness = 3
msResults.ScrollBarImageColor3 = COL_ACCENT
msResults.CanvasSize = UDim2.fromOffset(0, 0)
msResults.AutomaticCanvasSize = Enum.AutomaticSize.Y
msResults.Parent = moreScriptsView
local msResultsLayout = Instance.new("UIListLayout", msResults)
msResultsLayout.Padding = UDim.new(0, 7)

local searchGeneration = 0
local function clearMoreScriptResults()
    for _, child in ipairs(msResults:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
end

local function getScriptBloxText(url)
    return game:HttpGet(url)
end

local function runMoreScript(entry, runButton)
    runButton.Text = "..."
    task.spawn(function()
        local function setState(label, color, reset)
            if runButton and runButton.Parent then
                runButton.Text = label
                runButton.BackgroundColor3 = color
            end
            if reset then
                task.delay(2, function()
                    if runButton and runButton.Parent then
                        runButton.Text = "RUN"
                        runButton.BackgroundColor3 = COL_ACCENT
                    end
                end)
            end
        end

        local source = type(entry.script) == "string" and entry.script or ""
        if source == "" then
            local identifier = entry.slug or entry._id
            if not identifier then
                setState("DEAD", COL_RED, true)
                return
            end
            local success, response = pcall(function()
                return getScriptBloxText("https://scriptblox.com/api/script/raw/" .. HttpService:UrlEncode(tostring(identifier)))
            end)
            if not success or type(response) ~= "string" or response == "" or string.find(string.lower(response), "<html", 1, true) then
                setState("DEAD", COL_RED, true)
                return
            end
            source = response
        end

        if type(source) ~= "string" or source == "" or string.find(string.lower(source), "<html", 1, true) then
            setState("DEAD", COL_RED, true)
            return
        end
        local compiler = loadstring
        if type(compiler) ~= "function" then
            setState("ERR", COL_RED, true)
            return
        end
        local compileOK, compiled = pcall(compiler, source)
        if not compileOK or type(compiled) ~= "function" then
            setState("ERR", COL_RED, true)
            return
        end
        local execSuccess = pcall(compiled)
        if execSuccess then
            setState("RUN", COL_ACCENT, false)
        else
            setState("ERR", COL_RED, true)
        end
    end)
end

local function addMoreScriptResult(entry)
    local row = Instance.new("Frame")
    row.Name = tostring(entry.title or "Script")
    row.Size = UDim2.new(1, -6, 0, 44)
    row.BackgroundColor3 = COL_PANEL
    row.BorderSizePixel = 0
    row.Parent = msResults
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)
    UI.edge(row, 0.45)

    local nameLabel = Instance.new("TextLabel")
    nameLabel.BackgroundTransparency = 1
    nameLabel.Position = UDim2.fromOffset(9, 0)
    nameLabel.Size = UDim2.new(1, -154, 1, 0)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 9
    nameLabel.TextColor3 = COL_TEXT
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
    nameLabel.Text = tostring(entry.title or "Untitled Script")
    nameLabel.Parent = row

    local keyBadge = Instance.new("TextLabel")
    keyBadge.Size = UDim2.fromOffset(54, 22)
    keyBadge.Position = UDim2.new(1, -137, 0.5, -11)
    keyBadge.BackgroundColor3 = entry.key and Color3.fromRGB(105, 65, 35) or Color3.fromRGB(30, 90, 60)
    keyBadge.Text = entry.key and "KEY" or "KEYLESS"
    keyBadge.Font = Enum.Font.GothamBold
    keyBadge.TextSize = 8
    keyBadge.TextColor3 = COL_TEXT
    keyBadge.BorderSizePixel = 0
    keyBadge.Parent = row
    Instance.new("UICorner", keyBadge).CornerRadius = UDim.new(0, 5)

    local runButton = Instance.new("TextButton")
    runButton.Size = UDim2.fromOffset(70, 26)
    runButton.Position = UDim2.new(1, -77, 0.5, -13)
    runButton.BackgroundColor3 = COL_ACCENT
    runButton.Text = "RUN"
    runButton.Font = Enum.Font.GothamBold
    runButton.TextSize = 9
    runButton.TextColor3 = COL_TEXT
    runButton.BorderSizePixel = 0
    runButton.Parent = row
    Instance.new("UICorner", runButton).CornerRadius = UDim.new(0, 5)
    runButton.MouseButton1Click:Connect(function()
        runMoreScript(entry, runButton)
    end)
end

local function searchMoreScripts()
    local query = string.gsub(msSearchBox.Text or "", "^%s*(.-)%s*$", "%1")
    if query == "" then
        msStatus.Text = "Enter a script name first"
        return
    end
    searchGeneration += 1
    local thisSearch = searchGeneration
    clearMoreScriptResults()
    msStatus.Text = "Searching..."
    msSearchBtn.Text = "..."
    task.spawn(function()
        local url = "https://scriptblox.com/api/script/search?q=" .. HttpService:UrlEncode(query) .. "&max=20&sortBy=updatedAt&order=desc"
        local ok, response = pcall(function()
            return getScriptBloxText(url)
        end)
        if thisSearch ~= searchGeneration then return end
        if not ok then
            msStatus.Text = "Search failed. Check connection or try again."
            msSearchBtn.Text = "SEARCH"
            return
        end
        local decodedOk, data = pcall(function()
            return HttpService:JSONDecode(response)
        end)
        if not decodedOk or type(data) ~= "table" or type(data.result) ~= "table" or type(data.result.scripts) ~= "table" then
            msStatus.Text = "No results or API response error"
            msSearchBtn.Text = "SEARCH"
            return
        end
        local count = 0
        for _, entry in ipairs(data.result.scripts) do
            if type(entry) == "table" then
                addMoreScriptResult(entry)
                count += 1
            end
        end
        msStatus.Text = count > 0 and (tostring(count) .. " scripts found") or "No scripts found"
        msSearchBtn.Text = "SEARCH"
    end)
end

msSearchBtn.MouseButton1Click:Connect(searchMoreScripts)
msSearchBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then searchMoreScripts() end
end)

moreScriptsBtn.MouseButton1Click:Connect(function()
    gameListView.Visible = false
    universalView.Visible = false
    stealView.Visible = false
    suggestView.Visible = false
    gameHubView.Visible = false
    bypassView.Visible = false
    moreScriptsView.Visible = true
end)
msBack.MouseButton1Click:Connect(function()
    moreScriptsView.Visible = false
    gameListView.Visible = true
end)
end -- more scripts scope

-- ===== ROW BUILDER =====
local favRunFunctions = {}

local function makeScriptRow(parentFrame, name, url)
    local row = Instance.new("Frame")
    row.Name = name
    row.Size = UDim2.new(1, -6, 0, 40)
    row.BackgroundColor3 = COL_PANEL
    row.BorderSizePixel = 0
    row.Parent = parentFrame

    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)
    UI.edge(row, 0.45)


    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.fromOffset(14, 0)
    label.Size = UDim2.new(1, -120, 1, 0)
    label.Font = Enum.Font.GothamBold
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
    star.Font = Enum.Font.GothamBold
    star.TextSize = 12
    star.AutoButtonColor = false
    star.BorderSizePixel = 0
    star.Parent = row

    Instance.new("UICorner", star).CornerRadius = UDim.new(0, 5)

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
    run.Font = Enum.Font.GothamBold
    run.TextSize = 9
    run.TextColor3 = COL_TEXT
    run.AutoButtonColor = false
    run.BorderSizePixel = 0
    run.Parent = row

    Instance.new("UICorner", run).CornerRadius = UDim.new(0, 5)

    local function runFn()
        run.Text = "..."
        task.spawn(function()
            local function setState(label, color, reset)
                if run and run.Parent then
                    run.Text = label
                    run.BackgroundColor3 = color
                end
                if reset then
                    task.delay(2, function()
                        if run and run.Parent then
                            run.Text = "RUN"
                            run.BackgroundColor3 = COL_ACCENT
                        end
                    end)
                end
            end

            local success, response = pcall(function()
                if type(game.HttpGet) ~= "function" then
                    error("HttpGet is unavailable")
                end
                return game:HttpGet(url)
            end)
            if not success or type(response) ~= "string" or response == "" or string.find(string.lower(response), "<html", 1, true) then
                setState("DEAD", COL_RED, true)
                return
            end

            local compiler = loadstring
            if type(compiler) ~= "function" then
                setState("ERR", COL_RED, true)
                return
            end
            local compileOK, compiled = pcall(compiler, response)
            if not compileOK or type(compiled) ~= "function" then
                setState("ERR", COL_RED, true)
                return
            end

            local execSuccess = pcall(compiled)
            if execSuccess then
                setState("RUN", COL_ACCENT, false)
            else
                setState("ERR", COL_RED, true)
            end
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
    gameHubView.Visible = false
    moreScriptsView.Visible = false
    showUniversalList()
end)

stealBtn.MouseButton1Click:Connect(function()
    gameListView.Visible = false
    universalView.Visible = false
    stealView.Visible = true
    suggestView.Visible = false
    gameHubView.Visible = false
    moreScriptsView.Visible = false
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
stTitle.Font = Enum.Font.GothamBold
stTitle.TextSize = 14
stTitle.TextColor3 = COL_TEXT
stTitle.TextXAlignment = Enum.TextXAlignment.Left
stTitle.Text = "Settings"
stTitle.Parent = settingsPage

local colorTitle = Instance.new("TextLabel")
colorTitle.BackgroundTransparency = 1
colorTitle.Position = UDim2.fromOffset(0, 36)
colorTitle.Size = UDim2.new(1, 0, 0, 14)
colorTitle.Font = Enum.Font.GothamBold
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
colorBtn.Font = Enum.Font.GothamBold
colorBtn.TextSize = 10
colorBtn.TextColor3 = COL_TEXT
colorBtn.TextXAlignment = Enum.TextXAlignment.Left
colorBtn.AutoButtonColor = false
colorBtn.BorderSizePixel = 0
colorBtn.Parent = settingsPage

Instance.new("UICorner", colorBtn).CornerRadius = UDim.new(0, 6)
Instance.new("UIPadding", colorBtn).PaddingLeft = UDim.new(0, 14)

local colorPanel = Instance.new("Frame")
colorPanel.Size = UDim2.new(1, -6, 0, 130)
colorPanel.Position = UDim2.fromOffset(0, 94)
colorPanel.BackgroundColor3 = COL_PANEL
colorPanel.BorderSizePixel = 0
colorPanel.Visible = false
colorPanel.Parent = settingsPage

Instance.new("UICorner", colorPanel).CornerRadius = UDim.new(0, 8)

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
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 9
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.AutoButtonColor = false
    btn.BorderSizePixel = 0
    btn.Parent = colorPanel

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

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
songTitle.Font = Enum.Font.GothamBold
songTitle.TextSize = 9
songTitle.TextColor3 = COL_MUTED
songTitle.TextXAlignment = Enum.TextXAlignment.Left
songTitle.Text = "SONG ID"
songTitle.Parent = settingsPage

local songBox = Instance.new("TextBox")
songBox.Size = UDim2.new(1, -124, 0, 32)
songBox.Position = UDim2.fromOffset(0, 256)
songBox.BackgroundColor3 = COL_PANEL
songBox.Font = Enum.Font.Gotham
songBox.TextSize = 10
songBox.TextColor3 = COL_TEXT
songBox.PlaceholderText = "Enter Song ID"
songBox.PlaceholderColor3 = COL_MUTED
songBox.Text = ""
songBox.TextXAlignment = Enum.TextXAlignment.Left
songBox.ClearTextOnFocus = false
songBox.BorderSizePixel = 0
songBox.Parent = settingsPage

Instance.new("UICorner", songBox).CornerRadius = UDim.new(0, 6)
Instance.new("UIPadding", songBox).PaddingLeft = UDim.new(0, 12)

playBtn = Instance.new("TextButton")
playBtn.Size = UDim2.fromOffset(56, 32)
playBtn.Position = UDim2.new(1, -118, 0, 256)
playBtn.BackgroundColor3 = COL_ACCENT
playBtn.Text = "PLAY"
playBtn.Font = Enum.Font.GothamBold
playBtn.TextSize = 9
playBtn.TextColor3 = COL_TEXT
playBtn.AutoButtonColor = false
playBtn.BorderSizePixel = 0
playBtn.Parent = settingsPage

Instance.new("UICorner", playBtn).CornerRadius = UDim.new(0, 6)

local stopBtn = Instance.new("TextButton")
stopBtn.Size = UDim2.fromOffset(56, 32)
stopBtn.Position = UDim2.new(1, -56, 0, 256)
stopBtn.BackgroundColor3 = COL_PANEL
stopBtn.Text = "STOP"
stopBtn.Font = Enum.Font.GothamBold
stopBtn.TextSize = 9
stopBtn.TextColor3 = COL_TEXT
stopBtn.AutoButtonColor = false
stopBtn.BorderSizePixel = 0
stopBtn.Parent = settingsPage

Instance.new("UICorner", stopBtn).CornerRadius = UDim.new(0, 6)

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
transTitle.Font = Enum.Font.GothamBold
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
crTitle.Font = Enum.Font.GothamBold
crTitle.TextSize = 14
crTitle.TextColor3 = COL_TEXT
crTitle.TextXAlignment = Enum.TextXAlignment.Left
crTitle.Text = "Credit"
crTitle.Parent = creditPage

local crThank = Instance.new("TextLabel")
crThank.BackgroundTransparency = 1
crThank.Position = UDim2.fromOffset(0, 36)
crThank.Size = UDim2.new(1, 0, 0, 40)
crThank.Font = Enum.Font.Gotham
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
crSpecial.Font = Enum.Font.GothamBold
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
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 9
    btn.TextColor3 = COL_GLOW
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    btn.BorderSizePixel = 0
    btn.Parent = creditPage

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
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
crOwnerLabel.Font = Enum.Font.GothamBold
crOwnerLabel.TextSize = 9
crOwnerLabel.TextColor3 = COL_MUTED
crOwnerLabel.TextXAlignment = Enum.TextXAlignment.Left
crOwnerLabel.Text = "OWNER"
crOwnerLabel.Parent = creditPage

local crOwner = Instance.new("TextLabel")
crOwner.BackgroundTransparency = 1
crOwner.Position = UDim2.fromOffset(0, 274)
crOwner.Size = UDim2.new(1, 0, 0, 22)
crOwner.Font = Enum.Font.GothamBold
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
abTitle.Font = Enum.Font.GothamBold
abTitle.TextSize = 14
abTitle.TextColor3 = COL_TEXT
abTitle.TextXAlignment = Enum.TextXAlignment.Left
abTitle.Text = "About"
abTitle.Parent = aboutPage

local abVer = Instance.new("Frame")
abVer.Position = UDim2.fromOffset(0, 36)
abVer.Size = UDim2.new(1, -6, 0, 300)
abVer.BackgroundColor3 = COL_PANEL
abVer.BorderSizePixel = 0
abVer.Parent = aboutPage

Instance.new("UICorner", abVer).CornerRadius = UDim.new(0, 8)

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
abVerTitle.Font = Enum.Font.GothamBold
abVerTitle.TextSize = 11
abVerTitle.TextColor3 = COL_GLOW
abVerTitle.TextXAlignment = Enum.TextXAlignment.Left
abVerTitle.Text = "NEW UPDATED CAT HUB"
abVerTitle.Parent = abVer

local abChangelog = Instance.new("TextLabel")
abChangelog.BackgroundTransparency = 1
abChangelog.Position = UDim2.fromOffset(0, 26)
abChangelog.Size = UDim2.new(1, 0, 0, 240)
abChangelog.Font = Enum.Font.Gotham
abChangelog.TextSize = 10
abChangelog.TextColor3 = COL_TEXT
abChangelog.TextXAlignment = Enum.TextXAlignment.Left
abChangelog.TextYAlignment = Enum.TextYAlignment.Top
abChangelog.TextWrapped = true
abChangelog.Text = "What's new in this update\n\n- Added Avatar Changer: the visible body now follows your movement and animations. Body joints and parts are synced instead of staying stiff.\n- R6 / R15 visual avatar support and avatar preview controls.\n- Added Bypass Link with a link textbox, bypass button and supported-link list.\n- Search More Scripts: search Roblox scripts by name, with KEY or KEYLESS shown beside RUN.\n- Added game script pages for Blox Fruits, MM2, Fisch, Fish It and Bee Swarm.\n- First-time update badge with a Check About shortcut. It will not keep popping up after it has been seen.\n\nOther CAT HUB features are still included\n- Updated rounder look and the R6 / R15 avatar overlay jump fix.\n- Freeze / Unfreeze with its current state shown.\n- YouTube and TikTok links on Home.\n- Anti AFK, Speed, Infinite Jump, Noclip, Gravity and ESP (all OFF by default).\n- Existing tabs, tools, favorites, free-script notice and credits are still here."
abChangelog.Parent = abVer

local abFree = Instance.new("Frame")
abFree.Position = UDim2.fromOffset(0, 350)
abFree.Size = UDim2.new(1, -6, 0, 80)
abFree.BackgroundColor3 = Color3.fromRGB(38, 30, 22)
abFree.BorderSizePixel = 0
abFree.Parent = aboutPage

Instance.new("UICorner", abFree).CornerRadius = UDim.new(0, 8)

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
abFreeTitle.Font = Enum.Font.GothamBold
abFreeTitle.TextSize = 11
abFreeTitle.TextColor3 = Color3.fromRGB(255, 200, 80)
abFreeTitle.TextXAlignment = Enum.TextXAlignment.Left
abFreeTitle.Text = "This script is 100% FREE!"
abFreeTitle.Parent = abFree

local abFreeMsg = Instance.new("TextLabel")
abFreeMsg.BackgroundTransparency = 1
abFreeMsg.Position = UDim2.fromOffset(0, 26)
abFreeMsg.Size = UDim2.new(1, 0, 0, 40)
abFreeMsg.Font = Enum.Font.Gotham
abFreeMsg.TextSize = 9
abFreeMsg.TextColor3 = Color3.fromRGB(230, 200, 150)
abFreeMsg.TextXAlignment = Enum.TextXAlignment.Left
abFreeMsg.TextYAlignment = Enum.TextYAlignment.Top
abFreeMsg.TextWrapped = true
abFreeMsg.Text = "If you PAID for it, you got scammed.\nReport the seller on Discord."
abFreeMsg.Parent = abFree

local abThanks = Instance.new("Frame")
abThanks.Position = UDim2.fromOffset(0, 444)
abThanks.Size = UDim2.new(1, -6, 0, 55)
abThanks.BackgroundColor3 = COL_PANEL
abThanks.BorderSizePixel = 0
abThanks.Parent = aboutPage

Instance.new("UICorner", abThanks).CornerRadius = UDim.new(0, 8)

local abThanksPad = Instance.new("UIPadding", abThanks)
abThanksPad.PaddingTop = UDim.new(0, 12)
abThanksPad.PaddingBottom = UDim.new(0, 12)
abThanksPad.PaddingLeft = UDim.new(0, 14)
abThanksPad.PaddingRight = UDim.new(0, 14)

local abThanksText = Instance.new("TextLabel")
abThanksText.BackgroundTransparency = 1
abThanksText.Position = UDim2.fromOffset(0, 0)
abThanksText.Size = UDim2.new(1, 0, 1, 0)
abThanksText.Font = Enum.Font.GothamBold
abThanksText.TextSize = 11
abThanksText.TextColor3 = COL_TEXT
abThanksText.TextXAlignment = Enum.TextXAlignment.Left
abThanksText.TextYAlignment = Enum.TextYAlignment.Center
abThanksText.Text = "Thank you for using cat hub."
abThanksText.Parent = abThanks

end

__buildPages()

-- ===== PLAYER TAB (movement, avatar, teleport, spectate, esp) + anti afk =====
UI.buildTools = function()
    local LP = localPlayer
    local VirtualUser = game:GetService("VirtualUser")
    local conns = {}
    local S = {
        speed = 16, keep = false, jump = false, noclip = false, esp = false, team = false,
        dirty = false, busy = false, last = nil, frozen = false, afk = false,
    }
    local defGravity = workspace.Gravity
    local Overlay
    local origMin, origMax = LP.CameraMinZoomDistance, LP.CameraMaxZoomDistance
    local ord = 0

    pcall(function()
        local cam = workspace.CurrentCamera
        local old = cam and cam:FindFirstChild("_CatHubOverlay")
        if old then old:Destroy() end
    end)

    -- ghost collision group: the avatar copy collides with nothing, not even groups the game made
    local PhysicsService = game:GetService("PhysicsService")
    local GHOST = "CH_Ghost"
    pcall(function() PhysicsService:RegisterCollisionGroup(GHOST) end)
    pcall(function()
        PhysicsService:CollisionGroupSetCollidable(GHOST, "Default", false)
        PhysicsService:CollisionGroupSetCollidable(GHOST, GHOST, false)
    end)

    local WHITE = Color3.fromRGB(255, 255, 255)
    local R_CARD = 10
    local R_CTRL = 8

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

    local function shade(o, bottom)
        local g = Instance.new("UIGradient")
        g.Rotation = 90
        g.Color = ColorSequence.new(WHITE, bottom or Color3.fromRGB(185, 200, 238))
        g.Parent = o
        return g
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
        pad.PaddingBottom = UDim.new(0, 10)
        pad.PaddingLeft = UDim.new(0, 2)
        pad.PaddingRight = UDim.new(0, 8)
        local lay = Instance.new("UIListLayout", p)
        lay.Padding = UDim.new(0, 10)
        lay.SortOrder = Enum.SortOrder.LayoutOrder
        return p
    end

    local function label(parent, text, size, color, h, font)
        local l = Instance.new("TextLabel")
        l.BackgroundTransparency = 1
        l.Size = UDim2.new(1, 0, 0, h or 16)
        l.Font = font or Enum.Font.GothamMedium
        l.TextSize = size or 11
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
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, R_CARD)
        UI.edge(card, 0.5)
        local pad = Instance.new("UIPadding", card)
        pad.PaddingTop = UDim.new(0, 12)
        pad.PaddingBottom = UDim.new(0, 12)
        pad.PaddingLeft = UDim.new(0, 14)
        pad.PaddingRight = UDim.new(0, 14)
        local lay = Instance.new("UIListLayout", card)
        lay.Padding = UDim.new(0, 8)
        lay.SortOrder = Enum.SortOrder.LayoutOrder
        label(card, title, 10, COL_GLOW, 14, Enum.Font.GothamBold)
        return card
    end

    local function styleBtn(b, primary)
        b.BackgroundColor3 = primary and COL_ACCENT or COL_CARD
        b.Font = Enum.Font.GothamBold
        b.TextSize = 11
        b.TextColor3 = WHITE
        b.AutoButtonColor = false
        b.BorderSizePixel = 0
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, R_CTRL)
        if primary then
            shade(b)
        else
            UI.edge(b, 0.55)
        end
    end

    local function setPrimary(b, on)
        b.BackgroundColor3 = on and COL_ACCENT or COL_CARD
        local g = b:FindFirstChildOfClass("UIGradient")
        if on and not g then
            shade(b)
        elseif not on and g then
            g:Destroy()
        end
    end

    local function btnRow(parent, specs)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 30)
        row.BackgroundTransparency = 1
        row.LayoutOrder = #parent:GetChildren()
        row.Parent = parent
        local lay = Instance.new("UIListLayout", row)
        lay.FillDirection = Enum.FillDirection.Horizontal
        lay.Padding = UDim.new(0, 6)
        lay.SortOrder = Enum.SortOrder.LayoutOrder
        local n = #specs
        local made = {}
        for i, sp in ipairs(specs) do
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1 / n, -6 * (n - 1) / n, 1, 0)
            b.Text = sp[1]
            b.LayoutOrder = i
            b.Parent = row
            styleBtn(b, sp[3])
            b.MouseButton1Click:Connect(function() sp[2](b) end)
            made[i] = b
        end
        return row, made
    end

    local function inputRow(parent, placeholder, default, specs)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 30)
        row.BackgroundTransparency = 1
        row.LayoutOrder = #parent:GetChildren()
        row.Parent = parent
        local lay = Instance.new("UIListLayout", row)
        lay.FillDirection = Enum.FillDirection.Horizontal
        lay.Padding = UDim.new(0, 6)
        lay.SortOrder = Enum.SortOrder.LayoutOrder
        local n = #specs
        local box = Instance.new("TextBox")
        box.Size = UDim2.new(1, -(n * 68), 1, 0)
        box.BackgroundColor3 = COL_CARD
        box.Font = Enum.Font.GothamMedium
        box.TextSize = 11
        box.TextColor3 = COL_TEXT
        box.PlaceholderText = placeholder
        box.PlaceholderColor3 = COL_MUTED
        box.Text = default or ""
        box.TextXAlignment = Enum.TextXAlignment.Left
        box.ClearTextOnFocus = false
        box.BorderSizePixel = 0
        box.LayoutOrder = 0
        box.Parent = row
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, R_CTRL)
        Instance.new("UIPadding", box).PaddingLeft = UDim.new(0, 10)
        UI.edge(box, 0.55)
        for i, sp in ipairs(specs) do
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(0, 62, 1, 0)
            b.Text = sp[1]
            b.LayoutOrder = i
            b.Parent = row
            styleBtn(b, sp[3])
            b.TextSize = 10
            b.MouseButton1Click:Connect(function() sp[2](box) end)
        end
        return box
    end

    local function toggleRow(parent, text, onChange)
        local row = Instance.new("TextButton")
        row.Size = UDim2.new(1, 0, 0, 34)
        row.BackgroundColor3 = COL_CARD
        row.Text = ""
        row.AutoButtonColor = false
        row.BorderSizePixel = 0
        row.LayoutOrder = #parent:GetChildren()
        row.Parent = parent
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, R_CTRL)
        UI.edge(row, 0.55)

        local lbl = Instance.new("TextLabel")
        lbl.BackgroundTransparency = 1
        lbl.Position = UDim2.fromOffset(12, 0)
        lbl.Size = UDim2.new(1, -66, 1, 0)
        lbl.Font = Enum.Font.GothamMedium
        lbl.TextSize = 11
        lbl.TextColor3 = COL_TEXT
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextTruncate = Enum.TextTruncate.AtEnd
        lbl.Text = text
        lbl.Parent = row

        local pill = Instance.new("Frame")
        pill.Size = UDim2.fromOffset(34, 18)
        pill.Position = UDim2.new(1, -46, 0.5, -9)
        pill.BackgroundColor3 = COL_PANEL
        pill.BorderSizePixel = 0
        pill.Parent = row
        Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)
        UI.edge(pill, 0.4)

        local knob = Instance.new("Frame")
        knob.Size = UDim2.fromOffset(12, 12)
        knob.Position = UDim2.new(0, 3, 0.5, -6)
        knob.BackgroundColor3 = COL_MUTED
        knob.BorderSizePixel = 0
        knob.Parent = pill
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

        local state = false
        local function apply(v)
            state = v
            pill.BackgroundColor3 = state and COL_ACCENT or COL_PANEL
            knob.BackgroundColor3 = state and WHITE or COL_MUTED
            TweenService:Create(knob, TweenInfo.new(0.14, Enum.EasingStyle.Quad), {
                Position = state and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
            }):Play()
            onChange(state)
        end
        row.MouseButton1Click:Connect(function() apply(not state) end)
        return row, apply
    end

    local function listFrame(parent, height)
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
        Instance.new("UICorner", list).CornerRadius = UDim.new(0, R_CTRL)
        UI.edge(list, 0.55)
        local lp = Instance.new("UIPadding", list)
        lp.PaddingTop = UDim.new(0, 5)
        lp.PaddingBottom = UDim.new(0, 5)
        lp.PaddingLeft = UDim.new(0, 5)
        lp.PaddingRight = UDim.new(0, 8)
        local lay = Instance.new("UIListLayout", list)
        lay.Padding = UDim.new(0, 4)
        lay.SortOrder = Enum.SortOrder.LayoutOrder
        return list
    end

    local function listRow(list, text, order)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, 0, 0, 26)
        b.BackgroundColor3 = COL_PANEL
        b.Text = "  " .. text
        b.Font = Enum.Font.GothamMedium
        b.TextSize = 11
        b.TextColor3 = COL_TEXT
        b.TextXAlignment = Enum.TextXAlignment.Left
        b.TextTruncate = Enum.TextTruncate.AtEnd
        b.AutoButtonColor = false
        b.BorderSizePixel = 0
        b.LayoutOrder = order
        b.Parent = list
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
        b.MouseEnter:Connect(function() b.BackgroundColor3 = COL_ACCENT end)
        b.MouseLeave:Connect(function() b.BackgroundColor3 = COL_PANEL end)
        return b
    end

    local refreshers = {}
    local function playerList(parent, onPick, height)
        local list = listFrame(parent, height)
        local empty = Instance.new("TextLabel")
        empty.BackgroundTransparency = 1
        empty.Size = UDim2.new(1, 0, 0, 24)
        empty.Font = Enum.Font.GothamMedium
        empty.TextSize = 11
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
                    local b = listRow(list, p.DisplayName .. "  @" .. p.Name, n)
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

    -- ---------- freeze (enforced every frame so the game can't undo it) ----------
    local freezeBtns
    local function paintFreeze()
        if freezeBtns then
            setPrimary(freezeBtns[1], S.frozen)
            setPrimary(freezeBtns[2], not S.frozen)
        end
    end

    local function setFrozen(on)
        S.frozen = on
        local h, r = hum(), root()
        if on then
            if h then
                S.fzWS, S.fzJP, S.fzJH = h.WalkSpeed, h.JumpPower, h.JumpHeight
            end
            if r then
                r.AssemblyLinearVelocity = Vector3.zero
                r.AssemblyAngularVelocity = Vector3.zero
            end
        else
            if r then r.Anchored = false end
            if h then
                h.WalkSpeed = (S.keep or S.hold) and S.speed or (S.fzWS or 16)
                if S.fzJP then h.JumpPower = S.fzJP end
                if S.fzJH then h.JumpHeight = S.fzJH end
            end
        end
        paintFreeze()
    end

    -- ---------- runtime loops ----------
    track(RunService.Heartbeat:Connect(function()
        local h, r = hum(), root()
        if S.frozen then
            if r and not r.Anchored then r.Anchored = true end
            if h then
                if h.WalkSpeed ~= 0 then h.WalkSpeed = 0 end
                if h.JumpPower ~= 0 then h.JumpPower = 0 end
                if h.JumpHeight ~= 0 then h.JumpHeight = 0 end
            end
        elseif (S.keep or S.hold) and h and h.WalkSpeed ~= S.speed then
            h.WalkSpeed = S.speed
        end

    end))

    track(UIS.JumpRequest:Connect(function()
        if S.jump and not S.frozen then
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

    track(LP.Idled:Connect(function()
        if S.afk then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
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
                            tag.Size = UDim2.fromOffset(150, 18)
                            tag.StudsOffset = Vector3.new(0, 2.6, 0)
                            tag.AlwaysOnTop = true
                            tag.Adornee = head
                            local t0 = Instance.new("TextLabel")
                            t0.Name = "T"
                            t0.Size = UDim2.fromScale(1, 1)
                            t0.BackgroundTransparency = 1
                            t0.Font = Enum.Font.GothamBold
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

    -- ---------- avatar changer ----------
    -- Logic follows Chris' Avatar Changer: hide the real body, show a visual copy that
    -- follows the real root every frame (no weld) and plays the TARGET's own animations.
    Overlay = {
        model = nil,
        hrp = nil,
        weld = nil,
        renderConn = nil,
        animTracks = {},
        curAnim = nil,
        hiddenParts = {},
        hiddenTransp = {},
        hiddenCollide = {},
        lastUserId = nil,
        lastUsername = nil,
    }

    -- used only when the target description has no custom animation (id 0)
    local ANIM_DEFAULT = {
        R6  = { idle = 180435571, walk = 180426354, run = 180426354,
                jump = 125750702, fall = 180436148, climb = 180436334,
                swim = 180426354, swimidle = 180426354 },
        R15 = { idle = 507766666, walk = 507777826, run = 507767714,
                jump = 507765000, fall = 507767968, climb = 507765644,
                swim = 507784897, swimidle = 507785072 },
    }

    local function getCharacter()
        return LP.Character
    end

    local function getHRP(character)
        return character and character:FindFirstChild("HumanoidRootPart")
    end

    local function getOverlayFolder()
        local camera = workspace.CurrentCamera
        if not camera then return nil end
        local folder = camera:FindFirstChild("_CatHubOverlay")
        if not folder then
            folder = Instance.new("Folder")
            folder.Name = "_CatHubOverlay"
            folder.Parent = camera
        end
        return folder
    end

    local function stopMirror()
        if Overlay.renderConn then
            pcall(function() RunService:UnbindFromRenderStep("CH_Mirror") end)
            Overlay.renderConn = nil
        end
    end

    local function restoreRealAvatar()
        for instance, oldTransparency in pairs(Overlay.hiddenParts) do
            if instance and instance.Parent then
                if instance:IsA("BasePart") then
                    instance.LocalTransparencyModifier = oldTransparency
                elseif instance:IsA("Decal") or instance:IsA("Texture") then
                    instance.Transparency = oldTransparency
                end
            end
        end
        Overlay.hiddenParts = {}
        for part, t in pairs(Overlay.hiddenTransp or {}) do
            if part and part.Parent then part.Transparency = t end
        end
        Overlay.hiddenTransp = {}
        -- sleep fix: give the real body its collision / touch back
        for part, old in pairs(Overlay.hiddenCollide) do
            if part and part.Parent then
                part.CanCollide = old.collide
                part.CanTouch = old.touch
            end
        end
        Overlay.hiddenCollide = {}
    end

    local function hideRealAvatar(character)
        if not character then return end
        Overlay.hiddenParts = {}
        Overlay.hiddenCollide = {}
        Overlay.hiddenTransp = {}
        for _, instance in ipairs(character:GetDescendants()) do
            if instance:IsA("BasePart") then
                Overlay.hiddenParts[instance] = instance.LocalTransparencyModifier
                Overlay.hiddenTransp[instance] = instance.Transparency
                instance.LocalTransparencyModifier = 1
                instance.Transparency = 1
                -- sleep fix: the real body must not touch beds / triggers while the fake avatar is shown
                Overlay.hiddenCollide[instance] = { collide = instance.CanCollide, touch = instance.CanTouch }
                instance.CanCollide = false
                instance.CanTouch = false
            elseif instance:IsA("Decal") or instance:IsA("Texture") then
                Overlay.hiddenParts[instance] = instance.Transparency
                instance.Transparency = 1
            end
        end
    end

    -- Read the target avatar's actual Animate script before removing scripts.
    -- This preserves the animation pack assigned to that avatar instead of
    -- substituting CAT HUB's generic walk/run IDs.
    local function readAvatarAnimationIds(model)
        local result = {}
        local animate = model:FindFirstChild("Animate")
        if not animate then return result end

        local aliases = {
            idle = "idle", walk = "walk", run = "run", jump = "jump",
            fall = "fall", climb = "climb", swim = "swim", swimidle = "swimidle",
        }

        for _, node in ipairs(animate:GetDescendants()) do
            if node:IsA("Animation") and type(node.AnimationId) == "string" and node.AnimationId ~= "" then
                local current = node
                while current and current ~= animate do
                    local key = string.lower(current.Name):gsub("[%s_%-]", "")
                    if aliases[key] and not result[aliases[key]] then
                        result[aliases[key]] = node.AnimationId
                        break
                    end
                    current = current.Parent
                end
            end
        end
        return result
    end

    -- destroys every script (incl. the default Animate), makes the copy non-solid and massless
    local function prepareModel(model)
        local rig = "R15"
        local h0 = model:FindFirstChildOfClass("Humanoid")
        if h0 and h0.RigType == Enum.HumanoidRigType.R6 then rig = "R6" end

        local animate = model:FindFirstChild("Animate")
        if animate then pcall(function() animate:Destroy() end) end

        for _, i in ipairs(model:GetDescendants()) do
            if i:IsA("Script") or i:IsA("LocalScript") or i:IsA("ModuleScript") then
                pcall(function() i:Destroy() end)
            elseif i:IsA("BasePart") then
                i.CanCollide = false
                i.CanTouch = false
                i.CanQuery = false
                i.Massless = true
            end
        end

        if h0 then
            h0.PlatformStand = false
            h0.AutoRotate = false
            h0.Sit = false
            h0.WalkSpeed = 0
            h0.JumpPower = 0
            h0.JumpHeight = 0
            h0.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
            h0.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
        end
        return rig
    end

    -- Animator on the target humanoid + the target's own idle/walk/run/jump/fall/climb
    local function loadTargetAnimations(model, rig, desc, avatarAnimationIds)
        Overlay.animTracks = {}
        Overlay.curAnim = nil
        local h0 = model:FindFirstChildOfClass("Humanoid")
        if not h0 then return end
        local animator = h0:FindFirstChildOfClass("Animator")
        if not animator then
            animator = Instance.new("Animator")
            animator.Parent = h0
        end
        local ids = {}
        if desc then
            ids = {
                idle = desc.IdleAnimation, walk = desc.WalkAnimation, run = desc.RunAnimation,
                jump = desc.JumpAnimation, fall = desc.FallAnimation, climb = desc.ClimbAnimation,
                swim = desc.SwimAnimation, swimidle = desc.SwimIdleAnimation,
            }
        end
        avatarAnimationIds = avatarAnimationIds or {}
        for name, fallbackId in pairs(ANIM_DEFAULT[rig]) do
            -- HumanoidDescription is the authoritative source for the target
            -- user's equipped animation pack (e.g. Ninja). The model's Animate
            -- script may contain Roblox defaults, so only use it as a fallback.
            local id = ids[name]
            if type(id) == "number" and id <= 0 then id = nil end
            if (id == nil or id == "") then id = avatarAnimationIds[name] end
            if (id == nil or id == "") then id = fallbackId end
            local animationId
            if type(id) == "number" then
                if id == 0 then id = fallbackId end
                animationId = "rbxassetid://" .. tostring(math.floor(id))
            elseif type(id) == "string" then
                if id:match("^rbxassetid://") then
                    animationId = id
                else
                    local digits = id:match("(%d+)")
                    animationId = digits and ("rbxassetid://" .. digits) or ("rbxassetid://" .. tostring(fallbackId))
                end
            else
                animationId = "rbxassetid://" .. tostring(fallbackId)
            end
            local anim = Instance.new("Animation")
            anim.AnimationId = animationId
            local okLoad, track = pcall(function() return animator:LoadAnimation(anim) end)
            if okLoad and track then
                track.Looped = (name ~= "jump")
                if name == "idle" then
                    track.Priority = Enum.AnimationPriority.Idle
                elseif name == "jump" or name == "fall" then
                    track.Priority = Enum.AnimationPriority.Action
                else
                    track.Priority = Enum.AnimationPriority.Movement
                end
                Overlay.animTracks[name] = track
            end
        end
    end

    local function startMirror()
        stopMirror()
        Overlay.renderConn = true
        RunService:BindToRenderStep("CH_Mirror", Enum.RenderPriority.Last.Value, function()
            local visual = Overlay.model
            local visualHRP = Overlay.hrp
            if not visual or not visualHRP
                or not visual.Parent or not visualHRP.Parent then return end

            local realCharacter = getCharacter()
            local realHRP = getHRP(realCharacter)
            if not realHRP then return end

            -- Keep the visual root kinematic so client physics cannot make it
            -- wobble while it is being aligned to the real character.
            if not visualHRP.Anchored then
                visualHRP.Anchored = true
            end

            -- Follow the real root without repeatedly fighting physics velocity.
            visual:PivotTo(realHRP.CFrame)

            local realHumanoid = realCharacter:FindFirstChildOfClass("Humanoid")
            if not realHumanoid then return end

            -- Preserve the player's actual WalkSpeed by default.
            -- Only apply the hub speed when the user explicitly enables Keep Speed.
            if not S.frozen and (S.keep or S.hold) then
                if realHumanoid.WalkSpeed ~= S.speed then
                    realHumanoid.WalkSpeed = S.speed
                end
            end

            -- the humanoid resets CanCollide on its body parts, keep them off (sleep fix)
            for part, _ in pairs(Overlay.hiddenCollide) do
                if part.Parent then
                    if part.CanCollide then part.CanCollide = false end
                    if part.CanTouch then part.CanTouch = false end
                end
            end

            -- keep the copy's own parts non-solid
            for _, p in ipairs(visual:GetDescendants()) do
                if p:IsA("BasePart") then
                    if p.CanCollide then p.CanCollide = false end
                    if p.CanTouch then p.CanTouch = false end
                    if not p.Massless then p.Massless = true end
                end
            end

            -- local player's state -> target's animation
            local velocity = realHRP.AssemblyLinearVelocity
            local planar = Vector3.new(velocity.X, 0, velocity.Z).Magnitude
            local state = realHumanoid:GetState()
            local want
            if state == Enum.HumanoidStateType.Swimming then
                want = (planar > 1) and "swim" or "swimidle"
            elseif state == Enum.HumanoidStateType.Climbing then
                want = "climb"
            elseif state == Enum.HumanoidStateType.Jumping then
                want = "jump"
            elseif state == Enum.HumanoidStateType.Freefall then
                want = "fall"
            elseif planar > math.max(1, realHumanoid.WalkSpeed * 1.1) then
                -- Use the target avatar's run animation when actual movement
                -- exceeds its normal walking pace.
                want = "run"
            elseif planar > 0.75 or realHumanoid.MoveDirection.Magnitude > 0.1 then
                want = "walk"
            else
                want = "idle"
            end
            if not Overlay.animTracks[want] then
                if want == "run" and Overlay.animTracks.walk then
                    want = "walk"
                elseif want == "fall" and Overlay.animTracks.jump then
                    want = "jump"
                elseif want ~= "idle" and Overlay.animTracks.idle then
                    want = "idle"
                end
            end
            -- walk + run play together and are blended by speed, like the default Animate script
            local walkT, runT = Overlay.animTracks.walk, Overlay.animTracks.run
            local blend = (want == "walk" or want == "run") and walkT and runT and walkT ~= runT
                and walkT.Animation and runT.Animation
                and walkT.Animation.AnimationId ~= runT.Animation.AnimationId
            if blend then
                if Overlay.curAnim ~= "move" then
                    local old = Overlay.animTracks[Overlay.curAnim]
                    if old then old:Stop(0.2) end
                    walkT:Play(0.2, 1)
                    runT:Play(0.2, 0.001)
                    Overlay.curAnim = "move"
                end
                local ratio = planar / 16
                local w = math.clamp((ratio - 0.33) / 0.33, 0, 1)
                walkT:AdjustWeight(math.max(1 - w, 0.001))
                runT:AdjustWeight(math.max(w, 0.001))
                local sp = math.clamp(ratio, 0.1, 4)
                walkT:AdjustSpeed(sp)
                runT:AdjustSpeed(sp)
            else
                if Overlay.curAnim == "move" then
                    if walkT then walkT:Stop(0.2) end
                    if runT then runT:Stop(0.2) end
                    Overlay.curAnim = nil
                end
                if Overlay.curAnim ~= want then
                    local old = Overlay.animTracks[Overlay.curAnim]
                    if old then old:Stop(0.2) end
                    local new = Overlay.animTracks[want]
                    if new then
                        new:Play(0.2)
                        Overlay.curAnim = want
                    end
                end
                local track = Overlay.animTracks[want]
                if track and (want == "walk" or want == "run" or want == "swim") then
                    local referenceSpeed = (want == "run") and 24 or 16
                    local measuredSpeed = planar
                    if measuredSpeed < 0.1 then measuredSpeed = realHumanoid.WalkSpeed end
                    track:AdjustSpeed(math.clamp(measuredSpeed / referenceSpeed, 0.1, 4))
                end
            end

            -- keep the real body hidden (the camera script resets LocalTransparencyModifier every frame,
            -- and accessories can be added later), so hide again here
            for _, inst in ipairs(realCharacter:GetDescendants()) do
                if inst:IsA("BasePart") then
                    if Overlay.hiddenParts[inst] == nil then
                        Overlay.hiddenParts[inst] = inst.LocalTransparencyModifier
                        Overlay.hiddenTransp[inst] = inst.Transparency
                        Overlay.hiddenCollide[inst] = { collide = inst.CanCollide, touch = inst.CanTouch }
                    end
                    inst.LocalTransparencyModifier = 1
                    if inst.Transparency ~= 1 then inst.Transparency = 1 end
                elseif inst:IsA("Decal") or inst:IsA("Texture") then
                    if Overlay.hiddenParts[inst] == nil then Overlay.hiddenParts[inst] = inst.Transparency end
                    if inst.Transparency ~= 1 then inst.Transparency = 1 end
                end
            end
        end)
    end

    local function removeAvatar()
        stopMirror()
        for _, t in pairs(Overlay.animTracks) do
            pcall(function() t:Stop(0) end)
        end
        Overlay.animTracks = {}
        Overlay.curAnim = nil
        if Overlay.model then
            pcall(function() Overlay.model:Destroy() end)
        end
        Overlay.model = nil
        Overlay.hrp = nil
        Overlay.weld = nil
        restoreRealAvatar()
        Overlay.lastUserId = nil
        Overlay.lastUsername = nil
    end

    -- shared by changeAvatarTo (user avatar) and changeRig (R6 / R15 of your own avatar)
    local function installAvatar(targetModel, desc, okText)
        local realCharacter = getCharacter()
        local realHRP = getHRP(realCharacter)
        if not realHRP then
            targetModel:Destroy()
            return false, "Character not ready."
        end

        local avatarAnimationIds = readAvatarAnimationIds(targetModel)
        local rig = prepareModel(targetModel)
        targetModel.Name = "CH_Overlay"

        local folder = getOverlayFolder()
        if not folder then
            targetModel:Destroy()
            return false, "Camera not ready."
        end
        targetModel.Parent = folder

        local targetHRP = targetModel:FindFirstChild("HumanoidRootPart")
        if not targetHRP then
            targetModel:Destroy()
            return false, "Avatar has no HumanoidRootPart."
        end
        targetModel.PrimaryPart = targetHRP
        -- The visual rig is client-side only. Anchor its root to prevent
        -- physics jitter; Motor6D animation tracks can still animate its limbs.
        targetHRP.Anchored = true
        targetModel:PivotTo(realHRP.CFrame)

        targetHRP.CanCollide = false
        targetHRP.CanTouch = false
        targetHRP.CanQuery = false
        targetHRP.Massless = true

        Overlay.model = targetModel
        Overlay.hrp = targetHRP
        Overlay.weld = nil

        loadTargetAnimations(targetModel, rig, desc, avatarAnimationIds)
        startMirror()
        hideRealAvatar(realCharacter)
        return true, okText
    end

    -- ---------- real avatar change (applies the target look to YOUR character) ----------
    -- Target's clothes, accessories, body colors, face and (R15) animation pack are applied to the
    -- real character, so there is no copy, no overlay and no weld. Client-side only: other players
    -- keep seeing your normal avatar.
    local RealApply = { origDesc = nil, origAnim = {} }

    local ANIMATE_MAP = {
        { "idle", "Animation1", "IdleAnimation" },
        { "idle", "Animation2", "IdleAnimation" },
        { "walk", "WalkAnim", "WalkAnimation" },
        { "run", "RunAnim", "RunAnimation" },
        { "jump", "JumpAnim", "JumpAnimation" },
        { "fall", "FallAnim", "FallAnimation" },
        { "climb", "ClimbAnim", "ClimbAnimation" },
    }

    local function restartAnimate(character)
        local animate = character and character:FindFirstChild("Animate")
        local h = character and character:FindFirstChildOfClass("Humanoid")
        if not (animate and h) then return end
        local animator = h:FindFirstChildOfClass("Animator")
        animate.Disabled = true
        if animator then
            for _, t in ipairs(animator:GetPlayingAnimationTracks()) do
                pcall(function() t:Stop(0) end)
            end
        end
        task.wait()
        animate.Disabled = false
    end

    -- put the target's idle / walk / run / jump / fall / climb into the Animate script
    local function applyAnimationPack(character, desc)
        local animate = character and character:FindFirstChild("Animate")
        local h = character and character:FindFirstChildOfClass("Humanoid")
        if not (animate and h and desc) then return false end
        if h.RigType ~= Enum.HumanoidRigType.R15 then return false end -- R15 packs do not play on R6
        for _, m in ipairs(ANIMATE_MAP) do
            local folder = animate:FindFirstChild(m[1])
            local a = folder and folder:FindFirstChild(m[2])
            if a and a:IsA("Animation") then
                if RealApply.origAnim[a] == nil then RealApply.origAnim[a] = a.AnimationId end
                local id = desc[m[3]]
                if type(id) == "number" and id ~= 0 then
                    a.AnimationId = "rbxassetid://" .. tostring(math.floor(id))
                else
                    a.AnimationId = RealApply.origAnim[a]
                end
            end
        end
        restartAnimate(character)
        return true
    end

    local function applyRealDescription(desc)
        local h = hum()
        if not h then return false, "Character not ready." end
        local ok, err = pcall(function() h:ApplyDescriptionClientServer(desc) end)
        if ok then return true end
        ok, err = pcall(function() h:ApplyDescription(desc) end)
        if ok then return true end
        return false, tostring(err)
    end

    -- fallback when ApplyDescription is blocked: copy clothes / accessories / colors / face by hand
    local function copyAppearanceManual(character, model)
        local h = character:FindFirstChildOfClass("Humanoid")
        if not h then return false end
        for _, c in ipairs(character:GetChildren()) do
            if c:IsA("Accessory") or c:IsA("Shirt") or c:IsA("Pants") or c:IsA("ShirtGraphic")
                or c:IsA("BodyColors") or c:IsA("CharacterMesh") then
                pcall(function() c:Destroy() end)
            end
        end
        for _, c in ipairs(model:GetChildren()) do
            if c:IsA("Accessory") then
                pcall(function() h:AddAccessory(c:Clone()) end)
            elseif c:IsA("Shirt") or c:IsA("Pants") or c:IsA("ShirtGraphic")
                or c:IsA("BodyColors") or c:IsA("CharacterMesh") then
                c:Clone().Parent = character
            end
        end
        local mh, rh = model:FindFirstChild("Head"), character:FindFirstChild("Head")
        if mh and rh then
            local oldFace = rh:FindFirstChildOfClass("Decal")
            local newFace = mh:FindFirstChildOfClass("Decal")
            if oldFace then oldFace:Destroy() end
            if newFace then newFace:Clone().Parent = rh end
            for _, c in ipairs(mh:GetChildren()) do
                if c:IsA("SpecialMesh") then
                    local old = rh:FindFirstChildOfClass("SpecialMesh")
                    if old then old:Destroy() end
                    c:Clone().Parent = rh
                end
            end
        end
        return true
    end

    local function resetRealAvatar()
        local h = hum()
        local character = LP.Character
        if RealApply.origDesc and h then
            local desc = RealApply.origDesc
            local ok = pcall(function() h:ApplyDescriptionClientServer(desc) end)
            if not ok then pcall(function() h:ApplyDescription(desc) end) end
        end
        if character then
            for a, id in pairs(RealApply.origAnim) do
                if a and a.Parent then a.AnimationId = id end
            end
            restartAnimate(character)
        end
        RealApply.origDesc = nil
        RealApply.origAnim = {}
    end

    -- main avatar is hidden, the changed avatar is shown as a non-solid visual on your character
    -- (passes through it, no weld, no collision) and plays the target's own animations
    local function changeAvatarTo(userId, name)
        if S.busy then return false, "Please wait..." end
        if not userId then return false, "No user loaded." end
        if not (getCharacter() and getHRP(getCharacter())) then return false, "Character not ready." end

        S.busy = true
        removeAvatar()

        local ok, targetModel = pcall(function()
            return Players:CreateHumanoidModelFromUserIdAsync(userId)
        end)
        if not ok or not targetModel then
            S.busy = false
            return false, "Failed to load avatar."
        end

        local okDesc, desc = pcall(function()
            return Players:GetHumanoidDescriptionFromUserId(userId)
        end)
        if not okDesc then desc = nil end

        local ok2, msg = installAvatar(targetModel, desc, "Avatar changed: @" .. name)
        S.busy = false
        if ok2 then
            Overlay.lastUserId = userId
            Overlay.lastUsername = name
            S.last = { kind = "user", id = userId, name = name }
        end
        return ok2, msg
    end

    local function changeRig(rigType)
        local tag = (rigType == Enum.HumanoidRigType.R6) and "R6" or "R15"
        if S.busy then return false, "Please wait..." end
        local h = hum()
        -- Only skip rebuilding when the real character already uses this rig
        -- AND there is no visual avatar active.
        if h and h.RigType == rigType and not (Overlay and Overlay.model) then
            S.last = nil
            return true, "Your character is already " .. tag .. "."
        end
        S.busy = true
        removeAvatar()
        local desc
        local ok, model = pcall(function()
            desc = Players:GetHumanoidDescriptionFromUserId(LP.UserId)
            return Players:CreateHumanoidModelFromDescription(desc, rigType)
        end)
        if not ok or not model then
            S.busy = false
            return false, "Failed to build " .. tag .. " model."
        end
        local ok2, msg = installAvatar(model, desc, "Showing " .. tag .. " (visual only).")
        S.busy = false
        if ok2 then S.last = { kind = "rig", rig = rigType } end
        return ok2, msg
    end

    local function reapply()
        local l = S.last
        if not l then return end
        if l.kind == "user" then
            changeAvatarTo(l.id, l.name)
        else
            changeRig(l.rig)
        end
    end

    -- ================= PLAYER PAGE =================
    local pp = newPage("PlayerPage")

    local sMove = section(pp, "MOVEMENT")
    local currentHumanoid = hum()
    local initialWalkSpeed = currentHumanoid and currentHumanoid.WalkSpeed or 16
    S.speed = initialWalkSpeed
    inputRow(sMove, "SPEED", tostring(initialWalkSpeed), {
        {"SET", function(box)
            local v = tonumber(box.Text)
            if v then
                S.speed = math.clamp(v, 0, 500)
                S.hold = true
                local h = hum()
                if h and not S.frozen then h.WalkSpeed = S.speed end
            end
        end, true},
        {"RESET", function(box)
            S.speed = 16
            S.hold = false
            box.Text = "16"
            local h = hum()
            if h and not S.frozen then h.WalkSpeed = 16 end
        end},
    })
    toggleRow(sMove, "Keep speed (re-apply every frame)", function(v) S.keep = v end)
    toggleRow(sMove, "Infinite jump", function(v) S.jump = v end)
    toggleRow(sMove, "Noclip", function(v) S.noclip = v end)
    inputRow(sMove, "GRAVITY", tostring(math.floor(defGravity * 10) / 10), {
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
    local rigStatus = label(sChar, "R6 / R15 is visual only. Your real character is untouched.", 10, COL_SUBTEXT, 14)
    local freezeStatus = label(sChar, "Not frozen.", 10, COL_SUBTEXT, 14)
    local _, fb = btnRow(sChar, {
        {"FREEZE", function()
            setFrozen(true)
            freezeStatus.Text = "Frozen. You can't move or jump."
        end},
        {"UNFREEZE", function()
            setFrozen(false)
            freezeStatus.Text = "Not frozen."
        end, true},
        {"RESET", function()
            setFrozen(false)
            freezeStatus.Text = "Not frozen."
            local h = hum()
            if h then h.Health = 0 end
        end},
    })
    freezeBtns = fb
    btnRow(sChar, {
        {"R6", function()
            rigStatus.Text = "Building R6..."
            task.spawn(function()
                local _, msg = changeRig(Enum.HumanoidRigType.R6)
                rigStatus.Text = msg
            end)
        end},
        {"R15", function()
            rigStatus.Text = "Building R15..."
            task.spawn(function()
                local _, msg = changeRig(Enum.HumanoidRigType.R15)
                rigStatus.Text = msg
            end)
        end},
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

    -- ----- avatar changer -----
    local avFile = "cathub_avfav_" .. LP.UserId .. ".json"
    local avFavs = {}
    pcall(function()
        if isfile and readfile and isfile(avFile) then
            local d = HttpService:JSONDecode(readfile(avFile))
            if type(d) == "table" then avFavs = d end
        end
    end)
    local function saveAv()
        if writefile then
            pcall(function() writefile(avFile, HttpService:JSONEncode(avFavs)) end)
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

    local sLook = section(pp, "AVATAR CHANGER")
    inputRow(sLook, "Avatar name / username or user ID", "", {
        {"LOOKUP", function(box) lookup(box.Text) end, true},
    })

    local pv = Instance.new("Frame")
    pv.Size = UDim2.new(1, 0, 0, 128)
    pv.BackgroundColor3 = COL_CARD
    pv.BorderSizePixel = 0
    pv.LayoutOrder = #sLook:GetChildren()
    pv.Parent = sLook
    Instance.new("UICorner", pv).CornerRadius = UDim.new(0, R_CTRL)
    UI.edge(pv, 0.55)

    local img = Instance.new("ImageLabel")
    img.Size = UDim2.fromOffset(112, 112)
    img.Position = UDim2.fromOffset(8, 8)
    img.BackgroundColor3 = COL_PANEL
    img.BorderSizePixel = 0
    img.ScaleType = Enum.ScaleType.Fit
    img.Image = ""
    img.Parent = pv
    Instance.new("UICorner", img).CornerRadius = UDim.new(0, 6)

    local nameL = Instance.new("TextLabel")
    nameL.BackgroundTransparency = 1
    nameL.Position = UDim2.fromOffset(130, 12)
    nameL.Size = UDim2.new(1, -176, 0, 18)
    nameL.Font = Enum.Font.GothamBold
    nameL.TextSize = 13
    nameL.TextColor3 = COL_TEXT
    nameL.TextXAlignment = Enum.TextXAlignment.Left
    nameL.TextTruncate = Enum.TextTruncate.AtEnd
    nameL.Text = "No avatar loaded"
    nameL.Parent = pv

    local idL = Instance.new("TextLabel")
    idL.BackgroundTransparency = 1
    idL.Position = UDim2.fromOffset(130, 32)
    idL.Size = UDim2.new(1, -138, 0, 14)
    idL.Font = Enum.Font.GothamMedium
    idL.TextSize = 10
    idL.TextColor3 = COL_MUTED
    idL.TextXAlignment = Enum.TextXAlignment.Left
    idL.Text = ""
    idL.Parent = pv

    local statusL = Instance.new("TextLabel")
    statusL.BackgroundTransparency = 1
    statusL.Position = UDim2.fromOffset(130, 56)
    statusL.Size = UDim2.new(1, -138, 0, 60)
    statusL.Font = Enum.Font.GothamMedium
    statusL.TextSize = 11
    statusL.TextColor3 = COL_SUBTEXT
    statusL.TextXAlignment = Enum.TextXAlignment.Left
    statusL.TextYAlignment = Enum.TextYAlignment.Top
    statusL.TextWrapped = true
    statusL.Text = "Type a username or ID, then LOOKUP."
    statusL.Parent = pv

    local star = Instance.new("TextButton")
    star.Size = UDim2.fromOffset(30, 28)
    star.Position = UDim2.new(1, -38, 0, 8)
    star.BackgroundColor3 = COL_PANEL
    star.Text = "★"
    star.Font = Enum.Font.GothamBold
    star.TextSize = 15
    star.TextColor3 = COL_MUTED
    star.AutoButtonColor = false
    star.BorderSizePixel = 0
    star.Parent = pv
    Instance.new("UICorner", star).CornerRadius = UDim.new(0, R_CTRL)
    UI.edge(star, 0.5)

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
        idL.Text = "ID: " .. tostring(data.id)
        img.Image = string.format("rbxthumb://type=Avatar&id=%d&w=420&h=420", data.id)
        paintStar()
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
                id = math.floor(tonumber(q))
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
            statusL.Text = "Loaded. Press CHANGE to wear it."
        end)
    end

    btnRow(sLook, {
        {"CHANGE", function()
            if not current then
                statusL.Text = "Look up an avatar first."
                return
            end
            statusL.Text = "Loading avatar..."
            task.spawn(function()
                local _, msg = changeAvatarTo(current.id, current.name)
                statusL.Text = msg
            end)
        end, true},
        {"RESET TO MAIN", function()
            removeAvatar()
            task.spawn(resetRealAvatar)
            S.last = nil
            statusL.Text = "Back to your main avatar."
            rigStatus.Text = "R6 / R15 is visual only. Your real character is untouched."
        end},
    })

    local sFav = section(pp, "AVATAR FAVORITES")
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
            e.Font = Enum.Font.GothamMedium
            e.TextSize = 11
            e.TextColor3 = COL_MUTED
            e.TextXAlignment = Enum.TextXAlignment.Left
            e.Text = "Star an avatar to save it here."
            e.Parent = favHolder
            return
        end
        for i, f in ipairs(avFavs) do
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, 0, 0, 28)
            b.BackgroundColor3 = COL_CARD
            b.Text = "  " .. tostring(f.name)
            b.Font = Enum.Font.GothamMedium
            b.TextSize = 11
            b.TextColor3 = COL_TEXT
            b.TextXAlignment = Enum.TextXAlignment.Left
            b.TextTruncate = Enum.TextTruncate.AtEnd
            b.AutoButtonColor = false
            b.BorderSizePixel = 0
            b.LayoutOrder = i
            b.Parent = favHolder
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, R_CTRL)
            UI.edge(b, 0.55)
            b.MouseEnter:Connect(function() b.BackgroundColor3 = COL_ACCENT end)
            b.MouseLeave:Connect(function() b.BackgroundColor3 = COL_CARD end)
            b.MouseButton1Click:Connect(function()
                show({ id = f.id, name = f.name })
                statusL.Text = "Loaded from favorites."
            end)
        end
    end
    refreshFav()

    -- ----- teleport / spectate / esp -----
    local sTp = section(pp, "TELEPORT TO PLAYER")
    playerList(sTp, tpTo, 120)

    local sSpec = section(pp, "SPECTATE")
    specLabel = label(sSpec, "Not spectating.", 10, COL_SUBTEXT, 14)
    playerList(sSpec, spectate, 120)
    btnRow(sSpec, { {"STOP SPECTATING", stopSpectate} })

    local sEsp = section(pp, "ESP")
    toggleRow(sEsp, "ESP (highlight, name, distance)", function(v)
        S.esp = v
        S.dirty = true
    end)
    toggleRow(sEsp, "Team check (hide teammates)", function(v)
        S.team = v
        S.dirty = true
    end)

    -- ================= ANTI AFK (settings page, on by default) =================
    local afkTitle = Instance.new("TextLabel")
    afkTitle.BackgroundTransparency = 1
    afkTitle.Position = UDim2.fromOffset(0, 352)
    afkTitle.Size = UDim2.new(1, 0, 0, 14)
    afkTitle.Font = Enum.Font.GothamBold
    afkTitle.TextSize = 9
    afkTitle.TextColor3 = COL_MUTED
    afkTitle.TextXAlignment = Enum.TextXAlignment.Left
    afkTitle.Text = "ANTI AFK"
    afkTitle.Parent = settingsPage

    local afkRow = toggleRow(settingsPage, "Anti AFK (no idle kick)", function(v) S.afk = v end)
    afkRow.Position = UDim2.fromOffset(0, 372)
    afkRow.Size = UDim2.new(1, -6, 0, 34)
    -- All optional features start OFF and wait for the user to enable them.

    -- ---------- respawn + cleanup ----------
    track(LP.CharacterAdded:Connect(function(nc)
        S.frozen = false
        paintFreeze()
        freezeStatus.Text = "Not frozen."
        removeAvatar()
        RealApply.origDesc = nil
        RealApply.origAnim = {}
        task.wait(0.6)
        if S.last and nc.Parent then pcall(reapply) end
    end))

    gui.Destroying:Connect(function()
        S.esp = false
        S.keep = false
        S.hold = false
        S.jump = false
        S.noclip = false
        S.afk = false
        S.frozen = false
        pcall(espStep)
        pcall(removeAvatar)
        pcall(resetRealAvatar)
        pcall(function()
            local r = root()
            if r then r.Anchored = false end
        end)
        for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
        pcall(function()
            local h = hum()
            if h then workspace.CurrentCamera.CameraSubject = h end
        end)
    end)

    UI.playerPage = pp
end

if not PLAYER_TOOLS_DISABLED then
    UI.buildTools()
end

-- depth pass: soft shading on buttons and the window, runs once after everything is built
function UI.polish()
    local WHITE = Color3.fromRGB(255, 255, 255)
    for _, v in ipairs(gui:GetDescendants()) do
        if v:IsA("TextButton") and v.BackgroundTransparency < 1
            and v.BackgroundColor3 == COL_ACCENT and not v:FindFirstChildOfClass("UIGradient") then
            local g = Instance.new("UIGradient")
            g.Rotation = 90
            g.Color = ColorSequence.new(WHITE, Color3.fromRGB(185, 200, 238))
            g.Parent = v
        end
    end
    for _, f in ipairs({ main, sidebar }) do
        if not f:FindFirstChildOfClass("UIGradient") then
            local g = Instance.new("UIGradient")
            g.Rotation = 90
            g.Color = ColorSequence.new(WHITE, Color3.fromRGB(206, 214, 238))
            g.Parent = f
        end
    end
end

local allPages = {
    [homeBtn]       = homePage,
    [scriptBtn]     = scriptPage,
    [settingsBtn]   = settingsPage,
    [creditBtn]     = creditPage,
    [aboutBtn]      = aboutPage,
}
if not PLAYER_TOOLS_DISABLED then
    allPages[UI.playerBtn] = UI.playerPage
end

local allNavs = {homeBtn, scriptBtn}
if not PLAYER_TOOLS_DISABLED then
    table.insert(allNavs, UI.playerBtn)
end
table.insert(allNavs, settingsBtn)
table.insert(allNavs, creditBtn)
table.insert(allNavs, aboutBtn)

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
    -- hide every Scripts sub-view (bypass, universal, steal, hubs, suggest, search...)
    if scriptPage then
        for _, c in ipairs(scriptPage:GetChildren()) do
            if c:IsA("GuiObject") then c.Visible = false end
        end
        if page == scriptPage and gameListView then gameListView.Visible = true end
    end
    page.Visible = true
end

local UPDATE_SEEN_FILE = "cathub_update_seen_" .. localPlayer.UserId .. ".txt"
local function hasSeenUpdate()
    if isfile and readfile then
        local ok, exists = pcall(function() return isfile(UPDATE_SEEN_FILE) end)
        if ok and exists then
            local ok2, value = pcall(function() return readfile(UPDATE_SEEN_FILE) end)
            return ok2 and value == "seen"
        end
    end
    return localPlayer:GetAttribute("CatHubUpdateSeen") == true
end

local function markUpdateSeen()
    localPlayer:SetAttribute("CatHubUpdateSeen", true)
    if writefile then
        pcall(function() writefile(UPDATE_SEEN_FILE, "seen") end)
    end
end

if not hasSeenUpdate() then
    markUpdateSeen()
    local toast = Instance.new("Frame")
    toast.Name = "CatHubUpdateBadge"
    toast.AnchorPoint = Vector2.new(1, 0)
    toast.Position = UDim2.new(1, -12, 0, 12)
    toast.Size = UDim2.fromOffset(226, 66)
    toast.BackgroundColor3 = COL_CARD
    toast.BorderSizePixel = 0
    toast.ZIndex = 80
    toast.Parent = main
    Instance.new("UICorner", toast).CornerRadius = UDim.new(0, 9)
    local toastStroke = Instance.new("UIStroke", toast)
    toastStroke.Color = COL_ACCENT
    toastStroke.Thickness = 1.2
    toastStroke.Transparency = 0.15

    local newPill = Instance.new("TextLabel")
    newPill.Position = UDim2.fromOffset(10, 9)
    newPill.Size = UDim2.fromOffset(34, 16)
    newPill.BackgroundColor3 = COL_ACCENT
    newPill.BorderSizePixel = 0
    newPill.Text = "NEW"
    newPill.Font = Enum.Font.GothamBold
    newPill.TextSize = 8
    newPill.TextColor3 = Color3.new(1, 1, 1)
    newPill.ZIndex = 81
    newPill.Parent = toast
    Instance.new("UICorner", newPill).CornerRadius = UDim.new(0, 5)

    local toastTitle = Instance.new("TextLabel")
    toastTitle.BackgroundTransparency = 1
    toastTitle.Position = UDim2.fromOffset(52, 8)
    toastTitle.Size = UDim2.new(1, -82, 0, 18)
    toastTitle.Font = Enum.Font.GothamBold
    toastTitle.TextSize = 10
    toastTitle.TextXAlignment = Enum.TextXAlignment.Left
    toastTitle.TextColor3 = COL_TEXT
    toastTitle.Text = "CAT HUB UPDATED"
    toastTitle.ZIndex = 81
    toastTitle.Parent = toast

    local checkAbout = Instance.new("TextButton")
    checkAbout.Position = UDim2.fromOffset(10, 34)
    checkAbout.Size = UDim2.fromOffset(112, 23)
    checkAbout.BackgroundColor3 = COL_ACCENT
    checkAbout.BorderSizePixel = 0
    checkAbout.Text = "CHECK ABOUT"
    checkAbout.Font = Enum.Font.GothamBold
    checkAbout.TextSize = 8
    checkAbout.TextColor3 = Color3.new(1, 1, 1)
    checkAbout.ZIndex = 81
    checkAbout.Parent = toast
    Instance.new("UICorner", checkAbout).CornerRadius = UDim.new(0, 5)

    local dismiss = Instance.new("TextButton")
    dismiss.Position = UDim2.new(1, -28, 0, 5)
    dismiss.Size = UDim2.fromOffset(22, 20)
    dismiss.BackgroundTransparency = 1
    dismiss.Text = "x"
    dismiss.Font = Enum.Font.GothamBold
    dismiss.TextSize = 13
    dismiss.TextColor3 = COL_SUBTEXT
    dismiss.ZIndex = 82
    dismiss.Parent = toast

    checkAbout.MouseButton1Click:Connect(function()
        setActive(aboutBtn)
        showPage(aboutPage)
        toast:Destroy()
    end)
    dismiss.MouseButton1Click:Connect(function()
        toast:Destroy()
    end)
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
        if not b:GetAttribute("on") then
            b.BackgroundTransparency = 0.5
            b.TextColor3 = COL_TEXT
        end
    end)
    b.MouseLeave:Connect(function()
        if not b:GetAttribute("on") then
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

UI.polish()
print("[cat hub] v2.3 loaded.")
