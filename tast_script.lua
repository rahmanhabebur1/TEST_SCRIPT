-- ==========================================
-- MD GAMER SCRIPT (Part 1/4)
-- ==========================================
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

local autoCollectEnabled = false
local autoCollectChestEnabled = false
local islandESPEnabled = false
local fruitESPEnabled = true
local playerESPEnabled = true
local fpsBoostEnabled = false

local aimbotNearestEnabled = false
local ignoreMobsEnabled = false
local ignorePlayersEnabled = false
local killAuraEnabled = false

local fruitESPObjects = {}
local playerESPObjects = {}
local islandESPObjects = {}
local notifiedFruits = {}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MD_GAMER_SCRIPT_UI"
ScreenGui.ResetOnSpawn = false

if gethui then
    ScreenGui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = CoreGui
else
    ScreenGui.Parent = CoreGui or LocalPlayer:WaitForChild("PlayerGui")
end

local NotificationHolder = Instance.new("Frame")
NotificationHolder.Name = "NotificationHolder"
NotificationHolder.Size = UDim2.new(0, 180, 0, 200)
NotificationHolder.Position = UDim2.new(1, -190, 0, 10)
NotificationHolder.BackgroundTransparency = 1
NotificationHolder.Parent = ScreenGui

local UIListLayoutNotif = Instance.new("UIListLayout")
UIListLayoutNotif.Parent = NotificationHolder
UIListLayoutNotif.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayoutNotif.Padding = UDim.new(0, 6)

local function sendNotification(title, text)
    local notifFrame = Instance.new("Frame")
    notifFrame.Size = UDim2.new(1, 0, 0, 40)
    notifFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 26)
    notifFrame.Parent = NotificationHolder

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = notifFrame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 170, 255)
    stroke.Thickness = 1
    stroke.Parent = notifFrame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -10, 0, 16)
    titleLabel.Position = UDim2.new(0, 8, 0, 4)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(0, 170, 255)
    titleLabel.TextSize = 11
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = notifFrame

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -10, 0, 16)
    textLabel.Position = UDim2.new(0, 8, 0, 20)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    textLabel.TextSize = 11
    textLabel.Font = Enum.Font.Gotham
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = notifFrame

    task.spawn(function()
        task.wait(3.5)
        local fadeTween = TweenService:Create(notifFrame, TweenInfo.new(0.4), {BackgroundTransparency = 1})
        TweenService:Create(titleLabel, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
        TweenService:Create(textLabel, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.4), {Transparency = 1}):Play()
        fadeTween:Play()
        fadeTween.Completed:Wait()
        notifFrame:Destroy()
    end)
end
-- ==========================================
-- MD GAMER SCRIPT (Part 2/4)
-- ==========================================
local ToggleButton = Instance.new("ImageButton")
ToggleButton.Name = "OpenButton"
ToggleButton.Size = UDim2.new(0, 45, 0, 45)
ToggleButton.Position = UDim2.new(0.02, 0, 0.2, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(15, 15, 26)
ToggleButton.Active = true
ToggleButton.Draggable = true
ToggleButton.Parent = ScreenGui

local UICornerBtn = Instance.new("UICorner")
UICornerBtn.CornerRadius = UDim.new(1, 0)
UICornerBtn.Parent = ToggleButton

local BtnStroke = Instance.new("UIStroke")
BtnStroke.Color = Color3.fromRGB(0, 170, 255)
BtnStroke.Thickness = 2
BtnStroke.Parent = ToggleButton

local BtnIcon = Instance.new("TextLabel")
BtnIcon.Size = UDim2.new(1, 0, 1, 0)
BtnIcon.BackgroundTransparency = 1
BtnIcon.Text = "🎮"
BtnIcon.TextSize = 22
BtnIcon.Parent = ToggleButton

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 440, 0, 280)
MainFrame.Position = UDim2.new(0, 3, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 24)
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == Enum.KeyCode.U then
            MainFrame.Visible = not MainFrame.Visible
        end
    end
end)

local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0, 10)
UICornerMain.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(0, 170, 255)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(22, 22, 35)
TitleBar.Parent = MainFrame

local TitleBarCorner = Instance.new("UICorner")
TitleBarCorner.CornerRadius = UDim.new(0, 10)
TitleBarCorner.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -15, 1, 0)
TitleText.Position = UDim2.new(0, 12, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "MD GAMER <font color=\"#00ffff\">[SCRIPT HUB]</font>"
TitleText.RichText = true
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 14
TitleText.Font = Enum.Font.GothamBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 110, 1, -35)
Sidebar.Position = UDim2.new(0, 0, 0, 35)
Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
Sidebar.Parent = Sidebar or MainFrame

local UIListLayoutSidebar = Instance.new("UIListLayout")
UIListLayoutSidebar.Parent = Sidebar
UIListLayoutSidebar.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayoutSidebar.Padding = UDim.new(0, 5)

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.PaddingTop = UDim.new(0, 8)
SidebarPadding.PaddingLeft = UDim.new(0, 5)
SidebarPadding.Parent = Sidebar

local function createTabBtn(text)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(28, 28, 42)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.Parent = Sidebar

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    return btn
end

local TabMainBtn = createTabBtn("Main / ESP")
local TabPvpBtn = createTabBtn("PVP ☠️")
local TabIslandBtn = createTabBtn("ISLAND 🏝️")
local TabServerBtn = createTabBtn("SERVER 🌐")
local TabMovementBtn = createTabBtn("MOVEMENT 👨🏻‍💻")

local TabExitBtn = Instance.new("TextButton")
TabExitBtn.Size = UDim2.new(0, 100, 0, 32)
TabExitBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
TabExitBtn.Text = "EXIT SCRIPT ❌"
TabExitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TabExitBtn.Font = Enum.Font.GothamBold
TabExitBtn.TextSize = 10
TabExitBtn.Parent = Sidebar

local exitCorner = Instance.new("UICorner")
exitCorner.CornerRadius = UDim.new(0, 6)
exitCorner.Parent = TabExitBtn

TabMainBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
TabMainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

local MainContainer = Instance.new("ScrollingFrame")
MainContainer.Size = UDim2.new(1, -120, 1, -45)
MainContainer.Position = UDim2.new(0, 115, 0, 40)
MainContainer.BackgroundTransparency = 1
MainContainer.CanvasSize = UDim2.new(0, 0, 0, 260)
MainContainer.ScrollBarThickness = 3
MainContainer.Parent = MainFrame

local UIListLayoutMain = Instance.new("UIListLayout")
UIListLayoutMain.Parent = MainContainer
UIListLayoutMain.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayoutMain.Padding = UDim.new(0, 6)

local PvpContainer = Instance.new("ScrollingFrame")
PvpContainer.Size = UDim2.new(1, -120, 1, -45)
PvpContainer.Position = UDim2.new(0, 115, 0, 40)
PvpContainer.BackgroundTransparency = 1
PvpContainer.Visible = false
PvpContainer.CanvasSize = UDim2.new(0, 0, 0, 220)
PvpContainer.ScrollBarThickness = 3
PvpContainer.Parent = MainFrame

local UIListLayoutPvp = Instance.new("UIListLayout")
UIListLayoutPvp.Parent = PvpContainer
UIListLayoutPvp.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayoutPvp.Padding = UDim.new(0, 6)

local IslandContainer = Instance.new("ScrollingFrame")
IslandContainer.Size = UDim2.new(1, -120, 1, -45)
IslandContainer.Position = UDim2.new(0, 115, 0, 40)
IslandContainer.BackgroundTransparency = 1
IslandContainer.Visible = false
IslandContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
IslandContainer.ScrollBarThickness = 3
IslandContainer.Parent = MainFrame

local UIListLayoutIsland = Instance.new("UIListLayout")
UIListLayoutIsland.Parent = IslandContainer
UIListLayoutIsland.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayoutIsland.Padding = UDim.new(0, 6)

local ServerContainer = Instance.new("ScrollingFrame")
ServerContainer.Size = UDim2.new(1, -120, 1, -45)
ServerContainer.Position = UDim2.new(0, 115, 0, 40)
ServerContainer.BackgroundTransparency = 1
ServerContainer.Visible = false
ServerContainer.CanvasSize = UDim2.new(0, 0, 0, 160)
ServerContainer.ScrollBarThickness = 3
ServerContainer.Parent = MainFrame

local UIListLayoutServer = Instance.new("UIListLayout")
UIListLayoutServer.Parent = ServerContainer
UIListLayoutServer.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayoutServer.Padding = UDim.new(0, 6)

local MovementContainer = Instance.new("ScrollingFrame")
MovementContainer.Size = UDim2.new(1, -120, 1, -45)
MovementContainer.Position = UDim2.new(0, 115, 0, 40)
MovementContainer.BackgroundTransparency = 1
MovementContainer.Visible = false
MovementContainer.CanvasSize = UDim2.new(0, 0, 0, 160)
MovementContainer.ScrollBarThickness = 3
MovementContainer.Parent = MainFrame

local UIListLayoutMovement = Instance.new("UIListLayout")
UIListLayoutMovement.Parent = MovementContainer
UIListLayoutMovement.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayoutMovement.Padding = UDim.new(0, 6)

local function resetTabs()
    MainContainer.Visible = false
    PvpContainer.Visible = false
    IslandContainer.Visible = false
    ServerContainer.Visible = false
    MovementContainer.Visible = false
    TabMainBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 42)
    TabMainBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    TabPvpBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 42)
    TabPvpBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    TabIslandBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 42)
    TabIslandBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    TabServerBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 42)
    TabServerBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    TabMovementBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 42)
    TabMovementBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
end

TabMainBtn.MouseButton1Click:Connect(function() resetTabs(); MainContainer.Visible = true; TabMainBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255); TabMainBtn.TextColor3 = Color3.fromRGB(255, 255, 255) end)
TabPvpBtn.MouseButton1Click:Connect(function() resetTabs(); PvpContainer.Visible = true; TabPvpBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255); TabPvpBtn.TextColor3 = Color3.fromRGB(255, 255, 255) end)
TabIslandBtn.MouseButton1Click:Connect(function() resetTabs(); IslandContainer.Visible = true; TabIslandBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255); TabIslandBtn.TextColor3 = Color3.fromRGB(255, 255, 255) end)
TabServerBtn.MouseButton1Click:Connect(function() resetTabs(); ServerContainer.Visible = true; TabServerBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255); TabServerBtn.TextColor3 = Color3.fromRGB(255, 255, 255) end)
TabMovementBtn.MouseButton1Click:Connect(function() resetTabs(); MovementContainer.Visible = true; TabMovementBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255); TabMovementBtn.TextColor3 = Color3.fromRGB(255, 255, 255) end)
-- ==========================================
-- MD GAMER SCRIPT (Part 3/4)
-- ==========================================
local function createToggleRow(parentContainer, name, defaultState, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 36)
    frame.BackgroundColor3 = Color3.fromRGB(22, 22, 35)
    frame.Parent = parentContainer

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.65, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0.28, 0, 0.65, 0)
    toggleBtn.Position = UDim2.new(0.68, 0, 0.175, 0)
    toggleBtn.BackgroundColor3 = defaultState and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(40, 40, 55)
    toggleBtn.Text = defaultState and "ON" or "OFF"
    toggleBtn.TextColor3 = defaultState and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 10
    toggleBtn.Parent = frame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 5)
    btnCorner.Parent = toggleBtn

    local state = defaultState
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        toggleBtn.Text = state and "ON" or "OFF"
        toggleBtn.BackgroundColor3 = state and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(40, 40, 55)
        toggleBtn.TextColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
        callback(state)
    end)
end

local function isFruit(obj)
    if not (obj:IsA("Tool") or string.find(obj.Name, "Fruit")) then return false end
    return (obj:FindFirstChild("Handle") or obj:FindFirstChildOfClass("BasePart")) ~= nil
end

local function isChest(obj)
    if obj:IsA("Model") or obj:IsA("BasePart") then
        local name = string.lower(obj.Name)
        if name:find("chest") or name:find("bluechest") or name:find("goldenchest") or name:find("silverchest") then
            return (obj:FindFirstChild("RootPart") or obj:FindFirstChild("Handle") or obj:FindFirstChildOfClass("BasePart")) ~= nil
        end
    end
    return false
end

local FloatingHolder = Instance.new("ScreenGui")
FloatingHolder.Name = "MD_FloatingButtons"
FloatingHolder.ResetOnSpawn = false
FloatingHolder.Enabled = false

if gethui then
    FloatingHolder.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(FloatingHolder)
    FloatingHolder.Parent = CoreGui
else
    FloatingHolder.Parent = CoreGui or LocalPlayer:WaitForChild("PlayerGui")
end

local speedActive = false
local floatSpeedBtn, floatCollectBtn

local function instantCollectAction()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local found = false
    local fruitHandle = nil
    local fruitName = ""
    
    for _, obj in pairs(Workspace:GetChildren()) do
        if isFruit(obj) then
            local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildOfClass("BasePart")
            if handle then
                fruitHandle = handle
                fruitName = obj.Name
                found = true
                break
            end
        end
    end
    
    if found and fruitHandle then
        local originalPos = hrp.CFrame
        hrp.CFrame = fruitHandle.CFrame
        sendNotification("MOVEMENT", "Teleported to " .. fruitName .. "!")
        task.wait(3.0)
        if hrp and hrp.Parent then
            hrp.CFrame = originalPos
        end
    else
        sendNotification("MOVEMENT", "No fruit found!")
    end
end

local function toggleSpeedAction()
    speedActive = not speedActive
    if speedActive then
        if floatSpeedBtn then floatSpeedBtn.BackgroundColor3 = Color3.fromRGB(60, 255, 60) end
        sendNotification("MOVEMENT", "Smooth Speed: ON")
        task.spawn(function()
            while speedActive do
                task.wait(0.01)
                pcall(function()
                    local char = LocalPlayer.Character
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    local hum = char:FindFirstChild("Humanoid")
                    if hrp and hum and hum.MoveDirection.Magnitude > 0 then
                        hrp.CFrame = hrp.CFrame + (hum.MoveDirection * 1.8)
                    end
                end)
            end
        end)
    else
        if floatSpeedBtn then floatSpeedBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60) end
        sendNotification("MOVEMENT", "Smooth Speed: OFF")
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == Enum.KeyCode.Equals or input.KeyCode == Enum.KeyCode.KeypadPlus then
            instantCollectAction()
        elseif input.KeyCode == Enum.KeyCode.Minus or input.KeyCode == Enum.KeyCode.KeypadMinus then
            toggleSpeedAction()
        end
    end
end)

floatCollectBtn = Instance.new("TextButton")
floatCollectBtn.Name = "FloatCollect"
floatCollectBtn.Size = UDim2.new(0, 75, 0, 30)
floatCollectBtn.Position = UDim2.new(0.02, 0, 0.5, 0)
floatCollectBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
floatCollectBtn.BackgroundTransparency = 0.7
floatCollectBtn.Text = "collect"
floatCollectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
floatCollectBtn.Font = Enum.Font.GothamBold
floatCollectBtn.TextSize = 12
floatCollectBtn.Active = true
floatCollectBtn.Draggable = true
floatCollectBtn.Parent = FloatingHolder

local fcCorner = Instance.new("UICorner")
fcCorner.CornerRadius = UDim.new(0, 6)
fcCorner.Parent = floatCollectBtn
floatCollectBtn.MouseButton1Click:Connect(instantCollectAction)

floatSpeedBtn = Instance.new("TextButton")
floatSpeedBtn.Name = "FloatSpeed"
floatSpeedBtn.Size = UDim2.new(0, 75, 0, 30)
floatSpeedBtn.Position = UDim2.new(0.02, 0, 0.58, 0)
floatSpeedBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
floatSpeedBtn.BackgroundTransparency = 0.7
floatSpeedBtn.Text = "speed"
floatSpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
floatSpeedBtn.Font = Enum.Font.GothamBold
floatSpeedBtn.TextSize = 12
floatSpeedBtn.Active = true
floatSpeedBtn.Draggable = true
floatSpeedBtn.Parent = FloatingHolder

local fsCorner = Instance.new("UICorner")
fsCorner.CornerRadius = UDim.new(0, 6)
fsCorner.Parent = floatSpeedBtn
floatSpeedBtn.MouseButton1Click:Connect(toggleSpeedAction)

local tpFruitBtn = Instance.new("TextButton")
tpFruitBtn.Size = UDim2.new(1, -10, 0, 36)
tpFruitBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
tpFruitBtn.Text = "1. INSTANT FRUIT COLLECT ⚡"
tpFruitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
tpFruitBtn.Font = Enum.Font.GothamBold
tpFruitBtn.TextSize = 11
tpFruitBtn.Parent = MovementContainer

local tpFruitCorner = Instance.new("UICorner")
tpFruitCorner.CornerRadius = UDim.new(0, 6)
tpFruitCorner.Parent = tpFruitBtn
tpFruitBtn.MouseButton1Click:Connect(instantCollectAction)

createToggleRow(MovementContainer, "2. SMOOTH SPEED 🏃🏻‍♂️", false, function(enabled)
    if speedActive ~= enabled then toggleSpeedAction() end
end)

createToggleRow(MovementContainer, "Show Mobile Buttons 📱", false, function(enabled)
    FloatingHolder.Enabled = enabled
end)

local serverHopBtn = Instance.new("TextButton")
serverHopBtn.Size = UDim2.new(1, -10, 0, 34)
serverHopBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
serverHopBtn.Text = "🌐 Browser Top-Right Server Hop"
serverHopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
serverHopBtn.Font = Enum.Font.GothamBold
serverHopBtn.TextSize = 11
serverHopBtn.Parent = ServerContainer

local serverHopCorner = Instance.new("UICorner")
serverHopCorner.CornerRadius = UDim.new(0, 6)
serverHopCorner.Parent = serverHopBtn

serverHopBtn.MouseButton1Click:Connect(function()
    sendNotification("🌐 Server Hop", "Scanning server browser...")
    task.spawn(function()
        pcall(function()
            local playerGui = LocalPlayer:WaitForChild("PlayerGui")
            local serverBrowser = playerGui:FindFirstChild("ServerBrowser", true) or playerGui:FindFirstChild("ServerBrowserUI", true)
            if not serverBrowser and ReplicatedStorage:FindFirstChild("Remotes") then
                pcall(function() ReplicatedStorage.Remotes.CommF_:InvokeServer("ServerBrowser") end)
                task.wait(0.6)
                serverBrowser = playerGui:FindFirstChild("ServerBrowser", true) or playerGui:FindFirstChild("ServerBrowserUI", true)
            end
            if serverBrowser then
                local refreshBtn = serverBrowser:FindFirstChild("Refresh", true)
                if refreshBtn then
                    if firesignal then firesignal(refreshBtn.MouseButton1Click)
                    elseif getconnections then for _, conn in ipairs(getconnections(refreshBtn.MouseButton1Click)) do conn:Fire() end end
                    task.wait(0.8)
                end
                local bestJoinBtn = nil
                for _, obj in ipairs(serverBrowser:GetDescendants()) do
                    if obj:IsA("TextButton") or obj:IsA("ImageButton") then
                        if obj.Name == "Join" or string.lower(obj.Text):find("join") then
                            bestJoinBtn = obj
                            break
                        end
                    end
                end
                if bestJoinBtn then
                    if firesignal then firesignal(bestJoinBtn.MouseButton1Click)
                    elseif getconnections then for _, conn in ipairs(getconnections(bestJoinBtn.MouseButton1Click)) do conn:Fire() end end
                    return
                end
            end
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end)
    end)
end)

local rejoinBtn = Instance.new("TextButton")
rejoinBtn.Size = UDim2.new(1, -10, 0, 32)
rejoinBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 35)
rejoinBtn.Text = "🔄 Rejoin Current Server"
rejoinBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
rejoinBtn.Font = Enum.Font.GothamSemibold
rejoinBtn.TextSize = 11
rejoinBtn.Parent = ServerContainer

local rejoinCorner = Instance.new("UICorner")
rejoinCorner.CornerRadius = UDim.new(0, 6)
rejoinCorner.Parent = rejoinBtn

rejoinBtn.MouseButton1Click:Connect(function()
    pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end)
end)

local copyJobBtn = Instance.new("TextButton")
copyJobBtn.Size = UDim2.new(1, -10, 0, 32)
copyJobBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 35)
copyJobBtn.Text = "📋 Copy Server JobID"
copyJobBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
copyJobBtn.Font = Enum.Font.GothamSemibold
copyJobBtn.TextSize = 11
copyJobBtn.Parent = ServerContainer

local copyJobCorner = Instance.new("UICorner")
copyJobCorner.CornerRadius = UDim.new(0, 6)
copyJobCorner.Parent = copyJobBtn

copyJobBtn.MouseButton1Click:Connect(function()
    if setclipboard then setclipboard(game.JobId) sendNotification("📋 Copied!", "JobID copied.") end
end)

createToggleRow(PvpContainer, "Aimbot Nearest", false, function(enabled) aimbotNearestEnabled = enabled end)
createToggleRow(PvpContainer, "Ignore Mobs", false, function(enabled) ignoreMobsEnabled = enabled end)
createToggleRow(PvpContainer, "Ignore Players", false, function(enabled) ignorePlayersEnabled = enabled end)
createToggleRow(PvpContainer, "Kill Aura (No Anim)", false, function(enabled) killAuraEnabled = enabled end)

local netFolder = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:FindFirstChild("Net") or ReplicatedStorage
local function triggerAdvancedAttack(equippedTool, targetPart)
    pcall(function()
        equippedTool:Activate()
        local registerAttack = netFolder:FindFirstChild("RegisterAttack") or netFolder:FindFirstChild("CommF_")
        if registerAttack and registerAttack:IsA("RemoteEvent") then registerAttack:FireServer() end
        local validatorRemote = netFolder:FindFirstChild("Validator") or ReplicatedStorage:FindFirstChild("Validator", true)
        if validatorRemote and validatorRemote:IsA("RemoteEvent") then validatorRemote:FireServer(equippedTool.Name, targetPart) end
    end)
end

task.spawn(function()
    while task.wait(0.12) do
        if killAuraEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                local char = LocalPlayer.Character
                local hrp = char.HumanoidRootPart
                local equippedTool = char:FindFirstChildOfClass("Tool")
                if equippedTool then
                    local function checkAndAttack(targetHRP)
                        if (hrp.Position - targetHRP.Position).Magnitude <= 50 then triggerAdvancedAttack(equippedTool, targetHRP) end
                    end
                    if not ignorePlayersEnabled then
                        for _, player in ipairs(Players:GetPlayers()) do
                            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                                local pHum = player.Character:FindFirstChildOfClass("Humanoid")
                                if pHum and pHum.Health > 0 then checkAndAttack(player.Character.HumanoidRootPart) end
                            end
                        end
                    end
                    if not ignoreMobsEnabled then
                        local enemiesFolder = Workspace:FindFirstChild("Enemies")
                        if enemiesFolder then
                            for _, enemy in ipairs(enemiesFolder:GetChildren()) do
                                local eHRP = enemy:FindFirstChild("HumanoidRootPart")
                                local eHum = enemy:FindFirstChildOfClass("Humanoid")
                                if eHRP and eHum and eHum.Health > 0 then checkAndAttack(eHRP) end
                            end
                        end
                    end
                end
            end)
        end
    end
end)
-- ==========================================
-- MD GAMER SCRIPT (Part 4/4)
-- ==========================================
local function cleanLagEffects(v)
    if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") or v:IsA("Explosion") or v:IsA("Beam") or v:IsA("Trail") or v:IsA("Highlight") then
        v:Destroy()
    elseif v:IsA("BasePart") then
        v.CastShadow = false
    end
end

local function executeBalancedFPSBoost()
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.FogStart = 9e9
    for _, obj in ipairs(Lighting:GetChildren()) do
        if obj:IsA("PostEffect") or obj:IsA("Atmosphere") or obj:IsA("Clouds") or obj:IsA("BloomEffect") or obj:IsA("BlurEffect") or obj:IsA("DepthOfFieldEffect") or obj:IsA("SunRaysEffect") then obj:Destroy() end
    end
    for _, v in ipairs(Workspace:GetDescendants()) do pcall(function() cleanLagEffects(v) end) end
end

task.spawn(function()
    while true do
        task.wait(3)
        if fpsBoostEnabled then pcall(executeBalancedFPSBoost) end
    end
end)

ToggleButton.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

local function flyTo(targetCFrame)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    local duration = distance / 250
    local startTime = tick()
    local startCFrame = hrp.CFrame
    local connection
    connection = RunService.RenderStepped:Connect(function()
        local alpha = math.clamp((tick() - startTime) / duration, 0, 1)
        if hrp and hrp.Parent then
            hrp.Velocity = Vector3.zero
            hrp.CFrame = startCFrame:Lerp(targetCFrame, alpha)
        end
        if alpha >= 1 or not hrp or not hrp.Parent then connection:Disconnect() end
    end)
    task.wait(duration)
    if connection then connection:Disconnect() end
end

local seaIslands = {
    [2753915549] = { ["Starter Island"] = Vector3.new(1090, 16, 1400), ["Jungle"] = Vector3.new(-1240, 12, 380), ["Middle Town"] = Vector3.new(-650, 15, 1500), ["Frozen Village"] = Vector3.new(1150, 7, -1150), ["Marine Ford"] = Vector3.new(-4800, 20, 4200), ["Skypiea"] = Vector3.new(-4850, 718, -2620), ["Prison"] = Vector3.new(4850, 5, 740), ["Magma Village"] = Vector3.new(-5250, 8, 8500) },
    [4442272183] = { ["Cafe"] = Vector3.new(-380, 73, 300), ["Kingdom of Rose"] = Vector3.new(-450, 73, 1500), ["Green Zone"] = Vector3.new(-2400, 73, -3200), ["Snow Mountain"] = Vector3.new(1300, 400, -1300), ["Hot and Cold"] = Vector3.new(-6100, 15, -5000), ["Ice Castle"] = Vector3.new(5500, 28, -6200) },
    [7449423635] = { ["Port Town"] = Vector3.new(-2900, 15, 5300), ["Great Tree"] = Vector3.new(2250, 25, -7200), ["Castle on the Sea"] = Vector3.new(-5000, 315, -3000), ["Tiki Outpost"] = Vector3.new(-16200, 10, 500) }
}

local function loadIslandButtons()
    for _, child in ipairs(IslandContainer:GetChildren()) do
        if not child:IsA("UIListLayout") then child:Destroy() end
    end
    local refreshBtn = Instance.new("TextButton")
    refreshBtn.Size = UDim2.new(1, -10, 0, 34)
    refreshBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    refreshBtn.Text = "🔄 REFRESH ISLANDS MAP"
    refreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    refreshBtn.Font = Enum.Font.GothamBold
    refreshBtn.TextSize = 11
    refreshBtn.Parent = IslandContainer

    refreshBtn.MouseButton1Click:Connect(function() loadIslandButtons() sendNotification("🏝️ Map Refreshed", "Loaded!") end)

    local currentSeaIslands = seaIslands[game.PlaceId] or seaIslands[2753915549]
    for islandName, pos in pairs(currentSeaIslands) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 32)
        btn.BackgroundColor3 = Color3.fromRGB(22, 22, 35)
        btn.Text = "  📍 " .. islandName
        btn.TextColor3 = Color3.fromRGB(220, 220, 220)
        btn.Font = Enum.Font.GothamSemibold
        btn.TextSize = 11
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Parent = IslandContainer

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn

        btn.MouseButton1Click:Connect(function() flyTo(CFrame.new(pos)) end)
    end
end
loadIslandButtons()

local function removeIslandESP()
    for _, item in ipairs(islandESPObjects) do if item then item:Destroy() end end
    islandESPObjects = {}
end

local function updateIslandESP()
    removeIslandESP()
    if not islandESPEnabled then return end
    local currentSeaIslands = seaIslands[game.PlaceId] or seaIslands[2753915549]
    for islandName, pos in pairs(currentSeaIslands) do
        local part = Instance.new("Part")
        part.Size = Vector3.new(1, 1, 1)
        part.Position = pos
        part.Anchored = true
        part.Transparency = 1
        part.CanCollide = false
        part.Parent = Workspace

        local bbGui = Instance.new("BillboardGui")
        bbGui.Name = "IslandESP"
        bbGui.Adornee = part
        bbGui.Size = UDim2.new(0, 200, 0, 50)
        bbGui.StudsOffset = Vector3.new(0, 5, 0)
        bbGui.AlwaysOnTop = true
        bbGui.Parent = part

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(139, 69, 19)
        label.TextSize = 13
        label.Font = Enum.Font.GothamBold
        label.Parent = bbGui

        table.insert(islandESPObjects, part)
        table.insert(islandESPObjects, bbGui)

        task.spawn(function()
            while islandESPEnabled and part and part.Parent do
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local dist = math.floor((hrp.Position - pos).Magnitude)
                    label.Text = string.format("🏝️ %s\n[%dm]", islandName, dist)
                end
                task.wait(0.5)
            end
        end)
    end
end

local function removeFruitESP()
    for _, item in ipairs(fruitESPObjects) do if item then item:Destroy() end end
    fruitESPObjects = {}
end

local function updateFruitESP()
    removeFruitESP()
    if not fruitESPEnabled then return end
    for _, obj in ipairs(Workspace:GetChildren()) do
        if isFruit(obj) then
            local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildOfClass("BasePart")
            if handle then
                local hl = Instance.new("Highlight")
                hl.FillColor = Color3.fromRGB(0, 170, 255)
                hl.Parent = obj
                table.insert(fruitESPObjects, hl)
            end
        end
    end
end

local function removePlayerESP()
    for _, item in ipairs(playerESPObjects) do if item then item:Destroy() end end
    playerESPObjects = {}
end

local function updatePlayerESP()
    removePlayerESP()
    if not playerESPEnabled then return end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local bbGui = Instance.new("BillboardGui")
                bbGui.Adornee = head
                bbGui.Size = UDim2.new(0, 160, 0, 45)
                bbGui.StudsOffset = Vector3.new(0, 2.5, 0)
                bbGui.AlwaysOnTop = true
                bbGui.Parent = head
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.TextColor3 = Color3.fromRGB(255, 80, 80)
                label.TextSize = 12
                label.Font = Enum.Font.GothamBold
                label.Parent = bbGui
                table.insert(playerESPObjects, bbGui)
            end
        end
    end
end

createToggleRow(MainContainer, "Fruit ESP", false, function(enabled) fruitESPEnabled = enabled updateFruitESP() end)
createToggleRow(MainContainer, "Player ESP", false, function(enabled) playerESPEnabled = enabled updatePlayerESP() end)
createToggleRow(MainContainer, "Auto Fly Collect", false, function(enabled) autoCollectEnabled = enabled end)
createToggleRow(MainContainer, "Auto Collect Chest", false, function(enabled) autoCollectChestEnabled = enabled end)
createToggleRow(MainContainer, "Island ESP", false, function(enabled) islandESPEnabled = enabled updateIslandESP() end)
createToggleRow(MainContainer, "FPS Boost", false, function(enabled) fpsBoostEnabled = enabled if enabled then pcall(executeBalancedFPSBoost) end end)

TabExitBtn.MouseButton1Click:Connect(function()
    autoCollectEnabled = false
    autoCollectChestEnabled = false
    islandESPEnabled = false
    fruitESPEnabled = false
    playerESPEnabled = false
    fpsBoostEnabled = false
    removeFruitESP()
    removePlayerESP()
    removeIslandESP()
    if ScreenGui then ScreenGui:Destroy() end
    if FloatingHolder then FloatingHolder:Destroy() end
end)

task.spawn(function()
    while task.wait(1) do
        if autoCollectEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            for _, obj in ipairs(Workspace:GetChildren()) do
                if isFruit(obj) then
                    local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildOfClass("BasePart")
                    if handle then flyTo(handle.CFrame) break end
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(1.5) do
        if autoCollectChestEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if autoCollectChestEnabled and isChest(obj) then
                        local chestPart = obj:FindFirstChild("RootPart") or obj:FindFirstChild("Handle") or obj:FindFirstChildOfClass("BasePart")
                        if chestPart then flyTo(chestPart.CFrame) task.wait(0.5) end
                    end
                end
            end)
        end
    end
end)

sendNotification("🎮 MD GAMER", "Loaded successfully!")
