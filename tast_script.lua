-- Rayfield UI Library Load (HoHo Hub style interface)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Blox Fruits - Hub",
   LoadingTitle = "HoHo Style Hub",
   LoadingSubtitle = "by Assistant",
   ConfigurationSaving = { Enabled = false },
   Discord = { Enabled = false },
   KeySystem = false
})

-- Services
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Variables for Travel
local activeTween = nil
local noclipConnection = nil
local currentTarget = nil

-- Noclip Function
local function startNoclip()
    if noclipConnection then noclipConnection:Disconnect() end
    noclipConnection = RunService.Stepped:Connect(function()
        if LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end

local function stopNoclip()
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
end

-- Stop Traveling Function
local function stopTravel()
    if activeTween then
        activeTween:Cancel()
        activeTween = nil
    end
    stopNoclip()
    currentTarget = nil
end

-- Safe Tween Function
local function travelTo(targetCFrame, speed)
    stopTravel()
    
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    startNoclip()

    local distance = (rootPart.Position - targetCFrame.Position).Magnitude
    local timeToTravel = distance / (speed or 350)

    local tweenInfo = TweenInfo.new(timeToTravel, Enum.EasingStyle.Linear)
    activeTween = TweenService:Create(rootPart, tweenInfo, {CFrame = targetCFrame})
    
    activeTween:Play()
    
    activeTween.Completed:Connect(function()
        stopNoclip()
        activeTween = nil
    end)
    return activeTween
end


-- ============================================
-- ESP SYSTEM LOGIC
-- ============================================
local espEnabled = false
local espObjects = {}

local function createESP(plr)
    if plr == LocalPlayer then return end
    
    local function applyESP(chr)
        if not chr then return end
        local head = chr:WaitForChild("Head", 5)
        local humanoid = chr:WaitForChild("Humanoid", 5)
        if not head or not humanoid then return end

        local bb = Instance.new("BillboardGui")
        bb.Name = "ESP_Tag"
        bb.Adornee = head
        bb.Size = UDim2.new(0, 200, 0, 50)
        bb.StudsOffset = Vector3.new(0, 3, 0)
        bb.AlwaysOnTop = true
        bb.Parent = head

        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        textLabel.TextStrokeTransparency = 0
        textLabel.TextSize = 13
        textLabel.Font = Enum.Font.SourceSansBold
        textLabel.Parent = bb

        local conn
        conn = RunService.RenderStepped:Connect(function()
            if not espEnabled or not chr or not chr:Parent() or not humanoid or humanoid.Health <= 0 then
                bb:Destroy()
                if conn then conn:Disconnect() end
                return
            end

            local level = "N/A"
            if plr:FindFirstChild("Data") and plr.Data:FindFirstChild("Level") then
                level = tostring(plr.Data.Level.Value)
            elseif plr:FindFirstChild("leaderstats") and plr.leaderstats:FindFirstChild("Level") then
                level = tostring(plr.leaderstats.Level.Value)
            end

            local hp = math.floor(humanoid.Health)
            local maxHp = math.floor(humanoid.MaxHealth)

            textLabel.Text = string.format("%s\n[Lvl %s] | HP: %d/%d", plr.Name, level, hp, maxHp)
        end)

        table.insert(espObjects, bb)
    end

    if plr.Character then
        applyESP(plr.Character)
    end
    plr.CharacterAdded:Connect(applyESP)
end

local function toggleESP(state)
    espEnabled = state
    if not state then
        for _, v in pairs(espObjects) do
            if v and v.Parent then
                v:Destroy()
            end
        end
        espObjects = {}
    else
        for _, plr in pairs(Players:GetPlayers()) do
            createESP(plr)
        end
    end
end

Players.PlayerAdded:Connect(function(plr)
    if espEnabled then
        createESP(plr)
    end
end)


-- ============================================
-- AUTO CHEST FARM LOGIC
-- ============================================
local autoChest = false

-- নিকটবর্তী সবচেয়ে কাছের Chest খুঁজে বের করার ফাংশন
local function getClosestChest()
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return nil end
    
    local rootPart = character.HumanoidRootPart
    local closest = nil
    local shortestDistance = math.huge

    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Part") or v:IsA("MeshPart") or v:IsA("Model") then
            if v.Name:find("Chest") then
                local chestPart = v:IsA("Model") and (v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart")) or v
                if chestPart then
                    local dist = (rootPart.Position - chestPart.Position).Magnitude
                    if dist < shortestDistance then
                        shortestDistance = dist
                        closest = chestPart
                    end
                end
            end
        end
    end
    return closest
end

-- Chest Farm Loop
task.spawn(function()
    while task.wait(0.5) do
        if autoChest then
            local chest = getClosestChest()
            if chest and chest.Parent then
                local tw = travelTo(chest.CFrame, 350)
                if tw then
                    tw.Completed:Wait()
                    task.wait(0.2)
                end
            else
                -- কোনো Chest না থাকলে সতর্কবার্তা দেবে
                Rayfield:Notify({
                   Title = "Searching Chests...",
                   Content = "No chests found nearby. Retrying...",
                   Duration = 2,
                   Image = 4483362458
                })
                task.wait(3)
            end
        end
    end
end)


-- ============================================
-- UI TABS SETUP
-- ============================================

-- 1. Main/ESP Tab
local EspTab = Window:CreateTab("Main/Esp", 4483362458)
local EspSection = EspTab:CreateSection("ESP Visuals")

EspTab:CreateToggle({
   Name = "Player ESP (Name, Level, HP)",
   CurrentValue = false,
   Flag = "Player_ESP_Toggle",
   Callback = function(Value)
       toggleESP(Value)
   end,
})

local ChestSection = EspTab:CreateSection("Auto Farming")

EspTab:CreateToggle({
   Name = "Collect Chest",
   CurrentValue = false,
   Flag = "Collect_Chest_Toggle",
   Callback = function(Value)
       autoChest = Value
       if not Value then
           stopTravel()
           Rayfield:Notify({
              Title = "Chest Farm Stopped",
              Content = "Auto chest collection disabled.",
              Duration = 2,
              Image = 4483362458
           })
       end
   end,
})

-- 2. Sea 2 Teleport Tab
local Sea2Tab = Window:CreateTab("Sea 2 Teleport", 4483362458)
local Sea2Section = Sea2Tab:CreateSection("Select Destination")

local Sea2Islands = {
    ["Kingdom of Rose (Cafe)"] = CFrame.new(-382, 73, 297),
    ["Usoap's Island"]        = CFrame.new(4816, 8, 2863),
    ["Green Zone"]            = CFrame.new(-2385, 73, -3025),
    ["Graveyard Island"]      = CFrame.new(-5418, 48, -700),
    ["Snow Mountain"]         = CFrame.new(623, 401, -5373),
    ["Hot and Cold"]          = CFrame.new(-612, 16, -5024),
    ["Cursed Ship"]           = CFrame.new(923, 125, 32885),
    ["Ice Castle"]            = CFrame.new(5531, 28, -6282),
    ["Forgotten Island"]      = CFrame.new(-3050, 237, -10175),
    ["Dark Arena"]            = CFrame.new(3812, 18, -3520)
}

local islandToggles = {}

for islandName, targetCFrame in pairs(Sea2Islands) do
    islandToggles[islandName] = Sea2Tab:CreateToggle({
        Name = islandName,
        CurrentValue = false,
        Flag = islandName .. "_Toggle",
        Callback = function(Value)
            if Value then
                for otherName, toggleObj in pairs(islandToggles) do
                    if otherName ~= islandName then
                        toggleObj:Set(false)
                    end
                end
                
                currentTarget = islandName
                travelTo(targetCFrame, 350)
                
                Rayfield:Notify({
                   Title = "Traveling...",
                   Content = "Going to " .. islandName,
                   Duration = 3,
                   Image = 4483362458
                })
            else
                if currentTarget == islandName then
                    stopTravel()
                    Rayfield:Notify({
                       Title = "Travel Cancelled",
                       Content = "Stopped traveling to " .. islandName,
                       Duration = 3,
                       Image = 4483362458
                    })
                end
            end
        end,
    })
end

-- Emergency Stop Button
Sea2Tab:CreateButton({
   Name = "🔴 Emergency Stop Travel",
   Callback = function()
       stopTravel()
       autoChest = false
       for _, toggleObj in pairs(islandToggles) do
           toggleObj:Set(false)
       end
   end,
})
