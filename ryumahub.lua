--[[ 
    STamPHub Script - Blox Fruits Edition
    Created for Professional Use
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- // متغيرات التحكم (States)
local Config = {
    Enabled = false,
    Aimbot = false,
    FastAttack = false,
    InfEnergy = false,
    AutoV3 = false,
    AutoV4 = false,
    WalkSpeed = 16,
    JumpPower = 50,
    Target = nil
}

-- // إنشاء الواجهة (GUI Creation)
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "STamPHub_UI"

-- الزر الرئيسي (Main Toggle)
local MainBtn = Instance.new("TextButton")
MainBtn.Name = "MainBtn"
MainBtn.Parent = ScreenGui
MainBtn.Size = UDim2.new(0, 150, 0, 50)
MainBtn.Position = UDim2.new(0.5, -75, 0.2, 0)
MainBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainBtn.Text = "STamPHub Off"
MainBtn.TextColor3 = Color3.new(1, 1, 1)
MainBtn.Font = Enum.Font.GothamBold
MainBtn.TextSize = 18
MainBtn.BorderSizePixel = 2

-- إضافة انحناء للزوايا
local Corner = Instance.new("UICorner", MainBtn)
Corner.CornerRadius = UDim.new(0, 8)

-- زر الترس (Settings Cog)
local SettingsBtn = Instance.new("ImageButton")
SettingsBtn.Name = "SettingsBtn"
SettingsBtn.Parent = MainBtn
SettingsBtn.Size = UDim2.new(0, 30, 0, 30)
SettingsBtn.Position = UDim2.new(1, 10, 0.2, 0)
SettingsBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SettingsBtn.Image = "rbxassetid://6031289132" -- أيقونة ترس
Instance.new("UICorner", SettingsBtn).CornerRadius = UDim.new(0, 5)

-- لوحة الإعدادات (The Menu)
local MenuFrame = Instance.new("Frame")
MenuFrame.Name = "MenuFrame"
MenuFrame.Parent = ScreenGui
MenuFrame.Size = UDim2.new(0, 220, 0, 350)
MenuFrame.Position = UDim2.new(0.5, 85, 0.2, 0)
MenuFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MenuFrame.Visible = false -- تبدأ مخفية
Instance.new("UICorner", MenuFrame).CornerRadius = UDim.new(0, 10)

-- تخطيط القائمة (Layout)
local Layout = Instance.new("UIListLayout", MenuFrame)
Layout.Padding = UDim.new(0, 10)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- // وظائف إنشاء العناصر داخل القائمة
local function CreateToggle(name, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 180, 0, 35)
    Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Btn.Text = name .. " [OFF]"
    Btn.TextColor3 = Color3.new(1, 1, 1)
    Btn.Parent = MenuFrame
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 5)
    
    local active = false
    Btn.MouseButton1Click:Connect(function()
        active = not active
        Btn.Text = name .. (active and " [ON]" or " [OFF]")
        Btn.BackgroundColor3 = active and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(40, 40, 40)
        callback(active)
    end)
end

local function CreateEdit(name, placeholder, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 180, 0, 35)
    Frame.BackgroundTransparency = 1
    Frame.Parent = MenuFrame
    
    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(0, 100, 1, 0)
    Label.Text = name
    Label.TextColor3 = Color3.new(1, 1, 1)
    Label.BackgroundTransparency = 1
    
    local Box = Instance.new("TextBox", Frame)
    Box.Size = UDim2.new(0, 70, 1, 0)
    Box.Position = UDim2.new(0, 110, 0, 0)
    Box.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Box.PlaceholderText = placeholder
    Box.Text = ""
    Box.TextColor3 = Color3.new(1, 1, 1)
    
    Box.FocusLost:Connect(function()
        callback(tonumber(Box.Text))
    end)
end

-- // تفعيل السحب (Draggable Script)
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    MainBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    MenuFrame.Position = UDim2.new(MainBtn.Position.X.Scale, MainBtn.Position.X.Offset + 160, MainBtn.Position.Y.Scale, MainBtn.Position.Y.Offset)
end

MainBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainBtn.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        update(input)
    end
end)

MainBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- // برمجة الوظائف (The Logic)

-- 1. الزر الرئيسي والايمبوت
MainBtn.MouseButton1Click:Connect(function()
    Config.Enabled = not Config.Enabled
    MainBtn.Text = Config.Enabled and "STamPHub On" or "STamPHub Off"
    MainBtn.BackgroundColor3 = Config.Enabled and Color3.fromRGB(40, 0, 0) or Color3.fromRGB(0, 0, 0)
    
    if Config.Enabled then
        -- البحث عن أقرب هدف عند الضغط
        local closest = nil
        local dist = math.huge
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local d = (v.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if d < dist then
                    dist = d
                    closest = v
                end
            end
        end
        Config.Target = closest
    else
        Config.Target = nil
    end
end)

-- 2. فتح وإغلاق القائمة
SettingsBtn.MouseButton1Click:Connect(function()
    MenuFrame.Visible = not MenuFrame.Visible
end)

-- 3. إضافة الأزرار داخل القائمة
CreateToggle("Inf Energy", function(v) Config.InfEnergy = v end)
CreateToggle("Auto V3", function(v) Config.AutoV3 = v end)
CreateToggle("Auto V4", function(v) Config.AutoV4 = v end)
CreateToggle("Fast Attack", function(v) Config.FastAttack = v end)

CreateEdit("Jump Edit", "150", function(v) 
    if v then LocalPlayer.Character.Humanoid.JumpPower = v end 
end)
CreateEdit("Speed Edit", "50", function(v) 
    if v then LocalPlayer.Character.Humanoid.WalkSpeed = v end 
end)

-- // الحلقات التكرارية (Main Loops)

-- حلقة الـ Fast Attack والإيمبوت
RunService.RenderStepped:Connect(function()
    -- تثبيت الايم (Aimbot)
    if Config.Enabled and Config.Target and Config.Target.Character then
        local targetPos = Config.Target.Character.HumanoidRootPart.Position
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
    end
    
    -- الطاقة اللانهائية
    if Config.InfEnergy then
        local myStats = LocalPlayer:FindFirstChild("Data") or LocalPlayer:FindFirstChild("Stats")
        if myStats and myStats:FindFirstChild("Energy") then
            myStats.Energy.Value = myStats.Energy.MaxValue
        end
    end
    
    -- Auto V3 / V4
    if Config.AutoV3 then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ActivateAbility")
    end
end)

-- حلقة الضرب المحيطي (0.2 ثانية)
task.spawn(function()
    while true do
        task.wait(0.2)
        if Config.Enabled and Config.FastAttack then
            pcall(function()
                local char = LocalPlayer.Character
                local weapon = char:FindFirstChildOfClass("Tool")
                if weapon then
                    for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                        local hrp = enemy:FindFirstChild("HumanoidRootPart")
                        if hrp and (hrp.Position - char.HumanoidRootPart.Position).Magnitude <= 20 then
                            -- استدعاء ضربة اللعبة (تختلف حسب نسخة اللعبة)
                            game:GetService("ReplicatedStorage").RigControllerEvent:FireServer("hit", hrp.Position)
                        end
                    end
                end
            end)
        end
    end
end)

print("STamPHub Loaded Successfully!")
