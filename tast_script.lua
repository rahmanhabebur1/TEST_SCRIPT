-- ==========================================
-- MD GAMER SCRIPT (Part 1/4 - Safe Version)
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
local LocalPlayer = Players.LocalPlayer

local autoCollectEnabled = false
local autoCollectChestEnabled = false
local islandESPEnabled = false
local fruitESPEnabled = false
local playerESPEnabled = false
local fpsBoostEnabled = false

local aimbotNearestEnabled = false
local ignoreMobsEnabled = false
local ignorePlayersEnabled = false
local killAuraEnabled = false

local fruitESPObjects = {}
local playerESPObjects = {}
local islandESPObjects = {}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MD_GAMER_FIXED_UI"
ScreenGui.ResetOnSpawn = false

pcall(function()
    if gethui then
        ScreenGui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = CoreGui
    else
        ScreenGui.Parent = CoreGui or LocalPlayer:WaitForChild("PlayerGui")
    end
end)

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
    task.spawn(function()
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

        task.wait(3)
        if notifFrame then notifFrame:Destroy() end
    end)
end
-- ==========================================
-- MD GAMER SCRIPT (Part 2/4 - UI Elements)
-- ==========================================
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "OpenButton"
ToggleButton.Size = UDim2.new(0, 45, 0, 45)
ToggleButton.Position = UDim2.new(0.02, 0, 0.2, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(15, 15, 26)
ToggleButton.Text = "🎮"
ToggleButton.TextSize = 22
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

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 420, 0, 260)
MainFrame.Position = UDim2.new(0.2, 0, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 24)
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Safe Toggle System
local function toggleMainUI()
    MainFrame.Visible = not MainFrame.Visible
end

ToggleButton.MouseButton1Click:Connect(toggleMainUI)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.U then
        toggleMainUI()
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
TitleBar.Size = UDim2.new(1, 0, 0, 32)
TitleBar.BackgroundColor3 = Color3.fromRGB(22, 22, 35)
TitleBar.Parent = MainFrame

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -15, 1, 0)
TitleText.Position = UDim2.new(0, 12, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "MD GAMER [SCRIPT HUB]"
TitleText.TextColor3 = Color3.fromRGB(0, 255, 255)
TitleText.TextSize = 13
TitleText.Font = Enum.Font.GothamBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 105, 1, -32)
Sidebar.Position = UDim2.new(0, 0, 0, 32)
Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
Sidebar.Parent = MainFrame

local UIListLayoutSidebar = Instance.new("UIListLayout")
UIListLayoutSidebar.Parent = Sidebar
UIListLayoutSidebar.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayoutSidebar.Padding = UDim.new(0, 4)

local function createTabBtn(text)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 95, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(28, 28, 42)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 9
    btn.Parent = Sidebar
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = btn
    return btn
end

local TabMainBtn = createTabBtn("Main / ESP")
local TabPvpBtn = createTabBtn("PVP ☠️")
local TabIslandBtn = createTabBtn("ISLAND 🏝️")
local TabServerBtn = createTabBtn("SERVER 🌐")
local TabMovementBtn = createTabBtn("MOVEMENT 👨🏻‍💻")

local TabExitBtn = Instance.new("TextButton")
TabExitBtn.Size = UDim2.new(0, 95, 0, 30)
TabExitBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
TabExitBtn.Text = "EXIT SCRIPT ❌"
TabExitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TabExitBtn.Font = Enum.Font.GothamBold
TabExitBtn.TextSize = 9
TabExitBtn.Parent = Sidebar
local exitCorner = Instance.new("UICorner")
exitCorner.CornerRadius = UDim.new(0, 5)
exitCorner.Parent = TabExitBtn

local MainContainer = Instance.new("ScrollingFrame")
MainContainer.Size = UDim2.new(1, -115, 1, -40)
MainContainer.Position = UDim2.new(0, 110, 0, 35)
MainContainer.BackgroundTransparency = 1
MainContainer.CanvasSize = UDim2.new(0, 0, 0, 240)
MainContainer.ScrollBarThickness = 2
MainContainer.Parent = MainFrame

local PvpContainer = Instance.new("ScrollingFrame")
PvpContainer.Size = MainContainer.Size
PvpContainer.Position = MainContainer.Position
PvpContainer.BackgroundTransparency = 1
PvpContainer.Visible = false
PvpContainer.CanvasSize = UDim2.new(0, 0, 0, 200)
PvpContainer.Parent = MainFrame

local IslandContainer = Instance.new("ScrollingFrame")
IslandContainer.Size = MainContainer.Size
IslandContainer.Position = MainContainer.Position
IslandContainer.BackgroundTransparency = 1
IslandContainer.Visible = false
IslandContainer.Parent = MainFrame

local ServerContainer = Instance.new("ScrollingFrame")
ServerContainer.Size = MainContainer.Size
ServerContainer.Position = MainContainer.Position
ServerContainer.BackgroundTransparency = 1
ServerContainer.Visible = false
ServerContainer.Parent = MainFrame

local MovementContainer = Instance.new("ScrollingFrame")
MovementContainer.Size = MainContainer.Size
MovementContainer.Position = MainContainer.Position
MovementContainer.BackgroundTransparency = 1
MovementContainer.Visible = false
MovementContainer.Parent = MainFrame

for _, c in ipairs({MainContainer, PvpContainer, IslandContainer, ServerContainer, MovementContainer}) do
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 5)
    layout.Parent = c
end

local function resetTabs()
    MainContainer.Visible = false
    PvpContainer.Visible = false
    IslandContainer.Visible = false
    ServerContainer.Visible = false
    MovementContainer.Visible = false
end

TabMainBtn.MouseButton1Click:Connect(function() resetTabs(); MainContainer.Visible = true end)
TabPvpBtn.MouseButton1Click:Connect(function() resetTabs(); PvpContainer.Visible = true end)
TabIslandBtn.MouseButton1Click:Connect(function() resetTabs(); IslandContainer.Visible = true end)
TabServerBtn.MouseButton1Click:Connect(function() resetTabs(); ServerContainer.Visible = true end)
TabMovementBtn.MouseButton1Click:Connect(function() resetTabs(); MovementContainer.Visible = true end)
-- ==========================================
-- MD GAMER SCRIPT (Part 3/4 - Features)
-- ==========================================
local function createToggleRow(parentContainer, name, defaultState, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 32)
    frame.BackgroundColor3 = Color3.fromRGB(22, 22, 35)
    frame.Parent = parentContainer

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.65, 0, 1, 0)
    label.Position = UDim2.new(0, 8, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 10
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0.28, 0, 0.7, 0)
    toggleBtn.Position = UDim2.new(0.68, 0, 0.15, 0)
    toggleBtn.BackgroundColor3 = defaultState and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(40, 40, 55)
    toggleBtn.Text = defaultState and "ON" or "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 9
    toggleBtn.Parent = frame

    local state = defaultState
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        toggleBtn.Text = state and "ON" or "OFF"
        toggleBtn.BackgroundColor3 = state and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(40, 40, 55)
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
        if name:find("chest") then
            return (obj:FindFirstChild("RootPart") or obj:FindFirstChild("Handle") or obj:FindFirstChildOfClass("BasePart")) ~= nil
        end
    end
    return false
end

local function flyTo(targetCFrame)
    pcall(function()
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local hrp = char.HumanoidRootPart
        local distance = (hrp.Position - targetCFrame.Position).Magnitude
        local duration = math.clamp(distance / 250, 0.1, 5)
        local startTime = tick()
        local startCFrame = hrp.CFrame
        
        while tick() - startTime < duration do
            local alpha = (tick() - startTime) / duration
            if hrp and hrp.Parent then
                hrp.Velocity = Vector3.zero
                hrp.CFrame = startCFrame:Lerp(targetCFrame, alpha)
            end
            task.wait(0.02)
        end
    end)
end

local tpFruitBtn = Instance.new("TextButton")
tpFruitBtn.Size = UDim2.new(1, -10, 0, 32)
tpFruitBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
tpFruitBtn.Text = "⚡ INSTANT FRUIT COLLECT"
tpFruitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
tpFruitBtn.Font = Enum.Font.GothamBold
tpFruitBtn.TextSize = 10
tpFruitBtn.Parent = MovementContainer

tpFruitBtn.MouseButton1Click:Connect(function()
    for _, obj in pairs(Workspace:GetChildren()) do
        if isFruit(obj) then
            local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildOfClass("BasePart")
            if handle and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = handle.CFrame
                sendNotification("MOVEMENT", "Fruit Collected!")
                break
            end
        end
    end
end)
-- ==========================================
-- MD GAMER SCRIPT (Part 4/4 - Final Loops)
-- ==========================================
local seaIslands = {
    [2753915549] = { ["Starter Island"] = Vector3.new(1090, 16, 1400), ["Jungle"] = Vector3.new(-1240, 12, 380), ["Middle Town"] = Vector3.new(-650, 15, 1500) },
    [4442272183] = { ["Cafe"] = Vector3.new(-380, 73, 300), ["Kingdom of Rose"] = Vector3.new(-450, 73, 1500) },
    [7449423635] = { ["Port Town"] = Vector3.new(-2900, 15, 5300), ["Castle on Sea"] = Vector3.new(-5000, 315, -3000) }
}

local currentSeaIslands = seaIslands[game.PlaceId] or seaIslands[2753915549]

for islandName, pos in pairs(currentSeaIslands) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(22, 22, 35)
    btn.Text = " 📍 " .. islandName
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 10
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = IslandContainer
    
    btn.MouseButton1Click:Connect(function()
        flyTo(CFrame.new(pos))
    end)
end

local function removeIslandESP()
    for _, item in ipairs(islandESPObjects) do pcall(function() item:Destroy() end) end
    islandESPObjects = {}
end

local function updateIslandESP()
    removeIslandESP()
    if not islandESPEnabled then return end
    for islandName, pos in pairs(currentSeaIslands) do
        local part = Instance.new("Part")
        part.Size = Vector3.new(1, 1, 1)
        part.Position = pos
        part.Anchored = true
        part.Transparency = 1
        part.CanCollide = false
        part.Parent = Workspace

        local bbGui = Instance.new("BillboardGui")
        bbGui.Adornee = part
        bbGui.Size = UDim2.new(0, 180, 0, 40)
        bbGui.AlwaysOnTop = true
        bbGui.Parent = part

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(139, 69, 19)
        label.TextSize = 12
        label.Font = Enum.Font.GothamBold
        label.Text = "🏝️ " .. islandName
        label.Parent = bbGui

        table.insert(islandESPObjects, part)
        table.insert(islandESPObjects, bbGui)
    end
end

createToggleRow(MainContainer, "Fruit ESP", false, function(enabled) fruitESPEnabled = enabled end)
createToggleRow(MainContainer, "Player ESP", false, function(enabled) playerESPEnabled = enabled end)
createToggleRow(MainContainer, "Auto Fly Collect", false, function(enabled) autoCollectEnabled = enabled end)
createToggleRow(MainContainer, "Auto Collect Chest", false, function(enabled) autoCollectChestEnabled = enabled end)
createToggleRow(MainContainer, "Island ESP", false, function(enabled) islandESPEnabled = enabled updateIslandESP() end)

TabExitBtn.MouseButton1Click:Connect(function()
    autoCollectEnabled = false
    autoCollectChestEnabled = false
    islandESPEnabled = false
    fruitESPEnabled = false
    playerESPEnabled = false
    removeIslandESP()
    if ScreenGui then ScreenGui:Destroy() end
end)

-- Safe Background Loops
task.spawn(function()
    while task.wait(2) do
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
    while task.wait(3) do
        if autoCollectChestEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                for _, obj in ipairs(Workspace:GetChildren()) do
                    if autoCollectChestEnabled and isChest(obj) then
                        local chestPart = obj:FindFirstChild("RootPart") or obj:FindFirstChild("Handle") or obj:FindFirstChildOfClass("BasePart")
                        if chestPart then flyTo(chestPart.CFrame) task.wait(1) end
                    end
                end
            end)
        end
    end
end)

sendNotification("🎮 MD GAMER", "UI Loaded Smoothly!")
