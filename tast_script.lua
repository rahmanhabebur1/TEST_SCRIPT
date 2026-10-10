-- MD GAMER SCRIPT (Part 1 - UI & Variables)
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
local fruitESPEnabled = true
local playerESPEnabled = true
local fpsBoostEnabled = false

local autoFarmEnabled = false
local autoQuestEnabled = false
local fastAttackEnabled = false
local bringMobEnabled = false
local selectWeaponType = "Melee"

-- PVP Options
local aimbotNearestEnabled = false
local ignoreMobsEnabled = false
local ignorePlayersEnabled = false
local killAuraEnabled = false

local fruitESPObjects = {}
local playerESPObjects = {}
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
Sidebar.Parent = MainFrame

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
    btn.Size = UDim2.new(0, 100, 0, 30)
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
local TabFarmBtn = createTabBtn("AUTO FARM ⚔️")
local TabIslandBtn = createTabBtn("ISLAND 🏝️")
local TabBossBtn = createTabBtn("BOSS LIST 👹")
local TabServerBtn = createTabBtn("SERVER 🌐")

TabMainBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
TabMainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

local MainContainer = Instance.new("ScrollingFrame")
MainContainer.Size = UDim2.new(1, -120, 1, -45)
MainContainer.Position = UDim2.new(0, 115, 0, 40)
MainContainer.BackgroundTransparency = 1
MainContainer.CanvasSize = UDim2.new(0, 0, 0, 200)
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

local FarmContainer = Instance.new("ScrollingFrame")
FarmContainer.Size = UDim2.new(1, -120, 1, -45)
FarmContainer.Position = UDim2.new(0, 115, 0, 40)
FarmContainer.BackgroundTransparency = 1
FarmContainer.Visible = false
FarmContainer.CanvasSize = UDim2.new(0, 0, 0, 250)
FarmContainer.ScrollBarThickness = 3
FarmContainer.Parent = MainFrame

local UIListLayoutFarm = Instance.new("UIListLayout")
UIListLayoutFarm.Parent = FarmContainer
UIListLayoutFarm.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayoutFarm.Padding = UDim.new(0, 6)

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

local BossContainer = Instance.new("ScrollingFrame")
BossContainer.Size = UDim2.new(1, -120, 1, -45)
BossContainer.Position = UDim2.new(0, 115, 0, 40)
BossContainer.BackgroundTransparency = 1
BossContainer.Visible = false
BossContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
BossContainer.ScrollBarThickness = 3
BossContainer.Parent = MainFrame

local UIListLayoutBoss = Instance.new("UIListLayout")
UIListLayoutBoss.Parent = BossContainer
UIListLayoutBoss.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayoutBoss.Padding = UDim.new(0, 6)

local ServerContainer = Instance.new("ScrollingFrame")
ServerContainer.Size = UDim2.new(1, -120, 1, -45)
ServerContainer.Position = UDim2.new(0, 115, 0, 40)
ServerContainer.BackgroundTransparency = 1
ServerContainer.Visible = false
ServerContainer.CanvasSize = UDim2.new(0, 0, 0, 200)
ServerContainer.ScrollBarThickness = 3
ServerContainer.Parent = MainFrame

local UIListLayoutServer = Instance.new("UIListLayout")
UIListLayoutServer.Parent = ServerContainer
UIListLayoutServer.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayoutServer.Padding = UDim.new(0, 6)

local function resetTabs()
    MainContainer.Visible = false
    PvpContainer.Visible = false
    FarmContainer.Visible = false
    IslandContainer.Visible = false
    BossContainer.Visible = false
    ServerContainer.Visible = false
    TabMainBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 42)
    TabMainBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    TabPvpBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 42)
    TabPvpBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    TabFarmBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 42)
    TabFarmBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    TabIslandBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 42)
    TabIslandBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    TabBossBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 42)
    TabBossBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    TabServerBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 42)
    TabServerBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
end

TabMainBtn.MouseButton1Click:Connect(function()
    resetTabs()
    MainContainer.Visible = true
    TabMainBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    TabMainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

TabPvpBtn.MouseButton1Click:Connect(function()
    resetTabs()
    PvpContainer.Visible = true
    TabPvpBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    TabPvpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

TabFarmBtn.MouseButton1Click:Connect(function()
    resetTabs()
    FarmContainer.Visible = true
    TabFarmBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    TabFarmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

TabIslandBtn.MouseButton1Click:Connect(function()
    resetTabs()
    IslandContainer.Visible = true
    TabIslandBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    TabIslandBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

TabBossBtn.MouseButton1Click:Connect(function()
    resetTabs()
    BossContainer.Visible = true
    TabBossBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    TabBossBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

TabServerBtn.MouseButton1Click:Connect(function()
    resetTabs()
    ServerContainer.Visible = true
    TabServerBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    TabServerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

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
-- MD GAMER SCRIPT (Part 2 - Combat & Farm Engines)
createToggleRow(PvpContainer, "Aimbot Nearest", false, function(enabled)
    aimbotNearestEnabled = enabled
    if enabled then sendNotification("🎯 Aimbot", "Activated!") end
end)

createToggleRow(PvpContainer, "Ignore Mobs", false, function(enabled)
    ignoreMobsEnabled = enabled
end)

createToggleRow(PvpContainer, "Ignore Players", false, function(enabled)
    ignorePlayersEnabled = enabled
end)

createToggleRow(PvpContainer, "Kill Aura (No Anim)", false, function(enabled)
    killAuraEnabled = enabled
    if enabled then sendNotification("⚡ Kill Aura", "Active (50m Range)") end
end)

createToggleRow(FarmContainer, "Auto Level Farm", false, function(enabled)
    autoFarmEnabled = enabled
    if enabled then sendNotification("⚔️ Auto Farm", "Level Farm Activated!") end
end)

createToggleRow(FarmContainer, "Bring Mob (300m)", false, function(enabled)
    bringMobEnabled = enabled
    if enabled then sendNotification("📌 Bring Mob", "Activated!") end
end)

createToggleRow(FarmContainer, "Auto Accept Quest", false, function(enabled)
    autoQuestEnabled = enabled
end)

createToggleRow(FarmContainer, "Fast Attack (Hit)", false, function(enabled)
    fastAttackEnabled = enabled
    if enabled then sendNotification("⚡ Fast Attack", "Enabled!") end
end)

local weaponFrame = Instance.new("Frame")
weaponFrame.Size = UDim2.new(1, -10, 0, 36)
weaponFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 35)
weaponFrame.Parent = FarmContainer

local weaponCorner = Instance.new("UICorner")
weaponCorner.CornerRadius = UDim.new(0, 6)
weaponCorner.Parent = weaponFrame

local weaponLabel = Instance.new("TextLabel")
weaponLabel.Size = UDim2.new(0.5, 0, 1, 0)
weaponLabel.Position = UDim2.new(0, 10, 0, 0)
weaponLabel.BackgroundTransparency = 1
weaponLabel.Text = "Select Weapon"
weaponLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
weaponLabel.Font = Enum.Font.GothamSemibold
weaponLabel.TextSize = 11
weaponLabel.TextXAlignment = Enum.TextXAlignment.Left
weaponLabel.Parent = weaponFrame

local weaponBtn = Instance.new("TextButton")
weaponBtn.Size = UDim2.new(0.4, 0, 0.65, 0)
weaponBtn.Position = UDim2.new(0.56, 0, 0.175, 0)
weaponBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
weaponBtn.Text = "Melee"
weaponBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
weaponBtn.Font = Enum.Font.GothamBold
weaponBtn.TextSize = 10
weaponBtn.Parent = weaponFrame

local weaponBtnCorner = Instance.new("UICorner")
weaponBtnCorner.CornerRadius = UDim.new(0, 5)
weaponBtnCorner.Parent = weaponBtn

weaponBtn.MouseButton1Click:Connect(function()
    if selectWeaponType == "Melee" then
        selectWeaponType = "Sword"
        weaponBtn.Text = "Sword"
        weaponBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
    elseif selectWeaponType == "Sword" then
        selectWeaponType = "Blox Fruit"
        weaponBtn.Text = "Blox Fruit"
        weaponBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 255)
    else
        selectWeaponType = "Melee"
        weaponBtn.Text = "Melee"
        weaponBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    end
end)

local function equipSelectedWeapon()
    local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
    local char = LocalPlayer.Character
    if not backpack or not char then return end

    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            if selectWeaponType == "Melee" and (tool.ToolTip == "Melee" or string.find(tool.Name, "Combat") or string.find(tool.Name, "Step") or string.find(tool.Name, "Claw") or string.find(tool.Name, "Talon") or string.find(tool.Name, "Human") or string.find(tool.Name, "Superhuman") or string.find(tool.Name, "Godhuman")) then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then hum:EquipTool(tool) end
                break
            elseif selectWeaponType == "Sword" and tool.ToolTip == "Sword" then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then hum:EquipTool(tool) end
                break
            elseif selectWeaponType == "Blox Fruit" and tool.ToolTip == "Blox Fruit" then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then hum:EquipTool(tool) end
                break
            end
        end
    end
end

task.spawn(function()
    while task.wait(0.5) do
        if autoFarmEnabled then
            pcall(equipSelectedWeapon)
        end
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        if killAuraEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                local char = LocalPlayer.Character
                local hrp = char.HumanoidRootPart
                local equippedTool = char:FindFirstChildOfClass("Tool")

                if equippedTool then
                    local function checkAndAttack(targetHRP)
                        local dist = (hrp.Position - targetHRP.Position).Magnitude
                        if dist <= 50 then
                            equippedTool:Activate()
                        end
                    end

                    if not ignorePlayersEnabled then
                        for _, player in ipairs(Players:GetPlayers()) do
                            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                                local pHum = player.Character:FindFirstChildOfClass("Humanoid")
                                if pHum and pHum.Health > 0 then
                                    checkAndAttack(player.Character.HumanoidRootPart)
                                end
                            end
                        end
                    end

                    if not ignoreMobsEnabled then
                        local enemiesFolder = Workspace:FindFirstChild("Enemies")
                        if enemiesFolder then
                            for _, enemy in ipairs(enemiesFolder:GetChildren()) do
                                local eHRP = enemy:FindFirstChild("HumanoidRootPart")
                                local eHum = enemy:FindFirstChildOfClass("Humanoid")
                                if eHRP and eHum and eHum.Health > 0 then
                                    checkAndAttack(eHRP)
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if aimbotNearestEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        pcall(function()
            local hrp = LocalPlayer.Character.HumanoidRootPart
            local nearestTarget = nil
            local shortestDist = math.huge

            if not ignorePlayersEnabled then
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local pHum = player.Character:FindFirstChildOfClass("Humanoid")
                        if pHum and pHum.Health > 0 then
                            local dist = (hrp.Position - player.Character.HumanoidRootPart.Position).Magnitude
                            if dist < shortestDist then
                                shortestDist = dist
                                nearestTarget = player.Character.HumanoidRootPart
                            end
                        end
                    end
                end
            end

            if not ignoreMobsEnabled then
                local enemiesFolder = Workspace:FindFirstChild("Enemies")
                if enemiesFolder then
                    for _, enemy in ipairs(enemiesFolder:GetChildren()) do
                        local eHRP = enemy:FindFirstChild("HumanoidRootPart")
                        local eHum = enemy:FindFirstChildOfClass("Humanoid")
                        if eHRP and eHum and eHum.Health > 0 then
                            local dist = (hrp.Position - eHRP.Position).Magnitude
                            if dist < shortestDist then
                                shortestDist = dist
                                nearestTarget = eHRP
                            end
                        end
                    end
                end
            end

            if nearestTarget then
                local targetPos = Vector3.new(nearestTarget.Position.X, hrp.Position.Y, nearestTarget.Position.Z)
                hrp.CFrame = CFrame.new(hrp.Position, targetPos)
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(0.2) do
        if fastAttackEnabled then
            pcall(function()
                local vim = game:GetService("VirtualInputManager")
                vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(0.15) do
        if bringMobEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                local hrp = LocalPlayer.Character.HumanoidRootPart
                local enemiesFolder = Workspace:FindFirstChild("Enemies")
                if enemiesFolder then
                    for _, enemy in ipairs(enemiesFolder:GetChildren()) do
                        local eHRP = enemy:FindFirstChild("HumanoidRootPart")
                        local eHum = enemy:FindFirstChildOfClass("Humanoid")
                        if eHRP and eHum and eHum.Health > 0 then
                            local dist = (hrp.Position - eHRP.Position).Magnitude
                            if dist <= 300 then
                                eHRP.CFrame = hrp.CFrame * CFrame.new(0, 0, -3)
                                eHRP.Velocity = Vector3.new(0, 0, 0)
                                if enemy:FindFirstChild("Head") then
                                    enemy.Head.CanCollide = false
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)
-- MD GAMER SCRIPT (Part 3 - Teleports, ESP & Complete Execution)
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
        if obj:IsA("PostEffect") or obj:IsA("Atmosphere") or obj:IsA("Clouds") or obj:IsA("BloomEffect") or obj:IsA("BlurEffect") or obj:IsA("DepthOfFieldEffect") or obj:IsA("SunRaysEffect") then
            obj:Destroy()
        end
    end

    local cam = Workspace.CurrentCamera
    if cam then
        for _, obj in ipairs(cam:GetChildren()) do
            if obj:IsA("PostEffect") or obj:IsA("DepthOfFieldEffect") or obj:IsA("BlurEffect") then
                obj:Destroy()
            end
        end
    end

    for _, v in ipairs(Workspace:GetDescendants()) do
        pcall(function()
            cleanLagEffects(v)
        end)
    end
end

task.spawn(function()
    while true do
        task.wait(3)
        if fpsBoostEnabled then
            pcall(executeBalancedFPSBoost)
        end
    end
end)

Workspace.DescendantAdded:Connect(function(v)
    if fpsBoostEnabled then
        task.wait()
        pcall(function()
            cleanLagEffects(v)
        end)
    end
end)

local jobFrame = Instance.new("Frame")
jobFrame.Size = UDim2.new(1, -10, 0, 85)
jobFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 35)
jobFrame.Parent = ServerContainer

local jobCorner = Instance.new("UICorner")
jobCorner.CornerRadius = UDim.new(0, 6)
jobCorner.Parent = jobFrame

local jobTitle = Instance.new("TextLabel")
jobTitle.Size = UDim2.new(1, -10, 0, 22)
jobTitle.Position = UDim2.new(0, 8, 0, 4)
jobTitle.BackgroundTransparency = 1
jobTitle.Text = "Server Travel [JobID]"
jobTitle.TextColor3 = Color3.fromRGB(0, 255, 200)
jobTitle.Font = Enum.Font.GothamBold
jobTitle.TextSize = 11
jobTitle.TextXAlignment = Enum.TextXAlignment.Left
jobTitle.Parent = jobFrame

local jobInputBox = Instance.new("TextBox")
jobInputBox.Size = UDim2.new(1, -16, 0, 28)
jobInputBox.Position = UDim2.new(0, 8, 0, 28)
jobInputBox.BackgroundColor3 = Color3.fromRGB(15, 15, 24)
jobInputBox.PlaceholderText = "Paste JobID Here..."
jobInputBox.Text = ""
jobInputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
jobInputBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 150)
jobInputBox.Font = Enum.Font.Gotham
jobInputBox.TextSize = 11
jobInputBox.Parent = jobFrame

local jobInputCorner = Instance.new("UICorner")
jobInputCorner.CornerRadius = UDim.new(0, 4)
jobInputCorner.Parent = jobInputBox

local clearBtn = Instance.new("TextButton")
clearBtn.Size = UDim2.new(0.46, 0, 0, 22)
clearBtn.Position = UDim2.new(0, 8, 0, 60)
clearBtn.BackgroundColor3 = Color3.fromRGB(60, 40, 60)
clearBtn.Text = "Clear"
clearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
clearBtn.Font = Enum.Font.GothamBold
clearBtn.TextSize = 10
clearBtn.Parent = jobFrame

local clearCorner = Instance.new("UICorner")
clearCorner.CornerRadius = UDim.new(0, 4)
clearCorner.Parent = clearBtn

local confirmBtn = Instance.new("TextButton")
confirmBtn.Size = UDim2.new(0.46, 0, 0, 22)
confirmBtn.Position = UDim2.new(0.52, 0, 0, 60)
confirmBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
confirmBtn.Text = "Confirm (TP)"
confirmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
confirmBtn.Font = Enum.Font.GothamBold
confirmBtn.TextSize = 10
confirmBtn.Parent = jobFrame

local confirmCorner = Instance.new("UICorner")
confirmCorner.CornerRadius = UDim.new(0, 4)
confirmCorner.Parent = confirmBtn

clearBtn.MouseButton1Click:Connect(function()
    jobInputBox.Text = ""
    sendNotification("🌐 Server Travel", "JobID Cleared!")
end)

confirmBtn.MouseButton1Click:Connect(function()
    local targetJobID = jobInputBox.Text
    if targetJobID and targetJobID ~= "" then
        sendNotification("🌐 Connecting...", "Teleporting to Server JobID...")
        pcall(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, targetJobID, LocalPlayer)
        end)
    else
        sendNotification("⚠️ Error", "Please enter a valid JobID!")
    end
end)

local copyJobBtn = Instance.new("TextButton")
copyJobBtn.Size = UDim2.new(1, -10, 0, 32)
copyJobBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 35)
copyJobBtn.Text = "  📋 Copy Current Job ID"
copyJobBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
copyJobBtn.Font = Enum.Font.GothamSemibold
copyJobBtn.TextSize = 11
copyJobBtn.TextXAlignment = Enum.TextXAlignment.Left
copyJobBtn.Parent = ServerContainer

local copyJobCorner = Instance.new("UICorner")
copyJobCorner.CornerRadius = UDim.new(0, 6)
copyJobCorner.Parent = copyJobBtn

copyJobBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(game.JobId)
        sendNotification("📋 Copied!", "Current Server JobID copied to clipboard.")
    else
        sendNotification("⚠️ Error", "Clipboard not supported by executor!")
    end
end)

ServerContainer.CanvasSize = UDim2.new(0, 0, 0, 130)

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

local function flyTo(targetCFrame)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    local hrp = char.HumanoidRootPart
    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    local flySpeed = 250
    local duration = distance / flySpeed

    local startTime = tick()
    local startCFrame = hrp.CFrame
    local connection

    connection = RunService.RenderStepped:Connect(function()
        local elapsed = tick() - startTime
        local alpha = math.clamp(elapsed / duration, 0, 1)
        
        if hrp and hrp.Parent then
            hrp.Velocity = Vector3.zero
            hrp.CFrame = startCFrame:Lerp(targetCFrame, alpha)
        end

        if alpha >= 1 or not hrp or not hrp.Parent then
            connection:Disconnect()
        end
    end)

    task.wait(duration)
    if connection then connection:Disconnect() end
end

local seaIslands = {
    [2753915549] = {
        ["Starter Island"] = Vector3.new(1090, 16, 1400),
        ["Jungle"] = Vector3.new(-1240, 12, 380),
        ["Pirate Village"] = Vector3.new(-1120, 4, 3850),
        ["Desert"] = Vector3.new(1090, 6, 4360),
        ["Middle Town"] = Vector3.new(-650, 15, 1500),
        ["Frozen Village"] = Vector3.new(1150, 7, -1150),
        ["Marine Ford"] = Vector3.new(-4800, 20, 4200),
        ["Skypiea"] = Vector3.new(-4850, 725, -2620),
        ["Prison"] = Vector3.new(4850, 5, 740),
        ["Colosseum"] = Vector3.new(-1450, 7, -2750),
        ["Magma Village"] = Vector3.new(-5250, 8, 8500),
        ["Underwater City"] = Vector3.new(3860, 5, -1920),
        ["Fountain City"] = Vector3.new(5120, 4, 4100)
    },
    [4442272183] = {
        ["Cafe"] = Vector3.new(-380, 73, 300),
        ["Kingdom of Rose"] = Vector3.new(-450, 73, 1500),
        ["Ushapp's Island"] = Vector3.new(4800, 8, 2800),
        ["Green Zone"] = Vector3.new(-2400, 73, -3200),
        ["Graveyard"] = Vector3.new(-5400, 48, -750),
        ["Snow Mountain"] = Vector3.new(1300, 400, -1300),
        ["Hot and Cold"] = Vector3.new(-6100, 15, -5000),
        ["Cursed Ship"] = Vector3.new(900, 125, 3300),
        ["Ice Castle"] = Vector3.new(5500, 28, -6200),
        ["Forgotten Island"] = Vector3.new(-3050, 235, -10150)
    },
    [7449423635] = {
        ["Port Town"] = Vector3.new(-2900, 15, 5300),
        ["Great Tree"] = Vector3.new(2250, 25, -7200),
        ["Floating Turtle"] = Vector3.new(-13200, 330, -7600),
        ["Castle on the Sea"] = Vector3.new(-5000, 315, -3000),
        ["Haunted Castle"] = Vector3.new(-9500, 140, 5500),
        ["Chocolate Land"] = Vector3.new(100, 25, -12100),
        ["Ice Cream Land"] = Vector3.new(-900, 65, -11000),
        ["Tiki Outpost"] = Vector3.new(-16200, 10, 500)
    }
}

local currentSeaIslands = seaIslands[game.PlaceId] or seaIslands[2753915549]
local totalIslands = 0

for islandName, pos in pairs(currentSeaIslands) do
    totalIslands = totalIslands + 1
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

    btn.MouseButton1Click:Connect(function()
        sendNotification("🏝️ Flying...", islandName)
        flyTo(CFrame.new(pos))
    end)
end

IslandContainer.CanvasSize = UDim2.new(0, 0, 0, totalIslands * 38)

local seaBosses = {
    [2753915549] = {
        ["Gorilla King"] = Vector3.new(-1142, 6, 17),
        ["Bobby"] = Vector3.new(-1133, 15, 4363),
        ["Chief Warden"] = Vector3.new(4865, 6, 715),
        ["Swan"] = Vector3.new(5232, 4, 755),
        ["Chef"] = Vector3.new(3870, 7, -1965),
        ["Yeti"] = Vector3.new(1208, 107, -1505),
        ["Mob Leader"] = Vector3.new(-2855, 9, 5354),
        ["Vice Admiral"] = Vector3.new(-4825, 21, 4325),
        ["Warden"] = Vector3.new(4865, 6, 715),
        ["Saber Expert"] = Vector3.new(-1415, 10, 28),
        ["Fajita"] = Vector3.new(-2325, 16, -3785)
    },
    [4442272183] = {
        ["Diamond"] = Vector3.new(413, 116, 2525),
        ["Awakened Ice Admiral"] = Vector3.new(5815, 61, -6235),
        ["Tide Keeper"] = Vector3.new(-3725, 74, -11445),
        ["Smoke Admiral"] = Vector3.new(-5075, 23, -5365),
        ["Cursed Captain"] = Vector3.new(920, 125, 3290),
        ["Darkbeard"] = Vector3.new(-6200, 15, -5000),
        ["Order"] = Vector3.new(-6015, 16, -4930),
        ["Don Swan"] = Vector3.new(465, 85, 965)
    },
    [7449423635] = {
        ["Stone"] = Vector3.new(-10575, 330, -8760),
        ["Island Boy"] = Vector3.new(-10605, 330, -8460),
        ["Hydra Governor"] = Vector3.new(-5205, 10, -1025),
        ["Longsword"] = Vector3.new(-5815, 8, -1250),
        ["Beautiful Pirate"] = Vector3.new(5320, 20, 140),
        ["Cake Queen"] = Vector3.new(-705, 75, -11575),
        ["Cake Prince"] = Vector3.new(-2050, 15, -12150),
        ["Rip_Indra"] = Vector3.new(-5320, 400, -2600)
    }
}

local currentSeaBosses = seaBosses[game.PlaceId] or seaBosses[2753915549]
local totalBosses = 0

for bossName, pos in pairs(currentSeaBosses) do
    totalBosses = totalBosses + 1
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(22, 22, 35)
    btn.Text = "  👹 " .. bossName
    btn.TextColor3 = Color3.fromRGB(255, 120, 120)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 11
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = BossContainer

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        sendNotification("👹 Teleporting...", bossName)
        flyTo(CFrame.new(pos))
    end)
end

BossContainer.CanvasSize = UDim2.new(0, 0, 0, totalBosses * 38)

local function isFruit(obj)
    if not (obj:IsA("Tool") or string.find(obj.Name, "Fruit")) then return false end
    return (obj:FindFirstChild("Handle") or obj:FindFirstChildOfClass("BasePart")) ~= nil
end

local function checkFruitsForNotification(isNewSpawn)
    for _, obj in ipairs(Workspace:GetChildren()) do
        if isFruit(obj) and not notifiedFruits[obj] then
            notifiedFruits[obj] = true
            sendNotification(isNewSpawn and "🍎 Fruit Spawned!" or "🍇 Fruit Found:", obj.Name)
        end
    end
end

local function removeFruitESP()
    for _, item in ipairs(fruitESPObjects) do
        if item and item.Parent then item:Destroy() end
    end
    fruitESPObjects = {}
end

local function updateFruitESP()
    removeFruitESP()
    if not fruitESPEnabled then return end

    for _, obj in ipairs(Workspace:GetChildren()) do
        if isFruit(obj) then
            local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildOfClass("BasePart")
            if handle then
                local highlight = Instance.new("Highlight")
                highlight.FillColor = Color3.fromRGB(0, 170, 255)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                highlight.Parent = obj
                table.insert(fruitESPObjects, highlight)

                local bbGui = Instance.new("BillboardGui")
                bbGui.Name = "FruitESP"
                bbGui.Adornee = handle
                bbGui.Size = UDim2.new(0, 150, 0, 30)
                bbGui.StudsOffset = Vector3.new(0, 2, 0)
                bbGui.AlwaysOnTop = true
                bbGui.Parent = handle

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.TextColor3 = Color3.fromRGB(0, 255, 200)
                label.TextSize = 13
                label.Font = Enum.Font.GothamBold
                label.Text = "🍇 " .. obj.Name
                label.Parent = bbGui

                table.insert(fruitESPObjects, bbGui)
            end
        end
    end
end

local function removePlayerESP()
    for _, item in ipairs(playerESPObjects) do
        if item and item.Parent then item:Destroy() end
    end
    playerESPObjects = {}
end

local function updatePlayerESP()
    removePlayerESP()
    if not playerESPEnabled then return end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local char = player.Character
            local head = char.Head
            local humanoid = char:FindFirstChildOfClass("Humanoid")

            if humanoid and humanoid.Health > 0 then
                local pName = player.Name
                local levelText = "?"
                if player:FindFirstChild("Data") and player.Data:FindFirstChild("Level") then
                    levelText = tostring(player.Data.Level.Value)
                elseif player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Level") then
                    levelText = tostring(player.leaderstats.Level.Value)
                end

                local nameColor = Color3.fromRGB(255, 80, 80)
                if player.Team and (player.Team.Name == "Marines" or player.Team.Name == "Marine") then
                    nameColor = Color3.fromRGB(135, 206, 235)
                end

                local bbGui = Instance.new("BillboardGui")
                bbGui.Name = "PlayerESP"
                bbGui.Adornee = head
                bbGui.Size = UDim2.new(0, 160, 0, 45)
                bbGui.StudsOffset = Vector3.new(0, 2.5, 0)
                bbGui.AlwaysOnTop = true
                bbGui.Parent = head

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.TextColor3 = nameColor
                label.TextSize = 12
                label.Font = Enum.Font.GothamBold
                label.Parent = bbGui

                table.insert(playerESPObjects, bbGui)

                task.spawn(function()
                    while playerESPEnabled and char and char.Parent and humanoid and humanoid.Health > 0 do
                        label.Text = string.format("%s [Lvl %s]\nHP: %d/%d", pName, levelText, math.floor(humanoid.Health), math.floor(humanoid.MaxHealth))
                        task.wait(0.5)
                    end
                    if bbGui then bbGui:Destroy() end
                end)
            end
        end
    end
end

createToggleRow(MainContainer, "Fruit ESP", false, function(enabled)
    fruitESPEnabled = enabled
    updateFruitESP()
end)

createToggleRow(MainContainer, "Player ESP", false, function(enabled)
    playerESPEnabled = enabled
    updatePlayerESP()
end)

createToggleRow(MainContainer, "Auto Fly Collect", false, function(enabled)
    autoCollectEnabled = enabled
end)

createToggleRow(MainContainer, "FPS Boost", false, function(enabled)
    fpsBoostEnabled = enabled
    if enabled then
        pcall(executeBalancedFPSBoost)
        sendNotification("🚀 FPS Boost", "Balanced Mode Active (Textures Safe!)")
    end
end)

RunService.RenderStepped:Connect(function()
    if playerESPEnabled and math.random(1, 30) == 1 then
        updatePlayerESP()
    end
end)

task.spawn(function()
    while task.wait(1) do
        if autoCollectEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            for _, obj in ipairs(Workspace:GetChildren()) do
                if isFruit(obj) then
                    local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildOfClass("BasePart")
                    if handle then
                        flyTo(handle.CFrame)
                        break
                    end
                end
            end
        end
    end
end)

checkFruitsForNotification(false)

Workspace.ChildAdded:Connect(function()
    task.wait(0.5)
    if fruitESPEnabled then updateFruitESP() end
    checkFruitsForNotification(true)
end)

sendNotification("🎮 MD GAMER SCRIPT", "Successfully Loaded!")
