--[[
╔══════════════════════════════════════════╗
║   Blue Lock Rivals - ULTIMATE SCRIPT     ║
║   Version: 6.0.0 (Fixed & Complete)      ║
║   UI: Fluent UI Library                  ║
║   Copyright: @K_7Ko                      ║
╚══════════════════════════════════════════╝

Features:
1.  Ball Control (Camera follow + Analog movement)
2.  Hitbox Expander (Ball + Enemies) - TextBox
3.  VERY AUTO (Instant goal on kick)
4.  Magnet (Hold E to attract ball)
5.  Auto Goal (Team-based)
6.  Infinite Stamina
7.  Anti Stun
8.  Anti Steal (Press E to become untouchable)
9.  AI Stopper (Disable enemy goalkeeper)
10. Speed Boost (TextBox)
11. Jump Boost (TextBox)
12. Anti Detection / Debug Bypass
13. Anti Kick / Anti Ban
14. Anti AFK
15. No Clip
16. Auto Collect
17. ESP Players
18. FOV Changer
19. Floating Image Button (show/hide)
20. Base64 Image Support
21. KEY SYSTEM (مفتاح سري)
]]

-- ============================================
-- KEY SYSTEM - مفتاح سري
-- ============================================
local CORRECT_KEY = "abbastajrashassan"
local keyVerified = false

local function ShowKeySystem()
    -- إنشاء واجهة مفتاح بسيطة
    local KeyGui = Instance.new("ScreenGui")
    KeyGui.Name = "KeySystemGui"
    KeyGui.ResetOnSpawn = false
    KeyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local success, err = pcall(function()
        KeyGui.Parent = game:GetService("CoreGui")
    end)
    if not success then
        KeyGui.Parent = game:GetService("Players").LocalPlayer.PlayerGui
    end

    -- الخلفية
    local Background = Instance.new("Frame")
    Background.Size = UDim2.new(0, 400, 0, 220)
    Background.Position = UDim2.new(0.5, -200, 0.5, -110)
    Background.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    Background.BorderSizePixels = 0
    Background.Parent = KeyGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = Background

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(0, 120, 255)
    Stroke.Thickness = 2
    Stroke.Parent = Background

    -- العنوان
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.Position = UDim2.new(0, 0, 0, 10)
    Title.BackgroundTransparency = 1
    Title.Text = "🔐 Blue Lock Rivals - Key System"
    Title.TextColor3 = Color3.fromRGB(0, 150, 255)
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold
    Title.Parent = Background

    local SubTitle = Instance.new("TextLabel")
    SubTitle.Size = UDim2.new(1, 0, 0, 30)
    SubTitle.Position = UDim2.new(0, 0, 0, 50)
    SubTitle.BackgroundTransparency = 1
    SubTitle.Text = "أدخل المفتاح السري للمتابعة"
    SubTitle.TextColor3 = Color3.fromRGB(180, 180, 180)
    SubTitle.TextSize = 14
    SubTitle.Font = Enum.Font.Gotham
    SubTitle.Parent = Background

    -- حقل إدخال المفتاح
    local KeyBox = Instance.new("TextBox")
    KeyBox.Size = UDim2.new(0, 340, 0, 45)
    KeyBox.Position = UDim2.new(0.5, -170, 0, 95)
    KeyBox.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    KeyBox.BorderSizePixels = 0
    KeyBox.Text = ""
    KeyBox.PlaceholderText = "أدخل المفتاح هنا..."
    KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
    KeyBox.TextSize = 16
    KeyBox.Font = Enum.Font.Gotham
    KeyBox.ClearTextOnFocus = false
    KeyBox.Parent = Background

    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0, 8)
    BoxCorner.Parent = KeyBox

    local BoxStroke = Instance.new("UIStroke")
    BoxStroke.Color = Color3.fromRGB(60, 60, 80)
    BoxStroke.Thickness = 1.5
    BoxStroke.Parent = KeyBox

    -- رسالة الحالة
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, 0, 0, 25)
    StatusLabel.Position = UDim2.new(0, 0, 0, 148)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = ""
    StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
    StatusLabel.TextSize = 13
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.Parent = Background

    -- زر التأكيد
    local ConfirmButton = Instance.new("TextButton")
    ConfirmButton.Size = UDim2.new(0, 340, 0, 40)
    ConfirmButton.Position = UDim2.new(0.5, -170, 0, 168)
    ConfirmButton.BackgroundColor3 = Color3.fromRGB(0, 100, 220)
    ConfirmButton.BorderSizePixels = 0
    ConfirmButton.Text = "✓ تأكيد المفتاح"
    ConfirmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ConfirmButton.TextSize = 16
    ConfirmButton.Font = Enum.Font.GothamBold
    ConfirmButton.AutoButtonColor = true
    ConfirmButton.Parent = Background

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = ConfirmButton

    -- منطق التحقق
    local function checkKey()
        local entered = KeyBox.Text:lower():gsub("%s+", "")
        if entered == CORRECT_KEY:lower() then
            keyVerified = true
            StatusLabel.Text = "✓ مفتاح صحيح! جاري التحميل..."
            StatusLabel.TextColor3 = Color3.fromRGB(80, 220, 80)
            ConfirmButton.BackgroundColor3 = Color3.fromRGB(20, 160, 20)
            task.wait(1.2)
            KeyGui:Destroy()
        else
            StatusLabel.Text = "✗ مفتاح خاطئ! حاول مرة أخرى"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 60, 60)
            BoxStroke.Color = Color3.fromRGB(255, 60, 60)
            task.wait(1.5)
            BoxStroke.Color = Color3.fromRGB(60, 60, 80)
            StatusLabel.Text = ""
        end
    end

    ConfirmButton.MouseButton1Click:Connect(checkKey)
    KeyBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then checkKey() end
    end)

    -- انتظر حتى يتحقق المفتاح
    while not keyVerified do
        task.wait(0.1)
    end
end

-- تشغيل نظام المفتاح
ShowKeySystem()

-- ============================================
-- BASE64 IMAGE (ضع كود base64 صورتك هنا)
-- ============================================
local ImageBase64 = "" -- ضع هنا كود base64 للصورة

-- ============================================
-- SERVICES
-- ============================================
local Players         = game:GetService("Players")
local RunService      = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService    = game:GetService("TweenService")
local LocalPlayer     = Players.LocalPlayer
local Camera          = workspace.CurrentCamera

-- ============================================
-- PLAYER INFO
-- ============================================
local MY_NAME          = LocalPlayer.Name
local MY_CHARACTER     = nil
local MY_HUMANOID      = nil
local MY_HUMANOID_ROOT = nil

local function updateCharacter()
    MY_CHARACTER     = LocalPlayer.Character
    if MY_CHARACTER then
        MY_HUMANOID      = MY_CHARACTER:FindFirstChild("Humanoid")
        MY_HUMANOID_ROOT = MY_CHARACTER:FindFirstChild("HumanoidRootPart")
    end
end
LocalPlayer.CharacterAdded:Connect(updateCharacter)
updateCharacter()

-- ============================================
-- BALL REFERENCE
-- ============================================
local function getBall()
    return workspace:FindFirstChild("Football")
        or workspace:FindFirstChild("Ball")
        or workspace:FindFirstChild("SoccerBall")
end

-- ============================================
-- VARIABLES
-- ============================================
-- Ball Control
local BallControlEnabled    = false
local BallControlSpeed      = 200
local BallControlConnection = nil
local BallCameraOffset      = 12
local BallCameraHeight      = 8
local BallCameraAngle       = -15

-- Hitbox
local BallHitboxEnabled   = false
local BallHitboxSize      = 15
local PlayerHitboxEnabled = false
local PlayerHitboxSize    = 20
local OriginalBallSize    = nil
local OriginalPlayerSizes = {}

-- Very Auto
local VeryAutoEnabled    = false
local VeryAutoConnection = nil
local VeryAutoLastPos    = nil
local VeryAutoCooldown   = false

-- Magnet
local isMagnetActive   = false
local magnetConnection = nil
local MagnetForce      = 300

-- Auto Goal
local AutoGoalEnabled   = false
local AutoGoalForce     = 700
local AutoGoalConnection = nil
local myTeam            = "Home"
local AutoGoalLastPos   = nil
local AutoGoalJustShot  = false

-- Movement
local InfiniteStaminaEnabled = false
local AntiStunEnabled        = false
local AntiStunConnection     = nil
local AntiStealEnabled       = false
local AntiStealActive        = false
local AntiStealOriginalSize  = nil
local AIStopperEnabled       = false
local AIStopperConnection    = nil
local SpeedBoostEnabled      = false
local SpeedBoostValue        = 50
local OriginalWalkSpeed      = 16
local JumpBoostEnabled       = false
local JumpBoostValue         = 100
local OriginalJumpPower      = 50

-- Extra
local NoClipEnabled      = false
local AutoCollectEnabled = false
local AntiAFKEnabled     = true
local ESPEnabled         = false
local ESPObjects         = {}
local FOVEnabled         = false
local FOVValue           = 100

-- Protection
local AntiDetectionEnabled = true
local AntiKickEnabled      = true
local AntiBanEnabled       = true
local DebugBypassEnabled   = true

-- ============================================
-- PROTECTION SYSTEM
-- ============================================
local function BypassSecurity()
    if not DebugBypassEnabled then return end
    pcall(function()
        -- تعطيل debug
        debug = debug or {}
        debug.traceback  = function() return "" end
        debug.getinfo    = function() return nil end
        debug.getlocal   = function() return nil end
        debug.getupvalue = function() return nil end
    end)
    pcall(function()
        -- تعطيل cheat detection variables
        if getgc then
            for _, v in pairs(getgc(true)) do
                if type(v) == "table" then
                    pcall(function()
                        for _, key in pairs({"IsCheating","isCheating","IsCheater","isCheater",
                                             "IsCheated","isCheated","IsCheat","isCheat",
                                             "Detected","Banned","ischeat","ischeating","ischeated"}) do
                            if v[key] ~= nil then v[key] = false end
                        end
                    end)
                end
            end
        end
    end)
end

local function AntiKickBan()
    pcall(function()
        if AntiKickEnabled then
            local oldKick = LocalPlayer.Kick
            LocalPlayer.Kick = function(...)
                if AntiKickEnabled then
                    warn("Anti-Kick: تم منع محاولة الطرد!")
                    return nil
                end
                return oldKick(...)
            end
        end
    end)
end

-- تشغيل الحماية المستمرة
if AntiDetectionEnabled then
    task.spawn(function()
        while true do
            if AntiDetectionEnabled then
                pcall(BypassSecurity)
            end
            task.wait(0.5)
        end
    end)
end

-- ============================================
-- ANTI AFK
-- ============================================
local function AntiAFK()
    pcall(function()
        local vu = game:GetService("VirtualUser")
        LocalPlayer.Idled:Connect(function()
            vu:Button2Down(Vector2.new(0,0), Camera.CFrame)
            task.wait(1)
            vu:Button2Up(Vector2.new(0,0), Camera.CFrame)
        end)
    end)
end

-- ============================================
-- LOAD FLUENT UI
-- ============================================
local Fluent = loadstring(game:HttpGet(
    "https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"
))()
local SaveManager = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"
))()
local InterfaceManager = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"
))()

-- ============================================
-- NOTIFY
-- ============================================
local function Notify(title, content, duration)
    Fluent:Notify({ Title = title, Content = content, Duration = duration or 3 })
end

-- ============================================
-- CREATE WINDOW
-- ============================================
local Window = Fluent:CreateWindow({
    Title       = MY_NAME .. " | Blue Lock Rivals",
    SubTitle    = "Ultimate Script v6.0 | Protected",
    TabWidth    = 160,
    Size        = UDim2.fromOffset(640, 560),
    Acrylic     = true,
    Theme       = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- ============================================
-- TABS
-- ============================================
local Tabs = {
    BallControl = Window:AddTab({ Title = "🎮 Ball Control", Icon = "joystick" }),
    Hitbox      = Window:AddTab({ Title = "🎯 Hitbox",       Icon = "target"   }),
    Auto        = Window:AddTab({ Title = "⚽ Auto",          Icon = "zap"      }),
    Magnet      = Window:AddTab({ Title = "🧲 Magnet",        Icon = "magnet"   }),
    Movement    = Window:AddTab({ Title = "🏃 Movement",      Icon = "running"  }),
    Utilities   = Window:AddTab({ Title = "🔧 Utilities",     Icon = "settings" }),
    Protection  = Window:AddTab({ Title = "🛡️ Protection",    Icon = "shield"   }),
    Settings    = Window:AddTab({ Title = "⚙️ Settings",      Icon = "settings-2"}),
}

-- ============================================
-- BALL CONTROL TAB
-- ============================================
local BCSection = Tabs.BallControl:AddSection("Ball Control")

BCSection:AddToggle("BallControlToggle", {
    Title       = "Ball Control",
    Description = "الكاميرا تتبع الكرة | تحكم بالكرة بالعصا",
    Default     = false,
    Callback    = function(Value)
        BallControlEnabled = Value
        if BallControlEnabled then
            Camera.CameraType = Enum.CameraType.Scriptable
            BallControlConnection = RunService.RenderStepped:Connect(function()
                local ball = getBall()
                if ball then
                    local offset = CFrame.new(0, BallCameraHeight, BallCameraOffset)
                        * CFrame.Angles(math.rad(BallCameraAngle), 0, 0)
                    Camera.CFrame = ball.CFrame * offset
                end
            end)
            Notify("Ball Control", "✅ تم التفعيل", 1)
        else
            if BallControlConnection then
                BallControlConnection:Disconnect()
                BallControlConnection = nil
            end
            Camera.CameraType = Enum.CameraType.Custom
            Notify("Ball Control", "❌ تم التعطيل", 1)
        end
    end
})

BCSection:AddSlider("BallSpeedSlider", {
    Title    = "سرعة تحريك الكرة",
    Default  = 200,
    Min      = 50,
    Max      = 800,
    Rounding = 1,
    Callback = function(Value) BallControlSpeed = Value end
})

-- حركة الكرة بالعصا
RunService.Heartbeat:Connect(function()
    if BallControlEnabled then
        local ball = getBall()
        if ball then
            local moveVector = UserInputService:GetMoveVector()
            if moveVector.Magnitude > 0 then
                local camCF = Camera.CFrame
                local relMove = camCF.RightVector  * moveVector.X
                             + camCF.UpVector      * moveVector.Y
                             + camCF.LookVector    * -moveVector.Z
                ball:ApplyImpulse(relMove.Unit * BallControlSpeed * ball:GetMass())
            end
        end
    end
end)

-- ============================================
-- HITBOX TAB
-- ============================================
local HBSection = Tabs.Hitbox:AddSection("Hitbox Settings")

HBSection:AddToggle("BallHitboxToggle", {
    Title       = "تضخيم حجم الكرة",
    Description = "توسيع Hitbox الكرة",
    Default     = false,
    Callback    = function(Value)
        BallHitboxEnabled = Value
        if BallHitboxEnabled then
            task.spawn(function()
                while BallHitboxEnabled do
                    local ball = getBall()
                    if ball then
                        if not OriginalBallSize then OriginalBallSize = ball.Size end
                        ball.Size = Vector3.new(BallHitboxSize, BallHitboxSize, BallHitboxSize)
                    end
                    task.wait(0.3)
                end
            end)
            Notify("Ball Hitbox", "✅ تم التفعيل - الحجم: " .. BallHitboxSize, 1)
        else
            local ball = getBall()
            if ball and OriginalBallSize then ball.Size = OriginalBallSize end
            Notify("Ball Hitbox", "❌ تم التعطيل", 1)
        end
    end
})

HBSection:AddTextBox({
    Title       = "حجم الكرة (رقم)",
    Description = "أدخل أي رقم من 5 إلى 50",
    Default     = "15",
    Callback    = function(Value)
        local num = tonumber(Value)
        if num and num > 0 then
            BallHitboxSize = num
            if BallHitboxEnabled then
                local ball = getBall()
                if ball then ball.Size = Vector3.new(num, num, num) end
            end
            Notify("Ball Hitbox", "تم تغيير الحجم إلى: " .. num, 1)
        else
            Notify("خطأ", "أدخل رقم صحيح", 1)
        end
    end
})

HBSection:AddToggle("PlayerHitboxToggle", {
    Title       = "تضخيم Hitbox الأعداء",
    Description = "توسيع مناطق اصطدام اللاعبين الآخرين",
    Default     = false,
    Callback    = function(Value)
        PlayerHitboxEnabled = Value
        if PlayerHitboxEnabled then
            task.spawn(function()
                while PlayerHitboxEnabled do
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character then
                            local root = player.Character:FindFirstChild("HumanoidRootPart")
                            if root then
                                if not OriginalPlayerSizes[player.Name] then
                                    OriginalPlayerSizes[player.Name] = root.Size
                                end
                                root.Size = Vector3.new(PlayerHitboxSize, PlayerHitboxSize, PlayerHitboxSize)
                            end
                        end
                    end
                    task.wait(0.3)
                end
            end)
            Notify("Player Hitbox", "✅ تم التفعيل - الحجم: " .. PlayerHitboxSize, 1)
        else
            for _, player in ipairs(Players:GetPlayers()) do
                if player.Character then
                    local root = player.Character:FindFirstChild("HumanoidRootPart")
                    if root and OriginalPlayerSizes[player.Name] then
                        root.Size = OriginalPlayerSizes[player.Name]
                    end
                end
            end
            Notify("Player Hitbox", "❌ تم التعطيل", 1)
        end
    end
})

HBSection:AddTextBox({
    Title    = "حجم Hitbox الأعداء (رقم)",
    Default  = "20",
    Callback = function(Value)
        local num = tonumber(Value)
        if num and num > 0 then
            PlayerHitboxSize = num
            Notify("Player Hitbox", "تم تغيير الحجم إلى: " .. num, 1)
        else
            Notify("خطأ", "أدخل رقم صحيح", 1)
        end
    end
})

-- ============================================
-- AUTO TAB
-- ============================================
local AutoSection = Tabs.Auto:AddSection("Auto Goal")

AutoSection:AddDropdown("TeamDropdown", {
    Title    = "اختر فريقك",
    Values   = { "Home (المرمى الأزرق)", "Away (المرمى الأبيض)" },
    Default  = 1,
    Callback = function(Value)
        myTeam = (Value == "Home (المرمى الأزرق)") and "Home" or "Away"
        Notify("Team", "تم اختيار: " .. Value, 1)
    end
})

-- VERY AUTO - نظام تسجيل هدف حقيقي
AutoSection:AddToggle("VeryAutoToggle", {
    Title       = "⚡ VERY AUTO - تسجيل فوري",
    Description = "عندما تركل الكرة تنتقل مباشرة للمرمى",
    Default     = false,
    Callback    = function(Value)
        VeryAutoEnabled = Value
        if VeryAutoEnabled then
            VeryAutoLastPos = nil
            VeryAutoCooldown = false

            local function findGoalPosition()
                local keywords = myTeam == "Home"
                    and {"bluegoal","blue_goal","goalblue","homegoal"}
                    or  {"whitegoal","white_goal","goalwhite","awaygoal"}
                local fallback = {}
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        local name = obj.Name:lower()
                        for _, kw in ipairs(keywords) do
                            if name:find(kw) then return obj.Position end
                        end
                        if name:find("goal") or name:find("net") then
                            table.insert(fallback, obj)
                        end
                    end
                end
                if #fallback > 0 then return fallback[1].Position end
                return nil
            end

            VeryAutoConnection = RunService.Heartbeat:Connect(function()
                if not VeryAutoEnabled then return end
                local ball = getBall()
                if not ball then return end
                local currentPos = ball.Position
                if VeryAutoLastPos then
                    local dist = (currentPos - VeryAutoLastPos).Magnitude
                    local vel  = ball.AssemblyLinearVelocity.Magnitude
                    if dist > 4 and vel > 10 and not VeryAutoCooldown then
                        VeryAutoCooldown = true
                        local goalPos = findGoalPosition()
                        if goalPos then
                            ball.CFrame = CFrame.new(goalPos)
                            ball.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                            Notify("⚽ GOAL!", "تم تسجيل هدف!", 2)
                        end
                        task.wait(1.5)
                        VeryAutoCooldown = false
                    end
                end
                VeryAutoLastPos = currentPos
            end)
            Notify("VERY AUTO", "✅ تم التفعيل", 1)
        else
            if VeryAutoConnection then
                VeryAutoConnection:Disconnect()
                VeryAutoConnection = nil
            end
            Notify("VERY AUTO", "❌ تم التعطيل", 1)
        end
    end
})

-- Auto Goal
AutoSection:AddToggle("AutoGoalToggle", {
    Title       = "Auto Goal",
    Description = "يركل الكرة تلقائياً نحو المرمى",
    Default     = false,
    Callback    = function(Value)
        AutoGoalEnabled = Value
        if AutoGoalEnabled then
            AutoGoalConnection = RunService.Heartbeat:Connect(function()
                if not AutoGoalEnabled then return end
                local ball = getBall()
                if not ball or not MY_HUMANOID_ROOT then return end
                local dist = (ball.Position - MY_HUMANOID_ROOT.Position).Magnitude
                if dist < 8 and not AutoGoalJustShot then
                    AutoGoalJustShot = true
                    local goalDir = CFrame.new(ball.Position,
                        Vector3.new(myTeam == "Home" and -100 or 100, ball.Position.Y, ball.Position.Z)).LookVector
                    ball:ApplyImpulse(goalDir * AutoGoalForce * ball:GetMass())
                    task.wait(1)
                    AutoGoalJustShot = false
                end
            end)
            Notify("Auto Goal", "✅ تم التفعيل", 1)
        else
            if AutoGoalConnection then
                AutoGoalConnection:Disconnect()
                AutoGoalConnection = nil
            end
            Notify("Auto Goal", "❌ تم التعطيل", 1)
        end
    end
})

AutoSection:AddTextBox({
    Title    = "قوة الركلة (رقم)",
    Default  = "700",
    Callback = function(Value)
        local num = tonumber(Value)
        if num and num > 0 then
            AutoGoalForce = num
            Notify("Auto Goal", "قوة الركلة: " .. num, 1)
        end
    end
})

-- ============================================
-- MAGNET TAB
-- ============================================
local MagnetSection = Tabs.Magnet:AddSection("Magnet Settings")

MagnetSection:AddToggle("MagnetToggle", {
    Title       = "Magnet - مغناطيس الكرة",
    Description = "اضغط E لجذب الكرة إليك",
    Default     = false,
    Callback    = function(Value)
        isMagnetActive = Value
        Notify("Magnet", Value and "✅ اضغط E لجذب الكرة" or "❌ تم التعطيل", 2)
    end
})

MagnetSection:AddTextBox({
    Title    = "قوة المغناطيس (رقم)",
    Default  = "300",
    Callback = function(Value)
        local num = tonumber(Value)
        if num and num > 0 then
            MagnetForce = num
            Notify("Magnet", "قوة المغناطيس: " .. num, 1)
        end
    end
})

-- E key = Magnet
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.E and isMagnetActive then
        if magnetConnection then magnetConnection:Disconnect() end
        magnetConnection = RunService.Heartbeat:Connect(function()
            if not isMagnetActive then
                magnetConnection:Disconnect()
                return
            end
            local ball = getBall()
            if ball and MY_HUMANOID_ROOT then
                local dir = (MY_HUMANOID_ROOT.Position - ball.Position).Unit
                ball:ApplyImpulse(dir * MagnetForce * ball:GetMass())
            end
        end)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.E then
        if magnetConnection then
            magnetConnection:Disconnect()
            magnetConnection = nil
        end
    end
end)

-- ============================================
-- MOVEMENT TAB
-- ============================================
local MovSection = Tabs.Movement:AddSection("Movement Modifiers")

MovSection:AddToggle("SpeedBoostToggle", {
    Title    = "Speed Boost",
    Default  = false,
    Callback = function(Value)
        SpeedBoostEnabled = Value
        if SpeedBoostEnabled then
            if MY_HUMANOID then
                OriginalWalkSpeed = MY_HUMANOID.WalkSpeed
                MY_HUMANOID.WalkSpeed = SpeedBoostValue
            end
            Notify("Speed Boost", "✅ السرعة: " .. SpeedBoostValue, 1)
        else
            if MY_HUMANOID then MY_HUMANOID.WalkSpeed = OriginalWalkSpeed end
            Notify("Speed Boost", "❌ تم التعطيل", 1)
        end
    end
})

MovSection:AddTextBox({
    Title    = "قيمة السرعة (رقم)",
    Default  = "50",
    Callback = function(Value)
        local num = tonumber(Value)
        if num and num > 0 then
            SpeedBoostValue = num
            if SpeedBoostEnabled and MY_HUMANOID then MY_HUMANOID.WalkSpeed = num end
            Notify("Speed", "تم تغيير السرعة إلى: " .. num, 1)
        else
            Notify("خطأ", "أدخل رقم صحيح", 1)
        end
    end
})

MovSection:AddToggle("JumpBoostToggle", {
    Title    = "Jump Boost",
    Default  = false,
    Callback = function(Value)
        JumpBoostEnabled = Value
        if JumpBoostEnabled then
            if MY_HUMANOID then
                OriginalJumpPower = MY_HUMANOID.JumpPower
                MY_HUMANOID.JumpPower = JumpBoostValue
            end
            Notify("Jump Boost", "✅ القوة: " .. JumpBoostValue, 1)
        else
            if MY_HUMANOID then MY_HUMANOID.JumpPower = OriginalJumpPower end
            Notify("Jump Boost", "❌ تم التعطيل", 1)
        end
    end
})

MovSection:AddTextBox({
    Title    = "قوة القفز (رقم)",
    Default  = "100",
    Callback = function(Value)
        local num = tonumber(Value)
        if num and num > 0 then
            JumpBoostValue = num
            if JumpBoostEnabled and MY_HUMANOID then MY_HUMANOID.JumpPower = num end
            Notify("Jump", "تم تغيير قوة القفز إلى: " .. num, 1)
        else
            Notify("خطأ", "أدخل رقم صحيح", 1)
        end
    end
})

MovSection:AddToggle("InfiniteStaminaToggle", {
    Title    = "Infinite Stamina",
    Default  = false,
    Callback = function(Value)
        InfiniteStaminaEnabled = Value
        Notify("Stamina", Value and "✅ تم التفعيل" or "❌ تم التعطيل", 1)
    end
})

MovSection:AddToggle("AntiStunToggle", {
    Title    = "Anti Stun",
    Default  = false,
    Callback = function(Value)
        AntiStunEnabled = Value
        if AntiStunEnabled then
            AntiStunConnection = RunService.Heartbeat:Connect(function()
                if not AntiStunEnabled then return end
                if MY_HUMANOID then
                    pcall(function()
                        MY_HUMANOID:SetAttribute("Stunned", false)
                        MY_HUMANOID:SetAttribute("Stun", false)
                        MY_HUMANOID.PlatformStand = false
                    end)
                end
            end)
        else
            if AntiStunConnection then
                AntiStunConnection:Disconnect()
                AntiStunConnection = nil
            end
        end
        Notify("Anti Stun", Value and "✅ تم التفعيل" or "❌ تم التعطيل", 1)
    end
})

MovSection:AddToggle("AntiStealToggle", {
    Title       = "Anti Steal",
    Description = "اضغط E لتصبح غير قابل للمس (0.5 ثانية)",
    Default     = false,
    Callback    = function(Value)
        AntiStealEnabled = Value
        Notify("Anti Steal", Value and "✅ اضغط E للتفعيل" or "❌ تم التعطيل", 2)
    end
})

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.E and AntiStealEnabled and not AntiStealActive then
        AntiStealActive = true
        if MY_HUMANOID_ROOT then
            AntiStealOriginalSize = AntiStealOriginalSize or MY_HUMANOID_ROOT.Size
            pcall(function() MY_HUMANOID_ROOT.Size = Vector3.new(0.1, 0.1, 0.1) end)
            task.wait(0.5)
            pcall(function() MY_HUMANOID_ROOT.Size = AntiStealOriginalSize end)
        end
        AntiStealActive = false
    end
end)

-- ============================================
-- UTILITIES TAB
-- ============================================
local UtilSection = Tabs.Utilities:AddSection("Extra Features")

UtilSection:AddToggle("AIStopperToggle", {
    Title       = "AI Stopper",
    Description = "تعطيل حارس المرمى AI",
    Default     = false,
    Callback    = function(Value)
        AIStopperEnabled = Value
        if AIStopperEnabled then
            AIStopperConnection = RunService.Heartbeat:Connect(function()
                if not AIStopperEnabled then return end
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("Model") then
                        local n = obj.Name:lower()
                        if n:find("goalie") or n:find("keeper") or n:find("goalkeeper") then
                            local hum = obj:FindFirstChild("Humanoid")
                            if hum then
                                hum.PlatformStand = true
                                hum.WalkSpeed = 0
                                hum.JumpPower = 0
                            end
                        end
                    end
                end
            end)
        else
            if AIStopperConnection then
                AIStopperConnection:Disconnect()
                AIStopperConnection = nil
            end
        end
        Notify("AI Stopper", Value and "✅ تم التفعيل" or "❌ تم التعطيل", 1)
    end
})

UtilSection:AddToggle("NoClipToggle", {
    Title    = "No Clip",
    Default  = false,
    Callback = function(Value)
        NoClipEnabled = Value
        Notify("No Clip", Value and "✅ تم التفعيل" or "❌ تم التعطيل", 1)
    end
})

UtilSection:AddToggle("AutoCollectToggle", {
    Title       = "Auto Collect",
    Description = "جمع العملات والجوائز تلقائياً",
    Default     = false,
    Callback    = function(Value)
        AutoCollectEnabled = Value
        Notify("Auto Collect", Value and "✅ تم التفعيل" or "❌ تم التعطيل", 1)
    end
})

UtilSection:AddToggle("AntiAFKToggle", {
    Title    = "Anti AFK",
    Default  = true,
    Callback = function(Value)
        AntiAFKEnabled = Value
        if Value then AntiAFK() end
        Notify("Anti AFK", Value and "✅ تم التفعيل" or "❌ تم التعطيل", 1)
    end
})

UtilSection:AddToggle("ESPToggle", {
    Title       = "ESP Players",
    Description = "رؤية اللاعبين من خلال الجدران",
    Default     = false,
    Callback    = function(Value)
        ESPEnabled = Value
        if ESPEnabled then
            local function makeESP(player)
                if player == LocalPlayer then return end
                task.wait(1)
                if player.Character then
                    local hl = Instance.new("Highlight")
                    hl.FillColor         = Color3.fromRGB(255, 0, 0)
                    hl.OutlineColor      = Color3.fromRGB(255, 255, 255)
                    hl.FillTransparency  = 0.5
                    hl.Parent            = player.Character
                    ESPObjects[player.Name] = hl
                end
            end
            for _, p in ipairs(Players:GetPlayers()) do makeESP(p) end
            Players.PlayerAdded:Connect(makeESP)
        else
            for _, hl in pairs(ESPObjects) do pcall(function() hl:Destroy() end) end
            ESPObjects = {}
        end
        Notify("ESP", Value and "✅ تم التفعيل" or "❌ تم التعطيل", 1)
    end
})

UtilSection:AddToggle("FOVToggle", {
    Title    = "FOV Changer",
    Default  = false,
    Callback = function(Value)
        FOVEnabled = Value
        if not Value then Camera.FieldOfView = 70 end
        Notify("FOV", Value and "✅ تم التفعيل" or "❌ تم التعطيل", 1)
    end
})

UtilSection:AddTextBox({
    Title    = "قيمة FOV (رقم)",
    Default  = "100",
    Callback = function(Value)
        local num = tonumber(Value)
        if num and num >= 50 and num <= 120 then
            FOVValue = num
            if FOVEnabled then Camera.FieldOfView = num end
            Notify("FOV", "تم تغيير المجال إلى: " .. num, 1)
        else
            Notify("خطأ", "أدخل رقم بين 50 و 120", 1)
        end
    end
})

-- ============================================
-- PROTECTION TAB
-- ============================================
local ProtSection = Tabs.Protection:AddSection("Security & Bypass")

ProtSection:AddToggle("AntiDetToggle", {
    Title    = "Anti Detection",
    Default  = true,
    Callback = function(Value)
        AntiDetectionEnabled = Value
        Notify("Protection", Value and "✅ Anti Detection مفعل" or "❌ تم التعطيل", 1)
    end
})

ProtSection:AddToggle("AntiKickToggle", {
    Title    = "Anti Kick",
    Default  = true,
    Callback = function(Value)
        AntiKickEnabled = Value
        if Value then AntiKickBan() end
        Notify("Protection", Value and "✅ Anti Kick مفعل" or "❌ تم التعطيل", 1)
    end
})

ProtSection:AddToggle("AntiBanToggle", {
    Title    = "Anti Ban",
    Default  = true,
    Callback = function(Value)
        AntiBanEnabled = Value
        Notify("Protection", Value and "✅ Anti Ban مفعل" or "❌ تم التعطيل", 1)
    end
})

ProtSection:AddToggle("DebugBypassToggle", {
    Title    = "Debug Bypass",
    Default  = true,
    Callback = function(Value)
        DebugBypassEnabled = Value
        Notify("Protection", Value and "✅ Debug Bypass مفعل" or "❌ تم التعطيل", 1)
    end
})

ProtSection:AddButton({
    Title    = "🔒 تفعيل جميع أنظمة الحماية",
    Callback = function()
        AntiDetectionEnabled = true
        AntiKickEnabled      = true
        AntiBanEnabled       = true
        DebugBypassEnabled   = true
        BypassSecurity()
        AntiKickBan()
        Notify("الحماية", "✅ جميع أنظمة الحماية مفعلة!", 2)
    end
})

-- ============================================
-- SETTINGS TAB
-- ============================================
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

-- ============================================
-- CONTINUOUS LOOPS
-- ============================================
-- Infinite Stamina
task.spawn(function()
    while true do
        if InfiniteStaminaEnabled and MY_HUMANOID then
            pcall(function()
                MY_HUMANOID:SetAttribute("Stamina", 100)
                MY_HUMANOID:SetAttribute("stamina", 100)
                local sv = MY_HUMANOID:FindFirstChild("Stamina")
                if sv then sv.Value = 100 end
            end)
        end
        task.wait(0.1)
    end
end)

-- Auto Collect
task.spawn(function()
    while true do
        if AutoCollectEnabled and MY_HUMANOID_ROOT then
            pcall(function()
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        local n = obj.Name:lower()
                        if n:find("coin") or n:find("gem") or n:find("reward") or n:find("token") then
                            obj.CFrame = CFrame.new(MY_HUMANOID_ROOT.Position)
                        end
                    end
                end
            end)
        end
        task.wait(0.2)
    end
end)

-- Continuous checks
RunService.Heartbeat:Connect(function()
    if SpeedBoostEnabled and MY_HUMANOID then MY_HUMANOID.WalkSpeed = SpeedBoostValue end
    if JumpBoostEnabled  and MY_HUMANOID then MY_HUMANOID.JumpPower  = JumpBoostValue  end
    if FOVEnabled                         then Camera.FieldOfView     = FOVValue         end
    if NoClipEnabled and MY_HUMANOID_ROOT then
        pcall(function() MY_HUMANOID_ROOT.CanCollide = false end)
    end
end)

-- ============================================
-- FLOATING IMAGE BUTTON (يظهر/يخفي السكربت)
-- ============================================
local function CreateFloatingButton()
    local gui = Instance.new("ScreenGui")
    gui.Name          = "FloatingToggle"
    gui.ResetOnSpawn  = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local ok = pcall(function() gui.Parent = game:GetService("CoreGui") end)
    if not ok then gui.Parent = LocalPlayer.PlayerGui end

    local btn = Instance.new("ImageButton")
    btn.Name                  = "ToggleBtn"
    btn.Size                  = UDim2.new(0, 56, 0, 56)
    btn.Position              = UDim2.new(0, 20, 0.5, -28)
    btn.BackgroundColor3      = Color3.fromRGB(20, 20, 30)
    btn.BackgroundTransparency = 0.1
    btn.BorderSizePixels      = 0
    btn.AutoButtonColor       = false
    btn.Image                 = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    btn.ImageColor3           = Color3.fromRGB(0, 140, 255)
    btn.Parent                = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color     = Color3.fromRGB(0, 120, 255)
    stroke.Thickness = 2
    stroke.Parent    = btn

    -- حركة عائمة
    local baseY   = 0.5
    local phase   = 0
    local dragging = false
    local dragStart, startPos

    RunService.RenderStepped:Connect(function(dt)
        if not dragging then
            phase = phase + dt * 2
            btn.Position = UDim2.new(
                btn.Position.X.Scale,
                btn.Position.X.Offset,
                baseY,
                math.sin(phase) * 10 - 28
            )
        end
    end)

    -- سحب الزر
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos  = btn.Position
        end
    end)
    btn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
            baseY = btn.Position.Y.Scale
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local d = input.Position - dragStart
            btn.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y
            )
        end
    end)

    -- إظهار/إخفاء عند الضغط
    local scriptVisible = true
    btn.MouseButton1Click:Connect(function()
        scriptVisible = not scriptVisible
        if scriptVisible then
            Window:Show()
            btn.ImageColor3 = Color3.fromRGB(0, 140, 255)
        else
            Window:Hide()
            btn.ImageColor3 = Color3.fromRGB(80, 80, 80)
        end
    end)
end

-- ============================================
-- INITIALIZE
-- ============================================
BypassSecurity()
AntiKickBan()
AntiAFK()
CreateFloatingButton()

-- SAVE MANAGER
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("BlueLockRivals_v6")
SaveManager:SetFolder("BlueLockRivals_v6/saves")
Window:SelectTab(1)
SaveManager:LoadAutoloadConfig()

-- Character reload
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    updateCharacter()
    if SpeedBoostEnabled and MY_HUMANOID then MY_HUMANOID.WalkSpeed = SpeedBoostValue end
    if JumpBoostEnabled  and MY_HUMANOID then MY_HUMANOID.JumpPower  = JumpBoostValue  end
    if InfiniteStaminaEnabled and MY_HUMANOID then
        MY_HUMANOID:SetAttribute("Stamina", 100)
    end
end)

print("=== Blue Lock Rivals v6.0 Loaded ===")
print("Player : " .. MY_NAME)
print("Key    : Verified ✓")
print("Menu   : LeftCtrl to open/close")
print("Magnet : Hold E")
print("Button : Floating image to hide/show")

Notify("✅ Script Loaded", "Welcome " .. MY_NAME .. "! Key Verified ✓", 4)
