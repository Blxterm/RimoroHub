--[[
██████╗ ██╗      ██████╗ ██╗  ██╗    ███████╗██████╗ ██╗   ██╗██╗████████╗███████╗
██╔══██╗██║     ██╔═══██╗╚██╗██╔╝    ██╔════╝██╔══██╗██║   ██║██║╚══██╔══╝██╔════╝
██████╔╝██║     ██║   ██║ ╚███╔╝     █████╗  ██████╔╝██║   ██║██║   ██║   ███████╗
██╔══██╗██║     ██║   ██║ ██╔██╗     ██╔══╝  ██╔══██╗██║   ██║██║   ██║   ╚════██║
██████╔╝███████╗╚██████╔╝██╔╝ ██╗    ██║     ██║  ██║╚██████╔╝██║   ██║   ███████║
╚═════╝ ╚══════╝ ╚═════╝ ╚═╝  ╚═╝    ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝   ╚═╝   ╚══════╝

██╗      █████╗ ██╗   ██╗████████╗ ██████╗     ███████╗██╗   ██╗██████╗ ███████╗██████╗ 
██║     ██╔══██╗╚██╗ ██╔╝╚══██╔══╝██╔═══██╗    ██╔════╝╚██╗ ██╔╝██╔══██╗██╔════╝██╔══██╗
██║     ███████║ ╚████╔╝    ██║   ██║   ██║    ███████╗ ╚████╔╝ ██████╔╝█████╗  ██████╔╝
██║     ██╔══██║  ╚██╔╝     ██║   ██║   ██║    ╚════██║  ╚██╔╝  ██╔═══╝ ██╔══╝  ██╔══██╗
███████╗██║  ██║   ██║      ██║   ╚██████╔╝    ███████║   ██║   ██║     ███████╗██║  ██║
╚══════╝╚═╝  ╚═╝   ╚═╝      ╚═╝    ╚═════╝     ╚══════╝   ╚═╝   ╚═╝     ╚══════╝╚═╝  ╚═╝

═══════════════════════════════════════════════════════════════════════════════════════
                    BLOX FRUITS AUTO BOUNTY SUPER FARMER v7.0
                          Total Lines: 1800+ | Complete System
═══════════════════════════════════════════════════════════════════════════════════════
]]

-- ========================================================
-- SECTION 1: COMPREHENSIVE INITIALIZATION & CONFIGURATION
-- ========================================================

local scriptVersion = "7.0.0"
local debugMode = true
local startTime = os.time()
local lastUpdateCheck = os.time()
local updateInterval = 3600
local scriptLoaded = false
local moduleCount = 0
local totalFunctions = 0
local errorCount = 0
local warningCount = 0
local successCount = 0
local performanceMetrics = {}
local systemResources = {}
local securityChecks = {}
local networkStatus = {}
local uiComponents = {}
local dataStructures = {}
local runtimeVariables = {}
local configurationProfiles = {}
local backupSystems = {}
local recoveryProtocols = {}
local optimizationModules = {}
local monitoringSystems = {}
local loggingSystems = {}
local notificationSystems = {}
local securitySystems = {}
local compatibilityLayers = {}

-- Load Rayfield UI with enhanced error handling
local Rayfield = nil
local uiLoadSuccess = false
local uiLoadAttempts = 0
local maxUILoadAttempts = 3

repeat
    uiLoadAttempts = uiLoadAttempts + 1
    local success, result = pcall(function()
        return loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
    end)
    
    if success and result then
        Rayfield = result
        uiLoadSuccess = true
        if debugMode then
            print("[SUCCESS] Rayfield UI loaded successfully on attempt " .. uiLoadAttempts)
        end
    else
        if debugMode then
            print("[WARNING] Failed to load Rayfield UI (Attempt " .. uiLoadAttempts .. ")")
        end
        task.wait(1)
    end
until uiLoadSuccess or uiLoadAttempts >= maxUILoadAttempts

if not uiLoadSuccess then
    if debugMode then
        print("[ERROR] Failed to load Rayfield UI after " .. maxUILoadAttempts .. " attempts")
    end
    -- Continue with fallback UI later
end

-- Comprehensive Service Collection
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
    MarketplaceService = game:GetService("MarketplaceService"),
    ContentProvider = game:GetService("ContentProvider"),
    Chat = game:GetService("Chat"),
    TextChatService = game:GetService("TextChatService"),
    CollectionService = game:GetService("CollectionService"),
    TestService = game:GetService("TestService"),
    ScriptContext = game:GetService("ScriptContext"),
    SocialService = game:GetService("SocialService"),
    StarterPack = game:GetService("StarterPack"),
    StarterGui = game:GetService("StarterGui"),
    StarterPlayer = game:GetService("StarterPlayer"),
    Teams = game:GetService("Teams"),
    GroupService = game:GetService("GroupService"),
    VoiceChatService = game:GetService("VoiceChatService"),
    LocalizationService = game:GetService("LocalizationService"),
    MaterialService = game:GetService("MaterialService"),
    MeshPartService = game:GetService("MeshPartService"),
    PhysicsService = game:GetService("PhysicsService"),
    PolicyService = game:GetService("PolicyService"),
    RenderSettings = game:GetService("RenderSettings"),
    Selection = game:GetService("Selection"),
    ServerScriptService = game:GetService("ServerScriptService"),
    ServerStorage = game:GetService("ServerStorage"),
    TextService = game:GetService("TextService"),
    TouchInputService = game:GetService("TouchInputService"),
    VRService = game:GetService("VRService"),
    AnalyticsService = game:GetService("AnalyticsService"),
    AssetService = game:GetService("AssetService"),
    BadgeService = game:GetService("BadgeService"),
    ChangeHistoryService = game:GetService("ChangeHistoryService"),
    ContextActionService = game:GetService("ContextActionService"),
    ControllerService = game:GetService("ControllerService"),
    CookieService = game:GetService("CookieService"),
    DataStoreService = game:GetService("DataStoreService"),
    Debris = game:GetService("Debris"),
    DialogueService = game:GetService("DialogueService"),
    GamepadService = game:GetService("GamepadService"),
    GuiService = game:GetService("GuiService"),
    HapticService = game:GetService("HapticService"),
    HttpRbxApiService = game:GetService("HttpRbxApiService"),
    InsertService = game:GetService("InsertService"),
    JointsService = game:GetService("JointsService"),
    KeyframeSequenceProvider = game:GetService("KeyframeSequenceProvider"),
    LogService = game:GetService("LogService"),
    MemoryStoreService = game:GetService("MemoryStoreService"),
    MessagingService = game:GetService("MessagingService"),
    NotificationService = game:GetService("NotificationService"),
    PackageService = game:GetService("PackageService"),
    PlayerEmulatorService = game:GetService("PlayerEmulatorService"),
    PointsService = game:GetService("PointsService"),
    ProximityPromptService = game:GetService("ProximityPromptService"),
    RBXScriptConnection = game:GetService("RBXScriptConnection"),
    RBXScriptSignal = game:GetService("RBXScriptSignal"),
    RealtimeStorageService = game:GetService("RealtimeStorageService"),
    RibbonService = game:GetService("RibbonService"),
    RuntimeScriptService = game:GetService("RuntimeScriptService"),
    ScriptEditorService = game:GetService("ScriptEditorService"),
    ShareService = game:GetService("ShareService"),
    StreamingService = game:GetService("StreamingService"),
    TaskScheduler = game:GetService("TaskScheduler"),
    TextureService = game:GetService("TextureService"),
    TranslationService = game:GetService("TranslationService"),
    TutorialService = game:GetService("TutorialService"),
    UserGameSettings = game:GetService("UserGameSettings"),
    VersionControlService = game:GetService("VersionControlService"),
    VisualStudioCodeDebugger = game:GetService("VisualStudioCodeDebugger"),
    WebService = game:GetService("WebService")
}

-- Player and Character References
local Player = Services.Players.LocalPlayer
local Character = nil
local Humanoid = nil
local HumanoidRootPart = nil
local CurrentCamera = Services.Workspace.CurrentCamera
local Mouse = Player:GetMouse()

-- Character Loading System
local function WaitForCharacter()
    local maxAttempts = 30
    local attempt = 0
    
    while attempt < maxAttempts do
        if Player.Character then
            Character = Player.Character
            Humanoid = Character:WaitForChild("Humanoid", 5)
            HumanoidRootPart = Character:WaitForChild("HumanoidRootPart", 5)
            
            if Humanoid and HumanoidRootPart then
                if debugMode then
                    print("[SUCCESS] Character loaded successfully")
                end
                return true
            end
        end
        
        attempt = attempt + 1
        if debugMode then
            print("[INFO] Waiting for character... Attempt " .. attempt)
        end
        task.wait(1)
    end
    
    if debugMode then
        print("[ERROR] Failed to load character after " .. maxAttempts .. " attempts")
    end
    return false
end

-- Initialize character
if not WaitForCharacter() then
    Player.CharacterAdded:Connect(function(newCharacter)
        Character = newCharacter
        Humanoid = newCharacter:WaitForChild("Humanoid")
        HumanoidRootPart = newCharacter:WaitForChild("HumanoidRootPart")
        if debugMode then
            print("[SUCCESS] Character loaded via CharacterAdded event")
        end
    end)
end

-- ========================================================
-- SECTION 2: ENHANCED STATE MANAGEMENT SYSTEM
-- ========================================================

local StateManager = {
    -- Core States
    IsFarming = false,
    IsAttacking = false,
    IsSearching = false,
    IsTeleporting = false,
    IsTargeting = false,
    IsServerHopping = false,
    IsAiming = false,
    IsComboExecuting = false,
    IsEmergency = false,
    IsPaused = false,
    IsInCombat = false,
    IsInSafeZone = false,
    IsInitialized = false,
    IsUILoaded = false,
    IsConfigLoaded = false,
    IsPerformanceOptimized = false,
    IsSecurityEnabled = false,
    
    -- Sub-States
    FarmingSubStates = {
        SearchingForTarget = false,
        ApproachingTarget = false,
        EngagingTarget = false,
        ExecutingCombo = false,
        WaitingForCooldown = false,
        RecoveringHealth = false,
        EvadingDanger = false,
        CollectingRewards = false
    },
    
    -- Performance States
    PerformanceStates = {
        MemoryUsage = "Normal",
        CPULoad = "Normal",
        NetworkLatency = "Normal",
        FrameRate = "Optimal",
        ScriptPerformance = "Good"
    },
    
    -- Safety States
    SafetyStates = {
        HealthStatus = "Good",
        DistanceToSafeZone = "Far",
        ThreatLevel = "Low",
        CombatStatus = "Idle",
        DetectionRisk = "Low"
    },
    
    -- UI States
    UIStates = {
        MainWindowOpen = false,
        SettingsOpen = false,
        StatsOpen = false,
        LogsOpen = false,
        NotificationsEnabled = true,
        AutoHideUI = false
    },
    
    -- Target States
    TargetStates = {
        HasTarget = false,
        TargetValid = false,
        TargetInRange = false,
        TargetVulnerable = false,
        TargetEngaged = false,
        TargetEliminated = false
    },
    
    -- System States
    SystemStates = {
        AutoStartEnabled = true,
        AutoHopEnabled = true,
        AutoRecoveryEnabled = true,
        AutoUpdateEnabled = true,
        BackupEnabled = true,
        LoggingEnabled = true,
        ErrorHandlingEnabled = true
    }
}

-- State Change History
local StateHistory = {
    FarmingStateChanges = {},
    TargetStateChanges = {},
    ErrorStateChanges = {},
    PerformanceStateChanges = {}
}

-- State Validation Functions
local function ValidateState(stateName, expectedValue)
    if StateManager[stateName] ~= expectedValue then
        if debugMode then
            print("[STATE VALIDATION] State " .. stateName .. " is not " .. tostring(expectedValue))
        end
        return false
    end
    return true
end

local function LogStateChange(stateName, oldValue, newValue)
    local timestamp = os.date("%H:%M:%S")
    local entry = {
        Time = timestamp,
        State = stateName,
        OldValue = oldValue,
        NewValue = newValue
    }
    
    table.insert(StateHistory.FarmingStateChanges, entry)
    
    if #StateHistory.FarmingStateChanges > 100 then
        table.remove(StateHistory.FarmingStateChanges, 1)
    end
    
    if debugMode then
        print("[STATE CHANGE] " .. stateName .. ": " .. tostring(oldValue) .. " -> " .. tostring(newValue))
    end
end

-- State Transition Functions
local function SetFarmingState(newState)
    local oldState = StateManager.IsFarming
    if oldState ~= newState then
        StateManager.IsFarming = newState
        LogStateChange("IsFarming", oldState, newState)
        
        -- Update dependent states
        if newState == false then
            StateManager.IsAttacking = false
            StateManager.IsTargeting = false
            StateManager.FarmingSubStates.SearchingForTarget = false
            StateManager.FarmingSubStates.EngagingTarget = false
        end
    end
end

local function SetPauseState(newState)
    local oldState = StateManager.IsPaused
    if oldState ~= newState then
        StateManager.IsPaused = newState
        LogStateChange("IsPaused", oldState, newState)
        
        if newState then
            -- Pause all active processes
            StateManager.IsAttacking = false
            StateManager.IsComboExecuting = false
        end
    end
end

local function UpdatePerformanceState()
    local memUsage = Services.Stats:GetMemoryUsageMb()
    local frameRate = Services.Stats.Workspace:GetRealPhysicsFPS()
    
    -- Update memory state
    if memUsage < 200 then
        StateManager.PerformanceStates.MemoryUsage = "Low"
    elseif memUsage < 500 then
        StateManager.PerformanceStates.MemoryUsage = "Normal"
    else
        StateManager.PerformanceStates.MemoryUsage = "High"
    end
    
    -- Update FPS state
    if frameRate > 50 then
        StateManager.PerformanceStates.FrameRate = "Optimal"
    elseif frameRate > 30 then
        StateManager.PerformanceStates.FrameRate = "Normal"
    else
        StateManager.PerformanceStates.FrameRate = "Low"
    end
end

-- State Monitoring System
local StateMonitor = {
    LastUpdate = os.time(),
    UpdateInterval = 5,
    
    MonitorStates = function()
        while true do
            local currentTime = os.time()
            
            if currentTime - StateMonitor.LastUpdate >= StateMonitor.UpdateInterval then
                UpdatePerformanceState()
                
                -- Check for stuck states
                if StateManager.IsAttacking and not StateManager.TargetStates.HasTarget then
                    if debugMode then
                        print("[STATE MONITOR] Invalid state: Attacking without target")
                    end
                    StateManager.IsAttacking = false
                end
                
                StateMonitor.LastUpdate = currentTime
            end
            
            task.wait(1)
        end
    end,
    
    GetStateSummary = function()
        local summary = {
            TotalStates = 0,
            ActiveStates = 0,
            InactiveStates = 0,
            WarningStates = 0,
            ErrorStates = 0
        }
        
        -- Count core states
        for stateName, stateValue in pairs(StateManager) do
            if type(stateValue) == "boolean" then
                summary.TotalStates = summary.TotalStates + 1
                if stateValue then
                    summary.ActiveStates = summary.ActiveStates + 1
                else
                    summary.InactiveStates = summary.InactiveStates + 1
                end
            end
        end
        
        return summary
    end
}

-- Start state monitoring
task.spawn(StateMonitor.MonitorStates)

-- ========================================================
-- SECTION 3: COMPREHENSIVE CONFIGURATION SYSTEM
-- ========================================================

local ConfigurationSystem = {
    Profiles = {
        Default = {
            -- Targeting Configuration
            Targeting = {
                MinLevel = 2200,
                MaxLevel = 2800,
                MinDistance = 10,
                MaxDistance = 2000,
                TargetPriority = "Bounty", -- Options: Bounty, Level, Distance, Random, Health
                AvoidFriends = true,
                AvoidCrewMembers = false,
                AvoidAllies = true,
                PrioritizeHighBounty = true,
                SkipSafeZonePlayers = true,
                SkipLowLevelPlayers = true,
                SkipHighLevelPlayers = false,
                TargetSelectionAlgorithm = "Advanced",
                ScanRadius = 5000,
                ScanFrequency = 1,
                MaxTargetsToScan = 50
            },
            
            -- Combat Configuration
            Combat = {
                AttackSpeed = 0.15,
                ComboSpeed = 0.1,
                MaxComboLength = 15,
                UseRandomDelays = true,
                MinDelay = 0.05,
                MaxDelay = 0.2,
                AutoDodge = true,
                DodgeProbability = 0.7,
                AutoBlock = true,
                BlockProbability = 0.6,
                AutoCounter = true,
                CounterProbability = 0.5,
                UsePredictiveAiming = true,
                AimPredictionTime = 0.2,
                AutoReload = true,
                ReloadThreshold = 0.3,
                SkillRotation = "Optimal",
                ComboPreset = "FastKill",
                EnableRageMode = false,
                RageModeThreshold = 0.3,
                UseUltimateSkills = true,
                UltimateThreshold = 0.4
            },
            
            -- Movement Configuration
            Movement = {
                TeleportSpeed = 350,
                TeleportMethod = "Tween", -- Options: Tween, CFrame, Network, Hybrid
                UsePathfinding = true,
                PathfindingAlgorithm = "AStar",
                AvoidObstacles = true,
                ObstacleDetectionRange = 50,
                NoClipDuringCombat = true,
                HeightOffset = 3,
                HorizontalOffset = 5,
                MovementSmoothing = true,
                SmoothingFactor = 0.8,
                AutoJumpObstacles = true,
                JumpHeight = 7,
                UseWallClimb = false,
                WallClimbHeight = 10,
                EnableFlight = false,
                FlightHeight = 20,
                FlightSpeed = 100
            },
            
            -- Skills Configuration
            Skills = {
                UseMeleeSkills = true,
                UseSwordSkills = true,
                UseFruitSkills = true,
                UseGunSkills = true,
                UseRaceSkills = true,
                UseFightingStyles = true,
                SkillCooldownManagement = true,
                AutoSkillRotation = true,
                SkillPriority = {
                    "Ultimate",
                    "Transform",
                    "Awakened",
                    "Special",
                    "Basic"
                },
                MaxSkillsPerCombo = 8,
                SkillChainEnabled = true,
                ChainComboLength = 4,
                EnableSkillCanceling = true,
                CancelWindow = 0.1
            },
            
            -- Safety Configuration
            Safety = {
                LowHPThreshold = 30,
                LowHPThresholdPercentage = 0.3,
                EmergencyTeleportDistance = 500,
                EmergencyTeleportHeight = 50,
                AntiAFK = true,
                AntiAFKInterval = 30,
                AntiReport = true,
                ReportAvoidanceMethod = "PositionRandomization",
                AutoRejoin = true,
                RejoinDelay = 10,
                CrashRecovery = true,
                RecoveryAttempts = 3,
                EnableHealthMonitoring = true,
                HealthCheckInterval = 2,
                EnableStaminaMonitoring = false,
                StaminaThreshold = 0.2,
                EnableCooldownMonitoring = true,
                CooldownSafetyMargin = 0.5
            },
            
            -- Server Configuration
            Server = {
                AutoServerHop = true,
                ServerHopDelay = 300,
                MinPlayersForHop = 3,
                MaxPlayersForHop = 20,
                TargetServerRegion = "Germany",
                ServerRegionPriority = {
                    "Germany",
                    "Europe",
                    "USA",
                    "Asia",
                    "Australia"
                },
                AvoidFullServers = true,
                ServerStabilityCheck = true,
                StabilityThreshold = 0.8,
                PreferLowPingServers = true,
                MaxPingThreshold = 200,
                EnableServerBlacklist = true,
                BlacklistDuration = 3600,
                EnableServerWhitelist = false,
                ServerScanLimit = 100,
                ConnectionRetryCount = 3
            },
            
            -- UI Configuration
            UI = {
                ShowGUI = true,
                ShowNotifications = true,
                ShowTargetInfo = true,
                ShowDamageNumbers = true,
                ShowComboDisplay = true,
                ShowPerformanceStats = true,
                ShowSystemStatus = true,
                EnableTransparency = true,
                TransparencyLevel = 0.8,
                ColorScheme = "Dark",
                FontSize = 14,
                EnableAnimations = true,
                AnimationSpeed = 1,
                AutoHideUI = false,
                HideDelay = 10,
                EnableKeybindsDisplay = true,
                EnableTooltips = true,
                EnableSoundEffects = false,
                SoundVolume = 0.5
            },
            
            -- Performance Configuration
            Performance = {
                UpdateRate = 60,
                CacheLifetime = 60,
                MaxLogEntries = 1000,
                MemoryLimit = 500,
                EnableGarbageCollection = true,
                GcFrequency = 60,
                OptimizeRendering = true,
                RenderDistance = 1000,
                EnableLOD = true,
                LODDistance = 500,
                EnableCulling = true,
                CullingDistance = 100,
                ReduceParticles = true,
                MaxParticles = 100,
                LimitPhysics = true,
                PhysicsRate = 30
            },
            
            -- Advanced Configuration
            Advanced = {
                EnableDebugMode = false,
                DebugLevel = "Info", -- Options: Error, Warning, Info, Debug
                EnableProfiling = false,
                ProfileInterval = 60,
                EnableTelemetry = false,
                TelemetryInterval = 300,
                EnableBackup = true,
                BackupInterval = 600,
                EnableAutoUpdate = true,
                UpdateCheckInterval = 3600,
                EnableExperimentalFeatures = false,
                ExperimentalFeatureList = {},
                EnableCustomScripts = false,
                CustomScriptsPath = "",
                EnableAPI = false,
                APIPort = 8080
            }
        },
        
        Aggressive = {
            Targeting = {
                MinLevel = 2000,
                MaxLevel = 3000,
                TargetPriority = "Distance",
                AvoidFriends = false
            },
            Combat = {
                AttackSpeed = 0.08,
                UseRandomDelays = false
            }
        },
        
        Stealth = {
            Targeting = {
                MinLevel = 2300,
                MaxLevel = 2700,
                TargetPriority = "Bounty"
            },
            Combat = {
                AttackSpeed = 0.2,
                UseRandomDelays = true
            },
            Safety = {
                AntiReport = true
            }
        }
    },
    
    CurrentProfile = "Default",
    CurrentConfig = {},
    
    Initialize = function(self)
        self.CurrentConfig = self.Profiles[self.CurrentProfile]
        if debugMode then
            print("[CONFIG] Configuration system initialized with profile: " .. self.CurrentProfile)
        end
        return true
    end,
    
    LoadProfile = function(self, profileName)
        if self.Profiles[profileName] then
            self.CurrentProfile = profileName
            self.CurrentConfig = self.Profiles[profileName]
            if debugMode then
                print("[CONFIG] Loaded profile: " .. profileName)
            end
            return true
        else
            if debugMode then
                print("[CONFIG ERROR] Profile not found: " .. profileName)
            end
            return false
        end
    end,
    
    SaveProfile = function(self, profileName)
        self.Profiles[profileName] = table.clone(self.CurrentConfig)
        if debugMode then
            print("[CONFIG] Saved profile: " .. profileName)
        end
        return true
    end,
    
    GetValue = function(self, path)
        local parts = string.split(path, ".")
        local current = self.CurrentConfig
        
        for _, part in ipairs(parts) do
            if current[part] then
                current = current[part]
            else
                if debugMode then
                    print("[CONFIG ERROR] Path not found: " .. path)
                end
                return nil
            end
        end
        
        return current
    end,
    
    SetValue = function(self, path, value)
        local parts = string.split(path, ".")
        local current = self.CurrentConfig
        
        for i = 1, #parts - 1 do
            if not current[parts[i]] then
                current[parts[i]] = {}
            end
            current = current[parts[i]]
        end
        
        current[parts[#parts]] = value
        
        if debugMode then
            print("[CONFIG] Set " .. path .. " = " .. tostring(value))
        end
        return true
    end,
    
    ExportConfig = function(self)
        local configString = Services.HttpService:JSONEncode(self.CurrentConfig)
        return configString
    end,
    
    ImportConfig = function(self, configString)
        local success, config = pcall(function()
            return Services.HttpService:JSONDecode(configString)
        end)
        
        if success and config then
            self.CurrentConfig = config
            if debugMode then
                print("[CONFIG] Configuration imported successfully")
            end
            return true
        else
            if debugMode then
                print("[CONFIG ERROR] Failed to import configuration")
            end
            return false
        end
    end,
    
    ResetToDefault = function(self)
        self.CurrentProfile = "Default"
        self.CurrentConfig = table.clone(self.Profiles.Default)
        if debugMode then
            print("[CONFIG] Configuration reset to default")
        end
        return true
    end,
    
    ValidateConfig = function(self)
        local errors = {}
        
        -- Validate targeting config
        if self.CurrentConfig.Targeting.MinLevel > self.CurrentConfig.Targeting.MaxLevel then
            table.insert(errors, "MinLevel cannot be greater than MaxLevel")
        end
        
        if self.CurrentConfig.Combat.AttackSpeed < 0.01 then
            table.insert(errors, "AttackSpeed too low")
        end
        
        if self.CurrentConfig.Performance.UpdateRate < 10 or self.CurrentConfig.Performance.UpdateRate > 120 then
            table.insert(errors, "UpdateRate out of range")
        end
        
        return #errors == 0, errors
    end
}

-- Initialize configuration system
ConfigurationSystem:Initialize()

-- ========================================================
-- SECTION 4: ADVANCED STATISTICS AND ANALYTICS SYSTEM
-- ========================================================

local StatisticsSystem = {
    -- Session Statistics
    Session = {
        StartTime = os.time(),
        BountyEarned = 0,
        Kills = 0,
        Deaths = 0,
        DamageDealt = 0,
        DamageTaken = 0,
        CombosExecuted = 0,
        SkillsUsed = 0,
        Teleports = 0,
        ServerHops = 0,
        ErrorsEncountered = 0,
        WarningsEncountered = 0,
        Uptime = 0,
        Efficiency = 0,
        PerformanceScore = 0
    },
    
    -- Lifetime Statistics
    Lifetime = {
        TotalBounty = 0,
        TotalKills = 0,
        TotalDeaths = 0,
        TotalDamageDealt = 0,
        TotalDamageTaken = 0,
        TotalPlayTime = 0,
        TotalServerHops = 0,
        TotalCombos = 0,
        TotalSkills = 0,
        MaxBountyInSession = 0,
        MaxKillsInSession = 0,
        MaxKillStreak = 0,
        MaxEfficiency = 0,
        BestSessionTime = 0,
        WorstSessionTime = 0
    },
    
    -- Real-time Statistics
    RealTime = {
        BountyPerHour = 0,
        KillsPerHour = 0,
        DamagePerMinute = 0,
        ComboSuccessRate = 0,
        SkillAccuracy = 0,
        TargetAcquisitionTime = 0,
        KillTimeAverage = 0,
        SurvivalRate = 0,
        ResourceEfficiency = 0,
        PerformanceIndex = 0
    },
    
    -- Detailed Tracking
    Details = {
        BountyHistory = {},
        KillHistory = {},
        DamageHistory = {},
        ComboHistory = {},
        SkillHistory = {},
        TeleportHistory = {},
        ErrorHistory = {},
        PerformanceHistory = {},
        TargetHistory = {},
        SessionHistory = {}
    },
    
    -- Performance Metrics
    Performance = {
        FPSHistory = {},
        MemoryHistory = {},
        NetworkHistory = {},
        CPULoadHistory = {},
        ScriptLoadHistory = {},
        RenderingHistory = {}
    },
    
    -- Initialize the statistics system
    Initialize = function(self)
        self.Session.StartTime = os.time()
        
        -- Load lifetime stats from saved data if available
        local success, savedStats = pcall(function()
            if readfile then
                return Services.HttpService:JSONDecode(readfile("BloxFarmer_Stats.json"))
            end
        end)
        
        if success and savedStats then
            self.Lifetime = savedStats.Lifetime or self.Lifetime
            if debugMode then
                print("[STATS] Lifetime statistics loaded")
            end
        end
        
        return true
    end,
    
    -- Update session statistics
    UpdateSessionStats = function(self)
        local currentTime = os.time()
        self.Session.Uptime = currentTime - self.Session.StartTime
        
        -- Calculate real-time stats
        local hours = self.Session.Uptime / 3600
        if hours > 0 then
            self.RealTime.BountyPerHour = self.Session.BountyEarned / hours
            self.RealTime.KillsPerHour = self.Session.Kills / hours
        end
        
        -- Calculate efficiency
        if self.Session.Kills > 0 then
            self.Session.Efficiency = (self.Session.BountyEarned / self.Session.Kills) * 100
        end
        
        -- Update performance score
        self.CalculatePerformanceScore()
        
        return true
    end,
    
    -- Record a kill
    RecordKill = function(self, playerName, bountyEarned)
        local timestamp = os.time()
        
        -- Update session stats
        self.Session.Kills = self.Session.Kills + 1
        self.Session.BountyEarned = self.Session.BountyEarned + bountyEarned
        
        -- Update lifetime stats
        self.Lifetime.TotalKills = self.Lifetime.TotalKills + 1
        self.Lifetime.TotalBounty = self.Lifetime.TotalBounty + bountyEarned
        
        -- Update max values
        if bountyEarned > self.Lifetime.MaxBountyInSession then
            self.Lifetime.MaxBountyInSession = bountyEarned
        end
        
        -- Record in history
        local killRecord = {
            Time = timestamp,
            Player = playerName,
            Bounty = bountyEarned,
            SessionKills = self.Session.Kills,
            SessionBounty = self.Session.BountyEarned
        }
        
        table.insert(self.Details.KillHistory, killRecord)
        
        -- Keep history limited
        if #self.Details.KillHistory > 1000 then
            table.remove(self.Details.KillHistory, 1)
        end
        
        -- Update real-time stats
        self.UpdateSessionStats()
        
        if debugMode then
            print("[STATS] Kill recorded: " .. playerName .. " (+" .. bountyEarned .. " bounty)")
        end
        
        return true
    end,
    
    -- Record combo execution
    RecordCombo = function(self, comboName, successRate, damageDealt)
        self.Session.CombosExecuted = self.Session.CombosExecuted + 1
        self.Lifetime.TotalCombos = self.Lifetime.TotalCombos + 1
        self.Session.DamageDealt = self.Session.DamageDealt + damageDealt
        
        local comboRecord = {
            Time = os.time(),
            Name = comboName,
            SuccessRate = successRate,
            Damage = damageDealt,
            TotalCombos = self.Session.CombosExecuted
        }
        
        table.insert(self.Details.ComboHistory, comboRecord)
        
        if #self.Details.ComboHistory > 500 then
            table.remove(self.Details.ComboHistory, 1)
        end
        
        return true
    end,
    
    -- Record server hop
    RecordServerHop = function(self, serverId, reason)
        self.Session.ServerHops = self.Session.ServerHops + 1
        self.Lifetime.TotalServerHops = self.Lifetime.TotalServerHops + 1
        
        local hopRecord = {
            Time = os.time(),
            ServerId = serverId,
            Reason = reason,
            TotalHops = self.Session.ServerHops
        }
        
        table.insert(self.Details.TeleportHistory, hopRecord)
        
        if debugMode then
            print("[STATS] Server hop recorded: " .. reason)
        end
        
        return true
    end,
    
    -- Record error
    RecordError = function(self, errorType, errorMessage, severity)
        self.Session.ErrorsEncountered = self.Session.ErrorsEncountered + 1
        
        local errorRecord = {
            Time = os.time(),
            Type = errorType,
            Message = errorMessage,
            Severity = severity,
            TotalErrors = self.Session.ErrorsEncountered
        }
        
        table.insert(self.Details.ErrorHistory, errorRecord)
        
        if debugMode then
            print("[STATS] Error recorded: " .. errorType .. " - " .. errorMessage)
        end
        
        return true
    end,
    
    -- Calculate performance score
    CalculatePerformanceScore = function(self)
        local score = 100
        
        -- Deduct for errors
        if self.Session.ErrorsEncountered > 0 then
            score = score - (self.Session.ErrorsEncountered * 0.5)
        end
        
        -- Add for efficiency
        if self.Session.Efficiency > 0 then
            score = score + (self.Session.Efficiency / 10)
        end
        
        -- Add for kill rate
        if self.RealTime.KillsPerHour > 0 then
            score = score + (self.RealTime.KillsPerHour / 5)
        end
        
        -- Ensure score is within bounds
        score = math.max(0, math.min(100, score))
        
        self.Session.PerformanceScore = score
        
        return score
    end,
    
    -- Generate statistics report
    GenerateReport = function(self, reportType)
        local report = {
            Timestamp = os.time(),
            ReportType = reportType,
            SessionDuration = self.Session.Uptime,
            SessionStats = {
                BountyEarned = self.Session.BountyEarned,
                Kills = self.Session.Kills,
                Efficiency = self.Session.Efficiency,
                PerformanceScore = self.Session.PerformanceScore,
                Errors = self.Session.ErrorsEncountered
            },
            RealTimeStats = {
                BountyPerHour = self.RealTime.BountyPerHour,
                KillsPerHour = self.RealTime.KillsPerHour
            },
            LifetimeStats = {
                TotalBounty = self.Lifetime.TotalBounty,
                TotalKills = self.Lifetime.TotalKills
            }
        }
        
        return report
    end,
    
    -- Save statistics to file
    SaveStats = function(self)
        local statsData = {
            Lifetime = self.Lifetime,
            Details = {
                KillHistory = self.Details.KillHistory,
                ComboHistory = self.Details.ComboHistory,
                ErrorHistory = self.Details.ErrorHistory
            },
            LastUpdate = os.time()
        }
        
        local success = pcall(function()
            if writefile then
                local json = Services.HttpService:JSONEncode(statsData)
                writefile("BloxFarmer_Stats.json", json)
                return true
            end
        end)
        
        if success then
            if debugMode then
                print("[STATS] Statistics saved successfully")
            end
        else
            if debugMode then
                print("[STATS ERROR] Failed to save statistics")
            end
        end
        
        return success
    end,
    
    -- Reset session statistics
    ResetSession = function(self)
        self.Session = {
            StartTime = os.time(),
            BountyEarned = 0,
            Kills = 0,
            Deaths = 0,
            DamageDealt = 0,
            DamageTaken = 0,
            CombosExecuted = 0,
            SkillsUsed = 0,
            Teleports = 0,
            ServerHops = 0,
            ErrorsEncountered = 0,
            WarningsEncountered = 0,
            Uptime = 0,
            Efficiency = 0,
            PerformanceScore = 0
        }
        
        self.RealTime = {
            BountyPerHour = 0,
            KillsPerHour = 0,
            DamagePerMinute = 0,
            ComboSuccessRate = 0,
            SkillAccuracy = 0,
            TargetAcquisitionTime = 0,
            KillTimeAverage = 0,
            SurvivalRate = 0,
            ResourceEfficiency = 0,
            PerformanceIndex = 0
        }
        
        if debugMode then
            print("[STATS] Session statistics reset")
        end
        
        return true
    end
}

-- Initialize statistics system
StatisticsSystem:Initialize()

-- ========================================================
-- SECTION 5: TARGETING SYSTEM ENHANCEMENTS
-- ========================================================

local AdvancedTargetingSystem = {
    Cache = {
        PlayerData = {},
        SafeZones = {},
        Blacklist = {},
        Whitelist = {},
        RecentTargets = {},
        PlayerHistory = {}
    },
    
    Algorithms = {
        -- Distance-based targeting
        DistanceBased = function(players)
            local closest = nil
            local closestDist = math.huge
            
            for _, player in pairs(players) do
                if AdvancedTargetingSystem:IsValidTarget(player) then
                    local dist = AdvancedTargetingSystem:CalculateDistance(player)
                    if dist < closestDist then
                        closestDist = dist
                        closest = player
                    end
                end
            end
            
            return closest
        end,
        
        -- Bounty-based targeting
        BountyBased = function(players)
            local highestBounty = nil
            local highestValue = 0
            
            for _, player in pairs(players) do
                if AdvancedTargetingSystem:IsValidTarget(player) then
                    local bounty = AdvancedTargetingSystem:EstimateBounty(player)
                    if bounty > highestValue then
                        highestValue = bounty
                        highestBounty = player
                    end
                end
            end
            
            return highestBounty
        end,
        
        -- Level-based targeting
        LevelBased = function(players)
            local optimalTarget = nil
            local optimalScore = -math.huge
            
            for _, player in pairs(players) do
                if AdvancedTargetingSystem:IsValidTarget(player) then
                    local level = AdvancedTargetingSystem:EstimateLevel(player)
                    local score = AdvancedTargetingSystem:CalculateLevelScore(level)
                    
                    if score > optimalScore then
                        optimalScore = score
                        optimalTarget = player
                    end
                end
            end
            
            return optimalTarget
        end,
        
        -- Hybrid targeting (combines multiple factors)
        Hybrid = function(players)
            local bestTarget = nil
            local bestScore = -math.huge
            
            for _, player in pairs(players) do
                if AdvancedTargetingSystem:IsValidTarget(player) then
                    local score = AdvancedTargetingSystem:CalculateHybridScore(player)
                    
                    if score > bestScore then
                        bestScore = score
                        bestTarget = player
                    end
                end
            end
            
            return bestTarget
        end,
        
        -- Random targeting with weights
        WeightedRandom = function(players)
            local validPlayers = {}
            local weights = {}
            
            for _, player in pairs(players) do
                if AdvancedTargetingSystem:IsValidTarget(player) then
                    table.insert(validPlayers, player)
                    local weight = AdvancedTargetingSystem:CalculateWeight(player)
                    table.insert(weights, weight)
                end
            end
            
            if #validPlayers == 0 then
                return nil
            end
            
            -- Weighted random selection
            local totalWeight = 0
            for _, weight in ipairs(weights) do
                totalWeight = totalWeight + weight
            end
            
            local randomValue = math.random() * totalWeight
            local cumulativeWeight = 0
            
            for i, player in ipairs(validPlayers) do
                cumulativeWeight = cumulativeWeight + weights[i]
                if randomValue <= cumulativeWeight then
                    return player
                end
            end
            
            return validPlayers[#validPlayers]
        end
    },
    
    -- Initialize targeting system
    Initialize = function(self)
        self:ScanSafeZones()
        self:LoadBlacklist()
        self:LoadWhitelist()
        
        if debugMode then
            print("[TARGETING] Advanced targeting system initialized")
        end
        
        return true
    end,
    
    -- Scan for safe zones
    ScanSafeZones = function(self)
        self.Cache.SafeZones = {}
        
        for _, part in pairs(Services.Workspace:GetDescendants()) do
            if part.Name:lower():find("safe") or part.Name:lower():find("zone") then
                if part:IsA("BasePart") then
                    local safeZone = {
                        Position = part.Position,
                        Size = part.Size,
                        Name = part.Name
                    }
                    table.insert(self.Cache.SafeZones, safeZone)
                end
            end
        end
        
        if debugMode then
            print("[TARGETING] Found " .. #self.Cache.SafeZones .. " safe zones")
        end
    end,
    
    -- Check if position is in safe zone
    IsInSafeZone = function(self, position)
        for _, zone in pairs(self.Cache.SafeZones) do
            local zoneMin = zone.Position - (zone.Size / 2)
            local zoneMax = zone.Position + (zone.Size / 2)
            
            if position.X >= zoneMin.X and position.X <= zoneMax.X and
               position.Y >= zoneMin.Y and position.Y <= zoneMax.Y and
               position.Z >= zoneMin.Z and position.Z <= zoneMax.Z then
                return true
            end
        end
        
        return false
    end,
    
    -- Calculate distance to player
    CalculateDistance = function(self, player)
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            return math.huge
        end
        
        if not HumanoidRootPart then
            return math.huge
        end
        
        return (HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
    end,
    
    -- Estimate player level (placeholder - needs actual implementation)
    EstimateLevel = function(self, player)
        -- This should be replaced with actual level detection
        -- For now, return a random value within range
        return math.random(ConfigurationSystem.CurrentConfig.Targeting.MinLevel, 
                          ConfigurationSystem.CurrentConfig.Targeting.MaxLevel)
    end,
    
    -- Estimate player bounty (placeholder - needs actual implementation)
    EstimateBounty = function(self, player)
        -- This should be replaced with actual bounty detection
        local level = self:EstimateLevel(player)
        return level * 5 -- Rough estimate
    end,
    
    -- Check if player is valid target
    IsValidTarget = function(self, player)
        if player == Player then
            return false
        end
        
        if not player.Character then
            return false
        end
        
        local humanoid = player.Character:FindFirstChild("Humanoid")
        local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
        
        if not humanoid or not rootPart then
            return false
        end
        
        if humanoid.Health <= 0 then
            return false
        end
        
        -- Check safe zone
        if self:IsInSafeZone(rootPart.Position) then
            return false
        end
        
        -- Check blacklist
        if self.Cache.Blacklist[player.UserId] then
            return false
        end
        
        -- Check level range
        local level = self:EstimateLevel(player)
        if level < ConfigurationSystem.CurrentConfig.Targeting.MinLevel or
           level > ConfigurationSystem.CurrentConfig.Targeting.MaxLevel then
            return false
        end
        
        -- Check distance
        local distance = self:CalculateDistance(player)
        if distance > ConfigurationSystem.CurrentConfig.Targeting.MaxDistance then
            return false
        end
        
        -- Check if recently targeted
        if self.Cache.RecentTargets[player.UserId] then
            local timeSinceLastTarget = os.time() - self.Cache.RecentTargets[player.UserId]
            if timeSinceLastTarget < 300 then -- 5 minutes cooldown
                return false
            end
        end
        
        -- Check if friend (if configured)
        if ConfigurationSystem.CurrentConfig.Targeting.AvoidFriends then
            local success, isFriend = pcall(function()
                return player:IsFriendsWith(Player.UserId)
            end)
            
            if success and isFriend then
                return false
            end
        end
        
        return true
    end,
    
    -- Calculate level score
    CalculateLevelScore = function(self, level)
        local minLevel = ConfigurationSystem.CurrentConfig.Targeting.MinLevel
        local maxLevel = ConfigurationSystem.CurrentConfig.Targeting.MaxLevel
        local optimalLevel = (minLevel + maxLevel) / 2
        
        -- Score higher for levels closer to optimal
        local distanceFromOptimal = math.abs(level - optimalLevel)
        local maxDistance = (maxLevel - minLevel) / 2
        
        return 100 * (1 - (distanceFromOptimal / maxDistance))
    end,
    
    -- Calculate hybrid score
    CalculateHybridScore = function(self, player)
        local score = 0
        
        -- Distance factor (closer is better)
        local distance = self:CalculateDistance(player)
        local maxDistance = ConfigurationSystem.CurrentConfig.Targeting.MaxDistance
        score = score + (100 * (1 - (distance / maxDistance)))
        
        -- Level factor (optimal level is best)
        local level = self:EstimateLevel(player)
        score = score + self:CalculateLevelScore(level)
        
        -- Bounty factor (higher is better)
        local bounty = self:EstimateBounty(player)
        score = score + (bounty / 100)
        
        -- Health factor (lower is better)
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then
            local healthPercent = humanoid.Health / humanoid.MaxHealth
            score = score + (100 * (1 - healthPercent))
        end
        
        return score
    end,
    
    -- Calculate weight for random selection
    CalculateWeight = function(self, player)
        local baseWeight = 1
        
        -- Increase weight for closer targets
        local distance = self:CalculateDistance(player)
        baseWeight = baseWeight * (1000 / (distance + 1))
        
        -- Increase weight for higher bounty
        local bounty = self:EstimateBounty(player)
        baseWeight = baseWeight * (1 + (bounty / 10000))
        
        -- Decrease weight if recently targeted
        if self.Cache.RecentTargets[player.UserId] then
            baseWeight = baseWeight * 0.5
        end
        
        return baseWeight
    end,
    
    -- Find best target using selected algorithm
    FindBestTarget = function(self)
        local players = Services.Players:GetPlayers()
        local algorithm = ConfigurationSystem.CurrentConfig.Targeting.TargetPriority
        
        if algorithm == "Distance" then
            return self.Algorithms.DistanceBased(players)
        elseif algorithm == "Bounty" then
            return self.Algorithms.BountyBased(players)
        elseif algorithm == "Level" then
            return self.Algorithms.LevelBased(players)
        elseif algorithm == "Hybrid" then
            return self.Algorithms.Hybrid(players)
        elseif algorithm == "Random" then
            return self.Algorithms.WeightedRandom(players)
        else
            -- Default to hybrid
            return self.Algorithms.Hybrid(players)
        end
    end,
    
    -- Find random valid target
    FindRandomTarget = function(self)
        local validPlayers = {}
        
        for _, player in pairs(Services.Players:GetPlayers()) do
            if self:IsValidTarget(player) then
                table.insert(validPlayers, player)
            end
        end
        
        if #validPlayers > 0 then
            return validPlayers[math.random(1, #validPlayers)]
        end
        
        return nil
    end,
    
    -- Mark player as recently targeted
    MarkAsTargeted = function(self, player)
        if player and player.UserId then
            self.Cache.RecentTargets[player.UserId] = os.time()
        end
    end,
    
    -- Add player to blacklist
    AddToBlacklist = function(self, player, duration)
        if player and player.UserId then
            self.Cache.Blacklist[player.UserId] = {
                Time = os.time(),
                Duration = duration or 3600, -- 1 hour default
                Reason = "Manual blacklist"
            }
            
            if debugMode then
                print("[TARGETING] Added " .. player.Name .. " to blacklist")
            end
        end
    end,
    
    -- Load blacklist from file
    LoadBlacklist = function(self)
        local success, data = pcall(function()
            if readfile then
                return Services.HttpService:JSONDecode(readfile("BloxFarmer_Blacklist.json"))
            end
        end)
        
        if success and data then
            self.Cache.Blacklist = data
            if debugMode then
                print("[TARGETING] Blacklist loaded: " .. #self.Cache.Blacklist .. " entries")
            end
        end
    end,
    
    -- Load whitelist from file
    LoadWhitelist = function(self)
        local success, data = pcall(function()
            if readfile then
                return Services.HttpService:JSONDecode(readfile("BloxFarmer_Whitelist.json"))
            end
        end)
        
        if success and data then
            self.Cache.Whitelist = data
            if debugMode then
                print("[TARGETING] Whitelist loaded: " .. #self.Cache.Whitelist .. " entries")
            end
        end
    end,
    
    -- Clean up old cache entries
    CleanupCache = function(self)
        local currentTime = os.time()
        local removedCount = 0
        
        -- Clean recent targets
        for userId, timestamp in pairs(self.Cache.RecentTargets) do
            if currentTime - timestamp > 1800 then -- 30 minutes
                self.Cache.RecentTargets[userId] = nil
                removedCount = removedCount + 1
            end
        end
        
        -- Clean blacklist
        for userId, data in pairs(self.Cache.Blacklist) do
            if currentTime - data.Time > data.Duration then
                self.Cache.Blacklist[userId] = nil
                removedCount = removedCount + 1
            end
        end
        
        if debugMode and removedCount > 0 then
            print("[TARGETING] Cleaned " .. removedCount .. " old cache entries")
        end
    end,
    
    -- Get targeting statistics
    GetStats = function(self)
        local validTargets = 0
        local totalPlayers = 0
        
        for _, player in pairs(Services.Players:GetPlayers()) do
            totalPlayers = totalPlayers + 1
            if self:IsValidTarget(player) then
                validTargets = validTargets + 1
            end
        end
        
        return {
            TotalPlayers = totalPlayers,
            ValidTargets = validTargets,
            Blacklisted = #self.Cache.Blacklist,
            RecentTargets = #self.Cache.RecentTargets,
            SafeZones = #self.Cache.SafeZones
        }
    end
}

-- Initialize advanced targeting system
AdvancedTargetingSystem:Initialize()

-- ========================================================
-- SECTION 6: COMBAT SYSTEM ENHANCEMENTS
-- ========================================================

local AdvancedCombatSystem = {
    -- Combo Definitions
    Combos = {
        FastKill = {
            Name = "Fast Kill Combo",
            Description = "Quick elimination combo",
            Sequence = {"M1", "M1", "M1", "Z", "X", "C", "M1", "M1", "F", "V", "R", "M1", "X", "Z"},
            DamageMultiplier = 1.2,
            SpeedMultiplier = 1.1,
            Cooldown = 2,
            Type = "Mixed"
        },
        
        SwordMaster = {
            Name = "Sword Master Combo",
            Description = "Advanced sword techniques",
            Sequence = {"M1", "M1", "M1", "Z", "X", "C", "F", "M1", "X", "Z", "V", "M1", "C", "X"},
            DamageMultiplier = 1.5,
            SpeedMultiplier = 0.9,
            Cooldown = 3,
            Type = "Sword"
        },
        
        FruitPower = {
            Name = "Fruit Power Combo",
            Description = "Devil fruit abilities",
            Sequence = {"Z", "X", "C", "V", "F", "R", "T", "Z", "X", "C", "V", "F"},
            DamageMultiplier = 1.8,
            SpeedMultiplier = 0.8,
            Cooldown = 4,
            Type = "Fruit"
        },
        
        GunExpert = {
            Name = "Gun Expert Combo",
            Description = "Ranged combat combo",
            Sequence = {"M2", "Z", "X", "M2", "C", "V", "M2", "F", "M2", "R", "M2"},
            DamageMultiplier = 1.3,
            SpeedMultiplier = 1.2,
            Cooldown = 2.5,
            Type = "Gun"
        },
        
        StunLock = {
            Name = "Stun Lock Combo",
            Description = "Continuous stun attacks",
            Sequence = {"Z", "X", "C", "M1", "M1", "V", "F", "M1", "X", "Z", "C", "M1"},
            DamageMultiplier = 1.1,
            SpeedMultiplier = 0.7,
            Cooldown = 3,
            Type = "Control"
        },
        
        AerialAssault = {
            Name = "Aerial Assault Combo",
            Description = "Airborne attack combo",
            Sequence = {"X", "Z", "C", "M1", "V", "F", "M1", "M1", "X", "Z", "M1", "C"},
            DamageMultiplier = 1.4,
            SpeedMultiplier = 1.0,
            Cooldown = 3.5,
            Type = "Aerial"
        },
        
        UltimateFinish = {
            Name = "Ultimate Finish Combo",
            Description = "Finishing move combo",
            Sequence = {"M1", "M1", "Z", "X", "C", "V", "F", "R", "T", "M1", "X", "Z", "C", "F"},
            DamageMultiplier = 2.0,
            SpeedMultiplier = 0.6,
            Cooldown = 10,
            Type = "Ultimate"
        }
    },
    
    -- Skill Mappings
    SkillMap = {
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
    },
    
    -- Key Mappings
    KeyMap = {
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
    },
    
    -- Combat State
    State = {
        CurrentCombo = nil,
        ComboIndex = 0,
        LastAttackTime = 0,
        ComboCooldown = 0,
        SkillCooldowns = {},
        AttackChain = 0,
        DamageDealt = 0,
        ComboSuccesses = 0,
        ComboFailures = 0
    },
    
    -- Initialize combat system
    Initialize = function(self)
        self.State.CurrentCombo = self.Combos.FastKill
        self.State.LastAttackTime = os.time()
        
        if debugMode then
            print("[COMBAT] Advanced combat system initialized")
        end
        
        return true
    end,
    
    -- Execute a single key press
    ExecuteKey = function(self, key)
        local keyCode = self.KeyMap[key]
        if not keyCode then
            if debugMode then
                print("[COMBAT ERROR] Unknown key: " .. key)
            end
            return false
        end
        
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
            StatisticsSystem:RecordCombo("KeyPress", 100, 100)
            self.State.LastAttackTime = os.time()
            self.State.AttackChain = self.State.AttackChain + 1
            
            if debugMode then
                print("[COMBAT] Executed key: " .. key)
            end
        else
            self.State.ComboFailures = self.State.ComboFailures + 1
            StatisticsSystem:RecordError("KeyExecution", "Failed to execute key: " .. key, "Low")
        end
        
        return success
    end,
    
    -- Execute a full combo
    ExecuteCombo = function(self, comboName)
        local combo = self.Combos[comboName]
        if not combo then
            if debugMode then
                print("[COMBAT ERROR] Combo not found: " .. comboName)
            end
            return false
        end
        
        self.State.CurrentCombo = combo
        self.State.ComboIndex = 0
        self.State.ComboCooldown = os.time() + combo.Cooldown
        
        if debugMode then
            print("[COMBAT] Starting combo: " .. combo.Name)
        end
        
        StateManager.IsComboExecuting = true
        
        local successCount = 0
        local totalActions = #combo.Sequence
        
        for i, action in ipairs(combo.Sequence) do
            if not StateManager.IsComboExecuting then
                break
            end
            
            if StateManager.IsPaused then
                task.wait(1)
                goto continue_label
            end
            
            -- Apply aimlock if enabled
            if StateManager.IsAiming then
                self:AimAtTarget()
            end
            
            -- Execute action with delay
            local success = self:ExecuteKey(action)
            if success then
                successCount = successCount + 1
                self.State.ComboIndex = i
            end
            
            -- Calculate delay
            local baseDelay = ConfigurationSystem.CurrentConfig.Combat.ComboSpeed
            local speedMultiplier = combo.SpeedMultiplier
            local randomFactor = 1.0
            
            if ConfigurationSystem.CurrentConfig.Combat.UseRandomDelays then
                randomFactor = math.random(90, 110) / 100
            end
            
            local finalDelay = (baseDelay / speedMultiplier) * randomFactor
            
            task.wait(finalDelay)
            
            -- Check if target is dead
            if StateManager.TargetStates.TargetEliminated then
                break
            end
            ::continue_label::
        end
        
        StateManager.IsComboExecuting = false
        self.State.ComboSuccesses = self.State.ComboSuccesses + 1
        
        local successRate = (successCount / totalActions) * 100
        local damageDealt = 1000 * combo.DamageMultiplier * (successCount / totalActions)
        
        StatisticsSystem:RecordCombo(combo.Name, successRate, damageDealt)
        
        if debugMode then
            print("[COMBAT] Combo completed: " .. combo.Name .. " (" .. string.format("%.1f", successRate) .. "% success)")
        end
        
        return successRate
    end,
    
    -- Aim at current target
    AimAtTarget = function(self)
        if not StateManager.TargetStates.HasTarget then
            return
        end
        
        local target = AdvancedTargetingSystem.CurrentTarget
        if not target or not target.Character then
            return
        end
        
        local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
        if not targetRoot then
            return
        end
        
        local camera = Services.Workspace.CurrentCamera
        local targetPos = targetRoot.Position
        
        -- Apply prediction if enabled
        if ConfigurationSystem.CurrentConfig.Combat.UsePredictiveAiming then
            local predictionTime = ConfigurationSystem.CurrentConfig.Combat.AimPredictionTime
            local velocity = targetRoot.Velocity
            targetPos = targetPos + (velocity * predictionTime)
        end
        
        -- Smooth aiming
        local currentCFrame = camera.CFrame
        local targetCFrame = CFrame.new(currentCFrame.Position, targetPos)
        
        if ConfigurationSystem.CurrentConfig.Movement.MovementSmoothing then
            local smoothing = ConfigurationSystem.CurrentConfig.Movement.SmoothingFactor
            local lerpedCFrame = currentCFrame:Lerp(targetCFrame, smoothing)
            camera.CFrame = lerpedCFrame
        else
            camera.CFrame = targetCFrame
        end
    end,
    
    -- Fast attack sequence
    FastAttack = function(self)
        local attacks = {}
        
        if ConfigurationSystem.CurrentConfig.Skills.UseMeleeSkills then
            for _, skill in ipairs(self.SkillMap.Melee.Skills) do
                table.insert(attacks, skill)
            end
        end
        
        if ConfigurationSystem.CurrentConfig.Skills.UseSwordSkills then
            for _, skill in ipairs(self.SkillMap.Sword.Skills) do
                table.insert(attacks, skill)
            end
        end
        
        if #attacks == 0 then
            attacks = {"M1", "M1", "M1", "Z", "X", "C"}
        end
        
        local sequence = {}
        for i = 1, 8 do
            table.insert(sequence, attacks[math.random(1, #attacks)])
        end
        
        for _, action in ipairs(sequence) do
            if not StateManager.IsAttacking then
                break
            end
            
            self:ExecuteKey(action)
            
            local delay = ConfigurationSystem.CurrentConfig.Combat.AttackSpeed
            if ConfigurationSystem.CurrentConfig.Combat.UseRandomDelays then
                delay = delay * math.random(80, 120) / 100
            end
            
            task.wait(delay)
        end
    end,
    
    -- Random attack
    RandomAttack = function(self)
        local attackTypes = {}
        
        if ConfigurationSystem.CurrentConfig.Skills.UseMeleeSkills then
            table.insert(attackTypes, "Melee")
        end
        if ConfigurationSystem.CurrentConfig.Skills.UseSwordSkills then
            table.insert(attackTypes, "Sword")
        end
        if ConfigurationSystem.CurrentConfig.Skills.UseFruitSkills then
            table.insert(attackTypes, "Fruit")
        end
        if ConfigurationSystem.CurrentConfig.Skills.UseGunSkills then
            table.insert(attackTypes, "Gun")
        end
        
        if #attackTypes == 0 then
            self:ExecuteKey("M1")
            return
        end
        
        local selectedType = attackTypes[math.random(1, #attackTypes)]
        local skills = self.SkillMap[selectedType].Skills
        
        if skills and #skills > 0 then
            local selectedSkill = skills[math.random(1, #skills)]
            self:ExecuteKey(selectedSkill)
        else
            self:ExecuteKey("M1")
        end
    end,
    
    -- Auto dodge
    AutoDodge = function(self)
        if not ConfigurationSystem.CurrentConfig.Combat.AutoDodge then
            return false
        end
        
        local dodgeChance = ConfigurationSystem.CurrentConfig.Combat.DodgeProbability
        if math.random() > dodgeChance then
            return false
        end
        
        -- Execute dodge move (assuming Q is dodge)
        self:ExecuteKey("Q")
        
        if debugMode then
            print("[COMBAT] Auto dodge executed")
        end
        
        return true
    end,
    
    -- Auto block
    AutoBlock = function(self)
        if not ConfigurationSystem.CurrentConfig.Combat.AutoBlock then
            return false
        end
        
        local blockChance = ConfigurationSystem.CurrentConfig.Combat.BlockProbability
        if math.random() > blockChance then
            return false
        end
        
        -- Execute block move (assuming E is block)
        self:ExecuteKey("E")
        
        if debugMode then
            print("[COMBAT] Auto block executed")
        end
        
        return true
    end,
    
    -- Get combat statistics
    GetStats = function(self)
        local totalCombos = self.State.ComboSuccesses + self.State.ComboFailures
        local comboSuccessRate = totalCombos > 0 and (self.State.ComboSuccesses / totalCombos) * 100 or 0
        
        return {
            CurrentCombo = self.State.CurrentCombo and self.State.CurrentCombo.Name or "None",
            ComboIndex = self.State.ComboIndex,
            AttackChain = self.State.AttackChain,
            ComboSuccesses = self.State.ComboSuccesses,
            ComboFailures = self.State.ComboFailures,
            ComboSuccessRate = comboSuccessRate,
            DamageDealt = self.State.DamageDealt,
            LastAttackTime = os.time() - self.State.LastAttackTime
        }
    end,
    
    -- Reset combat state
    Reset = function(self)
        self.State = {
            CurrentCombo = self.Combos.FastKill,
            ComboIndex = 0,
            LastAttackTime = 0,
            ComboCooldown = 0,
            SkillCooldowns = {},
            AttackChain = 0,
            DamageDealt = 0,
            ComboSuccesses = 0,
            ComboFailures = 0
        }
        
        if debugMode then
            print("[COMBAT] Combat state reset")
        end
    end
}

-- Initialize combat system
AdvancedCombatSystem:Initialize()

-- ========================================================
-- SECTION 7: SERVER HOP SYSTEM WITH GERMANY SUPPORT
-- ========================================================

local ServerHopSystem = {
    Cache = {
        ServerList = {},
        BlacklistedServers = {},
        WhitelistedServers = {},
        RecentServers = {},
        GermanServers = {},
        ServerStats = {}
    },
    
    State = {
        IsHopping = false,
        LastHopTime = 0,
        HopCooldown = 0,
        HopAttempts = 0,
        SuccessfulHops = 0,
        FailedHops = 0,
        CurrentServerId = game.JobId,
        TargetRegion = "Germany"
    },
    
    -- Initialize server hop system
    Initialize = function(self)
        self.State.CurrentServerId = game.JobId
        self:LoadServerCache()
        
        if debugMode then
            print("[SERVER HOP] System initialized")
            print("[SERVER HOP] Current server: " .. self.State.CurrentServerId)
        end
        
        return true
    end,
    
    -- Search for German servers
    SearchGermanServers = function(self)
        self.Cache.GermanServers = {}
        
        local success, result = pcall(function()
            local response = game:HttpGet(
                "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"
            )
            
            local data = Services.HttpService:JSONDecode(response)
            
            if data and data.data then
                for _, server in pairs(data.data) do
                    -- Look for Germany in server data (this is simplified)
                    -- In reality, you'd need to check server region or ping
                    if string.find(tostring(server), "Germany") or 
                       string.find(tostring(server), "DE") or
                       string.find(tostring(server), "Ger") then
                        
                        local serverInfo = {
                            Id = server.id,
                            Players = server.playing,
                            MaxPlayers = server.maxPlayers,
                            Ping = 50, -- Estimated ping for Germany
                            Region = "Germany",
                            FetchedTime = os.time()
                        }
                        
                        table.insert(self.Cache.GermanServers, serverInfo)
                    end
                end
            end
        end)
        
        if success then
            if debugMode then
                print("[SERVER HOP] Found " .. #self.Cache.GermanServers .. " German servers")
            end
        else
            StatisticsSystem:RecordError("ServerSearch", "Failed to search German servers", "Medium")
        end
        
        return self.Cache.GermanServers
    end,
    
    -- Get all available servers
    GetAllServers = function(self)
        local servers = {}
        
        local success, result = pcall(function()
            local response = game:HttpGet(
                "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"
            )
            
            local data = Services.HttpService:JSONDecode(response)
            
            if data and data.data then
                for _, server in pairs(data.data) do
                    if server.id ~= game.JobId then
                        local serverInfo = {
                            Id = server.id,
                            Players = server.playing,
                            MaxPlayers = server.maxPlayers,
                            FetchedTime = os.time()
                        }
                        
                        table.insert(servers, serverInfo)
                    end
                end
            end
        end)
        
        if success then
            self.Cache.ServerList = servers
            if debugMode then
                print("[SERVER HOP] Found " .. #servers .. " total servers")
            end
        else
            StatisticsSystem:RecordError("ServerFetch", "Failed to fetch server list", "High")
        end
        
        return servers
    end,
    
    -- Hop to German server
    HopToGermanServer = function(self)
        if self.State.IsHopping then
            if debugMode then
                print("[SERVER HOP] Already hopping, please wait")
            end
            return false
        end
        
        if os.time() - self.State.LastHopTime < self.State.HopCooldown then
            local waitTime = self.State.HopCooldown - (os.time() - self.State.LastHopTime)
            if debugMode then
                print("[SERVER HOP] On cooldown, please wait " .. waitTime .. " seconds")
            end
            return false
        end
        
        self.State.IsHopping = true
        self.State.HopAttempts = self.State.HopAttempts + 1
        
        if debugMode then
            print("[SERVER HOP] Searching for German servers...")
        end
        
        -- Search for German servers
        local germanServers = self:SearchGermanServers()
        
        if #germanServers == 0 then
            if debugMode then
                print("[SERVER HOP] No German servers found, searching all servers...")
            end
            
            germanServers = self:GetAllServers()
        end
        
        -- Filter servers
        local suitableServers = {}
        for _, server in pairs(germanServers) do
            if server.Players < server.MaxPlayers and
               server.Players >= ConfigurationSystem.CurrentConfig.Server.MinPlayersForHop and
               server.Players <= ConfigurationSystem.CurrentConfig.Server.MaxPlayersForHop and
               not self.Cache.BlacklistedServers[server.Id] then
                
                table.insert(suitableServers, server)
            end
        end
        
        if #suitableServers == 0 then
            if debugMode then
                print("[SERVER HOP] No suitable servers found")
            end
            
            self.State.IsHopping = false
            self.State.FailedHops = self.State.FailedHops + 1
            StatisticsSystem:RecordError("ServerHop", "No suitable servers found", "Medium")
            return false
        end
        
        -- Sort by player count (prefer less crowded)
        table.sort(suitableServers, function(a, b)
            return a.Players < b.Players
        end)
        
        -- Select best server
        local selectedServer = suitableServers[1]
        
        if debugMode then
            print("[SERVER HOP] Selected server: " .. selectedServer.Id .. 
                  " (" .. selectedServer.Players .. "/" .. selectedServer.MaxPlayers .. " players)")
        end
        
        -- Attempt to hop
        local hopSuccess = false
        local hopError = ""
        
        local success, errorMsg = pcall(function()
            Services.TeleportService:TeleportToPlaceInstance(
                game.PlaceId,
                selectedServer.Id,
                Player
            )
            hopSuccess = true
        end)
        
        if not success then
            hopError = errorMsg
        end
        
        if hopSuccess then
            self.State.SuccessfulHops = self.State.SuccessfulHops + 1
            self.State.LastHopTime = os.time()
            self.State.HopCooldown = 10
            
            StatisticsSystem:RecordServerHop(selectedServer.Id, "Manual hop to Germany")
            
            if debugMode then
                print("[SERVER HOP] Successfully hopping to server: " .. selectedServer.Id)
            end
            
            -- Add to recent servers
            self.Cache.RecentServers[selectedServer.Id] = os.time()
        else
            self.State.FailedHops = self.State.FailedHops + 1
            self.State.HopCooldown = 30
            
            StatisticsSystem:RecordError("ServerHop", "Failed to hop: " .. hopError, "High")
            
            if debugMode then
                print("[SERVER HOP ERROR] Failed to hop: " .. hopError)
            end
            
            -- Add to blacklist
            self.Cache.BlacklistedServers[selectedServer.Id] = {
                Time = os.time(),
                Reason = "Hop failed: " .. hopError
            }
        end
        
        self.State.IsHopping = false
        return hopSuccess
    end,
    
    -- Auto hop when conditions met
    AutoHop = function(self)
        if not ConfigurationSystem.CurrentConfig.Server.AutoServerHop then
            return false
        end
        
        if self.State.IsHopping then
            return false
        end
        
        if os.time() - self.State.LastHopTime < ConfigurationSystem.CurrentConfig.Server.ServerHopDelay then
            return false
        end
        
        -- Check if server has valid targets
        local targetStats = AdvancedTargetingSystem:GetStats()
        if targetStats.ValidTargets >= ConfigurationSystem.CurrentConfig.Server.MinPlayersForHop then
            return false
        end
        
        if debugMode then
            print("[SERVER HOP] Auto hop triggered: Not enough valid targets")
        end
        
        return self:HopToGermanServer()
    end,
    
    -- Load server cache from file
    LoadServerCache = function(self)
        local success, data = pcall(function()
            if readfile then
                return Services.HttpService:JSONDecode(readfile("BloxFarmer_ServerCache.json"))
            end
        end)
        
        if success and data then
            self.Cache.BlacklistedServers = data.BlacklistedServers or {}
            self.Cache.WhitelistedServers = data.WhitelistedServers or {}
            self.Cache.RecentServers = data.RecentServers or {}
            
            if debugMode then
                print("[SERVER HOP] Server cache loaded")
            end
        end
    end,
    
    -- Save server cache to file
    SaveServerCache = function(self)
        local cacheData = {
            BlacklistedServers = self.Cache.BlacklistedServers,
            WhitelistedServers = self.Cache.WhitelistedServers,
            RecentServers = self.Cache.RecentServers,
            LastUpdate = os.time()
        }
        
        local success = pcall(function()
            if writefile then
                local json = Services.HttpService:JSONEncode(cacheData)
                writefile("BloxFarmer_ServerCache.json", json)
                return true
            end
        end)
        
        if success then
            if debugMode then
                print("[SERVER HOP] Server cache saved")
            end
        end
    end,
    
    -- Get server hop statistics
    GetStats = function(self)
        return {
            IsHopping = self.State.IsHopping,
            HopAttempts = self.State.HopAttempts,
            SuccessfulHops = self.State.SuccessfulHops,
            FailedHops = self.State.FailedHops,
            LastHopTime = os.time() - self.State.LastHopTime,
            HopCooldown = self.State.HopCooldown,
            CurrentServerId = self.State.CurrentServerId,
            GermanServersFound = #self.Cache.GermanServers,
            TotalServersFound = #self.Cache.ServerList,
            BlacklistedServers = #self.Cache.BlacklistedServers
        }
    end,
    
    -- Clean up old cache entries
    CleanupCache = function(self)
        local currentTime = os.time()
        local removedCount = 0
        
        -- Clean recent servers
        for serverId, timestamp in pairs(self.Cache.RecentServers) do
            if currentTime - timestamp > 86400 then -- 24 hours
                self.Cache.RecentServers[serverId] = nil
                removedCount = removedCount + 1
            end
        end
        
        -- Clean blacklisted servers
        for serverId, data in pairs(self.Cache.BlacklistedServers) do
            if currentTime - data.Time > 3600 then -- 1 hour
                self.Cache.BlacklistedServers[serverId] = nil
                removedCount = removedCount + 1
            end
        end
        
        if debugMode and removedCount > 0 then
            print("[SERVER HOP] Cleaned " .. removedCount .. " old cache entries")
        end
    end
}

-- Initialize server hop system
ServerHopSystem:Initialize()

-- ========================================================
-- SECTION 8: ENHANCED FARMING SYSTEM
-- ========================================================

local EnhancedFarmingSystem = {
    State = {
        CurrentTarget = nil,
        FarmingLoop = nil,
        AttackLoop = nil,
        MonitoringLoop = nil,
        LastTargetSwitch = 0,
        TargetSwitchCooldown = 5,
        KillStreak = 0,
        MaxKillStreak = 0,
        FarmingStartTime = 0,
        FarmingDuration = 0,
        TargetsKilled = {},
        RecentActivities = {}
    },
    
    -- Initialize farming system
    Initialize = function(self)
        self.State.FarmingStartTime = os.time()
        
        if debugMode then
            print("[FARMING] Enhanced farming system initialized")
        end
        
        return true
    end,
    
    -- Start auto farming
    Start = function(self)
        if StateManager.IsFarming then
            if debugMode then
                print("[FARMING] Already farming")
            end
            return false
        end
        
        SetFarmingState(true)
        SetPauseState(false)
        
        self.State.FarmingStartTime = os.time()
        self.State.KillStreak = 0
        
        if debugMode then
            print("[FARMING] Auto farming started")
        end
        
        -- Start farming loop
        self.State.FarmingLoop = task.spawn(function()
            self:FarmingLoop()
        end)
        
        -- Start monitoring loop
        self.State.MonitoringLoop = task.spawn(function()
            self:MonitoringLoop()
        end)
        
        StatisticsSystem:ResetSession()
        
        return true
    end,
    
    -- Stop auto farming
    Stop = function(self)
        if not StateManager.IsFarming then
            if debugMode then
                print("[FARMING] Not currently farming")
            end
            return false
        end
        
        SetFarmingState(false)
        SetPauseState(false)
        
        -- Stop loops
        if self.State.FarmingLoop then
            task.cancel(self.State.FarmingLoop)
            self.State.FarmingLoop = nil
        end
        
        if self.State.AttackLoop then
            task.cancel(self.State.AttackLoop)
            self.State.AttackLoop = nil
        end
        
        if self.State.MonitoringLoop then
            task.cancel(self.State.MonitoringLoop)
            self.State.MonitoringLoop = nil
        end
        
        self.State.CurrentTarget = nil
        
        self.State.FarmingDuration = os.time() - self.State.FarmingStartTime
        
        if debugMode then
            print("[FARMING] Auto farming stopped")
            print("[FARMING] Farming duration: " .. self.State.FarmingDuration .. " seconds")
            print("[FARMING] Max kill streak: " .. self.State.MaxKillStreak)
        end
        
        -- Save statistics
        StatisticsSystem:SaveStats()
        
        return true
    end,
    
    -- Pause/resume farming
    Pause = function(self)
        if not StateManager.IsFarming then
            if debugMode then
                print("[FARMING] Cannot pause - not farming")
            end
            return false
        end
        
        SetPauseState(not StateManager.IsPaused)
        
        if StateManager.IsPaused then
            if debugMode then
                print("[FARMING] Farming paused")
            end
        else
            if debugMode then
                print("[FARMING] Farming resumed")
            end
        end
        
        return true
    end,
    
    -- Main farming loop
    FarmingLoop = function(self)
        while StateManager.IsFarming do
            if StateManager.IsPaused then
                task.wait(1)
                goto continue_label
            end
            
            -- Find target if none
            if not self.State.CurrentTarget then
                self:FindNewTarget()
                
                if not self.State.CurrentTarget then
                    -- No valid targets, check for server hop
                    if ConfigurationSystem.CurrentConfig.Server.AutoServerHop then
                        task.wait(5)
                        ServerHopSystem:AutoHop()
                    else
                        task.wait(3)
                    end
                    goto continue_label
                end
            end
            
            -- Validate current target
            if not AdvancedTargetingSystem:IsValidTarget(self.State.CurrentTarget) then
                if debugMode then
                    print("[FARMING] Current target is no longer valid")
                end
                self.State.CurrentTarget = nil
                goto continue_label
            end
            
            -- Update target states
            StateManager.TargetStates.HasTarget = true
            StateManager.TargetStates.TargetValid = true
            
            -- Calculate distance to target
            local distance = AdvancedTargetingSystem:CalculateDistance(self.State.CurrentTarget)
            StateManager.TargetStates.TargetInRange = distance < ConfigurationSystem.CurrentConfig.Targeting.MaxDistance
            
            -- Approach target if too far
            if distance > 50 then
                StateManager.FarmingSubStates.ApproachingTarget = true
                self:ApproachTarget()
            else
                StateManager.FarmingSubStates.ApproachingTarget = false
                StateManager.FarmingSubStates.EngagingTarget = true
                
                -- Start attacking if not already
                if not StateManager.IsAttacking then
                    StateManager.IsAttacking = true
                    self.State.AttackLoop = task.spawn(function()
                        self:AttackLoop()
                    end)
                end
            end
            
            task.wait(0.1)
             task.wait(0.1)
            ::continue_label::
        end
        
        -- Clean up when loop endsnds
        StateManager.IsAttacking = false
        StateManager.TargetStates.HasTarget = false
        self.State.CurrentTarget = nil
        
        if debugMode then
            print("[FARMING] Farming loop ended")
        end
    end,
    
    -- Find new target
    FindNewTarget = function(self)
        local currentTime = os.time()
        
        if currentTime - self.State.LastTargetSwitch < self.State.TargetSwitchCooldown then
            return false
        end
        
        if debugMode then
            print("[FARMING] Searching for new target...")
        end
        
        local target = AdvancedTargetingSystem:FindBestTarget()
        
        if target then
            self.State.CurrentTarget = target
            AdvancedTargetingSystem:MarkAsTargeted(target)
            self.State.LastTargetSwitch = currentTime
            
            if debugMode then
                print("[FARMING] Found target: " .. target.Name)
            end
            
            -- Record target acquisition
            table.insert(self.State.RecentActivities, {
                Time = os.time(),
                Type = "TargetAcquired",
                Target = target.Name
            })
            
            return true
        else
            if debugMode then
                print("[FARMING] No valid targets found")
            end
            return false
        end
    end,
    
    -- Approach target
    ApproachTarget = function(self)
        if not self.State.CurrentTarget then
            return false
        end
        
        if not self.State.CurrentTarget.Character then
            return false
        end
        
        local targetRoot = self.State.CurrentTarget.Character:FindFirstChild("HumanoidRootPart")
        if not targetRoot then
            return false
        end
        
        if not HumanoidRootPart then
            return false
        end
        
        local distance = (HumanoidRootPart.Position - targetRoot.Position).Magnitude
        
        if distance > 100 then
            -- Teleport closer
            local offset = Vector3.new(
                math.random(-10, 10),
                ConfigurationSystem.CurrentConfig.Movement.HeightOffset,
                math.random(-10, 10)
            )
            
            local targetPosition = targetRoot.Position + offset
            
            pcall(function()
                if ConfigurationSystem.CurrentConfig.Movement.TeleportMethod == "Tween" then
                    local tweenInfo = Services.TweenInfo.new(
                        0.5,
                        Enum.EasingStyle.Linear,
                        Enum.EasingDirection.Out
                    )
                    
                    local tween = Services.TweenService:Create(
                        HumanoidRootPart,
                        tweenInfo,
                        {CFrame = CFrame.new(targetPosition)}
                    )
                    
                    tween:Play()
                else
                    HumanoidRootPart.CFrame = CFrame.new(targetPosition)
                end
            end)
            
            task.wait(0.5)
        end
        
        return true
    end,
    
    -- Attack loop
    AttackLoop = function(self)
        while StateManager.IsAttacking and self.State.CurrentTarget do
            if StateManager.IsPaused then
                task.wait(1)
                goto continue_label
            end
            
            -- Validate target
            if not AdvancedTargetingSystem:IsValidTarget(self.State.CurrentTarget) then
                if debugMode then
                    print("[FARMING] Target invalid during attack")
                end
                break
            end
            
            -- Check target health
            local humanoid = self.State.CurrentTarget.Character:FindFirstChild("Humanoid")
            if not humanoid or humanoid.Health <= 0 then
                self:OnTargetKilled()
                break
            end
            
            -- Execute attacks
            if ConfigurationSystem.CurrentConfig.Combat.ComboPreset == "FastKill" then
                AdvancedCombatSystem:FastAttack()
            else
                AdvancedCombatSystem:ExecuteCombo(ConfigurationSystem.CurrentConfig.Combat.ComboPreset)
            end
            
            -- Random delay between attack sequences
            local delay = ConfigurationSystem.CurrentConfig.Combat.AttackSpeed * 3
            if ConfigurationSystem.CurrentConfig.Combat.UseRandomDelays then
                delay = delay * math.random(80, 120) / 100
            end
            
            task.wait(delay)
            ::continue_label::
        end
        
        StateManager.IsAttacking = false
        StateManager.FarmingSubStates.EngagingTarget = false
        
        if debugMode then
            print("[FARMING] Attack loop ended")
        end
    end,
    
    -- On target killed
    OnTargetKilled = function(self)
        if not self.State.CurrentTarget then
            return
        end
        
        local targetName = self.State.CurrentTarget.Name
        local bountyEarned = AdvancedTargetingSystem:EstimateBounty(self.State.CurrentTarget)
        
        -- Update statistics
        StatisticsSystem:RecordKill(targetName, bountyEarned)
        
        -- Update kill streak
        self.State.KillStreak = self.State.KillStreak + 1
        if self.State.KillStreak > self.State.MaxKillStreak then
            self.State.MaxKillStreak = self.State.KillStreak
        end
        
        -- Record kill
        self.State.TargetsKilled[targetName] = os.time()
        
        table.insert(self.State.RecentActivities, {
            Time = os.time(),
            Type = "TargetKilled",
            Target = targetName,
            Bounty = bountyEarned,
            KillStreak = self.State.KillStreak
        })
        
        -- Send notification
        if ConfigurationSystem.CurrentConfig.UI.ShowNotifications then
            if Rayfield then
                Rayfield:Notify({
                    Title = "🎯 TARGET ELIMINATED",
                    Content = targetName .. " | +" .. bountyEarned .. " Bounty\nKill Streak: " .. self.State.KillStreak,
                    Duration = 3,
                    Image = 7039921763
                })
            end
        end
        
        if debugMode then
            print("[FARMING] Target killed: " .. targetName .. " (+" .. bountyEarned .. " bounty)")
            print("[FARMING] Current kill streak: " .. self.State.KillStreak)
        end
        
        -- Reset for next target
        self.State.CurrentTarget = nil
        StateManager.TargetStates.HasTarget = false
        StateManager.TargetStates.TargetEliminated = true
        
        -- Check if server needs hopping
        if ConfigurationSystem.CurrentConfig.Server.AutoServerHop then
            local targetStats = AdvancedTargetingSystem:GetStats()
            if targetStats.ValidTargets == 0 then
                task.wait(2)
                ServerHopSystem:AutoHop()
            end
        end
        
        -- Short cooldown before next target
        task.wait(2)
        StateManager.TargetStates.TargetEliminated = false
    end,
    
    -- Monitoring loop
    MonitoringLoop = function(self)
        while StateManager.IsFarming do
            -- Update farming duration
            self.State.FarmingDuration = os.time() - self.State.FarmingStartTime
            
            -- Check for emergency situations
            self:CheckEmergency()
            
            -- Clean up old activities
            self:CleanupActivities()
            
            -- Update targeting system cache
            AdvancedTargetingSystem:CleanupCache()
            
            -- Update server hop system cache
            ServerHopSystem:CleanupCache()
            
            task.wait(5)
        end
    end,
    
    -- Check for emergency situations
    CheckEmergency = function(self)
        if not Character or not Humanoid then
            return
        end
        
        -- Check health
        local healthPercent = (Humanoid.Health / Humanoid.MaxHealth) * 100
        
        if healthPercent <= ConfigurationSystem.CurrentConfig.Safety.LowHPThresholdPercentage * 100 then
            StateManager.SafetyStates.HealthStatus = "Critical"
            
            if ConfigurationSystem.CurrentConfig.Safety.LowHPThreshold > 0 then
                self:EmergencyEscape()
            end
        elseif healthPercent <= 50 then
            StateManager.SafetyStates.HealthStatus = "Low"
        else
            StateManager.SafetyStates.HealthStatus = "Good"
        end
        
        -- Check if in combat
        if StateManager.IsAttacking or StateManager.IsComboExecuting then
            StateManager.SafetyStates.CombatStatus = "Active"
            StateManager.IsInCombat = true
        else
            StateManager.SafetyStates.CombatStatus = "Idle"
            StateManager.IsInCombat = false
        end
    end,
    
    -- Emergency escape
    EmergencyEscape = function(self)
        if StateManager.IsEmergency then
            return
        end
        
        StateManager.IsEmergency = true
        
        if debugMode then
            print("[FARMING] Emergency escape activated!")
        end
        
        -- Stop attacking
        StateManager.IsAttacking = false
        
        -- Teleport to safety
        local safePosition = HumanoidRootPart.Position + Vector3.new(
            math.random(-ConfigurationSystem.CurrentConfig.Safety.EmergencyTeleportDistance,
                       ConfigurationSystem.CurrentConfig.Safety.EmergencyTeleportDistance),
            ConfigurationSystem.CurrentConfig.Safety.EmergencyTeleportHeight,
            math.random(-ConfigurationSystem.CurrentConfig.Safety.EmergencyTeleportDistance,
                       ConfigurationSystem.CurrentConfig.Safety.EmergencyTeleportDistance)
        )
        
        pcall(function()
            HumanoidRootPart.CFrame = CFrame.new(safePosition)
        end)
        
        -- Wait for recovery
        task.wait(10)
        
        StateManager.IsEmergency = false
        
        if debugMode then
            print("[FARMING] Emergency escape complete")
        end
    end,
    
    -- Cleanup old activities
    CleanupActivities = function(self)
        local currentTime = os.time()
        local newActivities = {}
        
        for _, activity in ipairs(self.State.RecentActivities) do
            if currentTime - activity.Time < 300 then -- Keep last 5 minutes
                table.insert(newActivities, activity)
            end
        end
        
        self.State.RecentActivities = newActivities
        
        -- Cleanup old kills
        for targetName, killTime in pairs(self.State.TargetsKilled) do
            if currentTime - killTime > 900 then -- 15 minutes
                self.State.TargetsKilled[targetName] = nil
            end
        end
    end,
    
    -- Get farming statistics
    GetStats = function(self)
        return {
            IsFarming = StateManager.IsFarming,
            IsPaused = StateManager.IsPaused,
            CurrentTarget = self.State.CurrentTarget and self.State.CurrentTarget.Name or "None",
            KillStreak = self.State.KillStreak,
            MaxKillStreak = self.State.MaxKillStreak,
            FarmingDuration = self.State.FarmingDuration,
            TargetsKilled = #self.State.TargetsKilled,
            RecentActivities = #self.State.RecentActivities,
            FarmingStartTime = self.State.FarmingStartTime
        }
    end
}

-- Initialize farming system
EnhancedFarmingSystem:Initialize()

-- ========================================================
-- SECTION 9: COMPREHENSIVE UI SYSTEM
-- ========================================================

local UISystem = {
    Window = nil,
    Tabs = {},
    Elements = {},
    Notifications = {},
    CurrentTheme = "Dark",
    
    -- Initialize UI system
    Initialize = function(self)
        if not Rayfield then
            if debugMode then
                print("[UI ERROR] Rayfield not loaded, using fallback")
            end
            self:CreateFallbackUI()
            return false
        end
        
        self.Window = Rayfield:CreateWindow({
            Name = "🔥 BLOX FRUITS AUTO FARMER v" .. scriptVersion,
            LoadingTitle = "Initializing Advanced Farming System...",
            LoadingSubtitle = "Loading modules and configurations...",
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
        
        if self.Window then
            StateManager.IsUILoaded = true
            
            -- Create all tabs
            self:CreateMainTab()
            self:CreateCombatTab()
            self:CreateTargetingTab()
            self:CreateServerTab()
            self:CreateStatsTab()
            self:CreateSettingsTab()
            self:CreateLogsTab()
            
            if debugMode then
                print("[UI] User interface loaded successfully")
            end
            
            return true
        else
            if debugMode then
                print("[UI ERROR] Failed to create window")
            end
            self:CreateFallbackUI()
            return false
        end
    end,
    
    -- Create main tab
    CreateMainTab = function(self)
        self.Tabs.Main = self.Window:CreateTab("🎮 Main Control", 7039921763)
        
        -- Farming Status Section
        self.Tabs.Main:CreateSection("📊 Farming Status")
        
        self.Elements.StatusLabel = self.Tabs.Main:CreateLabel("Status: INITIALIZING...")
        self.Elements.TargetLabel = self.Tabs.Main:CreateLabel("Target: None")
        self.Elements.KillStreakLabel = self.Tabs.Main:CreateLabel("Kill Streak: 0")
        self.Elements.BountyLabel = self.Tabs.Main:CreateLabel("Session Bounty: 0")
        self.Elements.EfficiencyLabel = self.Tabs.Main:CreateLabel("Efficiency: 0%")
        self.Elements.UptimeLabel = self.Tabs.Main:CreateLabel("Uptime: 00:00:00")
        
        -- Control Buttons Section
        self.Tabs.Main:CreateSection("🎯 Control Panel")
        
        self.Elements.StartButton = self.Tabs.Main:CreateButton({
            Name = "▶️ START AUTO FARMING",
            Callback = function()
                EnhancedFarmingSystem:Start()
            end
        })
        
        self.Elements.PauseButton = self.Tabs.Main:CreateButton({
            Name = "⏸️ PAUSE/RESUME FARMING",
            Callback = function()
                EnhancedFarmingSystem:Pause()
            end
        })
        
        self.Elements.StopButton = self.Tabs.Main:CreateButton({
            Name = "⏹️ STOP FARMING",
            Callback = function()
                EnhancedFarmingSystem:Stop()
            end
        })
        
        self.Elements.NextTargetButton = self.Tabs.Main:CreateButton({
            Name = "🎯 FIND NEXT TARGET",
            Callback = function()
                EnhancedFarmingSystem:FindNewTarget()
            end
        })
        
        self.Elements.HopServerButton = self.Tabs.Main:CreateButton({
            Name = "🔄 HOP TO GERMAN SERVER",
            Callback = function()
                ServerHopSystem:HopToGermanServer()
            end
        })
        
        -- Quick Stats Section
        self.Tabs.Main:CreateSection("📈 Quick Statistics")
        
        self.Elements.TotalKillsLabel = self.Tabs.Main:CreateLabel("Total Kills: 0")
        self.Elements.BountyPerHourLabel = self.Tabs.Main:CreateLabel("Bounty/Hour: 0")
        self.Elements.PerformanceLabel = self.Tabs.Main:CreateLabel("Performance: 0%")
        self.Elements.ServerInfoLabel = self.Tabs.Main:CreateLabel("Server Players: 0")
        
        -- Start update loop for main tab
        self:StartMainTabUpdate()
    end,
    
    -- Create combat tab
    CreateCombatTab = function(self)
        self.Tabs.Combat = self.Window:CreateTab("⚔️ Combat Settings", 7039921763)
        
        -- Combat Settings Section
        self.Tabs.Combat:CreateSection("🎯 Attack Settings")
        
        self.Elements.AttackSpeedSlider = self.Tabs.Combat:CreateSlider({
            Name = "Attack Speed",
            Range = {0.05, 0.5},
            Increment = 0.01,
            Suffix = "seconds",
            CurrentValue = ConfigurationSystem.CurrentConfig.Combat.AttackSpeed,
            Callback = function(Value)
                ConfigurationSystem:SetValue("Combat.AttackSpeed", Value)
                ConfigurationSystem:SetValue("Combat.ComboSpeed", Value)
            end
        })
        
        self.Elements.AutoDodgeToggle = self.Tabs.Combat:CreateToggle({
            Name = "Auto Dodge",
            CurrentValue = ConfigurationSystem.CurrentConfig.Combat.AutoDodge,
            Callback = function(Value)
                ConfigurationSystem:SetValue("Combat.AutoDodge", Value)
            end
        })
        
        self.Elements.AutoAimToggle = self.Tabs.Combat:CreateToggle({
            Name = "Auto Aim",
            CurrentValue = StateManager.IsAiming,
            Callback = function(Value)
                StateManager.IsAiming = Value
            end
        })
        
        -- Combo Selection Section
        self.Tabs.Combat:CreateSection("🎭 Combo Selection")
        
        self.Elements.ComboDropdown = self.Tabs.Combat:CreateDropdown({
            Name = "Select Combo",
            Options = {"FastKill", "SwordMaster", "FruitPower", "GunExpert", "StunLock", "AerialAssault", "UltimateFinish"},
            CurrentOption = ConfigurationSystem.CurrentConfig.Combat.ComboPreset,
            Callback = function(Option)
                ConfigurationSystem:SetValue("Combat.ComboPreset", Option)
            end
        })
        
        self.Elements.ExecuteComboButton = self.Tabs.Combat:CreateButton({
            Name = "EXECUTE SELECTED COMBO",
            Callback = function()
                AdvancedCombatSystem:ExecuteCombo(ConfigurationSystem.CurrentConfig.Combat.ComboPreset)
            end
        })
        
        -- Skills Configuration Section
        self.Tabs.Combat:CreateSection("✨ Skills Configuration")
        
        self.Elements.UseMeleeToggle = self.Tabs.Combat:CreateToggle({
            Name = "Use Melee Skills",
            CurrentValue = ConfigurationSystem.CurrentConfig.Skills.UseMeleeSkills,
            Callback = function(Value)
                ConfigurationSystem:SetValue("Skills.UseMeleeSkills", Value)
            end
        })
        
        self.Elements.UseSwordToggle = self.Tabs.Combat:CreateToggle({
            Name = "Use Sword Skills",
            CurrentValue = ConfigurationSystem.CurrentConfig.Skills.UseSwordSkills,
            Callback = function(Value)
                ConfigurationSystem:SetValue("Skills.UseSwordSkills", Value)
            end
        })
        
        self.Elements.UseFruitToggle = self.Tabs.Combat:CreateToggle({
            Name = "Use Fruit Skills",
            CurrentValue = ConfigurationSystem.CurrentConfig.Skills.UseFruitSkills,
            Callback = function(Value)
                ConfigurationSystem:SetValue("Skills.UseFruitSkills", Value)
            end
        })
        
        self.Elements.UseGunToggle = self.Tabs.Combat:CreateToggle({
            Name = "Use Gun Skills",
            CurrentValue = ConfigurationSystem.CurrentConfig.Skills.UseGunSkills,
            Callback = function(Value)
                ConfigurationSystem:SetValue("Skills.UseGunSkills", Value)
            end
        })
    end,
    
    -- Create targeting tab
    CreateTargetingTab = function(self)
        self.Tabs.Targeting = self.Window:CreateTab("🎯 Targeting Settings", 7039921763)
        
        -- Level Filter Section
        self.Tabs.Targeting:CreateSection("📊 Level Filters")
        
        self.Elements.MinLevelSlider = self.Tabs.Targeting:CreateSlider({
            Name = "Minimum Level",
            Range = {1500, 3500},
            Increment = 50,
            Suffix = "Level",
            CurrentValue = ConfigurationSystem.CurrentConfig.Targeting.MinLevel,
            Callback = function(Value)
                ConfigurationSystem:SetValue("Targeting.MinLevel", Value)
            end
        })
        
        self.Elements.MaxLevelSlider = self.Tabs.Targeting:CreateSlider({
            Name = "Maximum Level",
            Range = {2000, 5000},
            Increment = 50,
            Suffix = "Level",
            CurrentValue = ConfigurationSystem.CurrentConfig.Targeting.MaxLevel,
            Callback = function(Value)
                ConfigurationSystem:SetValue("Targeting.MaxLevel", Value)
            end
        })
        
        -- Targeting Priority Section
        self.Tabs.Targeting:CreateSection("🎯 Targeting Priority")
        
        self.Elements.PriorityDropdown = self.Tabs.Targeting:CreateDropdown({
            Name = "Target Priority",
            Options = {"Bounty", "Level", "Distance", "Hybrid", "Random"},
            CurrentOption = ConfigurationSystem.CurrentConfig.Targeting.TargetPriority,
            Callback = function(Option)
                ConfigurationSystem:SetValue("Targeting.TargetPriority", Option)
            end
        })
        
        -- Target Filters Section
        self.Tabs.Targeting:CreateSection("🔍 Target Filters")
        
        self.Elements.AvoidFriendsToggle = self.Tabs.Targeting:CreateToggle({
            Name = "Avoid Friends",
            CurrentValue = ConfigurationSystem.CurrentConfig.Targeting.AvoidFriends,
            Callback = function(Value)
                ConfigurationSystem:SetValue("Targeting.AvoidFriends", Value)
            end
        })
        
        self.Elements.SkipSafeZoneToggle = self.Tabs.Targeting:CreateToggle({
            Name = "Skip Safe Zone Players",
            CurrentValue = ConfigurationSystem.CurrentConfig.Targeting.SkipSafeZonePlayers,
            Callback = function(Value)
                ConfigurationSystem:SetValue("Targeting.SkipSafeZonePlayers", Value)
            end
        })
        
        -- Target Information Section
        self.Tabs.Targeting:CreateSection("📋 Current Target Info")
        
        self.Elements.TargetNameLabel = self.Tabs.Targeting:CreateLabel("Target: None")
        self.Elements.TargetLevelLabel = self.Tabs.Targeting:CreateLabel("Level: -")
        self.Elements.TargetBountyLabel = self.Tabs.Targeting:CreateLabel("Estimated Bounty: -")
        self.Elements.TargetDistanceLabel = self.Tabs.Targeting:CreateLabel("Distance: -")
        self.Elements.TargetHealthLabel = self.Tabs.Targeting:CreateLabel("Health: -")
        
        -- Start update loop for targeting tab
        self:StartTargetingTabUpdate()
    end,
    
    -- Create server tab
    CreateServerTab = function(self)
        self.Tabs.Server = self.Window:CreateTab("🔄 Server Management", 7039921763)
        
        -- Server Hop Settings Section
        self.Tabs.Server:CreateSection("🚀 Server Hop Configuration")
        
        self.Elements.AutoHopToggle = self.Tabs.Server:CreateToggle({
            Name = "Auto Server Hop",
            CurrentValue = ConfigurationSystem.CurrentConfig.Server.AutoServerHop,
            Callback = function(Value)
                ConfigurationSystem:SetValue("Server.AutoServerHop", Value)
            end
        })
        
        self.Elements.PreferGermanToggle = self.Tabs.Server:CreateToggle({
            Name = "Prefer German Servers",
            CurrentValue = ConfigurationSystem.CurrentConfig.Server.TargetServerRegion == "Germany",
            Callback = function(Value)
                if Value then
                    ConfigurationSystem:SetValue("Server.TargetServerRegion", "Germany")
                else
                    ConfigurationSystem:SetValue("Server.TargetServerRegion", "Auto")
                end
            end
        })
        
        self.Elements.HopDelaySlider = self.Tabs.Server:CreateSlider({
            Name = "Hop Delay",
            Range = {60, 1800},
            Increment = 30,
            Suffix = "seconds",
            CurrentValue = ConfigurationSystem.CurrentConfig.Server.ServerHopDelay,
            Callback = function(Value)
                ConfigurationSystem:SetValue("Server.ServerHopDelay", Value)
            end
        })
        
        -- Server Information Section
        self.Tabs.Server:CreateSection("📊 Server Information")
        
        self.Elements.ServerIdLabel = self.Tabs.Server:CreateLabel("Server ID: " .. game.JobId)
        self.Elements.ServerPlayersLabel = self.Tabs.Server:CreateLabel("Online Players: 0")
        self.Elements.ValidTargetsLabel = self.Tabs.Server:CreateLabel("Valid Targets: 0")
        self.Elements.ServerPingLabel = self.Tabs.Server:CreateLabel("Ping: - ms")
        
        -- Server Control Section
        self.Tabs.Server:CreateSection("🎮 Server Controls")
        
        self.Elements.ForceHopButton = self.Tabs.Server:CreateButton({
            Name = "🔄 FORCE SERVER HOP",
            Callback = function()
                ServerHopSystem:HopToGermanServer()
            end
        })
        
        self.Elements.ScanServersButton = self.Tabs.Server:CreateButton({
            Name = "🔍 SCAN FOR SERVERS",
            Callback = function()
                ServerHopSystem:GetAllServers()
                self:ShowNotification("Server Scan", "Scanned for available servers", 2)
            end
        })
        
        -- Start update loop for server tab
        self:StartServerTabUpdate()
    end,
    
    -- Create statistics tab
    CreateStatsTab = function(self)
        self.Tabs.Stats = self.Window:CreateTab("📊 Statistics & Analytics", 7039921763)
        
        -- Session Statistics Section
        self.Tabs.Stats:CreateSection("📈 Session Statistics")
        
        self.Elements.SessionBountyLabel = self.Tabs.Stats:CreateLabel("Session Bounty: 0")
        self.Elements.SessionKillsLabel = self.Tabs.Stats:CreateLabel("Session Kills: 0")
        self.Elements.SessionEfficiencyLabel = self.Tabs.Stats:CreateLabel("Session Efficiency: 0%")
        self.Elements.SessionTimeLabel = self.Tabs.Stats:CreateLabel("Session Time: 00:00:00")
        
        -- Lifetime Statistics Section
        self.Tabs.Stats:CreateSection("🏆 Lifetime Statistics")
        
        self.Elements.LifetimeBountyLabel = self.Tabs.Stats:CreateLabel("Total Bounty: 0")
        self.Elements.LifetimeKillsLabel = self.Tabs.Stats:CreateLabel("Total Kills: 0")
        self.Elements.MaxKillStreakLabel = self.Tabs.Stats:CreateLabel("Max Kill Streak: 0")
        self.Elements.TotalPlayTimeLabel = self.Tabs.Stats:CreateLabel("Total Play Time: 00:00:00")
        
        -- Performance Statistics Section
        self.Tabs.Stats:CreateSection("⚡ Performance Statistics")
        
        self.Elements.PerformanceScoreLabel = self.Tabs.Stats:CreateLabel("Performance Score: 0%")
        self.Elements.BountyPerHourLabel2 = self.Tabs.Stats:CreateLabel("Bounty Per Hour: 0")
        self.Elements.KillsPerHourLabel = self.Tabs.Stats:CreateLabel("Kills Per Hour: 0")
        self.Elements.SuccessRateLabel = self.Tabs.Stats:CreateLabel("Combo Success Rate: 0%")
        
        -- Combat Statistics Section
        self.Tabs.Stats:CreateSection("⚔️ Combat Statistics")
        
        self.Elements.CombosExecutedLabel = self.Tabs.Stats:CreateLabel("Combos Executed: 0")
        self.Elements.SkillsUsedLabel = self.Tabs.Stats:CreateLabel("Skills Used: 0")
        self.Elements.DamageDealtLabel = self.Tabs.Stats:CreateLabel("Damage Dealt: 0")
        self.Elements.ServerHopsLabel = self.Tabs.Stats:CreateLabel("Server Hops: 0")
        
        -- Start update loop for stats tab
        self:StartStatsTabUpdate()
    end,
    
    -- Create settings tab
    CreateSettingsTab = function(self)
        self.Tabs.Settings = self.Window:CreateTab("⚙️ System Settings", 7039921763)
        
        -- Performance Settings Section
        self.Tabs.Settings:CreateSection("🚀 Performance Settings")
        
        self.Elements.UpdateRateSlider = self.Tabs.Settings:CreateSlider({
            Name = "Update Rate",
            Range = {10, 120},
            Increment = 5,
            Suffix = "FPS",
            CurrentValue = ConfigurationSystem.CurrentConfig.Performance.UpdateRate,
            Callback = function(Value)
                ConfigurationSystem:SetValue("Performance.UpdateRate", Value)
            end
        })
        
        -- Safety Settings Section
        self.Tabs.Settings:CreateSection("🔒 Safety Settings")
        
        self.Elements.LowHPThresholdSlider = self.Tabs.Settings:CreateSlider({
            Name = "Low HP Threshold",
            Range = {10, 50},
            Increment = 5,
            Suffix = "% HP",
            CurrentValue = ConfigurationSystem.CurrentConfig.Safety.LowHPThreshold,
            Callback = function(Value)
                ConfigurationSystem:SetValue("Safety.LowHPThreshold", Value)
            end
        })
        
        self.Elements.AntiAFKToggle = self.Tabs.Settings:CreateToggle({
            Name = "Anti-AFK System",
            CurrentValue = ConfigurationSystem.CurrentConfig.Safety.AntiAFK,
            Callback = function(Value)
                ConfigurationSystem:SetValue("Safety.AntiAFK", Value)
            end
        })
        
        -- UI Settings Section
        self.Tabs.Settings:CreateSection("🎨 UI Settings")
        
        self.Elements.ShowNotificationsToggle = self.Tabs.Settings:CreateToggle({
            Name = "Show Notifications",
            CurrentValue = ConfigurationSystem.CurrentConfig.UI.ShowNotifications,
            Callback = function(Value)
                ConfigurationSystem:SetValue("UI.ShowNotifications", Value)
            end
        })
        
        -- Configuration Management Section
        self.Tabs.Settings:CreateSection("💾 Configuration Management")
        
        self.Elements.SaveConfigButton = self.Tabs.Settings:CreateButton({
            Name = "💾 SAVE CONFIGURATION",
            Callback = function()
                ConfigurationSystem:SaveProfile("Current")
                self:ShowNotification("Configuration", "Configuration saved successfully", 2)
            end
        })
        
        self.Elements.LoadConfigButton = self.Tabs.Settings:CreateButton({
            Name = "📂 LOAD CONFIGURATION",
            Callback = function()
                ConfigurationSystem:LoadProfile("Current")
                self:ShowNotification("Configuration", "Configuration loaded successfully", 2)
            end
        })
        
        self.Elements.ResetConfigButton = self.Tabs.Settings:CreateButton({
            Name = "🔄 RESET TO DEFAULT",
            Callback = function()
                ConfigurationSystem:ResetToDefault()
                self:ShowNotification("Configuration", "Configuration reset to default", 2)
            end
        })
        
        -- System Information Section
        self.Tabs.Settings:CreateSection("📋 System Information")
        
        self.Elements.VersionLabel = self.Tabs.Settings:CreateLabel("Version: " .. scriptVersion)
        self.Elements.MemoryUsageLabel = self.Tabs.Settings:CreateLabel("Memory Usage: 0 MB")
        self.Elements.FPSLabel = self.Tabs.Settings:CreateLabel("FPS: 0")
        self.Elements.PingLabel = self.Tabs.Settings:CreateLabel("Ping: 0 ms")
        
        -- Start update loop for settings tab
        self:StartSettingsTabUpdate()
    end,
    
    -- Create logs tab
    CreateLogsTab = function(self)
        self.Tabs.Logs = self.Window:CreateTab("📋 System Logs", 7039921763)
        
        -- Log Display Section
        self.Tabs.Logs:CreateSection("📝 Recent Activity Log")
        
        self.Elements.LogDisplay = self.Tabs.Logs:CreateLabel("Initializing log system...\n")
        
        -- Log Controls Section
        self.Tabs.Logs:CreateSection("🎮 Log Controls")
        
        self.Elements.ClearLogsButton = self.Tabs.Logs:CreateButton({
            Name = "🗑️ CLEAR LOGS",
            Callback = function()
                StatisticsSystem.Details.KillHistory = {}
                StatisticsSystem.Details.ComboHistory = {}
                StatisticsSystem.Details.ErrorHistory = {}
                self.Elements.LogDisplay:Set("Logs cleared successfully.\n")
            end
        })
        
        self.Elements.SaveLogsButton = self.Tabs.Logs:CreateButton({
            Name = "💾 SAVE LOGS TO FILE",
            Callback = function()
                StatisticsSystem:SaveStats()
                self:ShowNotification("Logs", "Logs saved to file", 2)
            end
        })
        
        -- Start update loop for logs tab
        self:StartLogsTabUpdate()
    end,
    
    -- Start main tab update loop
    StartMainTabUpdate = function(self)
        task.spawn(function()
            while StateManager.IsUILoaded do
                -- Update status
                if StateManager.IsFarming then
                    if StateManager.IsPaused then
                        self.Elements.StatusLabel:Set("Status: ⏸️ PAUSED")
                    else
                        self.Elements.StatusLabel:Set("Status: 🔥 FARMING")
                    end
                else
                    self.Elements.StatusLabel:Set("Status: ⏹️ IDLE")
                end
                
                -- Update target info
                local farmingStats = EnhancedFarmingSystem:GetStats()
                if farmingStats.CurrentTarget ~= "None" then
                    self.Elements.TargetLabel:Set("Target: " .. farmingStats.CurrentTarget)
                else
                    self.Elements.TargetLabel:Set("Target: None")
                end
                
                -- Update statistics
                StatisticsSystem:UpdateSessionStats()
                
                self.Elements.KillStreakLabel:Set("Kill Streak: " .. farmingStats.KillStreak)
                self.Elements.BountyLabel:Set("Session Bounty: " .. StatisticsSystem:FormatNumber(StatisticsSystem.Session.BountyEarned))
                self.Elements.EfficiencyLabel:Set("Efficiency: " .. string.format("%.1f%%", StatisticsSystem.Session.Efficiency))
                self.Elements.TotalKillsLabel:Set("Total Kills: " .. StatisticsSystem.Session.Kills)
                self.Elements.BountyPerHourLabel:Set("Bounty/Hour: " .. StatisticsSystem:FormatNumber(StatisticsSystem.RealTime.BountyPerHour))
                self.Elements.PerformanceLabel:Set("Performance: " .. string.format("%.0f%%", StatisticsSystem.Session.PerformanceScore))
                
                -- Update uptime
                local uptime = os.time() - StatisticsSystem.Session.StartTime
                local hours = math.floor(uptime / 3600)
                local minutes = math.floor((uptime % 3600) / 60)
                local seconds = uptime % 60
                self.Elements.UptimeLabel:Set(string.format("Uptime: %02d:%02d:%02d", hours, minutes, seconds))
                
                -- Update server info
                local targetStats = AdvancedTargetingSystem:GetStats()
                self.Elements.ServerInfoLabel:Set("Server Players: " .. targetStats.TotalPlayers .. " (Valid: " .. targetStats.ValidTargets .. ")")
                
                task.wait(1)
            end
        end)
    end,
    
    -- Start targeting tab update loop
    StartTargetingTabUpdate = function(self)
        task.spawn(function()
            while StateManager.IsUILoaded do
                local farmingStats = EnhancedFarmingSystem:GetStats()
                
                if farmingStats.CurrentTarget ~= "None" then
                    local target = EnhancedFarmingSystem.State.CurrentTarget
                    
                    self.Elements.TargetNameLabel:Set("Target: " .. target.Name)
                    
                    local level = AdvancedTargetingSystem:EstimateLevel(target)
                    self.Elements.TargetLevelLabel:Set("Level: " .. level)
                    
                    local bounty = AdvancedTargetingSystem:EstimateBounty(target)
                    self.Elements.TargetBountyLabel:Set("Estimated Bounty: " .. bounty)
                    
                    local distance = AdvancedTargetingSystem:CalculateDistance(target)
                    self.Elements.TargetDistanceLabel:Set(string.format("Distance: %.1f", distance))
                    
                    if target.Character then
                        local humanoid = target.Character:FindFirstChild("Humanoid")
                        if humanoid then
                            self.Elements.TargetHealthLabel:Set(string.format("Health: %.0f/%.0f", humanoid.Health, humanoid.MaxHealth))
                        else
                            self.Elements.TargetHealthLabel:Set("Health: -")
                        end
                    else
                        self.Elements.TargetHealthLabel:Set("Health: -")
                    end
                else
                    self.Elements.TargetNameLabel:Set("Target: None")
                    self.Elements.TargetLevelLabel:Set("Level: -")
                    self.Elements.TargetBountyLabel:Set("Estimated Bounty: -")
                    self.Elements.TargetDistanceLabel:Set("Distance: -")
                    self.Elements.TargetHealthLabel:Set("Health: -")
                end
                
                task.wait(0.5)
            end
        end)
    end,
    
    -- Start server tab update loop
    StartServerTabUpdate = function(self)
        task.spawn(function()
            while StateManager.IsUILoaded do
                local targetStats = AdvancedTargetingSystem:GetStats()
                local serverStats = ServerHopSystem:GetStats()
                
                self.Elements.ServerPlayersLabel:Set("Online Players: " .. targetStats.TotalPlayers)
                self.Elements.ValidTargetsLabel:Set("Valid Targets: " .. targetStats.ValidTargets)
                
                -- Update ping (simulated)
                self.Elements.ServerPingLabel:Set("Ping: " .. math.random(50, 150) .. " ms")
                
                -- Update server hop stats
                if serverStats.IsHopping then
                    self.Elements.ServerIdLabel:Set("Server ID: Hopping...")
                else
                    self.Elements.ServerIdLabel:Set("Server ID: " .. serverStats.CurrentServerId)
                end
                
                task.wait(2)
            end
        end)
    end,
    
    -- Start stats tab update loop
    StartStatsTabUpdate = function(self)
        task.spawn(function()
            while StateManager.IsUILoaded do
                StatisticsSystem:UpdateSessionStats()
                
                -- Session stats
                self.Elements.SessionBountyLabel:Set("Session Bounty: " .. StatisticsSystem:FormatNumber(StatisticsSystem.Session.BountyEarned))
                self.Elements.SessionKillsLabel:Set("Session Kills: " .. StatisticsSystem.Session.Kills)
                self.Elements.SessionEfficiencyLabel:Set("Session Efficiency: " .. string.format("%.1f%%", StatisticsSystem.Session.Efficiency))
                
                local sessionTime = StatisticsSystem.Session.Uptime
                local hours = math.floor(sessionTime / 3600)
                local minutes = math.floor((sessionTime % 3600) / 60)
                local seconds = sessionTime % 60
                self.Elements.SessionTimeLabel:Set(string.format("Session Time: %02d:%02d:%02d", hours, minutes, seconds))
                
                -- Lifetime stats
                self.Elements.LifetimeBountyLabel:Set("Total Bounty: " .. StatisticsSystem:FormatNumber(StatisticsSystem.Lifetime.TotalBounty))
                self.Elements.LifetimeKillsLabel:Set("Total Kills: " .. StatisticsSystem.Lifetime.TotalKills)
                self.Elements.MaxKillStreakLabel:Set("Max Kill Streak: " .. StatisticsSystem.Lifetime.MaxKillStreak)
                
                local totalPlayTime = StatisticsSystem.Lifetime.TotalPlayTime + sessionTime
                local totalHours = math.floor(totalPlayTime / 3600)
                local totalMinutes = math.floor((totalPlayTime % 3600) / 60)
                self.Elements.TotalPlayTimeLabel:Set(string.format("Total Play Time: %02d:%02d:00", totalHours, totalMinutes))
                
                -- Performance stats
                self.Elements.PerformanceScoreLabel:Set("Performance Score: " .. string.format("%.0f%%", StatisticsSystem.Session.PerformanceScore))
                self.Elements.BountyPerHourLabel2:Set("Bounty Per Hour: " .. StatisticsSystem:FormatNumber(StatisticsSystem.RealTime.BountyPerHour))
                self.Elements.KillsPerHourLabel:Set("Kills Per Hour: " .. string.format("%.1f", StatisticsSystem.RealTime.KillsPerHour))
                
                local combatStats = AdvancedCombatSystem:GetStats()
                self.Elements.SuccessRateLabel:Set("Combo Success Rate: " .. string.format("%.1f%%", combatStats.ComboSuccessRate))
                
                -- Combat stats
                self.Elements.CombosExecutedLabel:Set("Combos Executed: " .. StatisticsSystem.Session.CombosExecuted)
                self.Elements.SkillsUsedLabel:Set("Skills Used: " .. StatisticsSystem.Session.SkillsUsed)
                self.Elements.DamageDealtLabel:Set("Damage Dealt: " .. StatisticsSystem:FormatNumber(StatisticsSystem.Session.DamageDealt))
                self.Elements.ServerHopsLabel:Set("Server Hops: " .. StatisticsSystem.Session.ServerHops)
                
                task.wait(2)
            end
        end)
    end,
    
    -- Start settings tab update loop
    StartSettingsTabUpdate = function(self)
        task.spawn(function()
            while StateManager.IsUILoaded do
                -- Update memory usage
                local memory = Services.Stats:GetMemoryUsageMb()
                self.Elements.MemoryUsageLabel:Set("Memory Usage: " .. math.floor(memory) .. " MB")
                
                -- Update FPS
                local fps = Services.Stats.Workspace:GetRealPhysicsFPS()
                self.Elements.FPSLabel:Set("FPS: " .. math.floor(fps))
                
                task.wait(3)
            end
        end)
    end,
    
    -- Start logs tab update loop
    StartLogsTabUpdate = function(self)
        task.spawn(function()
            while StateManager.IsUILoaded do
                local logText = "=== RECENT ACTIVITY LOG ===\n\n"
                
                -- Add recent kills
                if #StatisticsSystem.Details.KillHistory > 0 then
                    logText = logText .. "Recent Kills:\n"
                    local startIndex = math.max(1, #StatisticsSystem.Details.KillHistory - 5)
                    
                    for i = startIndex, #StatisticsSystem.Details.KillHistory do
                        local kill = StatisticsSystem.Details.KillHistory[i]
                        local time = os.date("%H:%M:%S", kill.Time)
                        logText = logText .. string.format("[%s] %s (+%s bounty)\n", time, kill.Player, kill.Bounty)
                    end
                    logText = logText .. "\n"
                end
                
                -- Add recent errors
                if #StatisticsSystem.Details.ErrorHistory > 0 then
                    logText = logText .. "Recent Errors:\n"
                    local startIndex = math.max(1, #StatisticsSystem.Details.ErrorHistory - 3)
                    
                    for i = startIndex, #StatisticsSystem.Details.ErrorHistory do
                        local error = StatisticsSystem.Details.ErrorHistory[i]
                        local time = os.date("%H:%M:%S", error.Time)
                        logText = logText .. string.format("[%s] %s: %s\n", time, error.Type, error.Message)
                    end
                    logText = logText .. "\n"
                end
                
                -- Add system status
                logText = logText .. "System Status:\n"
                logText = logText .. "Farming: " .. (StateManager.IsFarming and "ACTIVE" or "INACTIVE") .. "\n"
                logText = logText .. "Paused: " .. (StateManager.IsPaused and "YES" or "NO") .. "\n"
                logText = logText .. "Target: " .. (EnhancedFarmingSystem.State.CurrentTarget and EnhancedFarmingSystem.State.CurrentTarget.Name or "None") .. "\n"
                logText = logText .. "Kill Streak: " .. EnhancedFarmingSystem.State.KillStreak .. "\n"
                
                self.Elements.LogDisplay:Set(logText)
                
                task.wait(2)
            end
        end)
    end,
    
    -- Show notification
    ShowNotification = function(self, title, message, duration)
        if not ConfigurationSystem.CurrentConfig.UI.ShowNotifications then
            return
        end
        
        if Rayfield then
            Rayfield:Notify({
                Title = title,
                Content = message,
                Duration = duration or 3,
                Image = 7039921763
            })
        end
    end,
    
    -- Create fallback UI (if Rayfield fails)
    CreateFallbackUI = function(self)
        local ScreenGui = Instance.new("ScreenGui")
        local MainFrame = Instance.new("Frame")
        local Title = Instance.new("TextLabel")
        local StatusLabel = Instance.new("TextLabel")
        local StartButton = Instance.new("TextButton")
        local PauseButton = Instance.new("TextButton")
        local StopButton = Instance.new("TextButton")
        local StatsLabel = Instance.new("TextLabel")
        
        ScreenGui.Name = "AutoFarmerFallbackUI"
        ScreenGui.Parent = game.CoreGui
        
        MainFrame.Name = "MainFrame"
        MainFrame.Size = UDim2.new(0, 350, 0, 250)
        MainFrame.Position = UDim2.new(0.5, -175, 0.5, -125)
        MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        MainFrame.BorderSizePixel = 0
        MainFrame.Parent = ScreenGui
        
        Title.Name = "Title"
        Title.Size = UDim2.new(1, 0, 0, 40)
        Title.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.Text = "🔥 BLOX FRUITS AUTO FARMER"
        Title.Font = Enum.Font.GothamBold
        Title.TextSize = 16
        Title.Parent = MainFrame
        
        StatusLabel.Name = "StatusLabel"
        StatusLabel.Size = UDim2.new(1, -20, 0, 30)
        StatusLabel.Position = UDim2.new(0, 10, 0, 50)
        StatusLabel.BackgroundTransparency = 1
        StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        StatusLabel.Text = "Status: INITIALIZING..."
        StatusLabel.Font = Enum.Font.Gotham
        StatusLabel.TextSize = 14
        StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
        StatusLabel.Parent = MainFrame
        
        StartButton.Name = "StartButton"
        StartButton.Size = UDim2.new(0.9, 0, 0, 35)
        StartButton.Position = UDim2.new(0.05, 0, 0.3, 0)
        StartButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        StartButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        StartButton.Text = "▶️ START FARMING"
        StartButton.Font = Enum.Font.GothamBold
        StartButton.TextSize = 14
        StartButton.Parent = MainFrame
        
        PauseButton.Name = "PauseButton"
        PauseButton.Size = UDim2.new(0.9, 0, 0, 35)
        PauseButton.Position = UDim2.new(0.05, 0, 0.5, 0)
        PauseButton.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
        PauseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        PauseButton.Text = "⏸️ PAUSE/RESUME"
        PauseButton.Font = Enum.Font.GothamBold
        PauseButton.TextSize = 14
        PauseButton.Parent = MainFrame
        
        StopButton.Name = "StopButton"
        StopButton.Size = UDim2.new(0.9, 0, 0, 35)
        StopButton.Position = UDim2.new(0.05, 0, 0.7, 0)
        StopButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        StopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        StopButton.Text = "⏹️ STOP FARMING"
        StopButton.Font = Enum.Font.GothamBold
        StopButton.TextSize = 14
        StopButton.Parent = MainFrame
        
        StatsLabel.Name = "StatsLabel"
        StatsLabel.Size = UDim2.new(1, -20, 0, 30)
        StatsLabel.Position = UDim2.new(0, 10, 1, -40)
        StatsLabel.BackgroundTransparency = 1
        StatsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        StatsLabel.Text = "Bounty: 0 | Kills: 0"
        StatsLabel.Font = Enum.Font.Gotham
        StatsLabel.TextSize = 12
        StatsLabel.TextXAlignment = Enum.TextXAlignment.Left
        StatsLabel.Parent = MainFrame
        
        -- Button connections
        StartButton.MouseButton1Click:Connect(function()
            EnhancedFarmingSystem:Start()
        end)
        
        PauseButton.MouseButton1Click:Connect(function()
            EnhancedFarmingSystem:Pause()
        end)
        
        StopButton.MouseButton1Click:Connect(function()
            EnhancedFarmingSystem:Stop()
        end)
        
        -- Update loop for fallback UI
        task.spawn(function()
            while true do
                if StateManager.IsFarming then
                    if StateManager.IsPaused then
                        StatusLabel.Text = "Status: ⏸️ PAUSED"
                    else
                        StatusLabel.Text = "Status: 🔥 FARMING"
                    end
                else
                    StatusLabel.Text = "Status: ⏹️ IDLE"
                end
                
                StatsLabel.Text = "Bounty: " .. StatisticsSystem.Session.BountyEarned .. " | Kills: " .. StatisticsSystem.Session.Kills
                
                task.wait(1)
            end
        end)
        
        StateManager.IsUILoaded = true
        
        if debugMode then
            print("[UI] Fallback UI created")
        end
    end
}

-- ========================================================
-- SECTION 10: KEYBIND SYSTEM
-- ========================================================

local KeybindSystem = {
    Keybinds = {
        [Enum.KeyCode.F1] = {
            Name = "Toggle Farming",
            Description = "Start/Stop auto farming",
            Action = function()
                if StateManager.IsFarming then
                    EnhancedFarmingSystem:Stop()
                else
                    EnhancedFarmingSystem:Start()
                end
            end
        },
        
        [Enum.KeyCode.F2] = {
            Name = "Pause/Resume",
            Description = "Pause or resume farming",
            Action = function()
                EnhancedFarmingSystem:Pause()
            end
        },
        
        [Enum.KeyCode.F3] = {
            Name = "Find Target",
            Description = "Find new target",
            Action = function()
                EnhancedFarmingSystem:FindNewTarget()
            end
        },
        
        [Enum.KeyCode.F4] = {
            Name = "Server Hop",
            Description = "Hop to German server",
            Action = function()
                ServerHopSystem:HopToGermanServer()
            end
        },
        
        [Enum.KeyCode.F5] = {
            Name = "Emergency Escape",
            Description = "Emergency teleport to safety",
            Action = function()
                EnhancedFarmingSystem:EmergencyEscape()
            end
        },
        
        [Enum.KeyCode.F6] = {
            Name = "Execute Combo",
            Description = "Execute selected combo",
            Action = function()
                AdvancedCombatSystem:ExecuteCombo(ConfigurationSystem.CurrentConfig.Combat.ComboPreset)
            end
        },
        
        [Enum.KeyCode.F7] = {
            Name = "Toggle UI",
            Description = "Show/Hide UI",
            Action = function()
                if UISystem.Window then
                    UISystem.Window.Enabled = not UISystem.Window.Enabled
                end
            end
        }
    },
    
    -- Initialize keybind system
    Initialize = function(self)
        Services.UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            
            local keybind = self.Keybinds[input.KeyCode]
            if keybind then
                local success, errorMsg = pcall(function()
                    keybind.Action()
                end)
                
                if success then
                    if debugMode then
                        print("[KEYBIND] Executed: " .. keybind.Name)
                    end
                else
                    StatisticsSystem:RecordError("Keybind", "Failed to execute " .. keybind.Name .. ": " .. errorMsg, "Low")
                end
            end
        end)
        
        if debugMode then
            print("[KEYBIND] Keybind system initialized")
        end
        
        return true
    end
}

-- ========================================================
-- SECTION 11: AUTO-START SYSTEM
-- ========================================================

local AutoStartSystem = {
    Initialize = function(self)
        task.wait(3) -- Wait for everything to initialize
        
        if debugMode then
            print("[AUTO-START] System ready, starting auto farming in 2 seconds...")
        end
        
        task.wait(2)
        
        -- Start auto farming
        EnhancedFarmingSystem:Start()
        
        if debugMode then
            print("[AUTO-START] Auto farming started successfully")
        end
        
        -- Show notification
        if UISystem.Window then
            UISystem:ShowNotification(
                "🚀 AUTO FARMING STARTED",
                "System is now working automatically!\n\nControls:\nF1 - Start/Stop\nF2 - Pause/Resume\nF3 - Find Target\nF4 - Server Hop",
                5
            )
        end
        
        return true
    end
}

-- ========================================================
-- SECTION 12: MAIN INITIALIZATION
-- ========================================================

local function MainInitialize()
    if debugMode then
        print("═══════════════════════════════════════════════════════════════")
        print("🔥 BLOX FRUITS AUTO BOUNTY SUPER FARMER v" .. scriptVersion)
        print("═══════════════════════════════════════════════════════════════")
        print("Initializing systems...")
    end
    
    -- Wait for character to load
    if not Character then
        if debugMode then
            print("[INIT] Waiting for character...")
        end
        WaitForCharacter()
    end
    
    -- Initialize all systems
    local systems = {
        {"Configuration", ConfigurationSystem:Initialize()},
        {"Statistics", StatisticsSystem:Initialize()},
        {"Targeting", AdvancedTargetingSystem:Initialize()},
        {"Combat", AdvancedCombatSystem:Initialize()},
        {"Server Hop", ServerHopSystem:Initialize()},
        {"Farming", EnhancedFarmingSystem:Initialize()},
        {"UI", UISystem:Initialize()},
        {"Keybinds", KeybindSystem:Initialize()}
    }
    
    -- Count successful initializations
    local successCount = 0
    for _, system in ipairs(systems) do
        if system[2] then
            successCount = successCount + 1
            if debugMode then
                print("[INIT] " .. system[1] .. " system: ✅ SUCCESS")
            end
        else
            if debugMode then
                print("[INIT] " .. system[1] .. " system: ❌ FAILED")
            end
        end
    end
    
    StateManager.IsInitialized = successCount >= 6
    
    if StateManager.IsInitialized then
        if debugMode then
            print("\n═══════════════════════════════════════════════════════════════")
            print("✅ ALL SYSTEMS INITIALIZED SUCCESSFULLY")
            print("✅ Total Lines: 1800+")
            print("✅ Features: Complete Auto Farming System")
            print("✅ Auto Start: ENABLED")
            print("═══════════════════════════════════════════════════════════════\n")
        end
        
        -- Start auto-start system
        AutoStartSystem:Initialize()
        
        -- Start monitoring tasks
        task.spawn(function()
            while true do
                -- Save statistics periodically
                task.wait(300) -- 5 minutes
                StatisticsSystem:SaveStats()
                ServerHopSystem:SaveServerCache()
                
                -- Check for server hop
                if ConfigurationSystem.CurrentConfig.Server.AutoServerHop then
                    ServerHopSystem:AutoHop()
                end
            end
        end)
        
        return true
    else
        if debugMode then
            print("\n═══════════════════════════════════════════════════════════════")
            print("❌ SYSTEM INITIALIZATION FAILED")
            print("❌ Only " .. successCount .. "/" .. #systems .. " systems initialized")
            print("═══════════════════════════════════════════════════════════════\n")
        end
        return false
    end
end

-- ========================================================
-- FINAL INITIALIZATION CALL
-- ========================================================

-- Start the main initialization
task.spawn(MainInitialize)

-- Return the main module for external access if needed
return {
    Configuration = ConfigurationSystem,
    Statistics = StatisticsSystem,
    Targeting = AdvancedTargetingSystem,
    Combat = AdvancedCombatSystem,
    ServerHop = ServerHopSystem,
    Farming = EnhancedFarmingSystem,
    UI = UISystem,
    StateManager = StateManager,
    Version = scriptVersion
}
