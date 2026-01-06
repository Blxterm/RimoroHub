-- [[ Blox Fruits Ultra Hub v3.0 ]]
-- Author: Anonymous (Enhanced by Gemini)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")

-- [[ الإعدادات الاحترافية ]]
_G.Settings = {
    -- Farming
    AutoFarm = false,
    AttackType = "Melee", -- "Melee" or "Sword"
    BringMob = true,
    FastAttack = true,
    AttackDelay = 0.1, -- سرعة الضربات
    FarmDistance = 8, -- المسافة بينك وبين الوحش
    
    -- Movement
    WalkSpeed = 50,
    TweenSpeed = 250,
    
    -- Stats
    AutoStats = false,
    StatPoints = "Melee",
    
    -- UI State
    GuiEnabled = true
}

-- [[ نظام المهمات الذكي - Smart Quest Logic ]]
local QuestList = {
    -- {Level, IslandName, QuestName, MobName, QuestNPC_CFrame}
    {1, "Starter Island", "BanditQuest1", "Bandit", CFrame.new(1059, 15, 1549)},
    {10, "Jungle", "MonkeyQuest1", "Monkey", CFrame.new(-1598, 35, 153)},
    {30, "Jungle", "GorillaQuest1", "Gorilla", CFrame.new(-1598, 35, 153)},
    -- يمكنك إضافة باقي الجزر هنا بنفس التنسيق
}

local function GetMyQuest()
    local myLevel = player.Data.Level.Value
    local best = QuestList[1]
    for _, v in pairs(QuestList) do
        if myLevel >= v[1] then
            best = v
        end
    end
    return best
end

-- [[ نظام الحركة (Tween) ]]
local function DirectTween(targetCFrame)
    local dist = (player.Character.HumanoidRootPart.Position - targetCFrame.Position).Magnitude
    local info = TweenInfo.new(dist / _G.Settings.TweenSpeed, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(player.Character.HumanoidRootPart, info, {CFrame = targetCFrame})
    tween:Play()
    return tween
end

-- [[ نظام الهجوم المطور (Fast Attack) ]]
local function Attack()
    local VirtualUser = game:GetService("VirtualUser")
    VirtualUser:CaptureController()
    VirtualUser:Button1Down(Vector2.new(0,0))
end

-- [[ إنشاء الواجهة الرسومية ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltraHub"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 400)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- شريط العناوين
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Text = "PREMIUM BLOX FRUITS HUB - v3.0"
Title.Size = UDim2.new(1, 0, 1, 0)
Title.TextColor3 = Color3.fromRGB(0, 255, 200)
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1
Title.Parent = TopBar

-- قائمة التبويبات (يسار)
local SideBar = Instance.new("Frame")
SideBar.Size = UDim2.new(0, 130, 1, -40)
SideBar.Position = UDim2.new(0, 0, 0, 40)
SideBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
SideBar.Parent = MainFrame

-- حاوية الصفحات
local Pages = Instance.new("Frame")
Pages.Size = UDim2.new(1, -140, 1, -50)
Pages.Position = UDim2.new(0, 135, 0, 45)
Pages.BackgroundTransparency = 1
Pages.Parent = MainFrame

-- [ قسم التلفيل - Leveling Section ]
local LevelPage = Instance.new("ScrollingFrame")
LevelPage.Size = UDim2.new(1, 0, 1, 0)
LevelPage.BackgroundTransparency = 1
LevelPage.CanvasSize = UDim2.new(0, 0, 1.5, 0)
LevelPage.Visible = true
LevelPage.Parent = Pages

local UIList = Instance.new("UIListLayout")
UIList.Parent = LevelPage
UIList.Padding = UDim.new(0, 10)

-- زر تفعيل الاوتو فارم
local ToggleFarm = Instance.new("TextButton")
ToggleFarm.Size = UDim2.new(0.9, 0, 0, 40)
ToggleFarm.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
ToggleFarm.Text = "Auto Farm: OFF"
ToggleFarm.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleFarm.Parent = LevelPage

-- اختيار السلاح
local SelectWeapon = Instance.new("TextButton")
SelectWeapon.Size = UDim2.new(0.9, 0, 0, 40)
SelectWeapon.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
SelectWeapon.Text = "Weapon: Melee"
SelectWeapon.TextColor3 = Color3.fromRGB(255, 255, 255)
SelectWeapon.Parent = LevelPage

-- تعديل سرعة الضربات (Slider بسيط)
local SpeedTitle = Instance.new("TextLabel")
SpeedTitle.Size = UDim2.new(0.9, 0, 0, 20)
SpeedTitle.Text = "Attack Delay: " .. _G.Settings.AttackDelay
SpeedTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
SpeedTitle.BackgroundTransparency = 1
SpeedTitle.Parent = LevelPage

-- قسم تطوير الخصائص (Auto Stats)
local StatToggle = Instance.new("TextButton")
StatToggle.Size = UDim2.new(0.9, 0, 0, 40)
StatToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
StatToggle.Text = "Auto Stats (Melee): OFF"
StatToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
StatToggle.Parent = LevelPage

-- [ قسم الحركة والسرعة ]
local ConfigPage = Instance.new("Frame")
ConfigPage.Size = UDim2.new(1, 0, 1, 0)
ConfigPage.BackgroundTransparency = 1
ConfigPage.Visible = false
ConfigPage.Parent = Pages

local SpeedInput = Instance.new("TextBox")
SpeedInput.Size = UDim2.new(0.9, 0, 0, 40)
SpeedInput.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
SpeedInput.PlaceholderText = "Enter WalkSpeed (Default 50)"
SpeedInput.Text = ""
SpeedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedInput.Parent = ConfigPage

-- [[ المنطق البرمجي للوظائف - The Logic ]]

-- تفعيل الاوتو فارم
ToggleFarm.MouseButton1Click:Connect(function()
    _G.Settings.AutoFarm = not _G.Settings.AutoFarm
    ToggleFarm.Text = _G.Settings.AutoFarm and "Auto Farm: ON" or "Auto Farm: OFF"
    ToggleFarm.BackgroundColor3 = _G.Settings.AutoFarm and Color3.fromRGB(0, 150, 80) or Color3.fromRGB(40, 40, 50)
end)

-- تبديل السلاح
SelectWeapon.MouseButton1Click:Connect(function()
    if _G.Settings.AttackType == "Melee" then
        _G.Settings.AttackType = "Sword"
    else
        _G.Settings.AttackType = "Melee"
    end
    SelectWeapon.Text = "Weapon: " .. _G.Settings.AttackType
end)

-- حلقة الـ Auto Farm الرئيسية
task.spawn(function()
    while task.wait() do
        if _G.Settings.AutoFarm then
            pcall(function()
                local q = GetMyQuest()
                -- التحقق من وجود مهمة
                if not player.PlayerGui.Main:FindFirstChild("Quest") then
                    DirectTween(q[5]) -- الذهاب للـ NPC
                    task.wait(0.5)
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", q[3], 1)
                else
                    -- البحث عن الوحوش
                    local targetMob = nil
                    for _, v in pairs(workspace.Enemies:GetChildren()) do
                        if v.Name == q[4] and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                            targetMob = v
                            break
                        end
                    end
                    
                    if targetMob then
                        -- تجهيز السلاح المختار
                        local tool = player.Backpack:FindFirstChild(_G.Settings.AttackType) or player.Character:FindFirstChild(_G.Settings.AttackType)
                        if tool then player.Character.Humanoid:EquipTool(tool) end
                        
                        -- القتال
                        repeat
                            task.wait(_G.Settings.AttackDelay)
                            -- تجميع الوحوش القريبة
                            if _G.Settings.BringMob then
                                for _, m in pairs(workspace.Enemies:GetChildren()) do
                                    if m.Name == q[4] and m:FindFirstChild("HumanoidRootPart") then
                                        m.HumanoidRootPart.CFrame = targetMob.HumanoidRootPart.CFrame
                                        m.HumanoidRootPart.CanCollide = false
                                        m.Humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOn
                                    end
                                end
                            end
                            
                            -- وضعية اللاعب (خلف/فوق الوحش) لضمان الضرب
                            player.Character.HumanoidRootPart.CFrame = targetMob.HumanoidRootPart.CFrame * CFrame.new(0, _G.Settings.FarmDistance, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                            Attack()
                        until not _G.Settings.AutoFarm or targetMob.Humanoid.Health <= 0 or not targetMob.Parent
                    else
                        -- الانتقال لمكان الوحوش إذا لم يظهروا
                        DirectTween(q[5] * CFrame.new(0, 100, 0))
                    end
                end
            end)
        end
    end
end)

-- حلقة تطوير الخصائص
task.spawn(function()
    while task.wait(1) do
        if _G.Settings.AutoStats then
            ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", _G.Settings.StatPoints, 1)
        end
    end
end)

-- تحديث السرعة (WalkSpeed)
SpeedInput.FocusLost:Connect(function()
    local val = tonumber(SpeedInput.Text)
    if val then
        _G.Settings.WalkSpeed = val
    end
end)

RunService.Heartbeat:Connect(function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = _G.Settings.WalkSpeed
    end
end)

-- إخفاء/إظهار الواجهة
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F5 then
        _G.Settings.GuiEnabled = not _G.Settings.GuiEnabled
        MainFrame.Visible = _G.Settings.GuiEnabled
    end
end)

print("Hub Loaded! Auto Quest, Fast Attack, and Mob Bring Active.")
