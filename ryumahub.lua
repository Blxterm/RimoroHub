-- Script made by anonymous
-- Blox Fruits Control Panel UI

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- إعدادات افتراضية
local Settings = {
    Speed = 50,
    Enabled = true
}

-- حالة السكربت
local ScriptState = {
    Hidden = false,
    Minimized = false,
    Maximized = false
}

-- إنشاء الواجهة الرئيسية
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ControlPanelGUI"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

-- شريط العنوان
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Text = "Blox Fruits Control Panel"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14

-- أزرار التحكم (X, □, _)
local ControlsFrame = Instance.new("Frame")
ControlsFrame.Name = "ControlsFrame"
ControlsFrame.Size = UDim2.new(0, 90, 1, 0)
ControlsFrame.Position = UDim2.new(1, -100, 0, 0)
ControlsFrame.BackgroundTransparency = 1

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Size = UDim2.new(0, 30, 1, 0)
MinimizeBtn.Position = UDim2.new(0, 0, 0, 0)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MinimizeBtn.Text = "_"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 16

local MaximizeBtn = Instance.new("TextButton")
MaximizeBtn.Name = "MaximizeBtn"
MaximizeBtn.Size = UDim2.new(0, 30, 1, 0)
MaximizeBtn.Position = UDim2.new(0, 30, 0, 0)
MaximizeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MaximizeBtn.Text = "□"
MaximizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MaximizeBtn.Font = Enum.Font.GothamBold
MaximizeBtn.TextSize = 16

local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 30, 1, 0)
CloseBtn.Position = UDim2.new(0, 60, 0, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16

-- منطقة المحتوى
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -20, 1, -50)
ContentFrame.Position = UDim2.new(0, 10, 0, 40)
ContentFrame.BackgroundTransparency = 1

-- تبويبات
local TabsFrame = Instance.new("Frame")
TabsFrame.Name = "TabsFrame"
TabsFrame.Size = UDim2.new(1, 0, 0, 30)
TabsFrame.Position = UDim2.new(0, 0, 0, 0)
TabsFrame.BackgroundTransparency = 1

local SettingsTab = Instance.new("TextButton")
SettingsTab.Name = "SettingsTab"
SettingsTab.Size = UDim2.new(0, 100, 1, 0)
SettingsTab.Position = UDim2.new(0, 0, 0, 0)
SettingsTab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SettingsTab.Text = "⚙️ Settings"
SettingsTab.TextColor3 = Color3.fromRGB(255, 255, 255)
SettingsTab.Font = Enum.Font.Gotham
SettingsTab.TextSize = 14

-- محتوى إعدادات السرعة
local SpeedFrame = Instance.new("Frame")
SpeedFrame.Name = "SpeedFrame"
SpeedFrame.Size = UDim2.new(1, 0, 0, 150)
SpeedFrame.Position = UDim2.new(0, 0, 0, 40)
SpeedFrame.BackgroundTransparency = 1
SpeedFrame.Visible = true

local SpeedTitle = Instance.new("TextLabel")
SpeedTitle.Name = "SpeedTitle"
SpeedTitle.Size = UDim2.new(1, 0, 0, 25)
SpeedTitle.Position = UDim2.new(0, 0, 0, 0)
SpeedTitle.BackgroundTransparency = 1
SpeedTitle.Text = "Speed Settings"
SpeedTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedTitle.Font = Enum.Font.GothamBold
SpeedTitle.TextSize = 16

local ToggleFrame = Instance.new("Frame")
ToggleFrame.Name = "ToggleFrame"
ToggleFrame.Size = UDim2.new(1, 0, 0, 30)
ToggleFrame.Position = UDim2.new(0, 0, 0, 30)
ToggleFrame.BackgroundTransparency = 1

local ToggleLabel = Instance.new("TextLabel")
ToggleLabel.Name = "ToggleLabel"
ToggleLabel.Size = UDim2.new(0, 100, 1, 0)
ToggleLabel.Position = UDim2.new(0, 0, 0, 0)
ToggleLabel.BackgroundTransparency = 1
ToggleLabel.Text = "Enable Speed:"
ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleLabel.Font = Enum.Font.Gotham
ToggleLabel.TextSize = 14

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Size = UDim2.new(0, 50, 0, 25)
ToggleBtn.Position = UDim2.new(0, 110, 0, 2)
ToggleBtn.BackgroundColor3 = Settings.Enabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
ToggleBtn.Text = Settings.Enabled and "ON" or "OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 12

local SpeedSliderFrame = Instance.new("Frame")
SpeedSliderFrame.Name = "SpeedSliderFrame"
SpeedSliderFrame.Size = UDim2.new(1, 0, 0, 60)
SpeedSliderFrame.Position = UDim2.new(0, 0, 0, 70)
SpeedSliderFrame.BackgroundTransparency = 1

local SpeedValueLabel = Instance.new("TextLabel")
SpeedValueLabel.Name = "SpeedValueLabel"
SpeedValueLabel.Size = UDim2.new(1, 0, 0, 20)
SpeedValueLabel.Position = UDim2.new(0, 0, 0, 0)
SpeedValueLabel.BackgroundTransparency = 1
SpeedValueLabel.Text = "Speed: " .. Settings.Speed
SpeedValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedValueLabel.Font = Enum.Font.Gotham
SpeedValueLabel.TextSize = 14

local SpeedSlider = Instance.new("Frame")
SpeedSlider.Name = "SpeedSlider"
SpeedSlider.Size = UDim2.new(1, -20, 0, 20)
SpeedSlider.Position = UDim2.new(0, 10, 0, 25)
SpeedSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

local SliderFill = Instance.new("Frame")
SliderFill.Name = "SliderFill"
SliderFill.Size = UDim2.new((Settings.Speed - 1) / 249, 0, 1, 0)
SliderFill.Position = UDim2.new(0, 0, 0, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)

local SliderButton = Instance.new("TextButton")
SliderButton.Name = "SliderButton"
SliderButton.Size = UDim2.new(0, 20, 0, 20)
SliderButton.Position = UDim2.new((Settings.Speed - 1) / 249, -10, 0, 0)
SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SliderButton.Text = ""
SliderButton.ZIndex = 2

-- ضع العناصر معًا
ControlsFrame.Parent = TitleBar
MinimizeBtn.Parent = ControlsFrame
MaximizeBtn.Parent = ControlsFrame
CloseBtn.Parent = ControlsFrame

TitleBar.Parent = MainFrame
Title.Parent = TitleBar

TabsFrame.Parent = ContentFrame
SettingsTab.Parent = TabsFrame

SpeedFrame.Parent = ContentFrame
SpeedTitle.Parent = SpeedFrame
ToggleFrame.Parent = SpeedFrame
ToggleLabel.Parent = ToggleFrame
ToggleBtn.Parent = ToggleFrame
SpeedSliderFrame.Parent = SpeedFrame
SpeedValueLabel.Parent = SpeedSliderFrame
SpeedSlider.Parent = SpeedSliderFrame
SliderFill.Parent = SpeedSlider
SliderButton.Parent = SpeedSlider

ContentFrame.Parent = MainFrame
MainFrame.Parent = ScreenGui
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- وظائف التحكم بالسرعة
local function updateSpeed()
    if Settings.Enabled and player.Character then
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = Settings.Speed
        end
    end
end

local function setSpeed(value)
    Settings.Speed = math.clamp(value, 1, 250)
    SpeedValueLabel.Text = "Speed: " .. Settings.Speed
    SliderFill.Size = UDim2.new((Settings.Speed - 1) / 249, 0, 1, 0)
    SliderButton.Position = UDim2.new((Settings.Speed - 1) / 249, -10, 0, 0)
    updateSpeed()
end

-- وظائف التحكم بالسكربت
local function toggleScript()
    if ScriptState.Hidden then
        -- إظهار السكربت
        MainFrame.Visible = true
        ScriptState.Hidden = false
    else
        -- إخفاء السكربت
        MainFrame.Visible = false
        ScriptState.Hidden = true
    end
end

local function minimizeScript()
    if ScriptState.Minimized then
        -- إعادة الحجم الطبيعي
        MainFrame.Size = UDim2.new(0, 400, 0, 300)
        ScriptState.Minimized = false
        ScriptState.Maximized = false
    else
        -- تصغير إلى سطر صغير
        MainFrame.Size = UDim2.new(0, 400, 0, 30)
        ContentFrame.Visible = false
        ScriptState.Minimized = true
        ScriptState.Maximized = false
    end
end

local function maximizeScript()
    if ScriptState.Maximized then
        -- إعادة الحجم الطبيعي
        MainFrame.Size = UDim2.new(0, 400, 0, 300)
        ScriptState.Maximized = false
    else
        -- تكبير السكربت
        MainFrame.Size = UDim2.new(0, 600, 0, 450)
        ScriptState.Maximized = true
        ScriptState.Minimized = false
        ContentFrame.Visible = true
    end
end

-- أحداث الأزرار
CloseBtn.MouseButton1Click:Connect(toggleScript)

MinimizeBtn.MouseButton1Click:Connect(function()
    minimizeScript()
end)

MaximizeBtn.MouseButton1Click:Connect(function()
    maximizeScript()
end)

-- تفعيل/تعطيل السرعة
ToggleBtn.MouseButton1Click:Connect(function()
    Settings.Enabled = not Settings.Enabled
    ToggleBtn.BackgroundColor3 = Settings.Enabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    ToggleBtn.Text = Settings.Enabled and "ON" or "OFF"
    updateSpeed()
end)

-- السلايدر
local sliding = false
SliderButton.MouseButton1Down:Connect(function()
    sliding = true
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        sliding = false
    end
end)

mouse.Move:Connect(function()
    if sliding then
        local x = math.clamp(mouse.X - SpeedSlider.AbsolutePosition.X, 0, SpeedSlider.AbsoluteSize.X)
        local ratio = x / SpeedSlider.AbsoluteSize.X
        local speed = math.floor(1 + ratio * 249)
        setSpeed(speed)
    end
end)

SpeedSlider.MouseButton1Down:Connect(function()
    local x = math.clamp(mouse.X - SpeedSlider.AbsolutePosition.X, 0, SpeedSlider.AbsoluteSize.X)
    local ratio = x / SpeedSlider.AbsoluteSize.X
    local speed = math.floor(1 + ratio * 249)
    setSpeed(speed)
end)

-- تحديث السرعة عند تغيير الشخصية
player.CharacterAdded:Connect(function(character)
    wait(1)
    updateSpeed()
end)

-- تحديث مستمر للسرعة
RunService.Heartbeat:Connect(function()
    updateSpeed()
end)

-- زر إختصار لإظهار/إخفاء السكربت (زر F5)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == Enum.KeyCode.F5 then
            toggleScript()
        end
    end
end)

-- إعداد السرعة الأولية
wait(1)
updateSpeed()

print("Blox Fruits Control Panel loaded successfully!")
print("Press F5 to hide/show the panel")
print("Speed range: 1-250")
