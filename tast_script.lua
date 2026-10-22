-- HOHO HUB Style UI with Speed Slider (1.5 - 5.0) & Toggle
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HoHoHubCustomSlider"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- Floating Toggle Icon (Show/Hide Button)
local ToggleButton = Instance.new("ImageButton")
ToggleButton.Name = "ToggleIcon"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
ToggleButton.Position = UDim2.new(0, 15, 0.4, 0)
ToggleButton.Size = UDim2.new(0, 45, 0, 45)
ToggleButton.Active = true
ToggleButton.Draggable = true
ToggleButton.Image = "rbxassetid://6031097225"

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 12)
ToggleCorner.Parent = ToggleButton

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Parent = ToggleButton
ToggleStroke.Thickness = 2
ToggleStroke.Color = Color3.fromRGB(255, 0, 100)

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -125)
MainFrame.Size = UDim2.new(0, 420, 0, 250)
MainFrame.Active = true
MainFrame.Draggable = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Parent = MainFrame
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(255, 0, 100)

-- Header Title
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Font = Enum.Font.GothamBold
Title.Text = "   🌺 HOHO HUB | PRIVATE"
Title.TextColor3 = Color3.fromRGB(255, 50, 130)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 8)
HeaderCorner.Parent = Title

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Parent = MainFrame
Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
Sidebar.Position = UDim2.new(0, 5, 0, 40)
Sidebar.Size = UDim2.new(0, 115, 1, -45)

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 6)
SidebarCorner.Parent = Sidebar

-- Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
ContentFrame.Position = UDim2.new(0, 125, 0, 40)
ContentFrame.Size = UDim2.new(1, -130, 1, -45)

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 6)
ContentCorner.Parent = ContentFrame

local Tabs = {}
local tabCount = 0

local function CreateTab(name)
    tabCount = tabCount + 1
    
    local TabPage = Instance.new("Frame")
    TabPage.Name = name .. "Page"
    TabPage.Parent = ContentFrame
    TabPage.Size = UDim2.new(1, -10, 1, -10)
    TabPage.Position = UDim2.new(0, 5, 0, 5)
    TabPage.BackgroundTransparency = 1
    TabPage.Visible = false
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = TabPage
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 8)

    local TabButton = Instance.new("TextButton")
    TabButton.Name = name .. "Btn"
    TabButton.Parent = Sidebar
    TabButton.Size = UDim2.new(1, -8, 0, 32)
    TabButton.Position = UDim2.new(0, 4, 0, (tabCount - 1) * 36 + 6)
    TabButton.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    TabButton.Font = Enum.Font.GothamBold
    TabButton.Text = name
    TabButton.TextColor3 = Color3.fromRGB(150, 150, 160)
    TabButton.TextSize = 12
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 5)
    BtnCorner.Parent = TabButton

    TabButton.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Page.Visible = false
            t.Btn.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
            t.Btn.TextColor3 = Color3.fromRGB(150, 150, 160)
        end
        TabPage.Visible = true
        TabButton.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)

    Tabs[name] = {Page = TabPage, Btn = TabButton}
    return TabPage
end

local function AddButton(page, text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 35)
    Btn.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
    Btn.Font = Enum.Font.GothamSemibold
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.TextSize = 13
    Btn.Parent = page
    
    local BCorner = Instance.new("UICorner")
    BCorner.CornerRadius = UDim.new(0, 5)
    BCorner.Parent = Btn

    local BStroke = Instance.new("UIStroke")
    BStroke.Parent = Btn
    BStroke.Color = Color3.fromRGB(255, 0, 100)
    BStroke.Thickness = 1
    
    Btn.MouseButton1Click:Connect(function()
        callback(Btn)
    end)
end

-- Create Tabs
local MainEspTab = CreateTab("📌 MAIN/ESP")
local SettingsTab = CreateTab("⚙️ Settings")

-- Set Main/ESP as Default Tab
Tabs["📌 MAIN/ESP"].Page.Visible = true
Tabs["📌 MAIN/ESP"].Btn.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
Tabs["📌 MAIN/ESP"].Btn.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Speed Variables
local speedActive = false
local speedMultiplier = 1.8 -- Default Value

-- Toggle Button for Speed Bypass
AddButton(MainEspTab, "⚡ Smooth Bypass Speed: OFF", function(btn)
    speedActive = not speedActive
    if speedActive then
        btn.Text = "⚡ Smooth Bypass Speed: ON"
        btn.TextColor3 = Color3.fromRGB(0, 255, 120)
        task.spawn(function()
            while speedActive do
                task.wait(0.01)
                pcall(function()
                    local char = game.Players.LocalPlayer.Character
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    local hum = char:FindFirstChild("Humanoid")
                    if hrp and hum and hum.MoveDirection.Magnitude > 0 then
                        hrp.CFrame = hrp.CFrame + (hum.MoveDirection * speedMultiplier)
                    end
                end)
            end
        end)
    else
        btn.Text = "⚡ Smooth Bypass Speed: OFF"
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end)

-- Slider Functionality (1.5 to 5.0)
local SliderFrame = Instance.new("Frame")
SliderFrame.Name = "SpeedSliderFrame"
SliderFrame.Parent = MainEspTab
SliderFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
SliderFrame.Size = UDim2.new(1, 0, 0, 45)

local SliderCorner = Instance.new("UICorner")
SliderCorner.CornerRadius = UDim.new(0, 5)
SliderCorner.Parent = SliderFrame

local SliderStroke = Instance.new("UIStroke")
SliderStroke.Parent = SliderFrame
SliderStroke.Color = Color3.fromRGB(255, 0, 100)
SliderStroke.Thickness = 1

local SliderTitle = Instance.new("TextLabel")
SliderTitle.Parent = SliderFrame
SliderTitle.BackgroundTransparency = 1
SliderTitle.Position = UDim2.new(0, 10, 0, 2)
SliderTitle.Size = UDim2.new(1, -20, 0, 20)
SliderTitle.Font = Enum.Font.GothamSemibold
SliderTitle.Text = "Speed Multiplier: 1.8"
SliderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
SliderTitle.TextSize = 12
SliderTitle.TextXAlignment = Enum.TextXAlignment.Left

local SliderBar = Instance.new("TextButton")
SliderBar.Name = "SliderBar"
SliderBar.Parent = SliderFrame
SliderBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
SliderBar.Position = UDim2.new(0, 10, 0, 25)
SliderBar.Size = UDim2.new(1, -20, 0, 12)
SliderBar.AutoButtonColor = false
SliderBar.Text = ""

local BarCorner = Instance.new("UICorner")
BarCorner.CornerRadius = UDim.new(0, 4)
BarCorner.Parent = SliderBar

local SliderFill = Instance.new("Frame")
SliderFill.Name = "SliderFill"
SliderFill.Parent = SliderBar
SliderFill.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
-- Initial calculation for default value 1.8: (1.8 - 1.5) / (5.0 - 1.5) = 0.0857
SliderFill.Size = UDim2.new(0.0857, 0, 1, 0)

local FillCorner = Instance.new("UICorner")
FillCorner.CornerRadius = UDim.new(0, 4)
FillCorner.Parent = SliderFill

local UserInputService = game:GetService("UserInputService")
local dragging = false

local function UpdateSlider(input)
    local minVal = 1.5
    local maxVal = 5.0
    local mousePos = input.Position.X
    local barPos = SliderBar.AbsolutePosition.X
    local barSize = SliderBar.AbsoluteSize.X
    
    local percent = math.clamp((mousePos - barPos) / barSize, 0, 1)
    speedMultiplier = minVal + (percent * (maxVal - minVal))
    speedMultiplier = math.floor(speedMultiplier * 10) / 10 -- Round to 1 decimal place
    
    SliderFill.Size = UDim2.new(percent, 0, 1, 0)
    SliderTitle.Text = "Speed Multiplier: " .. string.format("%.1f", speedMultiplier)
end

SliderBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        UpdateSlider(input)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        UpdateSlider(input)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Settings Tab Options
AddButton(SettingsTab, "❌ Destroy Hub", function()
    ScreenGui:Destroy()
end)

-- Show / Hide Toggle Functionality
ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)
