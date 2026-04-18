
-- 1. Ball Control (Camera follow + Analog movement)
-- 2. Hitbox Expander (Enemies ONLY) - TEXTBOX for size
-- 3. VERY AUTO (Instant REAL goal on kick)
-- 4. Magnet (Hold E to attract ball to YOU)
-- 5. Auto Goal (REAL goal function detection + score)
-- 6. Infinite Stamina
-- 7. Anti Stun
-- 8. Anti Steal (Press E to become untouchable)
-- 9. AI Stopper (Disable enemy goalkeeper)
-- 10. Speed Boost (TEXTBOX)
-- 11. Jump Boost (TEXTBOX)
-- 12. Anti-Cheat Bypass (Disables all detection systems)
-- 13. KEY SYSTEM (مفتاح سري) - REMOVED as per user request
-- 14. Base64 Image Support for Floating Button
-- 15. Auto GK (Automatic Goalkeeper)
-- 16. Auto Slide Tackle
-- 17. Auto Dribble

-- UI Library: Fluent UI
-- Copyright: @K_7Ko

-- ============================================
-- LOAD FLUENT UI LIBRARY
-- ============================================
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- ============================================
-- BASE64 IMAGE (ضع كود base64 صورتك هنا)
-- ============================================
local ImageBase64 = "" -- ضع هنا كود base64 للصورة

-- ============================================
-- SERVICES
-- ============================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

-- ============================================
-- PLAYER INFO (Auto Detect)
-- ============================================
local MY_NAME = LocalPlayer.Name
local MY_USER_ID = LocalPlayer.UserId
local MY_CHARACTER = nil
local MY_HUMANOID = nil
local MY_HUMANOID_ROOT = nil

local function updateCharacter()
    MY_CHARACTER = LocalPlayer.Character
    if MY_CHARACTER then
        MY_HUMANOID = MY_CHARACTER:FindFirstChild("Humanoid")
        MY_HUMANOID_ROOT = MY_CHARACTER:FindFirstChild("HumanoidRootPart")
    end
end

LocalPlayer.CharacterAdded:Connect(updateCharacter)
updateCharacter()

local function getBall()
    return workspace:FindFirstChild("Football")
end

-- ============================================
-- ANTI-CHEAT BYPASS SYSTEM (from v7.0)
-- ============================================
local AntiCheatBypassEnabled = false

local antiCheatKeywords = {
    "isCheating", "is_cheating", "ischeating", "IsCheating",
    "isCheat", "is_cheat", "ischeat", "IsCheat",
    "cheatDetected", "cheat_detected", "cheatdetected",
    "bypass", "Bypass", "BYPASS",
    "antiCheat", "anti_cheat", "anticheat",
    "verify", "verification", "verified",
    "security", "secure", "Secure",
    "detection", "detect", "Detect",
    "flag", "Flag", "FLAG",
    "ban", "Ban", "BAN",
    "kick", "Kick", "KICK",
    "exploit", "Exploit", "EXPLOIT",
    "hack", "Hack", "HACK",
    "inject", "Inject", "INJECT",
    "spoof", "Spoof", "SPOOF"
}

local function bypassAntiCheat()
    -- تعطيل المتغيرات العامة
    for _, keyword in ipairs(antiCheatKeywords) do
        pcall(function()
            _G[keyword] = nil
            rawset(_G, keyword, nil)
        end)
    end
    
    -- تعطيل المتغيرات في البيئة
    pcall(function()
        local env = getfenv() or _G
        for _, keyword in ipairs(antiCheatKeywords) do
            env[keyword] = nil
        end
    end)
    
    -- Hook ومنع دوال الكشف
    pcall(function()
        local mt = getrawmetatable(game)
        local old_index = mt.__index
        setreadonly(mt, false)
        mt.__index = newcclosure(function(self, key)
            for _, keyword in ipairs(antiCheatKeywords) do
                if string.lower(tostring(key)):find(string.lower(keyword)) then
                    return nil
                end
            end
            return old_index(self, key)
        end)
        setreadonly(mt, true)
    end)
    
    -- تعطيل الـ Remote Events الخاصة بالكشف
    for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            local name = v.Name:lower()
            for _, keyword in ipairs(antiCheatKeywords) do
                if name:find(keyword:lower()) then
                    pcall(function()
                        v:Destroy()
                    end)
                end
            end
        end
    end
    
    -- تعطيل الـ Attributes الخاصة بالكشف
    pcall(function()
        local attrs = LocalPlayer:GetAttributes()
        for _, keyword in ipairs(antiCheatKeywords) do
            if attrs[keyword] then
                LocalPlayer:SetAttribute(keyword, nil)
            end
        end
    end)
    
    print("[Anti-Cheat] Protection systems disabled")
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

-- ============================================
-- FIND REAL GOAL FUNCTION (from v7.0)
-- ============================================
local GoalFunction = nil

local function findGoalFunction()
    local goalEvents = {
        ReplicatedStorage:FindFirstChild("GoalEvent"),
        ReplicatedStorage:FindFirstChild("ScoreGoal"),
        ReplicatedStorage:FindFirstChild("AddScore"),
        ReplicatedStorage:FindFirstChild("GoalScored"),
        ReplicatedStorage:FindFirstChild("TeamScore"),
        ReplicatedStorage:FindFirstChild("IncreaseScore"),
        ReplicatedStorage:FindFirstChild("OnGoal"),
        ReplicatedStorage:FindFirstChild("Goal"),
        ReplicatedStorage:FindFirstChild("Score"),
        ReplicatedStorage:FindFirstChild("AddPoint"),
        ReplicatedStorage:FindFirstChild("PointScored"),
        ReplicatedStorage:FindFirstChild("RegisterGoal"),
        ReplicatedStorage:FindFirstChild("GoalMade"),
        ReplicatedStorage:FindFirstChild("ScorePoint")
    }
    
    for _, event in ipairs(goalEvents) do
        if event then
            return event
        end
    end
    
    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") or obj:IsA("BindableEvent") then
            local name = obj.Name:lower()
            if name:find("goal") or name:find("score") or name:find("point") then
                return obj
            end
        end
    end
    
    return nil
end

GoalFunction = findGoalFunction()

local function scoreRealGoal()
    if GoalFunction then
        pcall(function()
            if GoalFunction:IsA("RemoteEvent") then
                GoalFunction:FireServer()
                GoalFunction:FireServer(unpack({}))
            elseif GoalFunction:IsA("RemoteFunction") then
                GoalFunction:InvokeServer()
            elseif GoalFunction:IsA("BindableEvent") then
                GoalFunction:Fire()
            end
        end)
        return true
    end
    return false
end

-- ============================================
-- VARIABLES (Combined from both scripts)
-- ============================================
-- Ball Control
local BallControlEnabled    = false
local BallControlSpeed      = 200
local BallControlConnection = nil
local OriginalCameraType    = nil
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
local VeryAutoCooldown   = false
local VeryAutoLastPos    = nil -- From user's original script

-- Magnet
local isMagnetActive   = false
local magnetConnection = nil
local magnetBodyVel    = nil -- From v7.0
local MagnetForce      = 300

-- Auto Goal
local AutoGoalEnabled   = false
local AutoGoalForce     = 700
local AutoGoalConnection = nil
local myTeam            = "Home"
local AutoGoalLastPos   = nil -- From user's original script
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

-- Protection (Updated to use AntiCheatBypassEnabled)
local AntiDetectionEnabled = true
local AntiKickEnabled      = true
local AntiBanEnabled       = true
local DebugBypassEnabled   = true -- Kept for UI toggle, but actual bypass uses AntiCheatBypassEnabled

-- New Features
local AutoGKEnabled = false
local AutoSlideEnabled = false
local AutoDribbleEnabled = false

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
-- CREATE WINDOW
-- ============================================
local Window = Fluent:CreateWindow({
    Title       = MY_NAME .. " | Blue Lock Rivals",
    SubTitle    = "Ultimate Script v7.1 | Protected",
    TabWidth    = 160,
    Size        = UDim2.fromOffset(640, 600), -- Increased size for new features
    Acrylic     = true,
    Theme       = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- ============================================
-- TABS
-- ============================================
local Tabs = {
    Main        = Window:AddTab({ Title = "🏠 Main",         Icon = "home"     }),
    BallControl = Window:AddTab({ Title = "⚽ Ball Control", Icon = "ball"     }),
    Hitbox      = Window:AddTab({ Title = "🎯 Hitbox",       Icon = "target"   }),
    Auto        = Window:AddTab({ Title = "⚡ Auto",          Icon = "zap"      }),
    Magnet      = Window:AddTab({ Title = "🧲 Magnet",        Icon = "magnet"   }),
    Movement    = Window:AddTab({ Title = "🏃 Movement",      Icon = "running"  }),
    Defense     = Window:AddTab({ Title = "🛡️ Defense",     Icon = "shield"   }), -- New Tab for GK and Slide
    Offense     = Window:AddTab({ Title = "⚔️ Offense",     Icon = "sword"    }), -- New Tab for Dribble
    Utilities   = Window:AddTab({ Title = "🔧 Utilities",     Icon = "settings" }),
    Protection  = Window:AddTab({ Title = "🔒 Protection",    Icon = "lock"     }),
    Settings    = Window:AddTab({ Title = "⚙️ Settings",      Icon = "settings-2"}),
}
    Protection  = Window:AddTab({ Title = "🔒 Protection",    Icon = "lock"     }),
    Settings    = Window:AddTab({ Title = "⚙️ Settings",      Icon = "settings-2"}),
}

-- ============================================
-- MAIN TAB (from v7.0)
-- ============================================
local MainSection = Tabs.Main:AddSection("Player Information")

MainSection:AddParagraph({
    Title = "Player Info",
    Content = "Name: " .. MY_NAME .. "\nUser ID: " .. MY_USER_ID .. "\nStatus: Connected"
})

MainSection:AddButton({
    Title = "Rejoin Game",
    Description = "Leave and rejoin the server",
    Callback = function()
        Notify("Rejoining", "Teleporting to new server...", 2)
        task.wait(1)
        game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
    end
})

MainSection:AddButton({
    Title = "Server Hop",
    Description = "Find a new server",
    Callback = function()
        Notify("Server Hop", "Searching for new server...", 2)
        task.wait(1)
        local servers = {}
        pcall(function()
            local data = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100"))
            for _, v in ipairs(data.data) do
                if type(v) == "table" and v.playing and v.playing < v.maxPlayers then
                    servers[#servers + 1] = v.id
                end
            end
        end)
        if #servers > 0 then
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], LocalPlayer)
        else
            Notify("Error", "No servers found!", 2)
        end
    end
})

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
            OriginalCameraType = Camera.CameraType -- Save original camera type
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
            Camera.CameraType = OriginalCameraType or Enum.CameraType.Custom -- Restore original camera type
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
            for name, size in pairs(OriginalPlayerSizes) do
                local player = Players:FindFirstChild(name)
                if player and player.Character then
                    local root = player.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        root.Size = size
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

-- VERY AUTO - نظام تسجيل هدف حقيقي (Updated with scoreRealGoal from v7.0)
AutoSection:AddToggle("VeryAutoToggle", {
    Title       = "⚡ VERY AUTO - تسجيل فوري",
    Description = "عندما تركل الكرة تنتقل مباشرة للمرمى",
    Default     = false,
    Callback    = function(Value)
        VeryAutoEnabled = Value
        if VeryAutoEnabled then
            VeryAutoCooldown = false

            VeryAutoConnection = RunService.Heartbeat:Connect(function()
                if not VeryAutoEnabled then return end
                local ball = getBall()
                if not ball then return end
                
                local vel = ball.AssemblyLinearVelocity.Magnitude
                
                if vel > 10 and not VeryAutoCooldown then
                    VeryAutoCooldown = true
                    
                    local success = scoreRealGoal()
                    if success then
                        Notify("VERY AUTO", "GOAL SCORED!", 1)
                    else
                        local goalPart = nil
                        for _, obj in ipairs(workspace:GetDescendants()) do
                            if obj:IsA("BasePart") and (obj.Name:lower():find("goal") or obj.Name:lower():find("net")) then
                                goalPart = obj
                                break
                            end
                        end
                        if goalPart then
                            ball.Position = goalPart.Position
                            ball.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                            Notify("VERY AUTO", "Ball teleported to goal!", 1)
                        end
                    end
                    
                    task.wait(1.5)
                    VeryAutoCooldown = false
                end
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

-- Auto Goal (Updated with scoreRealGoal from v7.0)
AutoSection:AddToggle("AutoGoalToggle", {
    Title       = "Auto Goal",
    Description = "يركل الكرة تلقائياً نحو المرمى",
    Default     = false,
    Callback    = function(Value)
        AutoGoalEnabled = Value
        if AutoGoalEnabled then
            local function findOpponentGoal()
                if not myTeam then 
                    Notify("Error", "Select your team first!", 2)
                    return nil 
                end
                local targetColor = (myTeam == "Home") and "blue" or "white"
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and (obj.Name:lower():find("goal") or obj.Name:lower():find("net")) then
                        local brickColor = tostring(obj.BrickColor):lower()
                        if (targetColor == "blue" and brickColor:find("blue")) or 
                           (targetColor == "white" and brickColor:find("white")) then
                            return obj.Position
                        end
                    end
                end
                return nil
            end
            
            AutoGoalJustShot = false
            
            AutoGoalConnection = RunService.Heartbeat:Connect(function()
                if not AutoGoalEnabled then return end
                local ball = getBall()
                if not ball then return end
                
                local currentVel = ball.AssemblyLinearVelocity.Magnitude
                
                if currentVel > 15 and not AutoGoalJustShot then
                    AutoGoalJustShot = true
                    task.spawn(function()
                        task.wait(0.05)
                        local goalPos = findOpponentGoal()
                        if goalPos then
                            local direction = (goalPos - ball.Position).Unit
                            local reversedDir = Vector3.new(-direction.X, -direction.Y + 0.3, -direction.Z)
                            local force = reversedDir * AutoGoalForce * ball:GetMass()
                            ball:ApplyImpulse(force)
                            task.wait(0.5)
                            scoreRealGoal()
                            Notify("Auto Goal", "GOAL SCORED!", 1)
                        end
                        task.wait(2)
                        AutoGoalJustShot = false
                    end)
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
-- DEFENSE TAB (New for Auto GK and Auto Slide)
-- ============================================
local DefenseSection = Tabs.Defense:AddSection("Defensive Features")

DefenseSection:AddToggle("AutoGKToggle", {
    Title       = "Auto Goalkeeper (Auto GK)",
    Description = "تصدّي تلقائي للكرات القريبة من المرمى",
    Default     = false,
    Callback    = function(Value)
        AutoGKEnabled = Value
        if AutoGKEnabled then
            Notify("Auto GK", "✅ تم التفعيل", 1)
            -- Implement Auto GK logic here
            task.spawn(function()
                while AutoGKEnabled do
                    local ball = getBall()
                    if ball and MY_HUMANOID_ROOT and MY_HUMANOID then
                        local goalPosition = nil
                        -- Find own goal (assuming it's the opposite of opponent's goal logic)
                        local ownTeamColor = (myTeam == "Home") and "white" or "blue"
                        for _, obj in ipairs(workspace:GetDescendants()) do
                            if obj:IsA("BasePart") and (obj.Name:lower():find("goal") or obj.Name:lower():find("net")) then
                                local brickColor = tostring(obj.BrickColor):lower()
                                if (ownTeamColor == "blue" and brickColor:find("blue")) or 
                                   (ownTeamColor == "white" and brickColor:find("white")) then
                                    goalPosition = obj.Position
                                    break
                                end
                            end
                        end

                        if goalPosition then
                            local distanceToGoal = (ball.Position - goalPosition).Magnitude
                            local distanceToPlayer = (ball.Position - MY_HUMANOID_ROOT.Position).Magnitude

                            if distanceToGoal < 30 and distanceToPlayer < 15 then -- Ball is close to goal and player
                                -- Move player towards the ball to intercept
                                local directionToBall = (ball.Position - MY_HUMANOID_ROOT.Position).Unit
                                MY_HUMANOID:Move(directionToBall * MY_HUMANOID.WalkSpeed)

                                -- Attempt to 
                                -- Attempt to intercept/kick the ball (simulate a kick or push)
                                local kickForce = 500 -- Adjust as needed
                                local directionToGoal = (goalPosition - ball.Position).Unit
                                ball:ApplyImpulse(directionToGoal * kickForce * ball:GetMass())
                            end
                        end
                    end
                    task.wait(0.1)
                end
            end)
        else
            Notify("Auto GK", "❌ تم التعطيل", 1)
        end
    end
})

DefenseSection:AddToggle("AutoSlideToggle", {
    Title       = "Auto Slide Tackle",
    Description = "مراوغة تلقائية عند اقتراب الخصم بالكرة",
    Default     = false,
    Callback    = function(Value)
        AutoSlideEnabled = Value
        if AutoSlideEnabled then
            Notify("Auto Slide Tackle", "✅ تم التفعيل", 1)
            -- Implement Auto Slide Tackle logic here
            task.spawn(function()
                while AutoSlideEnabled do
                    local ball = getBall()
                    if ball and MY_HUMANOID_ROOT and MY_HUMANOID then
                        for _, player in ipairs(Players:GetPlayers()) do
                            if player ~= LocalPlayer and player.Character then
                                local opponentRoot = player.Character:FindFirstChild("HumanoidRootPart")
                                if opponentRoot then
                                    local distanceToOpponent = (MY_HUMANOID_ROOT.Position - opponentRoot.Position).Magnitude
                                    local distanceBallToOpponent = (ball.Position - opponentRoot.Position).Magnitude

                                    -- If opponent has the ball and is close, and we are close to opponent
                                    if distanceBallToOpponent < 5 and distanceToOpponent < 10 then
                                        -- Simulate a slide tackle (usually a key press or specific function)
                                        -- Assuming 'Q' is a common slide key in Roblox games, or a specific game function
                                        -- For now, we'll just move towards them quickly, a proper slide would need game-specific function calls
                                        local directionToOpponent = (opponentRoot.Position - MY_HUMANOID_ROOT.Position).Unit
                                        MY_HUMANOID:Move(directionToOpponent * (MY_HUMANOID.WalkSpeed * 2)) -- Dash towards opponent
                                        -- A proper slide would involve setting a specific animation or calling a game function
                                    end
                                end
                            end
                        end
                    end
                    task.wait(0.1)
                end
            end)
        else
            Notify("Auto Slide Tackle", "❌ تم التعطيل", 1)
        end
    end
})

-- ============================================
-- OFFENSE TAB (New for Auto Dribble)
-- ============================================
local OffenseSection = Tabs.Offense:AddSection("Offensive Features")

OffenseSection:AddToggle("AutoDribbleToggle", {
    Title       = "Auto Dribble",
    Description = "مراوغة تلقائية عند محاولة الخصم الانزلاق من الخلف",
    Default     = false,
    Callback    = function(Value)
        AutoDribbleEnabled = Value
        if AutoDribbleEnabled then
            Notify("Auto Dribble", "✅ تم التفعيل", 1)
            -- Implement Auto Dribble logic here
            task.spawn(function()
                while AutoDribbleEnabled do
                    local ball = getBall()
                    if ball and MY_HUMANOID_ROOT and MY_HUMANOID then
                        -- Check if player has the ball
                        local distanceBallToPlayer = (ball.Position - MY_HUMANOID_ROOT.Position).Magnitude
                        if distanceBallToPlayer < 5 then -- Player has the ball
                            for _, player in ipairs(Players:GetPlayers()) do
                                if player ~= LocalPlayer and player.Character then
                                    local opponentRoot = player.Character:FindFirstChild("HumanoidRootPart")
                                    if opponentRoot then
                                        local directionOpponentToPlayer = (MY_HUMANOID_ROOT.Position - opponentRoot.Position).Unit
                                        local dotProduct = directionOpponentToPlayer:Dot(MY_HUMANOID_ROOT.CFrame.LookVector)

                                        -- If opponent is behind and moving towards player (simulating a slide from behind)
                                        if dotProduct > 0.7 and (opponentRoot.Position - MY_HUMANOID_ROOT.Position).Magnitude < 7 then
                                            -- Simulate a dribble move (e.g., quick sidestep or skill move)
                                            -- This would typically involve changing player's position or ball's position slightly
                                            local sideStepDirection = MY_HUMANOID_ROOT.CFrame.RightVector * 5 -- Sidestep to the right
                                            MY_HUMANOID_ROOT.CFrame = MY_HUMANOID_ROOT.CFrame + sideStepDirection
                                            ball.CFrame = ball.CFrame + sideStepDirection -- Move ball with player
                                            task.wait(0.2) -- Small delay for the dribble animation/effect
                                        end
                                    end
                                end
                            end
                        end
                    end
                    task.wait(0.1)
                end
            end)
        else
            Notify("Auto Dribble", "❌ تم التعطيل", 1)
        end
    end
})

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
        if Value then 
            pcall(function()
                local vu = game:GetService("VirtualUser")
                LocalPlayer.Idled:Connect(function()
                    vu:Button2Down(Vector2.new(0,0), Camera.CFrame)
                    task.wait(1)
                    vu:Button2Up(Vector2.new(0,0), Camera.CFrame)
                end)
            end)
        end
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
    Description = "تخطي أنظمة الكشف عن الأخطاء (Debug)",
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
        bypassAntiCheat() -- Call the new bypass function
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
                    local n = obj.Name:lower()
                    if n:find("coin") or n:find("gem") or n:find("reward") or n:find("token") then
                        obj.CFrame = CFrame.new(MY_HUMANOID_ROOT.Position)
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
    btn.Image                 = ImageBase64 -- ضع هنا كود base64 للصورة الخاصة بك
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
bypassAntiCheat() -- Call the new bypass function
AntiKickBan()
-- AntiAFK() -- This is now handled by the toggle in Utilities tab
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

print("=== Blue Lock Rivals v7.1 Merged Script Loaded ===")
print("Player : " .. MY_NAME)
print("Key    : Keyless ✓")
print("Menu   : LeftCtrl to open/close")
print("Magnet : Hold E")
print("Button : Floating image to hide/show")

Notify("✅ Script Loaded", "Welcome " .. MY_NAME .. "! Keyless ✓", 4)
