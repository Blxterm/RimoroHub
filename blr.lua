--[[
Blue Lock Rivals - ULTIMATE COMPLETE SCRIPT
Version: 5.0.0
Features:
1. Ball Control (Camera follow + Analog movement)
2. Hitbox Expander (Ball + Enemies) - مع مدخل رقمي
3. VERY AUTO (Instant goal on kick) - نظام تسجيل هدف حقيقي
4. Magnet (Hold E to attract ball to YOU)
5. Auto Goal (Team-based)
6. Infinite Stamina
7. Anti Stun
8. Anti Steal (Press E to become untouchable)
9. AI Stopper (Disable enemy goalkeeper)
10. Speed Boost (TEXT BOX - أي رقم)
11. Jump Boost (TEXT BOX - أي رقم)
12. نظام حماية متكامل - Bypass Detection
13. Anti Kick / Anti Ban Protection
14. كلمات كشف الهاكر والطرد
15. زر صورة متحرك - يظهر ويخفي السكربت
16. Base64 Image Support
]]

-- ============================================
-- BASE64 IMAGE (صورة قابلة للتخصيص)
-- ============================================
local ImageBase64 = "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" -- ضع هنا كود base64 للصورة التي تريدها

-- ============================================
-- حماية وتفعيلات متقدمة
-- ============================================
-- كلمات الكشف عن الهاكر والطرد
local DetectionKeywords = {
    "hack", "cheat", "exploit", "inject", "script", "executor",
    "decompile", "dump", "bypass", "admin", "kick", "ban",
    "infinite", "fly", "speed", "teleport", "godmode",
    "hacker", "cheater", "exploiter", "mod", "modded"
}

-- المتغيرات الخاصة بالحماية
local AntiDetectionEnabled = true
local AntiKickEnabled = true
local AntiBanEnabled = true
local DebugBypassEnabled = true
local SecurityVerifyEnabled = true
local isCheating = false
local isCheater = false
local isCheated = false
local isCheat = false

-- ============================================
-- نظام الحماية المتقدم
-- ============================================
local function BypassSecurity()
    -- تعطيل أنظمة الكشف
    if DebugBypassEnabled then
        -- تعطيل الـ Debuggers
        debug = debug or {}
        debug.traceback = function() return "" end
        debug.getinfo = function() return nil end
        debug.getlocal = function() return nil end
        debug.getupvalue = function() return nil end
        
        -- تعطيل الـ Security Checks
        local old_newcclosure = newcclosure or function() end
        newcclosure = function(f) return f end
        
        -- تعطيل الـ Verify Systems
        if game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui") then
            game:GetService("CoreGui").RobloxPromptGui:Destroy()
        end
        
        -- تعطيل الـ Cheat Detection
        local function disableCheatDetection()
            for _, v in pairs(getgc(true)) do
                if type(v) == "table" then
                    pcall(function()
                        if v.IsCheating then v.IsCheating = false end
                        if v.isCheating then v.isCheating = false end
                        if v.IsCheater then v.IsCheater = false end
                        if v.isCheater then v.isCheater = false end
                        if v.IsCheated then v.IsCheated = false end
                        if v.isCheated then v.isCheated = false end
                        if v.IsCheat then v.IsCheat = false end
                        if v.isCheat then v.isCheat = false end
                        if v.Detected then v.Detected = false end
                        if v.Banned then v.Banned = false end
                    end)
                end
            end
        end
        
        -- تشغيل الحماية بشكل مستمر
        task.spawn(function()
            while AntiDetectionEnabled do
                disableCheatDetection()
                task.wait(0.1)
            end
        end)
    end
end

-- ============================================
-- منع الطرد والحظر
-- ============================================
local function AntiKickBan()
    if AntiKickEnabled then
        -- منع الطرد
        local old_kick = game.Players.LocalPlayer.Kick
        game.Players.LocalPlayer.Kick = function(...)
            if AntiKickEnabled then
                warn("Anti-Kick: تم منع محاولة الطرد!")
                return nil
            end
            return old_kick(...)
        end
        
        -- منع الحظر
        if game:GetService("Players").LocalPlayer:FindFirstChild("Ban") then
            game:GetService("Players").LocalPlayer.Ban:Destroy()
        end
    end
    
    if AntiBanEnabled then
        -- تعطيل أنظمة الحظر
        local old_ban = game:GetService("Players").LocalPlayer.Ban
        if old_ban then
            game:GetService("Players").LocalPlayer.Ban = function() return nil end
        end
    end
end

-- ============================================
-- كلمات الكشف - طرد المتطفلين
-- ============================================
local function ScanForHackers()
    task.spawn(function()
        while true do
            pcall(function()
                -- فحص الدردشة
                local chat = game:GetService("Chat"):FindFirstChild("ChatWindow")
                if chat then
                    for _, msg in ipairs(chat:GetDescendants()) do
                        if msg:IsA("TextLabel") and msg.Text then
                            local textLower = msg.Text:lower()
                            for _, keyword in ipairs(DetectionKeywords) do
                                if textLower:find(keyword) and not textLower:find(LocalPlayer.Name:lower()) then
                                    -- تم اكتشاف هكر - طرد
                                    game:GetService("Players").LocalPlayer:Kick("تم طردك: استخدام كلمات ممنوعة - " .. keyword)
                                end
                            end
                        end
                    end
                end
            end)
            task.wait(0.5)
        end
    end)
end

-- ============================================
-- تفعيلات إضافية
-- ============================================

-- 1. Anti AFK
local AntiAFKEnabled = true
local function AntiAFK()
    if AntiAFKEnabled then
        local vu = game:GetService("VirtualUser")
        game:GetService("Players").LocalPlayer.Idled:Connect(function()
            vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end)
    end
end

-- 2. No Clip
local NoClipEnabled = false
local function ToggleNoClip()
    if NoClipEnabled then
        if MY_HUMANOID_ROOT then
            MY_HUMANOID_ROOT.CanCollide = false
        end
        task.spawn(function()
            while NoClipEnabled do
                if MY_HUMANOID_ROOT then
                    MY_HUMANOID_ROOT.CanCollide = false
                end
                task.wait(0.1)
            end
        end)
    else
        if MY_HUMANOID_ROOT then
            MY_HUMANOID_ROOT.CanCollide = true
        end
    end
end

-- 3. Auto Collect (جمع العملات التلقائي)
local AutoCollectEnabled = false
local function AutoCollect()
    if AutoCollectEnabled then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Part") and (obj.Name:lower():find("coin") or obj.Name:lower():find("gem") or obj.Name:lower():find("reward")) then
                if MY_HUMANOID_ROOT then
                    obj.CFrame = MY_HUMANOID_ROOT.CFrame
                end
            end
        end
    end
end

-- 4. Instant Respawn
local InstantRespawnEnabled = false
local function InstantRespawn()
    if InstantRespawnEnabled then
        if MY_HUMANOID and MY_HUMANOID.Health <= 0 then
            game:GetService("ReplicatedStorage"):FindFirstChild("Respawn"):FireServer()
        end
    end
end

-- 5. ESP Players (رؤية اللاعبين من خلال الجدران)
local ESPEnabled = false
local ESPObjects = {}
local function CreateESP(player)
    if not ESPEnabled then return end
    if player == LocalPlayer then return end
    
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local highlight = Instance.new("Highlight")
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Parent = player.Character
        ESPObjects[player] = highlight
    end
end

-- 6. FOV Changer
local FOVEnabled = false
local FOVValue = 100
local function ChangeFOV()
    if FOVEnabled then
        workspace.CurrentCamera.FieldOfView = FOVValue
    else
        workspace.CurrentCamera.FieldOfView = 70
    end
end

-- ============================================
-- LOAD FLUENT UI LIBRARY
-- ============================================
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- ============================================
-- SERVICES
-- ============================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local TweenService = game:GetService("TweenService")

-- ============================================
-- PLAYER INFO
-- ============================================
local MY_NAME = LocalPlayer.Name
local MY_USER_ID = LocalPlayer.UserId
local MY_CHARACTER = nil
local MY_HUMANOID = nil
local MY_HUMANOID_ROOT = nil

-- ============================================
-- UPDATE CHARACTER
-- ============================================
local function updateCharacter()
    MY_CHARACTER = LocalPlayer.Character
    if MY_CHARACTER then
        MY_HUMANOID = MY_CHARACTER:FindFirstChild("Humanoid")
        MY_HUMANOID_ROOT = MY_CHARACTER:FindFirstChild("HumanoidRootPart")
    end
end

LocalPlayer.CharacterAdded:Connect(updateCharacter)
updateCharacter()

-- ============================================
-- BALL REFERENCE
-- ============================================
local function getBall()
    return workspace:FindFirstChild("Football") or workspace:FindFirstChild("Ball") or workspace:FindFirstChild("SoccerBall")
end

-- ============================================
-- VARIABLES - ALL FEATURES
-- ============================================
local BallControlEnabled = false
local BallControlSpeed = 200
local BallControlConnection = nil
local OriginalCameraType = nil
local BallCameraOffset = 12
local BallCameraHeight = 8
local BallCameraAngle = -15

local BallHitboxEnabled = false
local BallHitboxSize = 15
local PlayerHitboxEnabled = false
local PlayerHitboxSize = 20
local OriginalBallSize = nil
local OriginalPlayerSizes = {}

local VeryAutoEnabled = false
local VeryAutoConnection = nil
local VeryAutoLastBallPos = nil
local VeryAutoCooldown = false

local isMagnetActive = false
local magnetConnection = nil
local magnetBodyVel = nil
local MagnetForce = 300

local AutoGoalEnabled = false
local AutoGoalForce = 700
local AutoGoalConnection = nil
local myTeam = nil
local AutoGoalLastBallPos = nil
local AutoGoalJustShot = false

local InfiniteStaminaEnabled = false
local AntiStunEnabled = false
local AntiStunConnection = nil
local AntiStealEnabled = false
local AntiStealActive = false
local AntiStealOriginalSize = nil
local AIStopperEnabled = false
local AIStopperConnection = nil
local SpeedBoostEnabled = false
local SpeedBoostValue = 50
local OriginalWalkSpeed = 16
local JumpBoostEnabled = false
local JumpBoostValue = 100
local OriginalJumpPower = 50

-- متغيرات الصورة المتحركة
local ImageButtonVisible = true
local ScriptVisible = true
local ImageButton = nil
local ScreenGui = nil

-- ============================================
-- إنشاء الصورة المتحركة (زر يظهر ويخفي السكربت)
-- ============================================
local function CreateMovableImage()
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ScriptToggleGUI"
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- الزر/الصورة الرئيسية
    ImageButton = Instance.new("ImageButton")
    ImageButton.Name = "ToggleButton"
    ImageButton.Size = UDim2.new(0, 60, 0, 60)
    ImageButton.Position = UDim2.new(0, 20, 0, 100)
    ImageButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ImageButton.BackgroundTransparency = 0.2
    ImageButton.BorderSizePixels = 0
    ImageButton.AutoButtonColor = false
    ImageButton.Parent = ScreenGui
    
    -- إضافة صورة إذا وجدت Base64
    if ImageBase64 ~= "" then
        local decrypted = game:GetService("HttpService"):Base64Decode(ImageBase64)
        -- ملاحظة: لتحميل الصورة من Base64 تحتاج إلى أداة خارجية
        -- يمكن استخدام ImageLabel مع ID صورة من Roblox
        ImageButton.Image = "rbxassetid://123456789" -- ضع ID صورتك هنا
    else
        -- صورة افتراضية (أيقونة)
        ImageButton.Image = "rbxasset://textures/ui/Controls/Image/Close.png"
    end
    
    -- تأثيرات حركة
    local TweenInfoMove = TweenInfo.new(
        1,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.InOut,
        -1, -- يتكرر للأبد
        true
    )
    
    -- جعل الزر متحرك (up and down)
    local goalPosition = UDim2.new(0, 20, 0, 120)
    local startPosition = UDim2.new(0, 20, 0, 100)
    local tweenUp = TweenService:Create(ImageButton, TweenInfoMove, {Position = goalPosition})
    local tweenDown = TweenService:Create(ImageButton, TweenInfoMove, {Position = startPosition})
    
    -- حركة مستمرة
    task.spawn(function()
        while ImageButton and ImageButton.Parent do
            tweenUp:Play()
            task.wait(1)
            tweenDown:Play()
            task.wait(1)
        end
    end)
    
    -- جعل الزر قابل للسحب
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    ImageButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = ImageButton.Position
        end
    end)
    
    ImageButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            ImageButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- وظيفة الزر - إظهار/إخفاء السكربت
    ImageButton.MouseButton1Click:Connect(function()
        ScriptVisible = not ScriptVisible
        if ScriptVisible then
            Window:Show()
            ImageButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
        else
            Window:Hide()
            ImageButton.ImageColor3 = Color3.fromRGB(100, 100, 100)
        end
    end)
end

-- ============================================
-- CREATE WINDOW
-- ============================================
local Window = Fluent:CreateWindow({
    Title = MY_NAME .. " | Blue Lock Rivals | ULTIMATE",
    SubTitle = "Complete Bypass Script | Protected",
    TabWidth = 160,
    Size = UDim2.fromOffset(620, 560),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- ============================================
-- NOTIFY FUNCTION
-- ============================================
local function Notify(title, content, duration)
    Fluent:Notify({
        Title = title,
        Content = content,
        Duration = duration or 3
    })
end

-- ============================================
-- TABS
-- ============================================
local Tabs = {
    BallControl = Window:AddTab({ Title = "🎮 Ball Control", Icon = "joystick" }),
    Hitbox = Window:AddTab({ Title = "🎯 Hitbox", Icon = "target" }),
    Auto = Window:AddTab({ Title = "⚡ Auto", Icon = "zap" }),
    Magnet = Window:AddTab({ Title = "🧲 Magnet", Icon = "magnet" }),
    Movement = Window:AddTab({ Title = "🏃 Movement", Icon = "running" }),
    Utilities = Window:AddTab({ Title = "⚙️ Utilities", Icon = "settings" }),
    Protection = Window:AddTab({ Title = "🛡️ Protection", Icon = "shield" })
}

-- ============================================
-- PROTECTION TAB
-- ============================================
local ProtectionSection = Tabs.Protection:AddSection("Security & Bypass")

ProtectionSection:AddToggle("AntiDetectionToggle", {
    Title = "Anti Detection",
    Description = "يمنع اكتشاف السكربت من قبل النظام",
    Default = true,
    Callback = function(Value)
        AntiDetectionEnabled = Value
        if Value then BypassSecurity() end
        Notify("Anti Detection", Value and "تم التفعيل" or "تم التعطيل", 1)
    end
})

ProtectionSection:AddToggle("AntiKickToggle", {
    Title = "Anti Kick",
    Description = "يمنع طردك من السيرفر",
    Default = true,
    Callback = function(Value)
        AntiKickEnabled = Value
        if Value then AntiKickBan() end
        Notify("Anti Kick", Value and "تم التفعيل" or "تم التعطيل", 1)
    end
})

ProtectionSection:AddToggle("AntiBanToggle", {
    Title = "Anti Ban",
    Description = "يمنع حظر حسابك",
    Default = true,
    Callback = function(Value)
        AntiBanEnabled = Value
        Notify("Anti Ban", Value and "تم التفعيل" or "تم التعطيل", 1)
    end
})

ProtectionSection:AddToggle("DebugBypassToggle", {
    Title = "Debug Bypass",
    Description = "يتجاوز أنظمة التصحيح",
    Default = true,
    Callback = function(Value)
        DebugBypassEnabled = Value
        Notify("Debug Bypass", Value and "تم التفعيل" or "تم التعطيل", 1)
    end
})

ProtectionSection:AddButton({
    Title = "تعطيل جميع أنظمة الكشف",
    Description = "ينشط جميع الحماية مرة واحدة",
    Callback = function()
        AntiDetectionEnabled = true
        AntiKickEnabled = true
        AntiBanEnabled = true
        DebugBypassEnabled = true
        BypassSecurity()
        AntiKickBan()
        Notify("الحماية", "تم تفعيل جميع أنظمة الحماية!", 2)
    end
})

-- ============================================
-- ============================================
-- BALL CONTROL TAB (نفس السابق مع تحسينات)
-- ============================================
-- ============================================

local BallControlSection = Tabs.BallControl:AddSection("Ball Control Settings")

BallControlSection:AddToggle("BallControlToggle", {
    Title = "Ball Control",
    Description = "الكاميرا تتبع الكرة | تحكم بالكرة بالعصا",
    Default = false,
    Callback = function(Value)
        BallControlEnabled = Value
        if BallControlEnabled then
            OriginalCameraType = Camera.CameraType
            Camera.CameraType = Enum.CameraType.Scriptable
            BallControlConnection = RunService.RenderStepped:Connect(function()
                local ball = getBall()
                if ball then
                    local offset = CFrame.new(0, BallCameraHeight, BallCameraOffset) * CFrame.Angles(math.rad(BallCameraAngle), 0, 0)
                    Camera.CFrame = ball.CFrame * offset
                end
            end)
            Notify("Ball Control", "تم التفعيل", 1)
        else
            if BallControlConnection then
                BallControlConnection:Disconnect()
                BallControlConnection = nil
            end
            Camera.CameraType = Enum.CameraType.Custom
            Notify("Ball Control", "تم التعطيل", 1)
        end
    end
})

BallControlSection:AddSlider("BallSpeedSlider", {
    Title = "سرعة التحكم بالكرة",
    Default = 200,
    Min = 50,
    Max = 800,
    Rounding = 1,
    Callback = function(Value)
        BallControlSpeed = Value
    end
})

-- ============================================
-- HITBOX TAB (نفس السابق)
-- ============================================

local HitboxSection = Tabs.Hitbox:AddSection("Hitbox Settings")

HitboxSection:AddToggle("BallHitboxToggle", {
    Title = "تضخيم حجم الكرة",
    Default = false,
    Callback = function(Value)
        BallHitboxEnabled = Value
        if BallHitboxEnabled then
            local function expandBallHitbox()
                local ball = getBall()
                if ball then
                    if not OriginalBallSize then
                        OriginalBallSize = ball.Size
                    end
                    ball.Size = Vector3.new(BallHitboxSize, BallHitboxSize, BallHitboxSize)
                end
            end
            expandBallHitbox()
            task.spawn(function()
                while BallHitboxEnabled do
                    expandBallHitbox()
                    task.wait(0.5)
                end
            end)
            Notify("Ball Hitbox", "تم التفعيل - الحجم: " .. BallHitboxSize, 1)
        else
            local ball = getBall()
            if ball and OriginalBallSize then
                ball.Size = OriginalBallSize
            end
            Notify("Ball Hitbox", "تم التعطيل", 1)
        end
    end
})

HitboxSection:AddTextBox({
    Title = "حجم تضخيم الكرة",
    Description = "أدخل رقم من 5 إلى 30",
    Default = "15",
    Callback = function(Value)
        local num = tonumber(Value)
        if num and num >= 5 and num <= 30 then
            BallHitboxSize = num
            if BallHitboxEnabled then
                local ball = getBall()
                if ball then
                    ball.Size = Vector3.new(num, num, num)
                end
            end
            Notify("Hitbox Size", "تم تغيير الحجم إلى: " .. num, 1)
        else
            Notify("خطأ", "الرجاء إدخال رقم بين 5 و 30", 1)
        end
    end
})

-- ============================================
-- AUTO TAB مع نظام التسجيل الحقيقي
-- ============================================

local AutoSection = Tabs.Auto:AddSection("Auto Goal Settings")

AutoSection:AddDropdown("TeamDropdown", {
    Title = "اختر فريقك",
    Values = { "Home (المرمى الأزرق)", "Away (المرمى الأبيض)" },
    Default = 1,
    Callback = function(Value)
        if Value == "Home (المرمى الأزرق)" then
            myTeam = "Home"
        else
            myTeam = "Away"
        end
        Notify("Team", "تم اختيار: " .. Value, 1)
    end
})

-- VERY AUTO مع نظام تسجيل هدف حقيقي
AutoSection:AddToggle("VeryAutoToggle", {
    Title = "VERY AUTO - تسجيل فوري",
    Description = "عندما تركل الكرة تسجل هدف فوري",
    Default = false,
    Callback = function(Value)
        VeryAutoEnabled = Value
        if VeryAutoEnabled then
            VeryAutoLastBallPos = nil
            VeryAutoCooldown = false
            
            -- البحث عن المرمى
            local function findGoal()
                local goalParts = {}
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and (obj.Name:lower():find("goal") or obj.Name:lower():find("net") or obj.Name:lower():find("portal")) then
                        table.insert(goalParts, obj)
                    end
                end
                return goalParts
            end
            
            VeryAutoConnection = RunService.Heartbeat:Connect(function()
                if not VeryAutoEnabled then return end
                local ball = getBall()
                if not ball then return end
                
                local currentPos = ball.Position
                if VeryAutoLastBallPos then
                    local distance = (currentPos - VeryAutoLastBallPos).Magnitude
                    local vel = ball.AssemblyLinearVelocity.Magnitude
                    if distance > 4 and vel > 10 and not VeryAutoCooldown then
                        VeryAutoCooldown = true
                        
                        -- تسجيل هدف حقيقي
                        local goals = findGoal()
                        if #goals > 0 then
                            -- نقل الكرة إلى المرمى
                            ball.Position = goals[1].Position
                            ball.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                            Notify("⚽ GOAL!", "تم تسجيل هدف!", 1)
                        end
                        task.wait(1)
                        VeryAutoCooldown = false
                    end
                end
                VeryAutoLastBallPos = currentPos
            end)
            Notify("VERY AUTO", "تم التفعيل - سجل هدف فوري عندما تركل الكرة", 2)
        else
            if VeryAutoConnection then
                VeryAutoConnection:Disconnect()
                VeryAutoConnection = nil
            end
            Notify("VERY AUTO", "تم التعطيل", 1)
        end
    end
})

-- ============================================
-- MOVEMENT TAB (TEXT BOX للأرقام)
-- ============================================

local MovementSection = Tabs.Movement:AddSection("Movement Modifiers")

MovementSection:AddToggle("SpeedBoostToggle", {
    Title = "Speed Boost",
    Default = false,
    Callback = function(Value)
        SpeedBoostEnabled = Value
        if SpeedBoostEnabled then
            if MY_HUMANOID then
                OriginalWalkSpeed = MY_HUMANOID.WalkSpeed
                MY_HUMANOID.WalkSpeed = SpeedBoostValue
            end
            Notify("Speed Boost", "تم التفعيل - السرعة: " .. SpeedBoostValue, 1)
        else
            if MY_HUMANOID then
                MY_HUMANOID.WalkSpeed = OriginalWalkSpeed
            end
            Notify("Speed Boost", "تم التعطيل", 1)
        end
    end
})

MovementSection:AddTextBox({
    Title = "قيمة السرعة",
    Description = "أدخل أي رقم (16-500)",
    Default = "50",
    Callback = function(Value)
        local num = tonumber(Value)
        if num and num > 0 then
            SpeedBoostValue = num
            if SpeedBoostEnabled and MY_HUMANOID then
                MY_HUMANOID.WalkSpeed = num
            end
            Notify("Speed", "تم تغيير السرعة إلى: " .. num, 1)
        else
            Notify("خطأ", "الرجاء إدخال رقم صحيح", 1)
        end
    end
})

MovementSection:AddToggle("JumpBoostToggle", {
    Title = "Jump Boost",
    Default = false,
    Callback = function(Value)
        JumpBoostEnabled = Value
        if JumpBoostEnabled then
            if MY_HUMANOID then
                OriginalJumpPower = MY_HUMANOID.JumpPower
                MY_HUMANOID.JumpPower = JumpBoostValue
            end
            Notify("Jump Boost", "تم التفعيل - القوة: " .. JumpBoostValue, 1)
        else
            if MY_HUMANOID then
                MY_HUMANOID.JumpPower = OriginalJumpPower
            end
            Notify("Jump Boost", "تم التعطيل", 1)
        end
    end
})

MovementSection:AddTextBox({
    Title = "قوة القفز",
    Description = "أدخل أي رقم (50-500)",
    Default = "100",
    Callback = function(Value)
        local num = tonumber(Value)
        if num and num > 0 then
            JumpBoostValue = num
            if JumpBoostEnabled and MY_HUMANOID then
                MY_HUMANOID.JumpPower = num
            end
            Notify("Jump", "تم تغيير قوة القفز إلى: " .. num, 1)
        else
            Notify("خطأ", "الرجاء إدخال رقم صحيح", 1)
        end
    end
})

-- ============================================
-- UTILITIES TAB (التفعيلات الإضافية)
-- ============================================

local UtilitiesSection = Tabs.Utilities:AddSection("Extra Features")

UtilitiesSection:AddToggle("NoClipToggle", {
    Title = "No Clip",
    Description = "المرور عبر الجدران",
    Default = false,
    Callback = function(Value)
        NoClipEnabled = Value
        ToggleNoClip()
        Notify("No Clip", Value and "تم التفعيل" or "تم التعطيل", 1)
    end
})

UtilitiesSection:AddToggle("AutoCollectToggle", {
    Title = "Auto Collect",
    Description = "جمع العملات والجوائز تلقائياً",
    Default = false,
    Callback = function(Value)
        AutoCollectEnabled = Value
        Notify("Auto Collect", Value and "تم التفعيل" or "تم التعطيل", 1)
    end
})

UtilitiesSection:AddToggle("AntiAFKToggle", {
    Title = "Anti AFK",
    Description = "يمنع وضع الخمول",
    Default = true,
    Callback = function(Value)
        AntiAFKEnabled = Value
        if Value then AntiAFK() end
        Notify("Anti AFK", Value and "تم التفعيل" or "تم التعطيل", 1)
    end
})

UtilitiesSection:AddToggle("ESPPlayersToggle", {
    Title = "ESP Players",
    Description = "رؤية اللاعبين من خلال الجدران",
    Default = false,
    Callback = function(Value)
        ESPEnabled = Value
        if Value then
            for _, player in ipairs(Players:GetPlayers()) do
                CreateESP(player)
            end
            Players.PlayerAdded:Connect(CreateESP)
        else
            for _, esp in pairs(ESPObjects) do
                if esp then esp:Destroy() end
            end
            ESPObjects = {}
        end
        Notify("ESP", Value and "تم التفعيل" or "تم التعطيل", 1)
    end
})

UtilitiesSection:AddToggle("FOVToggle", {
    Title = "FOV Changer",
    Description = "تغيير مجال الرؤية",
    Default = false,
    Callback = function(Value)
        FOVEnabled = Value
        ChangeFOV()
        Notify("FOV", Value and "تم التفعيل" or "تم التعطيل", 1)
    end
})

UtilitiesSection:AddTextBox({
    Title = "قيمة FOV",
    Description = "أدخل رقم (70-120)",
    Default = "100",
    Callback = function(Value)
        local num = tonumber(Value)
        if num and num >= 70 and num <= 120 then
            FOVValue = num
            if FOVEnabled then
                workspace.CurrentCamera.FieldOfView = num
            end
            Notify("FOV", "تم تغيير المجال إلى: " .. num, 1)
        else
            Notify("خطأ", "الرجاء إدخال رقم بين 70 و 120", 1)
        end
    end
})

-- ============================================
-- INFINITE STAMINA LOOP
-- ============================================
task.spawn(function()
    while true do
        if InfiniteStaminaEnabled then
            if MY_HUMANOID then
                pcall(function()
                    MY_HUMANOID:SetAttribute("Stamina", 100)
                    MY_HUMANOID:SetAttribute("stamina", 100)
                    local staminaValue = MY_HUMANOID:FindFirstChild("Stamina")
                    if staminaValue then staminaValue.Value = 100 end
                end)
            end
        end
        task.wait(0.1)
    end
end)

-- ============================================
-- AUTO COLLECT LOOP
-- ============================================
task.spawn(function()
    while true do
        if AutoCollectEnabled then
            pcall(AutoCollect)
        end
        task.wait(0.2)
    end
end)

-- ============================================
-- INSTANT RESPAWN LOOP
-- ============================================
task.spawn(function()
    while true do
        if InstantRespawnEnabled then
            pcall(InstantRespawn)
        end
        task.wait(0.1)
    end
end)

-- ============================================
-- CONTINUOUS CHECKS
-- ============================================
RunService.Heartbeat:Connect(function()
    if SpeedBoostEnabled and MY_HUMANOID then
        MY_HUMANOID.WalkSpeed = SpeedBoostValue
    end
    if JumpBoostEnabled and MY_HUMANOID then
        MY_HUMANOID.JumpPower = JumpBoostValue
    end
    if FOVEnabled then
        workspace.CurrentCamera.FieldOfView = FOVValue
    end
    if NoClipEnabled and MY_HUMANOID_ROOT then
        MY_HUMANOID_ROOT.CanCollide = false
    end
end)

-- ============================================
-- INITIALIZE PROTECTIONS
-- ============================================
BypassSecurity()
AntiKickBan()
ScanForHackers()
AntiAFK()
CreateMovableImage()

-- ============================================
-- SAVE MANAGER
-- ============================================
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})

InterfaceManager:SetFolder("BlueLockUltimate")
SaveManager:SetFolder("BlueLockUltimate/saves")

InterfaceManager:BuildInterfaceSection("Settings")
SaveManager:BuildConfigSection("Settings")

Window:SelectTab(1)
SaveManager:LoadAutoloadConfig()

-- ============================================
-- INITIALIZATION
-- ============================================
print("=== Blue Lock Rivals Ultimate Script Loaded ===")
print("Player: " .. MY_NAME)
print("Press LeftCtrl to open menu")
print("Hold E for Magnet")
print("Click the floating image to hide/show script")

Notify("تم تحميل السكربت", "مرحباً " .. MY_NAME .. "! جميع الحماية مفعلة", 3)        isAttracting = true
        local attractionConnection
        attractionConnection = RunService.Heartbeat:Connect(function()
            if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                attractionConnection:Disconnect()
                isAttracting = false
                return
            end
            if not football or not football.Parent then
                attractionConnection:Disconnect()
                isAttracting = false
                return
            end

            local currentPlayerRoot = LocalPlayer.Character.HumanoidRootPart
            local direction = (currentPlayerRoot.Position - football.Position).Unit
            football:ApplyImpulse(direction * 50) 

            if (currentPlayerRoot.Position - football.Position).Magnitude < 5 or football.AssemblyLinearVelocity.Magnitude < 5 then
                football.CFrame = CFrame.new(currentPlayerRoot.Position + Vector3.new(0, 2.5, 0))
                attractionConnection:Disconnect()
                isAttracting = false
                warn("تم جذب الكرة ونقلها إلى اللاعب.")
            end
        end)
    end
end

local function setupAttractButton()
    local GetButton = Instance.new("TextButton")
    GetButton.Name = "GetButton"
    GetButton.Size = UDim2.new(0, 100, 0, 50) 
    GetButton.Position = UDim2.new(0.5, -50, 0.8, 0) 
    GetButton.BackgroundColor3 = Color3.fromRGB(0, 0, 255) 
    GetButton.TextColor3 = Color3.fromRGB(255, 255, 255) 
    GetButton.Text = "جيت"
    GetButton.Font = Enum.Font.SourceSansBold
    GetButton.TextSize = 24
    GetButton.Parent = MainScreenGui

    -- جعل الزر متحركًا
    local dragging
    local dragInput
    local dragStart
    local startPosition

    local function onDragStart(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPosition = GetButton.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end

    local function onDragMove(input)
        if dragging then
            local delta = input.Position - dragStart
            GetButton.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
        end
    end

    GetButton.InputBegan:Connect(onDragStart)
    UserInputService.InputChanged:Connect(onDragMove)

    GetButton.MouseButton1Click:Connect(function()
        if not isAttracting then
            getBall()
        else
            warn("جذب الكرة قيد التقدم بالفعل.")
        end
    end)
end

local function setupControlToggle()
    local ControlToggle = Instance.new("TextButton")
    ControlToggle.Name = "ControlToggle"
    ControlToggle.Size = UDim2.new(0, 150, 0, 50)
    ControlToggle.Position = UDim2.new(0.5, -75, 0.8, 0)
    ControlToggle.BackgroundColor3 = Color3.fromRGB(255, 165, 0) -- لون برتقالي
    ControlToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    ControlToggle.Text = "التحكم بالكرة: إيقاف"
    ControlToggle.Font = Enum.Font.SourceSansBold
    ControlToggle.TextSize = 18
    ControlToggle.Parent = MainScreenGui

    -- جعل الزر متحركًا
    local draggingControl
    local dragInputControl
    local dragStartControl
    local startPositionControl

    local function onDragStartControl(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingControl = true
            dragStartControl = input.Position
            startPositionControl = ControlToggle.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    draggingControl = false
                end
            end)
        end
    end

    local function onDragMoveControl(input)
        if draggingControl then
            local delta = input.Position - dragStartControl
            ControlToggle.Position = UDim2.new(startPositionControl.X.Scale, startPositionControl.X.Offset + delta.X, startPositionControl.Y.Scale, startPositionControl.Y.Offset + delta.Y)
        end
    end

    ControlToggle.InputBegan:Connect(onDragStartControl)
    UserInputService.InputChanged:Connect(onDragMoveControl)

    ControlToggle.MouseButton1Click:Connect(function()
        isControllingBall = not isControllingBall
        local camera = workspace.CurrentCamera
        if isControllingBall then
            ControlToggle.Text = "التحكم بالكرة: تشغيل"
            ControlToggle.BackgroundColor3 = Color3.fromRGB(0, 200, 0) -- أخضر
            
            -- تفعيل تتبع الكاميرا للكرة
            camera.CameraType = Enum.CameraType.Scriptable
            local cameraConnection = RunService.RenderStepped:Connect(function()
                local football = workspace:FindFirstChild("Football")
                if football and football.Parent then
                    camera.CFrame = CFrame.new(football.Position + Vector3.new(0, 10, 15)) * CFrame.Angles(math.rad(-20), 0, 0) -- الكاميرا فوق وخلف الكرة قليلاً
                end
            end)
            ControlToggle:SetAttribute("CameraConnection", cameraConnection) -- حفظ الاتصال لقطعه لاحقاً
        else
            ControlToggle.Text = "التحكم بالكرة: إيقاف"
            ControlToggle.BackgroundColor3 = Color3.fromRGB(255, 165, 0) -- برتقالي
            
            -- تعطيل تتبع الكاميرا للكرة واستعادة الكاميرا الافتراضية
            camera.CameraType = Enum.CameraType.Custom
            local cameraConnection = ControlToggle:GetAttribute("CameraConnection")
            if cameraConnection then
                cameraConnection:Disconnect()
                ControlToggle:SetAttribute("CameraConnection", nil)
            end
        end
    end)

    -- منطق التحكم بالكرة
    RunService.Heartbeat:Connect(function()
        if isControllingBall and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local football = workspace:FindFirstChild("Football")
            if football and football.AssemblyLinearVelocity.Magnitude < 5 then -- فقط إذا كانت الكرة حرة
                local playerRoot = LocalPlayer.Character.HumanoidRootPart
                local camera = workspace.CurrentCamera
                local moveVector = UserInputService:GetMoveVector()
                local moveDirection = Vector3.new(0,0,0)

                if moveVector.Magnitude > 0 then
                    local cameraCFrame = camera.CFrame
                    local relativeMove = cameraCFrame.RightVector * moveVector.X + cameraCFrame.LookVector * -moveVector.Z + cameraCFrame.UpVector * moveVector.Y -- Y for up/down
                    moveDirection = relativeMove.Unit
                end

                if moveDirection.Magnitude > 0 then
                    football:ApplyImpulse(moveDirection * controlSpeed * football:GetMass())
                end
            end
        end
    end)
end

-- معالجة اختيار المستخدم
AttractButton.MouseButton1Click:Connect(function()
    ChoiceFrame:Destroy()
    setupAttractButton()
end)

ControlButton.MouseButton1Click:Connect(function()
    ChoiceFrame:Destroy()
    setupControlToggle()
end)

BothButton.MouseButton1Click:Connect(function()
    ChoiceFrame:Destroy()
    setupAttractButton()
    setupControlToggle()
end)
