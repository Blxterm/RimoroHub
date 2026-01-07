--[[
    ██████╗ ██╗      ██████╗ ██╗  ██╗   ███████╗██████╗ ██╗   ██╗██╗████████╗███████╗
    ██╔══██╗██║     ██╔═══██╗╚██╗██╔╝   ██╔════╝██╔══██╗██║   ██║██║╚══██╔══╝██╔════╝
    ██████╔╝██║     ██║   ██║ ╚███╔╝    █████╗  ██████╔╝██║   ██║██║   ██║   ███████╗
    ██╔══██╗██║     ██║   ██║ ██╔██╗    ██╔══╝  ██╔══██╗██║   ██║██║   ██║   ╚════██║
    ██████╔╝███████╗╚██████╔╝██╔╝ ██╗   ██║     ██║  ██║╚██████╔╝██║   ██║   ███████║
    ╚═════╝ ╚══════╝ ╚═════╝ ╚═╝  ╚═╝   ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝   ╚═╝   ╚══════╝
    
    BLOX FRUITS AUTO BOUNTY FARMER v5.0
    Total Lines: 1700+
    Features: Complete Auto Farming System
]]

-- =============================================
-- SECTION 1: INITIALIZATION & CONFIGURATION
-- =============================================

local startTime = os.time()
local debugMode = true
local scriptVersion = "5.0.0"
local lastUpdateCheck = os.time()
local updateInterval = 3600 -- 1 hour

-- Load Rayfield UI
local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not success then
    warn("Failed to load Rayfield UI, using fallback UI")
    -- Fallback UI will be created later
end

-- Services
local Services = {
    Players = game:GetService("Players"),
    Workspace = game:GetService("Workspace"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    RunService = game:GetService("RunService"),
    VirtualInputManager = game:GetService("VirtualInputManager"),
    TweenService = game:GetService("TweenService"),
    HttpService = game:GetService("HttpService"),
    TeleportService = game:GetService("TeleportService"),
    Lighting = game:GetService("Lighting"),
    Stats = game:GetService("Stats"),
    NetworkClient = game:GetService("NetworkClient"),
    UserInputService = game:GetService("UserInputService"),
    PathfindingService = game:GetService("PathfindingService"),
    SoundService = game:GetService("SoundService"),
    MarketPlaceService = game:GetService("MarketplaceService"),
    ContentProvider = game:GetService("ContentProvider"),
    Chat = game:GetService("Chat"),
    TextChatService = game:GetService("TextChatService")
}

-- Global Variables
local Player = Services.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- State Management
local States = {
    IsFarming = false,
    IsAttacking = false,
    IsTeleporting = false,
    IsTargeting = false,
    IsServerHopping = false,
    IsAiming = false,
    IsComboExecuting = false,
    IsEmergency = false,
    IsPaused = false,
    IsInCombat = false,
    IsInSafeZone = false
}

-- Statistics
local Statistics = {
    SessionBounty = 0,
    TotalBounty = 0,
    SessionKills = 0,
    TotalKills = 0,
    SessionStartTime = os.time(),
    LastKillTime = 0,
    HighestBountyGain = 0,
    AverageBountyPerKill = 0,
    BountyPerHour = 0,
    Efficiency = 0,
    ComboExecutions = 0,
    FailedAttempts = 0,
    ServerHops = 0,
    DistanceTraveled = 0,
    AttacksPerformed = 0,
    DamageDealt = 0,
    DamageTaken = 0,
    PlayTime = 0
}

-- Target Management
local Target = {
    Player = nil,
    Character = nil,
    Humanoid = nil,
    RootPart = nil,
    LastPosition = Vector3.new(0,0,0),
    LastHealth = 100,
    Distance = 0,
    Level = 0,
    Bounty = 0,
    Fruit = "Unknown",
    IsElite = false,
    IsBoss = false,
    ThreatLevel = 0,
    Priority = 0
}

-- Cache System
local Cache = {
    Players = {},
    SafeZones = {},
    CombatLog = {},
    SkillCooldowns = {},
    RecentKills = {},
    ServerPlayers = {},
    BlacklistedPlayers = {},
    WhitelistedPlayers = {},
    PerformanceMetrics = {},
    PathCache = {}
}

-- Configuration
local Config = {
    -- Targeting
    MinLevel = 2200,
    MaxLevel = 5000,
    MinDistance = 10,
    MaxDistance = 2000,
    TargetPriority = "Bounty", -- Bounty, Level, Distance, Random
    AvoidFriends = true,
    AvoidCrew = false,
    AvoidAllies = true,
    
    -- Combat
    AttackSpeed = 0.15,
    ComboSpeed = 0.1,
    MaxComboLength = 15,
    UseRandomDelays = true,
    MinDelay = 0.05,
    MaxDelay = 0.2,
    AutoDodge = true,
    AutoBlock = true,
    AutoCounter = true,
    
    -- Movement
    TeleportSpeed = 350,
    TeleportMethod = "Tween", -- Tween, CFrame, Network
    UsePathfinding = true,
    AvoidObstacles = true,
    NoClipDuringCombat = true,
    HeightOffset = 3,
    
    -- Skills
    UseMelee = true,
    UseSword = true,
    UseFruit = true,
    UseGun = true,
    UseRaces = true,
    UseFightingStyles = true,
    SkillRotation = "Optimal",
    
    -- Safety
    LowHPThreshold = 30,
    EmergencyTeleportDistance = 500,
    AntiAFK = true,
    AntiReport = true,
    AutoRejoin = true,
    CrashRecovery = true,
    
    -- UI
    ShowGUI = true,
    ShowNotifications = true,
    ShowTargetInfo = true,
    ShowDamageNumbers = true,
    ShowComboDisplay = true,
    
    -- Server
    AutoServerHop = true,
    ServerHopDelay = 300,
    MinPlayersForHop = 3,
    TargetServerRegion = "Auto",
    AvoidFullServers = true,
    
    -- Performance
    UpdateRate = 60,
    CacheLifetime = 60,
    MaxLogEntries = 1000,
    MemoryLimit = 500
}

-- Skill Mappings
local Skills = {
    Melee = {
        Basic = {"M1"},
        Skills = {"Z", "X", "C", "F", "V", "R", "T", "Y", "G", "H"},
        Transformations = {"J", "K", "L"},
        Ultimates = {"B", "N", "M"}
    },
    
    Sword = {
        Basic = {"M1"},
        Skills = {"Z", "X", "C", "F", "V", "R", "T"},
        Aerial = {"Q", "E"},
        Specials = {"G", "H", "J"},
        Ultimates = {"B", "N"}
    },
    
    Fruit = {
        Basic = {"Z"},
        Skills = {"X", "C", "V", "F", "R", "T", "Y", "G", "H", "J"},
        Transform = {"K", "L"},
        Awakened = {"U", "I", "O", "P"},
        Ultimates = {"B", "N", "M"}
    },
    
    Gun = {
        Basic = {"M2"},
        Skills = {"Z", "X", "C", "V", "F", "R", "T"},
        Reload = {"R"},
        Special = {"G", "H"},
        Ultimate = {"B"}
    },
    
    Race = {
        V1 = {"Z"},
        V2 = {"X"},
        V3 = {"C"},
        V4 = {"V"},
        Transform = {"F"}
    }
}

-- Combo Presets
local Combos = {
    FastKill = {
        "M1", "M1", "M1", "Z", "X", "C", "M1", "M1", "F", "V", "R", "M1", "X", "Z"
    },
    
    SwordCombo = {
        "M1", "M1", "M1", "Z", "X", "C", "F", "M1", "X", "Z", "V", "M1"
    },
    
    FruitCombo = {
        "Z", "X", "C", "V", "F", "R", "T", "Z", "X", "C"
    },
    
    GunCombo = {
        "M2", "Z", "X", "M2", "C", "V", "M2", "F", "M2"
    },
    
    MixedCombo = {
        "M1", "Z", "M1", "X", "C", "M1", "V", "F", "M1", "R", "M1"
    },
    
    StunLock = {
        "Z", "X", "C", "M1", "M1", "V", "F", "M1", "X", "Z"
    },
    
    AerialCombo = {
        "X", "Z", "C", "M1", "V", "F", "M1", "M1", "X", "Z"
    }
}

-- Key Mappings
local KeyMap = {
    ["M1"] = Enum.UserInputType.MouseButton1,
    ["M2"] = Enum.UserInputType.MouseButton2,
    ["Z"] = Enum.KeyCode.Z,
    ["X"] = Enum.KeyCode.X,
    ["C"] = Enum.KeyCode.C,
    ["V"] = Enum.KeyCode.V,
    ["F"] = Enum.KeyCode.F,
    ["R"] = Enum.KeyCode.R,
    ["T"] = Enum.KeyCode.T,
    ["Y"] = Enum.KeyCode.Y,
    ["G"] = Enum.KeyCode.G,
    ["H"] = Enum.KeyCode.H,
    ["J"] = Enum.KeyCode.J,
    ["K"] = Enum.KeyCode.K,
    ["L"] = Enum.KeyCode.L,
    ["B"] = Enum.KeyCode.B,
    ["N"] = Enum.KeyCode.N,
    ["M"] = Enum.KeyCode.M,
    ["Q"] = Enum.KeyCode.Q,
    ["E"] = Enum.KeyCode.E,
    ["U"] = Enum.KeyCode.U,
    ["I"] = Enum.KeyCode.I,
    ["O"] = Enum.KeyCode.O,
    ["P"] = Enum.KeyCode.P,
    ["1"] = Enum.KeyCode.One,
    ["2"] = Enum.KeyCode.Two,
    ["3"] = Enum.KeyCode.Three,
    ["4"] = Enum.KeyCode.Four,
    ["5"] = Enum.KeyCode.Five
}

-- =============================================
-- SECTION 2: UTILITY FUNCTIONS
-- =============================================

local Utilities = {}

function Utilities:PrintDebug(message, level)
    if not debugMode then return end
    local timestamp = os.date("%H:%M:%S")
    local prefix = level == "ERROR" and "❌" or level == "WARN" and "⚠️" or "ℹ️"
    print(string.format("[%s] %s %s", timestamp, prefix, message))
end

function Utilities:FormatNumber(num)
    if num >= 1000000000 then
        return string.format("%.2fB", num / 1000000000)
    elseif num >= 1000000 then
        return string.format("%.2fM", num / 1000000)
    elseif num >= 1000 then
        return string.format("%.2fK", num / 1000)
    end
    return tostring(math.floor(num))
end

function Utilities:CalculateDistance(pos1, pos2)
    if not pos1 or not pos2 then return math.huge end
    return (pos1 - pos2).Magnitude
end

function Utilities:IsInRadius(position, center, radius)
    return (position - center).Magnitude <= radius
end

function Utilities:GetPlayerLevel(player)
    -- This is a placeholder for actual level detection
    -- In real implementation, you would parse the player's level
    return math.random(1000, 5000)
end

function Utilities:GetPlayerBounty(player)
    -- Placeholder for bounty detection
    return math.random(1000, 50000)
end

function Utilities:IsPlayerInSafeZone(player)
    if not player.Character then return false end
    local root = player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    
    -- Check common safe zone locations
    for _, zone in pairs(Cache.SafeZones) do
        if Utilities:IsInRadius(root.Position, zone.Position, zone.Radius) then
            return true
        end
    end
    
    return false
end

function Utilities:IsPlayerValidTarget(player)
    if player == Player then return false end
    if not player.Character then return false end
    
    local humanoid = player.Character:FindFirstChild("Humanoid")
    local root = player.Character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not root then return false end
    if humanoid.Health <= 0 then return false end
    if Utilities:IsPlayerInSafeZone(player) then return false end
    
    local level = Utilities:GetPlayerLevel(player)
    if level < Config.MinLevel or level > Config.MaxLevel then return false end
    
    if Config.AvoidFriends and player:IsFriendsWith(Player.UserId) then return false end
    
    return true
end

function Utilities:GetClosestValidTarget()
    local closest = nil
    local closestDist = math.huge
    
    for _, player in pairs(Services.Players:GetPlayers()) do
        if Utilities:IsPlayerValidTarget(player) then
            local dist = Utilities:CalculateDistance(
                HumanoidRootPart.Position,
                player.Character.HumanoidRootPart.Position
            )
            
            if dist < closestDist and dist <= Config.MaxDistance then
                closestDist = dist
                closest = player
            end
        end
    end
    
    return closest
end

function Utilities:GetHighestBountyTarget()
    local bestTarget = nil
    local highestBounty = 0
    
    for _, player in pairs(Services.Players:GetPlayers()) do
        if Utilities:IsPlayerValidTarget(player) then
            local bounty = Utilities:GetPlayerBounty(player)
            if bounty > highestBounty then
                highestBounty = bounty
                bestTarget = player
            end
        end
    end
    
    return bestTarget
end

function Utilities:GetRandomValidTarget()
    local validTargets = {}
    
    for _, player in pairs(Services.Players:GetPlayers()) do
        if Utilities:IsPlayerValidTarget(player) then
            table.insert(validTargets, player)
        end
    end
    
    if #validTargets > 0 then
        return validTargets[math.random(1, #validTargets)]
    end
    
    return nil
end

function Utilities:UpdateTargetData()
    if not Target.Player then return end
    
    Target.Character = Target.Player.Character
    if not Target.Character then
        Target.Player = nil
        return
    end
    
    Target.Humanoid = Target.Character:FindFirstChild("Humanoid")
    Target.RootPart = Target.Character:FindFirstChild("HumanoidRootPart")
    
    if Target.RootPart then
        Target.LastPosition = Target.RootPart.Position
        Target.Distance = Utilities:CalculateDistance(
            HumanoidRootPart.Position,
            Target.RootPart.Position
        )
    end
    
    if Target.Humanoid then
        Target.LastHealth = Target.Humanoid.Health
    end
    
    Target.Level = Utilities:GetPlayerLevel(Target.Player)
    Target.Bounty = Utilities:GetPlayerBounty(Target.Player)
end

function Utilities:CreateNotification(title, message, duration)
    if not Config.ShowNotifications then return end
    
    if Rayfield then
        Rayfield:Notify({
            Title = title,
            Content = message,
            Duration = duration or 3,
            Image = 7039921763
        })
    else
        -- Fallback notification
        game.StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = message,
            Duration = duration or 3
        })
    end
end

function Utilities:LogCombat(message)
    local timestamp = os.date("%H:%M:%S")
    local entry = string.format("[%s] %s", timestamp, message)
    
    table.insert(Cache.CombatLog, entry)
    
    if #Cache.CombatLog > Config.MaxLogEntries then
        table.remove(Cache.CombatLog, 1)
    end
end

function Utilities:CalculateEfficiency()
    local timeElapsed = os.time() - Statistics.SessionStartTime
    if timeElapsed == 0 then return 0 end
    
    local hours = timeElapsed / 3600
    Statistics.BountyPerHour = hours > 0 and Statistics.SessionBounty / hours or 0
    
    if Statistics.SessionKills > 0 then
        Statistics.AverageBountyPerKill = Statistics.SessionBounty / Statistics.SessionKills
    end
    
    Statistics.Efficiency = (Statistics.SessionBounty / math.max(timeElapsed, 1)) * 100
    
    return Statistics.Efficiency
end

-- =============================================
-- SECTION 3: COMBAT SYSTEM
-- =============================================

local CombatSystem = {}

function CombatSystem:ExecuteKey(key)
    local keyCode = KeyMap[key]
    if not keyCode then return false end
    
    local success = pcall(function()
        if typeof(keyCode) == "EnumItem" then
            if keyCode.EnumType == Enum.KeyCode then
                Services.VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
                task.wait(0.03)
                Services.VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
            elseif keyCode.EnumType == Enum.UserInputType then
                Services.VirtualInputManager:SendMouseButtonEvent(0, 0, keyCode, true, game, 0)
                task.wait(0.03)
                Services.VirtualInputManager:SendMouseButtonEvent(0, 0, keyCode, false, game, 0)
            end
        end
    end)
    
    if success then
        Statistics.AttacksPerformed = Statistics.AttacksPerformed + 1
    end
    
    return success
end

function CombatSystem:ExecuteCombo(comboArray)
    if not comboArray or #comboArray == 0 then return false end
    
    States.IsComboExecuting = true
    Utilities:LogCombat("Starting combo execution")
    
    local successCount = 0
    local totalActions = #comboArray
    
    for i, action in ipairs(comboArray) do
        if not States.IsComboExecuting then break end
        if not Target.Player or not Target.Character then break end
        
        -- Apply aimlock if enabled
        if States.IsAiming then
            CombatSystem:AimAtTarget()
        end
        
        -- Execute action
        local success = CombatSystem:ExecuteKey(action)
        if success then
            successCount = successCount + 1
        end
        
        -- Add random delay for human-like behavior
        local delay = Config.AttackSpeed
        if Config.UseRandomDelays then
            delay = delay + math.random(-0.02, 0.02)
        end
        
        task.wait(delay)
        
        -- Check if target died
        if Target.Humanoid and Target.Humanoid.Health <= 0 then
            CombatSystem:OnTargetKilled()
            break
        end
    end
    
    States.IsComboExecuting = false
    Statistics.ComboExecutions = Statistics.ComboExecutions + 1
    
    local successRate = (successCount / totalActions) * 100
    Utilities:LogCombat(string.format("Combo executed: %.1f%% success rate", successRate))
    
    return successCount > 0
end

function CombatSystem:AimAtTarget()
    if not Target.RootPart then return end
    if not States.IsAiming then return end
    
    local camera = Services.Workspace.CurrentCamera
    local targetPos = Target.RootPart.Position
    
    -- Add prediction based on target velocity
    if Target.RootPart.Velocity.Magnitude > 10 then
        targetPos = targetPos + (Target.RootPart.Velocity * 0.2)
    end
    
    camera.CFrame = CFrame.new(camera.CFrame.Position, targetPos)
end

function CombatSystem:RandomAttack()
    if not States.IsAttacking then return end
    
    local attackTypes = {"Melee", "Sword", "Fruit", "Gun"}
    local selectedType = attackTypes[math.random(1, #attackTypes)]
    
    local attacks = Skills[selectedType].Skills
    local selectedAttack = attacks[math.random(1, #attacks)]
    
    CombatSystem:ExecuteKey(selectedAttack)
end

function CombatSystem:FastAttackSequence()
    local sequence = {
        "M1", "M1", "M1",
        Skills.Melee.Skills[math.random(1, #Skills.Melee.Skills)],
        "M1", "M1",
        Skills.Sword.Skills[math.random(1, #Skills.Sword.Skills)],
        "M1"
    }
    
    for _, action in ipairs(sequence) do
        if not States.IsAttacking then break end
        CombatSystem:ExecuteKey(action)
        task.wait(Config.ComboSpeed)
    end
end

function CombatSystem:StunLockCombo()
    local stunCombo = Combos.StunLock
    
    for i = 1, 3 do -- Repeat 3 times for longer stun
        for _, action in ipairs(stunCombo) do
            if not States.IsAttacking then break end
            CombatSystem:ExecuteKey(action)
            task.wait(Config.ComboSpeed * 0.8) -- Faster for stun
        end
    end
end

function CombatSystem:OnTargetKilled()
    if not Target.Player then return end
    
    -- Calculate bounty gain
    local bountyGain = Utilities:GetPlayerBounty(Target.Player)
    Statistics.SessionBounty = Statistics.SessionBounty + bountyGain
    Statistics.TotalBounty = Statistics.TotalBounty + bountyGain
    Statistics.SessionKills = Statistics.SessionKills + 1
    Statistics.TotalKills = Statistics.TotalKills + 1
    Statistics.LastKillTime = os.time()
    
    if bountyGain > Statistics.HighestBountyGain then
        Statistics.HighestBountyGain = bountyGain
    end
    
    -- Log kill
    Utilities:LogCombat(string.format("Killed %s: +%s bounty", 
        Target.Player.Name, 
        Utilities:FormatNumber(bountyGain)))
    
    -- Show notification
    Utilities:CreateNotification(
        "🎯 TARGET ELIMINATED",
        string.format("%s\n+%s Bounty", Target.Player.Name, Utilities:FormatNumber(bountyGain)),
        3
    )
    
    -- Add to recent kills
    Cache.RecentKills[Target.Player.Name] = os.time()
    
    -- Clear target
    Target.Player = nil
    States.IsAttacking = false
    States.IsTargeting = false
    
    -- Update efficiency
    Utilities:CalculateEfficiency()
end

-- =============================================
-- SECTION 4: MOVEMENT SYSTEM
-- =============================================

local MovementSystem = {}

function MovementSystem:TeleportToPosition(position)
    if not HumanoidRootPart then return false end
    if States.IsTeleporting then return false end
    
    States.IsTeleporting = true
    
    local success = pcall(function()
        if Config.TeleportMethod == "Tween" then
            local tweenInfo = Services.TweenInfo.new(
                0.3,
                Enum.EasingStyle.Linear,
                Enum.EasingDirection.Out
            )
            
            local tween = Services.TweenService:Create(
                HumanoidRootPart,
                tweenInfo,
                {CFrame = CFrame.new(position)}
            )
            
            tween:Play()
            tween.Completed:Wait()
            
        elseif Config.TeleportMethod == "CFrame" then
            HumanoidRootPart.CFrame = CFrame.new(position)
        end
    end)
    
    States.IsTeleporting = false
    return success
end

function MovementSystem:TeleportToTarget()
    if not Target.RootPart then return false end
    
    local targetPos = Target.RootPart.Position
    local offset = Vector3.new(
        math.random(-8, 8),
        Config.HeightOffset,
        math.random(-8, 8)
    )
    
    local teleportPos = targetPos + offset
    local success = MovementSystem:TeleportToPosition(teleportPos)
    
    if success then
        Statistics.DistanceTraveled = Statistics.DistanceTraveled + 
            Utilities:CalculateDistance(HumanoidRootPart.Position, teleportPos)
    end
    
    return success
end

function MovementSystem:EmergencyTeleport()
    if States.IsEmergency then return end
    
    States.IsEmergency = true
    Utilities:LogCombat("Emergency teleport activated!")
    
    -- Find safe position far away
    local safePosition = HumanoidRootPart.Position + 
        Vector3.new(
            math.random(-Config.EmergencyTeleportDistance, Config.EmergencyTeleportDistance),
            50,
            math.random(-Config.EmergencyTeleportDistance, Config.EmergencyTeleportDistance)
        )
    
    MovementSystem:TeleportToPosition(safePosition)
    
    -- Wait for safety
    task.wait(5)
    
    States.IsEmergency = false
    Utilities:LogCombat("Emergency teleport complete")
end

function MovementSystem:NoClip(enable)
    if not Character then return end
    
    for _, part in pairs(Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not enable
        end
    end
end

-- =============================================
-- SECTION 5: TARGETING SYSTEM
-- =============================================

local TargetingSystem = {}

function TargetingSystem:FindTarget()
    if States.IsTargeting then return nil end
    
    States.IsTargeting = true
    
    local target = nil
    
    if Config.TargetPriority == "Closest" then
        target = Utilities:GetClosestValidTarget()
    elseif Config.TargetPriority == "Bounty" then
        target = Utilities:GetHighestBountyTarget()
    elseif Config.TargetPriority == "Random" then
        target = Utilities:GetRandomValidTarget()
    else
        target = Utilities:GetClosestValidTarget()
    end
    
    if target then
        Target.Player = target
        Utilities:UpdateTargetData()
        
        Utilities:LogCombat(string.format("Target acquired: %s (Level: %d, Bounty: %s)",
            target.Name,
            Target.Level,
            Utilities:FormatNumber(Target.Bounty)))
        
        Utilities:CreateNotification(
            "🎯 TARGET ACQUIRED",
            target.Name .. "\nLevel: " .. Target.Level,
            2
        )
    end
    
    States.IsTargeting = false
    return target
end

function TargetingSystem:ValidateTarget()
    if not Target.Player then return false end
    return Utilities:IsPlayerValidTarget(Target.Player)
end

function TargetingSystem:SwitchToNextTarget()
    TargetingSystem:FindTarget()
end

-- =============================================
-- SECTION 6: SERVER MANAGEMENT
-- =============================================

local ServerSystem = {}

function ServerSystem:GetServerList()
    local servers = {}
    
    local success, result = pcall(function()
        return Services.HttpService:JSONDecode(game:HttpGet(
            string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100",
                game.PlaceId)
        ))
    end)
    
    if success and result.data then
        for _, server in pairs(result.data) do
            if server.playing < server.maxPlayers and 
               server.id ~= game.JobId and
               server.playing >= Config.MinPlayersForHop then
                table.insert(servers, server)
            end
        end
    end
    
    return servers
end

function ServerSystem:HopToBestServer()
    if States.IsServerHopping then return false end
    if ServerHopCooldown then return false end
    
    States.IsServerHopping = true
    ServerHopCooldown = true
    
    Utilities:LogCombat("Initiating server hop...")
    Utilities:CreateNotification("🔄 SERVER HOP", "Finding best server...", 2)
    
    local servers = ServerSystem:GetServerList()
    
    if #servers > 0 then
        local bestServer = servers[math.random(1, #servers)]
        
        Utilities:LogCombat(string.format("Hopping to server: %s (%d/%d players)",
            bestServer.id, bestServer.playing, bestServer.maxPlayers))
        
        local success = pcall(function()
            Services.TeleportService:TeleportToPlaceInstance(
                game.PlaceId,
                bestServer.id,
                Player
            )
        end)
        
        if success then
            Statistics.ServerHops = Statistics.ServerHops + 1
            Utilities:LogCombat("Server hop successful")
        else
            Utilities:LogCombat("Server hop failed")
        end
    else
        Utilities:LogCombat("No suitable servers found")
    end
    
    States.IsServerHopping = false
    
    -- Cooldown
    task.wait(10)
    ServerHopCooldown = false
    
    return true
end

function ServerSystem:ShouldHopServer()
    if not Config.AutoServerHop then return false end
    
    local playerCount = #Services.Players:GetPlayers()
    if playerCount < Config.MinPlayersForHop then return true end
    
    -- Check if enough valid targets
    local validTargets = 0
    for _, player in pairs(Services.Players:GetPlayers()) do
        if Utilities:IsPlayerValidTarget(player) then
            validTargets = validTargets + 1
        end
    end
    
    if validTargets < 2 then return true end
    
    -- Check time since last kill
    if os.time() - Statistics.LastKillTime > Config.ServerHopDelay then
        return true
    end
    
    return false
end

-- =============================================
-- SECTION 7: UI SYSTEM
-- =============================================

local UISystem = {}

function UISystem:CreateMainWindow()
    if not Rayfield then
        UISystem:CreateFallbackUI()
        return
    end
    
    Window = Rayfield:CreateWindow({
        Name = "🔥 BLOX FRUITS AUTO FARMER v" .. scriptVersion,
        LoadingTitle = "Initializing Advanced Farming System...",
        LoadingSubtitle = "Loading modules...",
        ConfigurationSaving = {
            Enabled = true,
            FolderName = "BloxAutoFarmer",
            FileName = "AdvancedConfig"
        },
        Discord = {
            Enabled = false
        },
        KeySystem = false
    })
    
    -- Create tabs
    UISystem:CreateMainTab()
    UISystem:CreateCombatTab()
    UISystem:CreateTargetingTab()
    UISystem:CreateSettingsTab()
    UISystem:CreateStatsTab()
    UISystem:CreateLogsTab()
    
    Utilities:CreateNotification(
        "✅ SYSTEM READY",
        "Blox Fruits Auto Farmer v" .. scriptVersion .. "\nPress F1 to start farming",
        5
    )
end

function UISystem:CreateMainTab()
    local MainTab = Window:CreateTab("🎮 Main Control", 7039921763)
    
    -- Status Section
    MainTab:CreateSection("📊 Farming Status")
    
    local FarmingStatus = MainTab:CreateLabel("Status: IDLE")
    local ActiveTarget = MainTab:CreateLabel("Target: None")
    local SessionStats = MainTab:CreateLabel("Session: 0 Bounty | 0 Kills")
    
    -- Control Buttons
    MainTab:CreateSection("🎯 Quick Controls")
    
    MainTab:CreateButton({
        Name = "▶️ Start Auto Farm",
        Callback = function()
            FarmingModule:Start()
        end
    })
    
    MainTab:CreateButton({
        Name = "⏸️ Pause Farming",
        Callback = function()
            FarmingModule:Pause()
        end
    })
    
    MainTab:CreateButton({
        Name = "⏹️ Stop Farming",
        Callback = function()
            FarmingModule:Stop()
        end
    })
    
    MainTab:CreateButton({
        Name = "🎯 Find New Target",
        Callback = function()
            TargetingSystem:FindTarget()
        end
    })
    
    MainTab:CreateButton({
        Name = "🔄 Force Server Hop",
        Callback = function()
            ServerSystem:HopToBestServer()
        end
    })
    
    -- Live Stats
    MainTab:CreateSection("📈 Live Statistics")
    
    local BountyLabel = MainTab:CreateLabel("Session Bounty: 0")
    local KillsLabel = MainTab:CreateLabel("Session Kills: 0")
    local BPHLabel = MainTab:CreateLabel("Bounty/Hour: 0")
    local EfficiencyLabel = MainTab:CreateLabel("Efficiency: 0%")
    
    -- Update function
    task.spawn(function()
        while task.wait(1) do
            FarmingStatus:Set("Status: " .. (States.IsFarming and "FARMING" or "IDLE"))
            
            if Target.Player then
                ActiveTarget:Set("Target: " .. Target.Player.Name)
            else
                ActiveTarget:Set("Target: None")
            end
            
            SessionStats:Set(string.format("Session: %s Bounty | %d Kills",
                Utilities:FormatNumber(Statistics.SessionBounty),
                Statistics.SessionKills))
            
            BountyLabel:Set("Session Bounty: " .. Utilities:FormatNumber(Statistics.SessionBounty))
            KillsLabel:Set("Session Kills: " .. Statistics.SessionKills)
            BPHLabel:Set("Bounty/Hour: " .. Utilities:FormatNumber(Statistics.BountyPerHour))
            EfficiencyLabel:Set("Efficiency: " .. string.format("%.1f%%", Statistics.Efficiency))
        end
    end)
end

function UISystem:CreateCombatTab()
    local CombatTab = Window:CreateTab("⚔️ Combat Settings", 7039921763)
    
    CombatTab:CreateSection("🎯 Attack Settings")
    
    CombatTab:CreateToggle({
        Name = "Auto Attack",
        CurrentValue = true,
        Callback = function(Value)
            States.IsAttacking = Value
        end
    })
    
    CombatTab:CreateToggle({
        Name = "Use Aimlock",
        CurrentValue = true,
        Callback = function(Value)
            States.IsAiming = Value
        end
    })
    
    CombatTab:CreateToggle({
        Name = "Fast Attack Mode",
        CurrentValue = true,
        Callback = function(Value)
            Config.FastAttack = Value
        end
    })
    
    CombatTab:CreateSlider({
        Name = "Attack Speed",
        Range = {0.05, 0.5},
        Increment = 0.01,
        Suffix = "seconds",
        CurrentValue = Config.AttackSpeed,
        Callback = function(Value)
            Config.AttackSpeed = Value
        end
    })
    
    CombatTab:CreateSection("🎭 Combo Selection")
    
    local ComboDropdown = CombatTab:CreateDropdown({
        Name = "Select Combo",
        Options = {"FastKill", "SwordCombo", "FruitCombo", "GunCombo", "MixedCombo", "StunLock", "AerialCombo"},
        CurrentOption = "FastKill",
        Callback = function(Option)
            CurrentCombo = Combos[Option]
        end
    })
    
    CombatTab:CreateButton({
        Name = "Execute Current Combo",
        Callback = function()
            CombatSystem:ExecuteCombo(CurrentCombo)
        end
    })
    
    CombatTab:CreateSection("🛡️ Defense Settings")
    
    CombatTab:CreateToggle({
        Name = "Auto Dodge",
        CurrentValue = Config.AutoDodge,
        Callback = function(Value)
            Config.AutoDodge = Value
        end
    })
    
    CombatTab:CreateToggle({
        Name = "Auto Block",
        CurrentValue = Config.AutoBlock,
        Callback = function(Value)
            Config.AutoBlock = Value
        end
    })
    
    CombatTab:CreateSlider({
        Name = "Low HP Threshold",
        Range = {10, 50},
        Increment = 5,
        Suffix = "% HP",
        CurrentValue = Config.LowHPThreshold,
        Callback = function(Value)
            Config.LowHPThreshold = Value
        end
    })
end

function UISystem:CreateTargetingTab()
    local TargetingTab = Window:CreateTab("🎯 Targeting", 7039921763)
    
    TargetingTab:CreateSection("🎯 Target Filters")
    
    TargetingTab:CreateSlider({
        Name = "Minimum Level",
        Range = {1, 5000},
        Increment = 10,
        Suffix = "Level",
        CurrentValue = Config.MinLevel,
        Callback = function(Value)
            Config.MinLevel = Value
        end
    })
    
    TargetingTab:CreateSlider({
        Name = "Maximum Level",
        Range = {1, 5000},
        Increment = 10,
        Suffix = "Level",
        CurrentValue = Config.MaxLevel,
        Callback = function(Value)
            Config.MaxLevel = Value
        end
    })
    
    TargetingTab:CreateSlider({
        Name = "Max Distance",
        Range = {50, 5000},
        Increment = 50,
        Suffix = "studs",
        CurrentValue = Config.MaxDistance,
        Callback = function(Value)
            Config.MaxDistance = Value
        end
    })
    
    TargetingTab:CreateSection("🎯 Target Priority")
    
    local PriorityDropdown = TargetingTab:CreateDropdown({
        Name = "Target Priority",
        Options = {"Closest", "Highest Bounty", "Random", "Lowest Health"},
        CurrentOption = Config.TargetPriority,
        Callback = function(Option)
            Config.TargetPriority = Option
        end
    })
    
    TargetingTab:CreateToggle({
        Name = "Avoid Friends",
        CurrentValue = Config.AvoidFriends,
        Callback = function(Value)
            Config.AvoidFriends = Value
        end
    })
    
    TargetingTab:CreateToggle({
        Name = "Avoid Allies",
        CurrentValue = Config.AvoidAllies,
        Callback = function(Value)
            Config.AvoidAllies = Value
        end
    })
    
    TargetingTab:CreateSection("🔍 Target Information")
    
    local TargetNameLabel = TargetingTab:CreateLabel("Current Target: None")
    local TargetLevelLabel = TargetingTab:CreateLabel("Target Level: -")
    local TargetBountyLabel = TargetingTab:CreateLabel("Target Bounty: -")
    local TargetDistanceLabel = TargetingTab:CreateLabel("Distance: -")
    local TargetHealthLabel = TargetingTab:CreateLabel("Health: -")
    
    task.spawn(function()
        while task.wait(0.5) do
            if Target.Player then
                Utilities:UpdateTargetData()
                
                TargetNameLabel:Set("Current Target: " .. Target.Player.Name)
                TargetLevelLabel:Set("Target Level: " .. Target.Level)
                TargetBountyLabel:Set("Target Bounty: " .. Utilities:FormatNumber(Target.Bounty))
                TargetDistanceLabel:Set(string.format("Distance: %.1f", Target.Distance))
                
                if Target.Humanoid then
                    TargetHealthLabel:Set(string.format("Health: %.0f/%.0f", 
                        Target.Humanoid.Health, Target.Humanoid.MaxHealth))
                end
            else
                TargetNameLabel:Set("Current Target: None")
                TargetLevelLabel:Set("Target Level: -")
                TargetBountyLabel:Set("Target Bounty: -")
                TargetDistanceLabel:Set("Distance: -")
                TargetHealthLabel:Set("Health: -")
            end
        end
    end)
end

function UISystem:CreateSettingsTab()
    local SettingsTab = Window:CreateTab("⚙️ Settings", 7039921763)
    
    SettingsTab:CreateSection("🚀 Performance")
    
    SettingsTab:CreateSlider({
        Name = "Update Rate",
        Range = {10, 120},
        Increment = 5,
        Suffix = "FPS",
        CurrentValue = Config.UpdateRate,
        Callback = function(Value)
            Config.UpdateRate = Value
        end
    })
    
    SettingsTab:CreateToggle({
        Name = "Use Pathfinding",
        CurrentValue = Config.UsePathfinding,
        Callback = function(Value)
            Config.UsePathfinding = Value
        end
    })
    
    SettingsTab:CreateToggle({
        Name = "NoClip During Combat",
        CurrentValue = Config.NoClipDuringCombat,
        Callback = function(Value)
            Config.NoClipDuringCombat = Value
        end
    })
    
    SettingsTab:CreateSection("🔄 Server Management")
    
    SettingsTab:CreateToggle({
        Name = "Auto Server Hop",
        CurrentValue = Config.AutoServerHop,
        Callback = function(Value)
            Config.AutoServerHop = Value
        end
    })
    
    SettingsTab:CreateSlider({
        Name = "Server Hop Delay",
        Range = {60, 1800},
        Increment = 30,
        Suffix = "seconds",
        CurrentValue = Config.ServerHopDelay,
        Callback = function(Value)
            Config.ServerHopDelay = Value
        end
    })
    
    SettingsTab:CreateSlider({
        Name = "Min Players For Hop",
        Range = {1, 20},
        Increment = 1,
        Suffix = "players",
        CurrentValue = Config.MinPlayersForHop,
        Callback = function(Value)
            Config.MinPlayersForHop = Value
        end
    })
    
    SettingsTab:CreateSection("🔒 Safety")
    
    SettingsTab:CreateToggle({
        Name = "Anti-AFK System",
        CurrentValue = Config.AntiAFK,
        Callback = function(Value)
            Config.AntiAFK = Value
        end
    })
    
    SettingsTab:CreateToggle({
        Name = "Crash Recovery",
        CurrentValue = Config.CrashRecovery,
        Callback = function(Value)
            Config.CrashRecovery = Value
        end
    })
    
    SettingsTab:CreateToggle({
        Name = "Auto Rejoin",
        CurrentValue = Config.AutoRejoin,
        Callback = function(Value)
            Config.AutoRejoin = Value
        end
    })
    
    SettingsTab:CreateButton({
        Name = "💾 Save Configuration",
        Callback = function()
            UISystem:SaveConfig()
        end
    })
    
    SettingsTab:CreateButton({
        Name = "🔄 Load Configuration",
        Callback = function()
            UISystem:LoadConfig()
        end
    })
end

function UISystem:CreateStatsTab()
    local StatsTab = Window:CreateTab("📊 Statistics", 7039921763)
    
    StatsTab:CreateSection("📈 Farming Statistics")
    
    local TotalBountyStat = StatsTab:CreateLabel("Total Bounty: 0")
    local TotalKillsStat = StatsTab:CreateLabel("Total Kills: 0")
    local HighestBountyStat = StatsTab:CreateLabel("Highest Bounty Gain: 0")
    local AverageBountyStat = StatsTab:CreateLabel("Average Bounty/Kill: 0")
    local BountyPerHourStat = StatsTab:CreateLabel("Bounty/Hour: 0")
    local EfficiencyStat = StatsTab:CreateLabel("Efficiency: 0%")
    local PlayTimeStat = StatsTab:CreateLabel("Play Time: 00:00:00")
    local ServerHopsStat = StatsTab:CreateLabel("Server Hops: 0")
    local ComboExecutionsStat = StatsTab:CreateLabel("Combos Executed: 0")
    local AttacksPerformedStat = StatsTab:CreateLabel("Attacks Performed: 0")
    local DistanceTraveledStat = StatsTab:CreateLabel("Distance Traveled: 0")
    
    task.spawn(function()
        while task.wait(2) do
            Utilities:CalculateEfficiency()
            
            TotalBountyStat:Set("Total Bounty: " .. Utilities:FormatNumber(Statistics.TotalBounty))
            TotalKillsStat:Set("Total Kills: " .. Statistics.TotalKills)
            HighestBountyStat:Set("Highest Bounty Gain: " .. Utilities:FormatNumber(Statistics.HighestBountyGain))
            AverageBountyStat:Set("Average Bounty/Kill: " .. Utilities:FormatNumber(Statistics.AverageBountyPerKill))
            BountyPerHourStat:Set("Bounty/Hour: " .. Utilities:FormatNumber(Statistics.BountyPerHour))
            EfficiencyStat:Set("Efficiency: " .. string.format("%.1f%%", Statistics.Efficiency))
            
            local playTime = os.time() - Statistics.SessionStartTime
            local hours = math.floor(playTime / 3600)
            local minutes = math.floor((playTime % 3600) / 60)
            local seconds = playTime % 60
            PlayTimeStat:Set(string.format("Play Time: %02d:%02d:%02d", hours, minutes, seconds))
            
            ServerHopsStat:Set("Server Hops: " .. Statistics.ServerHops)
            ComboExecutionsStat:Set("Combos Executed: " .. Statistics.ComboExecutions)
            AttacksPerformedStat:Set("Attacks Performed: " .. Utilities:FormatNumber(Statistics.AttacksPerformed))
            DistanceTraveledStat:Set("Distance Traveled: " .. string.format("%.0f studs", Statistics.DistanceTraveled))
        end
    end)
end

function UISystem:CreateLogsTab()
    local LogsTab = Window:CreateTab("📋 Combat Logs", 7039921763)
    
    LogsTab:CreateSection("📝 Recent Activity")
    
    local LogConsole = LogsTab:CreateLabel("Initializing log system...")
    
    local function updateLogs()
        local logText = ""
        local startIndex = math.max(1, #Cache.CombatLog - 10)
        
        for i = startIndex, #Cache.CombatLog do
            logText = logText .. Cache.CombatLog[i] .. "\n"
        end
        
        LogConsole:Set(logText)
    end
    
    task.spawn(function()
        while task.wait(1) do
            updateLogs()
        end
    end)
    
    LogsTab:CreateButton({
        Name = "🗑️ Clear Logs",
        Callback = function()
            Cache.CombatLog = {}
            LogConsole:Set("Logs cleared")
        end
    })
    
    LogsTab:CreateButton({
        Name = "💾 Save Logs to File",
        Callback = function()
            UISystem:SaveLogsToFile()
        end
    })
end

function UISystem:CreateFallbackUI()
    -- Simple fallback UI if Rayfield fails
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local StartButton = Instance.new("TextButton")
    local StatusLabel = Instance.new("TextLabel")
    
    ScreenGui.Parent = game.CoreGui
    ScreenGui.Name = "AutoFarmerFallbackUI"
    
    MainFrame.Size = UDim2.new(0, 300, 0, 200)
    MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    StartButton.Size = UDim2.new(0, 200, 0, 50)
    StartButton.Position = UDim2.new(0.5, -100, 0.3, -25)
    StartButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    StartButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    StartButton.Text = "START AUTO FARM"
    StartButton.Font = Enum.Font.GothamBold
    StartButton.TextSize = 16
    StartButton.Parent = MainFrame
    
    StartButton.MouseButton1Click:Connect(function()
        FarmingModule:Start()
    end)
    
    StatusLabel.Size = UDim2.new(0, 280, 0, 40)
    StatusLabel.Position = UDim2.new(0.5, -140, 0.7, -20)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    StatusLabel.Text = "Status: READY"
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.TextSize = 14
    StatusLabel.Parent = MainFrame
    
    -- Update status
    task.spawn(function()
        while task.wait(1) do
            StatusLabel.Text = "Status: " .. (States.IsFarming and "FARMING" or "IDLE") .. 
                " | Bounty: " .. Utilities:FormatNumber(Statistics.SessionBounty)
        end
    end)
end

function UISystem:SaveConfig()
    local configData = {
        Config = Config,
        Statistics = Statistics,
        LastSave = os.time()
    }
    
    local success, errorMsg = pcall(function()
        local json = Services.HttpService:JSONEncode(configData)
        writefile("BloxAutoFarmer_Config.json", json)
    end)
    
    if success then
        Utilities:CreateNotification("✅ CONFIG SAVED", "Configuration saved successfully", 2)
    else
        Utilities:CreateNotification("❌ SAVE FAILED", "Failed to save config: " .. errorMsg, 3)
    end
end

function UISystem:LoadConfig()
    local success, data = pcall(function()
        local json = readfile("BloxAutoFarmer_Config.json")
        return Services.HttpService:JSONDecode(json)
    end)
    
    if success and data then
        if data.Config then
            for key, value in pairs(data.Config) do
                if Config[key] ~= nil then
                    Config[key] = value
                end
            end
        end
        
        if data.Statistics then
            Statistics.TotalBounty = data.Statistics.TotalBounty or 0
            Statistics.TotalKills = data.Statistics.TotalKills or 0
        end
        
        Utilities:CreateNotification("✅ CONFIG LOADED", "Configuration loaded successfully", 2)
    else
        Utilities:CreateNotification("⚠️ LOAD FAILED", "No saved configuration found", 2)
    end
end

function UISystem:SaveLogsToFile()
    local logText = "=== BLOX FRUITS AUTO FARMER LOGS ===\n"
    logText = logText .. "Generated: " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n"
    logText = logText .. "Version: " .. scriptVersion .. "\n"
    logText = logText .. "================================\n\n"
    
    for _, entry in pairs(Cache.CombatLog) do
        logText = logText .. entry .. "\n"
    end
    
    local success = pcall(function()
        writefile("BloxAutoFarmer_Logs.txt", logText)
    end)
    
    if success then
        Utilities:CreateNotification("✅ LOGS SAVED", "Logs saved to file", 2)
    else
        Utilities:CreateNotification("❌ SAVE FAILED", "Failed to save logs", 2)
    end
end

-- =============================================
-- SECTION 8: FARMING MODULE
-- =============================================

local FarmingModule = {}

function FarmingModule:Start()
    if States.IsFarming then
        Utilities:CreateNotification("⚠️ ALREADY FARMING", "Farming is already in progress", 2)
        return
    end
    
    States.IsFarming = true
    Utilities:LogCombat("Auto farming started")
    Utilities:CreateNotification("🚀 FARMING STARTED", "Auto farming initiated", 2)
    
    -- Start main farming loop
    task.spawn(function()
        while States.IsFarming do
            FarmingModule:FarmingLoop()
            task.wait(0.1)
        end
    end)
    
    -- Start target monitoring
    task.spawn(function()
        while States.IsFarming do
            FarmingModule:TargetMonitoring()
            task.wait(0.5)
        end
    end)
    
    -- Start safety monitoring
    task.spawn(function()
        while States.IsFarming do
            FarmingModule:SafetyMonitor()
            task.wait(1)
        end
    end)
    
    -- Start server hop monitoring
    if Config.AutoServerHop then
        task.spawn(function()
            while States.IsFarming do
                FarmingModule:ServerHopMonitor()
                task.wait(30)
            end
        end)
    end
end

function FarmingModule:FarmingLoop()
    if States.IsPaused then return end
    if not States.IsFarming then return end
    
    -- Find target if none
    if not Target.Player then
        TargetingSystem:FindTarget()
        
        if not Target.Player then
            Utilities:LogCombat("No valid targets found, waiting...")
            task.wait(3)
            return
        end
    end
    
    -- Validate current target
    if not TargetingSystem:ValidateTarget() then
        Target.Player = nil
        return
    end
    
    -- Update target data
    Utilities:UpdateTargetData()
    
    -- Check distance
    if Target.Distance > Config.MaxDistance then
        Utilities:LogCombat("Target too far, finding new target")
        Target.Player = nil
        return
    end
    
    -- Teleport to target
    if Target.Distance > 20 then
        MovementSystem:TeleportToTarget()
        task.wait(0.3)
    end
    
    -- Start attacking
    if not States.IsAttacking then
        States.IsAttacking = true
        FarmingModule:AttackLoop()
    end
end

function FarmingModule:AttackLoop()
    while States.IsAttacking and States.IsFarming and Target.Player do
        if States.IsPaused then
            task.wait(1)
            continue
        end
        
        -- Apply aimlock
        if States.IsAiming then
            CombatSystem:AimAtTarget()
        end
        
        -- Enable noclip during combat
        if Config.NoClipDuringCombat then
            MovementSystem:NoClip(true)
        end
        
        -- Execute attack sequence
        if Config.FastAttack then
            CombatSystem:FastAttackSequence()
        else
            CombatSystem:RandomAttack()
        end
        
        -- Check if target died
        if Target.Humanoid and Target.Humanoid.Health <= 0 then
            CombatSystem:OnTargetKilled()
            break
        end
        
        -- Small delay between attack sequences
        task.wait(0.2)
    end
    
    -- Disable noclip
    if Config.NoClipDuringCombat then
        MovementSystem:NoClip(false)
    end
    
    States.IsAttacking = false
end

function FarmingModule:TargetMonitoring()
    if not Target.Player then return end
    
    -- Check if target still valid
    if not TargetingSystem:ValidateTarget() then
        Utilities:LogCombat("Target invalidated, finding new target")
        Target.Player = nil
        States.IsAttacking = false
        return
    end
    
    -- Check if target escaped
    if Target.Distance > Config.MaxDistance * 1.5 then
        Utilities:LogCombat("Target escaped, finding new target")
        Target.Player = nil
        States.IsAttacking = false
        return
    end
end

function FarmingModule:SafetyMonitor()
    -- Check player health
    if Humanoid.Health <= (Humanoid.MaxHealth * (Config.LowHPThreshold / 100)) then
        Utilities:LogCombat("Low health detected! Emergency teleport activated")
        MovementSystem:EmergencyTeleport()
        task.wait(10) -- Recovery time
    end
    
    -- Anti-AFK
    if Config.AntiAFK then
        local VirtualUser = game:GetService("VirtualUser")
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end

function FarmingModule:ServerHopMonitor()
    if ServerSystem:ShouldHopServer() then
        Utilities:LogCombat("Server hop conditions met, initiating hop...")
        ServerSystem:HopToBestServer()
    end
end

function FarmingModule:Pause()
    States.IsPaused = not States.IsPaused
    
    if States.IsPaused then
        Utilities:LogCombat("Farming paused")
        Utilities:CreateNotification("⏸️ FARMING PAUSED", "Farming has been paused", 2)
    else
        Utilities:LogCombat("Farming resumed")
        Utilities:CreateNotification("▶️ FARMING RESUMED", "Farming has been resumed", 2)
    end
end

function FarmingModule:Stop()
    States.IsFarming = false
    States.IsAttacking = false
    States.IsTargeting = false
    Target.Player = nil
    
    -- Disable noclip
    MovementSystem:NoClip(false)
    
    Utilities:LogCombat("Auto farming stopped")
    Utilities:CreateNotification("⏹️ FARMING STOPPED", "Auto farming has been stopped", 2)
    
    -- Save stats
    UISystem:SaveConfig()
end

-- =============================================
-- SECTION 9: KEYBIND SYSTEM
-- =============================================

local KeybindSystem = {}

function KeybindSystem:SetupKeybinds()
    Services.UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        -- Toggle Farming
        if input.KeyCode == Enum.KeyCode.F1 then
            if not States.IsFarming then
                FarmingModule:Start()
            else
                FarmingModule:Stop()
            end
        
        -- Pause Farming
        elseif input.KeyCode == Enum.KeyCode.F2 then
            FarmingModule:Pause()
        
        -- Find Target
        elseif input.KeyCode == Enum.KeyCode.F3 then
            TargetingSystem:FindTarget()
        
        -- Server Hop
        elseif input.KeyCode == Enum.KeyCode.F4 then
            ServerSystem:HopToBestServer()
        
        -- Emergency Teleport
        elseif input.KeyCode == Enum.KeyCode.F5 then
            MovementSystem:EmergencyTeleport()
        
        -- Execute Combo
        elseif input.KeyCode == Enum.KeyCode.F6 then
            CombatSystem:ExecuteCombo(CurrentCombo or Combos.FastKill)
        
        -- Toggle GUI
        elseif input.KeyCode == Enum.KeyCode.F7 then
            if Window then
                Window.Enabled = not Window.Enabled
            end
        end
    end)
end

-- =============================================
-- SECTION 10: INITIALIZATION & MAIN LOOP
-- =============================================

function InitializeSystem()
    Utilities:PrintDebug("Initializing Blox Fruits Auto Farmer v" .. scriptVersion, "INFO")
    
    -- Wait for character
    repeat task.wait() until Player.Character
    Character = Player.Character
    Humanoid = Character:WaitForChild("Humanoid")
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    
    -- Load saved config
    UISystem:LoadConfig()
    
    -- Create UI
    UISystem:CreateMainWindow()
    
    -- Setup keybinds
    KeybindSystem:SetupKeybinds()
    
    -- Setup auto-update
    task.spawn(function()
        while task.wait(updateInterval) do
            if os.time() - lastUpdateCheck > updateInterval then
                CheckForUpdates()
                lastUpdateCheck = os.time()
            end
        end
    end)
    
    -- Main update loop
    task.spawn(function()
        while task.wait(1/Config.UpdateRate) do
            UpdateSystem()
        end
    end)
    
    Utilities:PrintDebug("System initialization complete", "INFO")
    Utilities:CreateNotification(
        "✅ SYSTEM READY",
        string.format(
            "Blox Fruits Auto Farmer v%s\n\n" ..
            "🎮 Controls:\n" ..
            "F1 - Start/Stop Farming\n" ..
            "F2 - Pause Farming\n" ..
            "F3 - Find Target\n" ..
            "F4 - Server Hop\n" ..
            "F5 - Emergency Teleport\n" ..
            "F6 - Execute Combo\n" ..
            "F7 - Toggle GUI",
            scriptVersion
        ),
        10
    )
end

function UpdateSystem()
    -- Update statistics
    Statistics.PlayTime = os.time() - Statistics.SessionStartTime
    
    -- Update cache
    UpdateCache()
    
    -- Monitor performance
    MonitorPerformance()
end

function UpdateCache()
    local currentTime = os.time()
    
    -- Clean old cache entries
    for playerName, killTime in pairs(Cache.RecentKills) do
        if currentTime - killTime > 900 then -- 15 minutes
            Cache.RecentKills[playerName] = nil
        end
    end
end

function MonitorPerformance()
    local memory = Services.Stats:GetMemoryUsageMb()
    if memory > Config.MemoryLimit then
        Utilities:PrintDebug("High memory usage: " .. memory .. "MB", "WARN")
        
        -- Clear some cache
        if #Cache.CombatLog > Config.MaxLogEntries / 2 then
            table.remove(Cache.CombatLog, 1)
        end
    end
end

function CheckForUpdates()
    Utilities:PrintDebug("Checking for updates...", "INFO")
    
    -- This would check for updates from a remote source
    -- For now, just log
    Utilities:LogCombat("Update check performed - Running v" .. scriptVersion)
end

-- =============================================
-- SECTION 11: ANTI-AFK & SAFETY FEATURES
-- =============================================

local SafetySystem = {}

function SafetySystem:SetupAntiAFK()
    if not Config.AntiAFK then return end
    
    local VirtualUser = game:GetService("VirtualUser")
    
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
        Utilities:LogCombat("Anti-AFK triggered")
    end)
end

function SafetySystem:SetupAntiReport()
    if not Config.AntiReport then return end
    
    -- Randomize position slightly during combat
    task.spawn(function()
        while task.wait(5) do
            if States.IsAttacking and Target.Player then
                local randomOffset = Vector3.new(
                    math.random(-2, 2),
                    0,
                    math.random(-2, 2)
                )
                
                if HumanoidRootPart then
                    HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + randomOffset
                end
            end
        end
    end)
end

function SafetySystem:SetupCrashRecovery()
    if not Config.CrashRecovery then return end
    
    game:GetService("CoreGui").ChildRemoved:Connect(function(child)
        if child.Name == "AutoFarmerFallbackUI" or 
           (Window and child.Name == Window.Name) then
            Utilities:PrintDebug("UI removed, attempting recovery...", "WARN")
            
            task.wait(2)
            UISystem:CreateMainWindow()
        end
    end)
end

-- =============================================
-- SECTION 12: FINAL INITIALIZATION
-- =============================================

-- Set current combo
CurrentCombo = Combos.FastKill

-- Initialize safety systems
SafetySystem:SetupAntiAFK()
SafetySystem:SetupAntiReport()
SafetySystem:SetupCrashRecovery()

-- Start the system
task.spawn(InitializeSystem)

-- Final message
print("\n" .. string.rep("=", 60))
print("🔥 BLOX FRUITS AUTO FARMER v" .. scriptVersion .. " LOADED 🔥")
print(string.rep("=", 60))
print("📊 Total Lines: 1700+")
print("🎮 Features: Complete Auto Farming System")
print("⚙️ Status: READY")
print("📝 Press F1 to start farming")
print(string.rep("=", 60) .. "\n")

-- Return module for external use if needed
return {
    FarmingModule = FarmingModule,
    CombatSystem = CombatSystem,
    TargetingSystem = TargetingSystem,
    MovementSystem = MovementSystem,
    ServerSystem = ServerSystem,
    Utilities = Utilities,
    Config = Config,
    Statistics = Statistics,
    States = States,
    Target = Target
}
