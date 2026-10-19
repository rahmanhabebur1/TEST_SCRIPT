-- Delta Executor Dragon Script (Part 1)

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local SoundService = game:GetService("SoundService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- আগের UI থাকলে রিমুভ করবে
if CoreGui:FindFirstChild("DragonScriptUI") then
    CoreGui.DragonScriptUI:Destroy()
end

----------------------------------------------------
-- SOUND & NOTIFICATION SYSTEM
----------------------------------------------------
local FruitSound = Instance.new("Sound")
FruitSound.Name = "FruitNotificationSound"
FruitSound.SoundId = "rbxassetid://4590662766"
FruitSound.Volume = 2
FruitSound.Parent = SoundService

local function sendNotification(title, text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 4,
            Icon = "rbxassetid://5669312251"
        })
    end)
end

sendNotification("🐉 Dragon Script", "Script Loaded Successfully!", 5)

-- 1. Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DragonScriptUI"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- 2. Floating Round Dragon Icon Button
local IconBtn = Instance.new("ImageButton")
IconBtn.Name = "IconBtn"
IconBtn.Parent = ScreenGui
IconBtn.Position = UDim2.new(0.88, 0, 0.78, 0)
IconBtn.Size = UDim2.new(0, 50, 0, 50)
IconBtn.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
IconBtn.BackgroundTransparency = 0.15
IconBtn.AutoButtonColor = false
IconBtn.ZIndex = 10

local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(1, 0)
IconCorner.Parent = IconBtn

local IconStroke = Instance.new("UIStroke")
IconStroke.Color = Color3.fromRGB(236, 72, 153)
IconStroke.Thickness = 2
IconStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
IconStroke.Parent = IconBtn

local IconEmoji = Instance.new("TextLabel")
IconEmoji.Name = "IconEmoji"
IconEmoji.Parent = IconBtn
IconEmoji.AnchorPoint = Vector2.new(0.5, 0.5)
IconEmoji.Position = UDim2.new(0.5, 0, 0.5, 0)
IconEmoji.Size = UDim2.new(1, 0, 1, 0)
IconEmoji.BackgroundTransparency = 1
IconEmoji.Text = "🐲"
IconEmoji.TextSize = 24
IconEmoji.ZIndex = 11

-- 3. UI Modal Window
local UIFrame = Instance.new("Frame")
UIFrame.Name = "UIFrame"
UIFrame.Parent = ScreenGui
UIFrame.AnchorPoint = Vector2.new(0.5, 0.5)
UIFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
UIFrame.Size = UDim2.new(0, 0, 0, 0)
UIFrame.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
UIFrame.BackgroundTransparency = 0.1
UIFrame.ClipsDescendants = true
UIFrame.Visible = false

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 14)
UICorner.Parent = UIFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(236, 72, 153)
UIStroke.Thickness = 1.5
UIStroke.Transparency = 0.3
UIStroke.Parent = UIFrame

-- 4. UI Header Bar
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Parent = UIFrame
Header.Size = UDim2.new(1, 0, 0, 42)
Header.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
Header.BackgroundTransparency = 0.3

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 14)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = Header
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Size = UDim2.new(0, 250, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "🐉 Dragon Script - Blox Fruits"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Close Button (❌)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Parent = Header
CloseBtn.Position = UDim2.new(1, -38, 0, 6)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "❌"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.SourceSansBold

-- 5. Left Side Tab Container
local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Parent = UIFrame
TabContainer.Position = UDim2.new(0, 10, 0, 50)
TabContainer.Size = UDim2.new(0, 120, 1, -60)
TabContainer.BackgroundColor3 = Color3.fromRGB(20, 30, 48)
TabContainer.BackgroundTransparency = 0.5

local TabCorner = Instance.new("UICorner")
TabCorner.CornerRadius = UDim.new(0, 8)
TabCorner.Parent = TabContainer

local TabLayout = Instance.new("UIListLayout")
TabLayout.Parent = TabContainer
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Padding = UDim.new(0, 6)

-- Tab 1: MAIN & ESP
local MainTabBtn = Instance.new("TextButton")
MainTabBtn.Name = "MainTabBtn"
MainTabBtn.Parent = TabContainer
MainTabBtn.Size = UDim2.new(1, 0, 0, 35)
MainTabBtn.BackgroundColor3 = Color3.fromRGB(236, 72, 153)
MainTabBtn.Text = "MAIN & ESP"
MainTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MainTabBtn.TextSize = 11
MainTabBtn.Font = Enum.Font.SourceSansBold

local MainTabCorner = Instance.new("UICorner")
MainTabCorner.CornerRadius = UDim.new(0, 6)
MainTabCorner.Parent = MainTabBtn

-- Tab 2: PLAYER
local PlayerTabBtn = Instance.new("TextButton")
PlayerTabBtn.Name = "PlayerTabBtn"
PlayerTabBtn.Parent = TabContainer
PlayerTabBtn.Size = UDim2.new(1, 0, 0, 35)
PlayerTabBtn.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
PlayerTabBtn.Text = "PLAYER"
PlayerTabBtn.TextColor3 = Color3.fromRGB(203, 213, 225)
PlayerTabBtn.TextSize = 11
PlayerTabBtn.Font = Enum.Font.SourceSansBold

local PlayerTabCorner = Instance.new("UICorner")
PlayerTabCorner.CornerRadius = UDim.new(0, 6)
PlayerTabCorner.Parent = PlayerTabBtn

-- 6. Content Frames Area
local MainContent = Instance.new("ScrollingFrame")
MainContent.Name = "MainContent"
MainContent.Parent = UIFrame
MainContent.Position = UDim2.new(0, 140, 0, 50)
MainContent.Size = UDim2.new(1, -150, 1, -60)
MainContent.BackgroundTransparency = 1
MainContent.CanvasSize = UDim2.new(0, 0, 0, 260)
MainContent.ScrollBarThickness = 3
MainContent.Visible = true

local MainLayout = Instance.new("UIListLayout")
MainLayout.Parent = MainContent
MainLayout.SortOrder = Enum.SortOrder.LayoutOrder
MainLayout.Padding = UDim.new(0, 8)

local PlayerContent = Instance.new("ScrollingFrame")
PlayerContent.Name = "PlayerContent"
PlayerContent.Parent = UIFrame
PlayerContent.Position = UDim2.new(0, 140, 0, 50)
PlayerContent.Size = UDim2.new(1, -150, 1, -60)
PlayerContent.BackgroundTransparency = 1
PlayerContent.CanvasSize = UDim2.new(0, 0, 0, 260)
PlayerContent.ScrollBarThickness = 3
PlayerContent.Visible = false

local PlayerLayout = Instance.new("UIListLayout")
PlayerLayout.Parent = PlayerContent
PlayerLayout.SortOrder = Enum.SortOrder.LayoutOrder
PlayerLayout.Padding = UDim.new(0, 8)

-- Tab Switch Logic
MainTabBtn.MouseButton1Click:Connect(function()
    MainContent.Visible = true
    PlayerContent.Visible = false
    MainTabBtn.BackgroundColor3 = Color3.fromRGB(236, 72, 153)
    MainTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    PlayerTabBtn.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
    PlayerTabBtn.TextColor3 = Color3.fromRGB(203, 213, 225)
end)

PlayerTabBtn.MouseButton1Click:Connect(function()
    MainContent.Visible = false
    PlayerContent.Visible = true
    PlayerTabBtn.BackgroundColor3 = Color3.fromRGB(236, 72, 153)
    PlayerTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MainTabBtn.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
    MainTabBtn.TextColor3 = Color3.fromRGB(203, 213, 225)
end)

----------------------------------------------------
-- STATES & TRIGGER GENERATOR
----------------------------------------------------
local ESP_Folder = Instance.new("Folder")
ESP_Folder.Name = "Dragon_ESP_Holder"
ESP_Folder.Parent = CoreGui

local States = {
    Player = false,
    Fruit = false,
    Box = false,
    Island = false,
    AimLock = false,
    NpcLock = false
}

local function createTrigger(parentFrame, name, stateKey)
    local Container = Instance.new("Frame")
    Container.Name = name .. "_Container"
    Container.Parent = parentFrame
    Container.Size = UDim2.new(1, 0, 0, 42)
    Container.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
    Container.BackgroundTransparency = 0.4

    local CCorner = Instance.new("UICorner")
    CCorner.CornerRadius = UDim.new(0, 8)
    CCorner.Parent = Container

    local Label = Instance.new("TextLabel")
    Label.Name = "Label"
    Label.Parent = Container
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.Size = UDim2.new(0.6, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(241, 245, 249)
    Label.TextSize = 13
    Label.Font = Enum.Font.SourceSansBold
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local TriggerBtn = Instance.new("TextButton")
    TriggerBtn.Name = "TriggerBtn"
    TriggerBtn.Parent = Container
    TriggerBtn.Position = UDim2.new(1, -75, 0.5, -13)
    TriggerBtn.Size = UDim2.new(0, 65, 0, 26)
    TriggerBtn.BackgroundColor3 = Color3.fromRGB(220, 38, 38)
    TriggerBtn.Text = "OFF"
    TriggerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TriggerBtn.TextSize = 12
    TriggerBtn.Font = Enum.Font.SourceSansBold

    local TCorner = Instance.new("UICorner")
    TCorner.CornerRadius = UDim.new(0, 6)
    TCorner.Parent = TriggerBtn

    TriggerBtn.MouseButton1Click:Connect(function()
        States[stateKey] = not States[stateKey]
        if States[stateKey] then
            TriggerBtn.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
            TriggerBtn.Text = "ON"
        else
            TriggerBtn.BackgroundColor3 = Color3.fromRGB(220, 38, 38)
            TriggerBtn.Text = "OFF"
        end
    end)
end

-- MAIN & ESP Triggers
createTrigger(MainContent, "1. PLAYER ESP", "Player")
createTrigger(MainContent, "2. FRUIT ESP", "Fruit")
createTrigger(MainContent, "3. BOX ESP", "Box")
createTrigger(MainContent, "4. ISLAND ESP", "Island")

-- PLAYER Triggers
createTrigger(PlayerContent, "1. AIM LOCK", "AimLock")
createTrigger(PlayerContent, "2. NPC LOCK", "NpcLock")
-- Delta Executor Dragon Script (Part 2)

----------------------------------------------------
-- LOCK & ESP FUNCTIONS
----------------------------------------------------
local function getClosestPlayer()
    local closest = nil
    local shortestDist = math.huge
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")

    if root then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") then
                if p.Character.Humanoid.Health > 0 then
                    local dist = (root.Position - p.Character.HumanoidRootPart.Position).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        closest = p.Character.HumanoidRootPart
                    end
                end
            end
        end
    end
    return closest
end

local function getClosestNPC()
    local closest = nil
    local shortestDist = math.huge
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")

    if root then
        local enemiesFolder = Workspace:FindFirstChild("Enemies") or Workspace:FindFirstChild("NPCs") or Workspace
        for _, v in pairs(enemiesFolder:GetChildren()) do
            if v:IsA("Model") and not Players:GetPlayerFromCharacter(v) and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") then
                if v.Humanoid.Health > 0 then
                    local dist = (root.Position - v.HumanoidRootPart.Position).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        closest = v.HumanoidRootPart
                    end
                end
            end
        end
    end
    return closest
end

local function clearESPGroup(tag)
    for _, item in pairs(ESP_Folder:GetChildren()) do
        if item.Name == tag then
            item:Destroy()
        end
    end
end

local function createBillboard(targetPart, text, color, tag)
    local bb = Instance.new("BillboardGui")
    bb.Name = tag
    bb.Parent = ESP_Folder
    bb.Adornee = targetPart
    bb.Size = UDim2.new(0, 200, 0, 50)
    bb.StudsOffset = Vector3.new(0, 3, 0)
    bb.AlwaysOnTop = true

    local lbl = Instance.new("TextLabel")
    lbl.Parent = bb
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = color
    lbl.TextSize = 13
    lbl.Font = Enum.Font.SourceSansBold
    lbl.TextStrokeTransparency = 0.2
    return bb
end

----------------------------------------------------
-- AUTOMATIC FRUIT DETECTOR & SOUND NOTIFIER
----------------------------------------------------
local detectedFruits = {}

local function checkAndNotifyFruit(obj)
    if string.find(obj.Name, "Fruit") or obj:FindFirstChild("Handle") then
        if not detectedFruits[obj] then
            detectedFruits[obj] = true
            FruitSound:Play()
            
            local distStr = ""
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local targetPart = obj:FindFirstChild("Handle") or (obj:IsA("BasePart") and obj)
                if targetPart then
                    local dist = math.floor((char.HumanoidRootPart.Position - targetPart.Position).Magnitude)
                    distStr = " [" .. tostring(dist) .. "m]"
                end
            end
            sendNotification("🍎 Fruit Spawner Detected!", "Found: " .. obj.Name .. distStr, 6)
        end
    end
end

Workspace.ChildAdded:Connect(function(child)
    checkAndNotifyFruit(child)
end)

for _, child in pairs(Workspace:GetChildren()) do
    checkAndNotifyFruit(child)
end

----------------------------------------------------
-- MAIN RENDER LOOP
----------------------------------------------------
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")

    -- 🎯 PLAYER AIM LOCK LOGIC
    if States.AimLock and root then
        local targetPart = getClosestPlayer()
        if targetPart then
            local targetPos = targetPart.Position
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
            root.CFrame = CFrame.new(root.Position, Vector3.new(targetPos.X, root.Position.Y, targetPos.Z))
        end
    end

    -- 👾 NPC LOCK LOGIC
    if States.NpcLock and root then
        local targetPart = getClosestNPC()
        if targetPart then
            local targetPos = targetPart.Position
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
            root.CFrame = CFrame.new(root.Position, Vector3.new(targetPos.X, root.Position.Y, targetPos.Z))
        end
    end

    -- 1. PLAYER ESP
    clearESPGroup("Player_ESP")
    if States.Player and root then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") then
                local pChar = p.Character
                local hum = pChar.Humanoid
                local teamColor = Color3.fromRGB(255, 255, 255)

                if p.Team then
                    if string.find(p.Team.Name, "Marine") then
                        teamColor = Color3.fromRGB(59, 130, 246)
                    elseif string.find(p.Team.Name, "Pirate") then
                        teamColor = Color3.fromRGB(239, 68, 68)
                    end
                end

                local levelText = p:FindFirstChild("Data") and p.Data:FindFirstChild("Level") and p.Data.Level.Value or "N/A"
                local infoText = string.format("%s [Lvl %s]\nHP: %d/%d", p.Name, tostring(levelText), math.floor(hum.Health), math.floor(hum.MaxHealth))
                createBillboard(pChar.HumanoidRootPart, infoText, teamColor, "Player_ESP")
            end
        end
    end

    -- 2. FRUIT ESP
    clearESPGroup("Fruit_ESP")
    if States.Fruit and root then
        for _, obj in pairs(Workspace:GetChildren()) do
            if string.find(obj.Name, "Fruit") or obj:FindFirstChild("Handle") then
                local targetPart = obj:FindFirstChild("Handle") or (obj:IsA("BasePart") and obj)
                if targetPart then
                    local dist = math.floor((root.Position - targetPart.Position).Magnitude)
                    createBillboard(targetPart, string.format("🍎 %s\n[%dm]", obj.Name, dist), Color3.fromRGB(244, 114, 182), "Fruit_ESP")
                end
            end
        end
    end

    -- 3. BOX ESP
    clearESPGroup("Box_ESP")
    if States.Box and root then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if string.find(obj.Name, "Chest") and obj:IsA("BasePart") then
                local chestColor = Color3.fromRGB(255, 255, 255)
                if string.find(obj.Name, "Chest1") or string.find(obj.Name, "Silver") then
                    chestColor = Color3.fromRGB(241, 245, 249)
                elseif string.find(obj.Name, "Chest2") or string.find(obj.Name, "Gold") then
                    chestColor = Color3.fromRGB(234, 179, 8)
                elseif string.find(obj.Name, "Chest3") or string.find(obj.Name, "Diamond") then
                    chestColor = Color3.fromRGB(6, 182, 212)
                end
                
                local dist = math.floor((root.Position - obj.Position).Magnitude)
                createBillboard(obj, string.format("📦 BOX\n[%dm]", dist), chestColor, "Box_ESP")
            end
        end
    end

    -- 4. ISLAND ESP
    clearESPGroup("Island_ESP")
    if States.Island and root then
        local locations = Workspace:FindFirstChild("Locations") or Workspace:FindFirstChild("Map")
        if locations then
            for _, island in pairs(locations:GetChildren()) do
                local part = island:IsA("BasePart") and island or island:FindFirstChildWhichIsA("BasePart")
                if part then
                    local dist = math.floor((root.Position - part.Position).Magnitude)
                    createBillboard(part, string.format("🏝️ %s\n[%dm]", island.Name, dist), Color3.fromRGB(52, 211, 153), "Island_ESP")
                end
            end
        end
    end
end)

----------------------------------------------------
-- DRAGGING & ANIMATION LOGIC
----------------------------------------------------
local function makeDraggable(object)
    local dragging = false
    local dragInput, dragStart, startPos
    local moved = false

    object.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            moved = false
            dragStart = input.Position
            startPos = object.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    object.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            if delta.Magnitude > 5 then moved = true end
            local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            TweenService:Create(object, TweenInfo.new(0.05), {Position = newPos}):Play()
        end
    end)

    return function() return moved end
end

local wasIconMoved = makeDraggable(IconBtn)

local function makeHeaderDraggable(topbarObject, object)
    local dragging = false
    local dragInput, dragStart, startPos

    topbarObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = object.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)

    topbarObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            TweenService:Create(object, TweenInfo.new(0.05), {Position = newPos}):Play()
        end
    end)
end

makeHeaderDraggable(Header, UIFrame)

local isOpen = false
local targetSize = UDim2.new(0, 420, 0, 270)
local openTweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local closeTweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

local function toggleUI()
    isOpen = not isOpen
    if isOpen then
        UIFrame.Visible = true
        TweenService:Create(UIFrame, openTweenInfo, {Size = targetSize}):Play()
    else
        local closeTween = TweenService:Create(UIFrame, closeTweenInfo, {Size = UDim2.new(0, 0, 0, 0)})
        closeTween:Play()
        closeTween.Completed:Connect(function()
            if not isOpen then UIFrame.Visible = false end
        end)
    end
end

IconBtn.MouseButton1Click:Connect(function()
    if not wasIconMoved() then toggleUI() end
end)

CloseBtn.MouseButton1Click:Connect(toggleUI)
