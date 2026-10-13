-- ========================================================
-- MD_GAMER_SCRIPT (Blox Fruits - Luau Executor Script)
-- Author: MD_GAMER
-- Version: 2.0 (Updated & Optimized)
-- ========================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

-- Global Settings / State Storage
_G.MDGamerConfig = {
    SpeedBypass = false,
    InstantFruitCollect = false,
    NPCMagnet = false,
    PlayerMagnet = false,
    FruitESP = true,
    UsernameESP = true,
    NoticeOpacity = 1.0, -- 1.0 = Default, 0.2-0.3 = Semi-transparent
    NoticeTextSize = 14,
    HideNotices = false
}

-- Safe CoreGui Container Setup
local TargetParent = (gethui and gethui()) or CoreGui:FindFirstChild("RobloxGui") or LocalPlayer:WaitForChild("PlayerGui")
if TargetParent:FindFirstChild("MD_GAMER_GUI") then
    TargetParent["MD_GAMER_GUI"]:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MD_GAMER_GUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = TargetParent

-- Floating Buttons Container (Draggable / Mobile Responsive)
local FloatingFrame = Instance.new("Frame")
FloatingFrame.Name = "FloatingControls"
FloatingFrame.Size = UDim2.new(0, 220, 0, 50)
FloatingFrame.Position = UDim2.new(0.05, 0, 0.15, 0)
FloatingFrame.BackgroundTransparency = 1
FloatingFrame.Parent = ScreenGui

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.Parent = FloatingFrame

-- Helper function for creating Floating Toggle Buttons
local function CreateFloatingButton(name, text, color)
    local btn = Instance.new("TextButton")
    btn.Name = name .. "Btn"
    btn.Size = UDim2.new(0, 50, 0, 40)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 12
    btn.AutoButtonColor = true
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = btn
    
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(255, 255, 255)
    UIStroke.Thickness = 1
    UIStroke.Transparency = 0.5
    UIStroke.Parent = btn

    btn.Parent = FloatingFrame
    return btn
end

local SpeedBtn = CreateFloatingButton("Speed", "Speed", Color3.fromRGB(40, 120, 220))
local CollectBtn = CreateFloatingButton("Collect", "Collect", Color3.fromRGB(40, 180, 80))
local NPCBtn = CreateFloatingButton("NPC", "NPC", Color3.fromRGB(220, 100, 40))
local PlayerBtn = CreateFloatingButton("Player", "Player", Color3.fromRGB(180, 40, 200))

-- Toggle Functionalities
SpeedBtn.MouseButton1Click:Connect(function()
    _G.MDGamerConfig.SpeedBypass = not _G.MDGamerConfig.SpeedBypass
    SpeedBtn.BackgroundColor3 = _G.MDGamerConfig.SpeedBypass and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(40, 120, 220)
end)

CollectBtn.MouseButton1Click:Connect(function()
    _G.MDGamerConfig.InstantFruitCollect = not _G.MDGamerConfig.InstantFruitCollect
    CollectBtn.BackgroundColor3 = _G.MDGamerConfig.InstantFruitCollect and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(40, 180, 80)
end)

NPCBtn.MouseButton1Click:Connect(function()
    _G.MDGamerConfig.NPCMagnet = not _G.MDGamerConfig.NPCMagnet
    NPCBtn.BackgroundColor3 = _G.MDGamerConfig.NPCMagnet and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(220, 100, 40)
end)

PlayerBtn.MouseButton1Click:Connect(function()
    _G.MDGamerConfig.PlayerMagnet = not _G.MDGamerConfig.PlayerMagnet
    PlayerBtn.BackgroundColor3 = _G.MDGamerConfig.PlayerMagnet and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(180, 40, 200)
end)

-- Dynamic Game Notification & Notice Text Customizer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local function ApplyCustomNoticeStyle(obj)
    if _G.MDGamerConfig.HideNotices then
        if obj:IsA("GuiObject") then
            obj.Visible = false
        end
        return
    end

    if obj:IsA("TextLabel") or obj:IsA("TextButton") then
        obj.TextSize = _G.MDGamerConfig.NoticeTextSize
        obj.TextTransparency = 1 - _G.MDGamerConfig.NoticeOpacity
    end

    if obj:IsA("Frame") or obj:IsA("ImageLabel") then
        obj.BackgroundTransparency = 1 - (_G.MDGamerConfig.NoticeOpacity * 0.5)
    end
end

PlayerGui.DescendantAdded:Connect(function(descendant)
    if descendant.Name:lower():find("notice") or descendant.Name:lower():find("exp") or descendant.Name:lower():find("level") or descendant.Name:lower():find("reward") then
        task.wait(0.05)
        ApplyCustomNoticeStyle(descendant)
    end
end)
-- ========================================================
-- PART 2: CORE MECHANICS (NPC/Player Magnets & ESP Logic)
-- ========================================================

-- NPC Magnet Logic (20-30m Detection, 2-3m Offset, Same-Direction Facing for Zero-Damage)
RunService.Stepped:Connect(function()
    if _G.MDGamerConfig.NPCMagnet and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local myHRP = LocalPlayer.Character.HumanoidRootPart
        local myCFrame = myHRP.CFrame
        
        -- Target Position: 2.5 meters directly in front of the player
        local targetCFrame = myCFrame * CFrame.new(0, 0, -2.5)

        for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
            if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                local npcHRP = v.HumanoidRootPart
                local dist = (npcHRP.Position - myHRP.Position).Magnitude

                -- 20m to 30m Safe Detection Radius
                if dist <= 30 then
                    -- Same-Direction Facing Logic (NPC faces same direction as Player, back turned towards Player)
                    npcHRP.CFrame = CFrame.new(targetCFrame.Position, targetCFrame.Position + myCFrame.LookVector)
                    npcHRP.Velocity = Vector3.new(0, 0, 0)
                    if v.Humanoid:FindFirstChild("Animator") then
                        -- Keep NPC collision clean
                        v.HumanoidPlatformStand = true
                    end
                end
            end
        end
    end
end)

-- Player Magnet Logic (10-15m PvP Detection, 3-5m Ground Distance Hold)
RunService.Stepped:Connect(function()
    if _G.MDGamerConfig.PlayerMagnet and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local myHRP = LocalPlayer.Character.HumanoidRootPart
        local myCFrame = myHRP.CFrame
        
        -- Hold target 4 meters in front on ground level
        local targetPosition = myCFrame * CFrame.new(0, 0, -4)

        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= LocalPlayer and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") and otherPlayer.Character:FindFirstChild("Humanoid") then
                if otherPlayer.Character.Humanoid.Health > 0 then
                    local targetHRP = otherPlayer.Character.HumanoidRootPart
                    local dist = (targetHRP.Position - myHRP.Position).Magnitude

                    -- 10-15 Meters Safe PvP Replication Distance
                    if dist <= 15 then
                        targetHRP.CFrame = CFrame.new(targetPosition.Position)
                        targetHRP.Velocity = Vector3.new(0, 0, 0)
                    end
                end
            end
        end
    end
end)

-- Fruit ESP with Island Name Detection & Username ESP
local function UpdateESP()
    for _, v in pairs(game.Workspace:GetChildren()) do
        -- Natural Spawn Fruit Detection
        if v:IsA("Tool") or v.Name:find("Fruit") then
            if not v:FindFirstChild("MD_FruitESP") then
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "MD_FruitESP"
                billboard.AlwaysOnTop = true
                billboard.Size = UDim2.new(0, 200, 0, 50)
                billboard.StudsOffset = Vector3.new(0, 3, 0)
                
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.TextColor3 = Color3.fromRGB(255, 215, 0)
                label.TextStrokeTransparency = 0
                label.Font = Enum.Font.SourceSansBold
                label.TextSize = 14
                
                -- Nearest Island Name Lookup Logic
                local islandName = "Unknown Island"
                if game.Workspace:FindFirstChild("Locations") then
                    local nearestDist = math.huge
                    for _, loc in pairs(game.Workspace.Locations:GetChildren()) do
                        local d = (loc.Position - v:GetPivot().Position).Magnitude
                        if d < nearestDist then
                            nearestDist = d
                            islandName = loc.Name
                        end
                    end
                end
                
                label.Text = v.Name .. " [" .. islandName .. "]"
                label.Parent = billboard
                
                local parentPart = v:IsA("BasePart") and v or v:FindFirstChildWhichIsA("BasePart")
                if parentPart then
                    billboard.Parent = parentPart
                end
            end
        end
    end

    -- Player Username Only ESP (Removes Display Name clutter)
    if _G.MDGamerConfig.UsernameESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                if not p.Character.Head:FindFirstChild("MD_UserESP") then
                    local bGui = Instance.new("BillboardGui")
                    bGui.Name = "MD_UserESP"
                    bGui.AlwaysOnTop = true
                    bGui.Size = UDim2.new(0, 150, 0, 30)
                    bGui.StudsOffset = Vector3.new(0, 2, 0)

                    local txt = Instance.new("TextLabel")
                    txt.Size = UDim2.new(1, 0, 1, 0)
                    txt.BackgroundTransparency = 1
                    txt.TextColor3 = Color3.fromRGB(0, 255, 255)
                    txt.TextStrokeTransparency = 0
                    txt.Font = Enum.Font.SourceSansBold
                    txt.TextSize = 13
                    txt.Text = "@" .. p.Name -- Displaying strict Username
                    txt.Parent = bGui

                    bGui.Parent = p.Character.Head
                end
            end
        end
    end
end

task.spawn(function()
    while task.wait(2) do
        pcall(UpdateESP)
    end
end)

print("[MD_GAMER_SCRIPT v2.0]: Successfully Loaded All Systems!")
