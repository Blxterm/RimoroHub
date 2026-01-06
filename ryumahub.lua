--[[ 
    STamPHub V2 - Fixed & Optimized
    - Fixed Draggable Tool
    - Fixed Speed/Jump Reset
    - Fixed Fast Attack Logic
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- // Configuration Table
local STampConfig = {
    Enabled = false,
    Aimbot = false,
    FastAttack = false,
    InfEnergy = false,
    AutoV3 = false,
    AutoV4 = false,
    WalkSpeed = 16,
    JumpPower = 50,
    Target = nil,
    MenuVisible = false
}

-- // UI Creation (Built for Stability)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "STamPHub_Fixed"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- الزر الرئيسي (Parent لجميع العناصر لضمان الحركة الموحدة)
local MainBtn = Instance.new("TextButton")
MainBtn.Name = "MainBtn"
MainBtn.Parent = ScreenGui
MainBtn.Size = UDim2.new(0, 160, 0, 55)
MainBtn.Position = UDim2.new(0.5, -80, 0.4, 0)
MainBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainBtn.Text = "STamPHub Off"
MainBtn.TextColor3 = Color3.new(1, 1, 1)
MainBtn.Font = Enum.Font.SourceSansBold
MainBtn.TextSize = 20
MainBtn.ZIndex = 5
Instance.new("UICorner", MainBtn).CornerRadius = UDim.new(0, 10)

-- الترس (ملتصق بالزر تماماً)
local SettingsIcon = Instance.new("ImageButton")
SettingsIcon.Name = "SettingsIcon"
SettingsIcon.Parent = MainBtn
SettingsIcon.Size = UDim2.new(0, 30, 0, 30)
SettingsIcon.Position = UDim2.new(1, -35, 0.5, -15) -- داخل الزر جهة اليمين
SettingsIcon.BackgroundTransparency = 1
SettingsIcon.Image = "rbxassetid://6031289132"
SettingsIcon.ZIndex = 6

-- لوحة القائمة (تظهر تحت الزر وتتحرك معه)
local MenuFrame = Instance.new("Frame")
MenuFrame.Name = "MenuFrame"
MenuFrame.Parent = MainBtn
MenuFrame.Size = UDim2.new(0, 200, 0, 320)
MenuFrame.Position = UDim2.new(0, -20, 1, 10)
MenuFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MenuFrame.Visible = false
MenuFrame.BorderSizePixel = 0
Instance.new("UICorner", MenuFrame).CornerRadius = UDim.new(0, 8)

-- // تحريك الزر (Dragging Logic)
local dragging, dragInput, dragStart, startPos
MainBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainBtn.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

MainBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- // Helper Functions for UI
local function AddToggle(text, callback)
    local Tgl = Instance.new("TextButton")
    Tgl.Size = UDim2.new(0, 180, 0, 35)
    Tgl.Parent = MenuFrame
    Tgl.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Tgl.Text = text .. ": OFF"
    Tgl.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", Tgl).CornerRadius = UDim.new(0, 5)
    
    local state = false
    Tgl.MouseButton1Click:Connect(function()
        state = not state
        Tgl.Text = text .. (state and ": ON" or ": OFF")
        Tgl.BackgroundColor3 = state and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(35, 35, 35)
        callback(state)
    end)
end

local function AddInput(label, placeholder, callback)
    local Container = Instance.new("Frame", MenuFrame)
    Container.Size = UDim2.new(0, 180, 0, 35)
    Container.BackgroundTransparency = 1
    
    local txtLabel = Instance.new("TextLabel", Container)
    txtLabel.Size = UDim2.new(0, 100, 1, 0)
    txtLabel.Text = label
    txtLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    txtLabel.BackgroundTransparency = 1
    
    local box = Instance.new("TextBox", Container)
    box.Size = UDim2.new(0, 70, 0, 25)
    box.Position = UDim2.new(0, 105, 0.2, 0)
    box.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    box.Text = ""
    box.PlaceholderText = placeholder
    box.TextColor3 = Color3.new(1, 1, 1)
    
    box.FocusLost:Connect(function()
        callback(tonumber(box.Text))
    end)
end

Instance.new("UIListLayout", MenuFrame).Padding = UDim.new(0, 5)

-- // تفعيل الميزات (Logic)

-- 1. السرعة والقفز (إصلاح مشكلة عدم الاشتغال)
RunService.Stepped:Connect(function()
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            if STampConfig.WalkSpeed > 16 then
                LocalPlayer.Character.Humanoid.WalkSpeed = STampConfig.WalkSpeed
            end
            if STampConfig.JumpPower > 50 then
                LocalPlayer.Character.Humanoid.JumpPower = STampConfig.JumpPower
                LocalPlayer.Character.Humanoid.UseJumpPower = true
            end
        end
    end)
end)

-- 2. الضرب المحيطي (Fast Attack)
task.spawn(function()
    while true do
        task.wait(0.2)
        if STampConfig.Enabled and STampConfig.FastAttack then
            pcall(function()
                local char = LocalPlayer.Character
                local tool = char:FindFirstChildOfClass("Tool")
                if tool then
                    -- جلب الأعداء واللاعبين القريبين
                    for _, target in pairs(workspace:GetDescendants()) do
                        if target:FindFirstChild("Humanoid") and target ~= char then
                            local root = target:FindFirstChild("HumanoidRootPart")
                            if root then
                                local distance = (root.Position - char.HumanoidRootPart.Position).Magnitude
                                if distance <= 25 then -- نطاق الضرر
                                    -- محاكاة الضرب
                                    game:GetService("VirtualUser"):ClickButton1(Vector2.new())
                                    local args = { [1] = root.Position, [2] = target }
                                    game:GetService("ReplicatedStorage").RigControllerEvent:FireServer("hit", unpack(args))
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- 3. تفعيل الأزرار والقوائم
MainBtn.MouseButton1Click:Connect(function()
    STampConfig.Enabled = not STampConfig.Enabled
    MainBtn.Text = STampConfig.Enabled and "STamPHub On" or "STamPHub Off"
    MainBtn.BackgroundColor3 = STampConfig.Enabled and Color3.fromRGB(40, 0, 0) or Color3.fromRGB(15, 15, 15)
    
    -- Aimbot Target Lock
    if STampConfig.Enabled then
        local maxDist = math.huge
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local d = (p.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if d < maxDist then
                    maxDist = d
                    STampConfig.Target = p.Character.HumanoidRootPart
                end
            end
        end
    else
        STampConfig.Target = nil
    end
end)

SettingsIcon.MouseButton1Click:Connect(function()
    STampConfig.MenuVisible = not STampConfig.MenuVisible
    MenuFrame.Visible = STampConfig.MenuVisible
end)

-- 4. ربط التبديلات (Toggles)
AddToggle("Inf Energy", function(v) STampConfig.InfEnergy = v end)
AddToggle("Fast Attack", function(v) STampConfig.FastAttack = v end)
AddToggle("Auto V3", function(v) STampConfig.AutoV3 = v end)
AddToggle("Auto V4", function(v) STampConfig.AutoV4 = v end)

AddInput("Speed Edit", "16-200", function(v) if v then STampConfig.WalkSpeed = v end end)
AddInput("Jump Edit", "50-500", function(v) if v then STampConfig.JumpPower = v end end)

-- 5. حلقة التحديث المستمر (Energy & Aimbot)
RunService.RenderStepped:Connect(function()
    if STampConfig.Enabled and STampConfig.Target then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, STampConfig.Target.Position)
    end
    
    if STampConfig.InfEnergy then
        pcall(function()
            local energy = LocalPlayer.Character:FindFirstChild("Energy") or LocalPlayer:FindFirstChild("Data"):FindFirstChild("Energy")
            if energy then energy.Value = 10000 end
        end)
    end
    
    if STampConfig.AutoV3 and STampConfig.Enabled then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ActivateAbility")
    end
end)

print("STamPHub V2 Loaded - Draggable & Fixed Functions")
