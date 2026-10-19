-- Delta Executor Transparent Dragon UI Script

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- আগের UI থাকলে ডিলিট করবে
if CoreGui:FindFirstChild("DragonScriptUI") then
    CoreGui.DragonScriptUI:Destroy()
end

-- 1. Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DragonScriptUI"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- 2. Floating Transparent Dragon Icon Button
local DragonBtn = Instance.new("ImageButton")
DragonBtn.Name = "DragonBtn"
DragonBtn.Parent = ScreenGui
DragonBtn.BackgroundTransparency = 1  -- ব্যাকগ্রাউন্ড একদম ১০০% ট্রান্সপারেন্ট (কোনো বক্স বা ব্যাকগ্রাউন্ড থাকবে না)
DragonBtn.BorderSizePixel = 0        -- কোনো বর্ডার থাকবে না
DragonBtn.Position = UDim2.new(0.85, 0, 0.75, 0)
DragonBtn.Size = UDim2.new(0, 65, 0, 65)
DragonBtn.Image = "rbxassetid://5669312251" -- Pure Transparent Dragon Vector Asset
DragonBtn.ImageColor3 = Color3.fromRGB(236, 72, 153) -- Neon Dragon Glow Color
DragonBtn.ZIndex = 10

-- 3. UI Modal Window (স্ক্রিনের ঠিক মাঝখানে ওপেন হবে)
local UIFrame = Instance.new("Frame")
UIFrame.Name = "UIFrame"
UIFrame.Parent = ScreenGui
UIFrame.AnchorPoint = Vector2.new(0.5, 0.5)
UIFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
UIFrame.Size = UDim2.new(0, 0, 0, 0) -- শুরুতে ০ সাইজ থাকবে
UIFrame.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
UIFrame.BackgroundTransparency = 0.15
UIFrame.ClipsDescendants = true
UIFrame.Visible = false

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = UIFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(236, 72, 153)
UIStroke.Thickness = 1.5
UIStroke.Transparency = 0.3
UIStroke.Parent = UIFrame

-- 4. UI Header Bar (যা ধরে UI ড্রাগ করা যাবে)
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Parent = UIFrame
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
Header.BackgroundTransparency = 0.3

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = Header
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Size = UDim2.new(0, 200, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "🐉 Dragon Script"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Close Button (✕)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Parent = Header
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(148, 163, 184)
CloseBtn.TextSize = 18
CloseBtn.Font = Enum.Font.SourceSansBold

-- Empty UI Body (খালি রাখার জন্য)
local UIBody = Instance.new("Frame")
UIBody.Name = "UIBody"
UIBody.Parent = UIFrame
UIBody.Position = UDim2.new(0, 0, 0, 40)
UIBody.Size = UDim2.new(1, 0, 1, -40)
UIBody.BackgroundTransparency = 1

----------------------------------------------------
-- DRAGGING FUNCTIONALITY (আইকন ও UI ২টাই ড্রাগ করা যাবে)
----------------------------------------------------
local function makeDraggable(topbarObject, object)
    local dragging = false
    local dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        TweenService:Create(object, TweenInfo.new(0.08), {Position = newPos}):Play()
    end

    topbarObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = object.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
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
            update(input)
        end
    end)
end

-- ড্রাগন আইকন ও UI হেডারকে Draggable করা হলো
makeDraggable(DragonBtn, DragonBtn)
makeDraggable(Header, UIFrame)

----------------------------------------------------
-- TOGGLE & SMOOTH ANIMATION
----------------------------------------------------
local isOpen = false
local targetSize = UDim2.new(0, 360, 0, 240)
local tweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

local function toggleUI()
    isOpen = not isOpen
    if isOpen then
        UIFrame.Visible = true
        TweenService:Create(UIFrame, tweenInfo, {Size = targetSize}):Play()
    else
        local closeTween = TweenService:Create(UIFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
        closeTween:Play()
        closeTween.Completed:Connect(function()
            if not isOpen then
                UIFrame.Visible = false
            end
        end)
    end
end

-- আইকনে এবং ক্লোজ বাটনে ক্লিকে টগল হবে
DragonBtn.MouseButton1Click:Connect(toggleUI)
CloseBtn.MouseButton1Click:Connect(toggleUI)
