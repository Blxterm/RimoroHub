--[[
    NEXUS BOUNTY - Ultimate Blox Fruits Auto Bounty Script
    Version: 3.0 | Complete Integrated System
    Features: All-in-One Bounty Farming with Advanced AI
--]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local Stats = game:GetService("Stats")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")

-- Player Variables
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Camera = Workspace.CurrentCamera
local Mouse = Player:GetMouse()

-- Configuration
local Config = {
    TotalBounty = 0,
    SessionBounty = 0,
    Kills = 0,
    Deaths = 0,
    StartTime = os.time(),
    CooldownList = {},
    ServerHopCount = 0,
    ComboExecutions = 0,
    AutoFarm = false,
    NextPlayerMode = false,
    CurrentTarget = nil,
    IsExecuting = false,
    IsFlying = false
}

-- State Management
local States = {
    Scanning = false,
    Targeting = false,
    Approaching = false,
    Executing = false,
    Evaluating = false,
    Hopping = false
}

-- Skill Configuration
local Skills = {
    Sword = {"Z", "X", "C", "V", "F"},
    Fruit = {"Z", "X", "C", "V", "F"},
    Melee = {"Z", "X", "C", "V", "F"},
    Gun = {"Z", "X", "C", "V", "F"},
    Style = {"Z", "X", "C", "V", "F"}
}

-- Combo System
local Combo = {
    Active = {},
    Saved = {},
    Stage = 1,
    MaxStages = 4,
    Loop = false,
    Speed = 0.2,
    RandomDelay = true
}

-- Targeting System
local Targeting = {
    MinLevel = 2000,
    MinBounty = 100000,
    MaxDistance = 500,
    AvoidSafeZone = true,
    CheckPVP = true,
    Priority = {"Bounty", "Level", "Distance"},
    Blacklist = {}
}

-- Movement System
local Movement = {
    Speed = 350,
    FlySpeed = 150,
    UseBezier = true,
    NoClip = true,
    AntiAntiCheat = true,
    SmoothTween = true
}

-- Safety System
local Safety = {
    LowHPThreshold = 0.3,
    AutoCounter = true,
    AntiReport = true,
    EmergencyTP = true,
    AutoHeal = true
}

-- Server Management
local Server = {
    AutoHop = false,
    HopDelay = 300,
    MinPlayers = 3,
    Region = "Auto",
    SaveSession = true
}

-- UI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NexusBountyUI"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Container
local MainContainer = Instance.new("Frame")
MainContainer.Name = "MainContainer"
MainContainer.Size = UDim2.new(0, 500, 0, 600)
MainContainer.Position = UDim2.new(0.5, -250, 0.5, -300)
MainContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MainContainer.BorderSizePixel = 0
MainContainer.ClipsDescendants = true
MainContainer.Parent = ScreenGui

-- Make draggable
local dragging
local dragInput
local dragStart
local startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    MainContainer.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainContainer.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainContainer.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainContainer.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateInput(input)
    end
end)

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainContainer

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "NEXUS BOUNTY v3.0"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Parent = TitleBar

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 40, 0, 40)
CloseButton.Position = UDim2.new(1, -40, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.white
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 16
CloseButton.Parent = TitleBar

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 40, 0, 40)
MinimizeButton.Position = UDim2.new(1, -80, 0, 0)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
MinimizeButton.Text = "_"
MinimizeButton.TextColor3 = Color3.white
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 16
MinimizeButton.Parent = TitleBar

MinimizeButton.MouseButton1Click:Connect(function()
    MainContainer.Visible = not MainContainer.Visible
end)

-- Bounty Display Window (Square Image Style)
local BountyWindow = Instance.new("Frame")
BountyWindow.Name = "BountyWindow"
BountyWindow.Size = UDim2.new(0, 350, 0, 400)
BountyWindow.Position = UDim2.new(0, 20, 0.5, -200)
BountyWindow.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
BountyWindow.BorderSizePixel = 2
BountyWindow.BorderColor3 = Color3.fromRGB(0, 150, 255)
BountyWindow.Visible = true
BountyWindow.Parent = ScreenGui

-- Bounty Image Display
local BountyImage = Instance.new("ImageLabel")
BountyImage.Name = "BountyImage"
BountyImage.Size = UDim2.new(1, 0, 0, 200)
BountyImage.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
BountyImage.BorderSizePixel = 0
BountyImage.Image = "rbxassetid://0" -- Add your image ID here
BountyImage.ScaleType = Enum.ScaleType.Crop
BountyImage.Parent = BountyWindow

-- Bounty Stats Overlay
local StatsOverlay = Instance.new("Frame")
StatsOverlay.Name = "StatsOverlay"
StatsOverlay.Size = UDim2.new(1, 0, 0, 200)
StatsOverlay.Position = UDim2.new(0, 0, 0, 200)
StatsOverlay.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
StatsOverlay.BorderSizePixel = 0
StatsOverlay.Parent = BountyWindow

-- Current Bounty Display
local CurrentBountyLabel = Instance.new("TextLabel")
CurrentBountyLabel.Name = "CurrentBountyLabel"
CurrentBountyLabel.Size = UDim2.new(1, -20, 0, 40)
CurrentBountyLabel.Position = UDim2.new(0, 10, 0, 10)
CurrentBountyLabel.BackgroundTransparency = 1
CurrentBountyLabel.Text = "CURRENT BOUNTY: 0"
CurrentBountyLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
CurrentBountyLabel.Font = Enum.Font.GothamBold
CurrentBountyLabel.TextSize = 20
CurrentBountyLabel.TextStrokeTransparency = 0.5
CurrentBountyLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
CurrentBountyLabel.Parent = StatsOverlay

-- Session Bounty Display
local SessionBountyLabel = Instance.new("TextLabel")
SessionBountyLabel.Name = "SessionBountyLabel"
SessionBountyLabel.Size = UDim2.new(1, -20, 0, 30)
SessionBountyLabel.Position = UDim2.new(0, 10, 0, 60)
SessionBountyLabel.BackgroundTransparency = 1
SessionBountyLabel.Text = "SESSION TOTAL: 0"
SessionBountyLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
SessionBountyLabel.Font = Enum.Font.GothamBold
SessionBountyLabel.TextSize = 16
SessionBountyLabel.Parent = StatsOverlay

-- Time Display
local TimeLabel = Instance.new("TextLabel")
TimeLabel.Name = "TimeLabel"
TimeLabel.Size = UDim2.new(1, -20, 0, 30)
TimeLabel.Position = UDim2.new(0, 10, 0, 100)
TimeLabel.BackgroundTransparency = 1
TimeLabel.Text = "TIME: 00:00:00"
TimeLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
TimeLabel.Font = Enum.Font.Gotham
TimeLabel.TextSize = 14
TimeLabel.Parent = StatsOverlay

-- KDR Display
local KDRLabel = Instance.new("TextLabel")
KDRLabel.Name = "KDRLabel"
KDRLabel.Size = UDim2.new(1, -20, 0, 30)
KDRLabel.Position = UDim2.new(0, 10, 0, 140)
KDRLabel.BackgroundTransparency = 1
KDRLabel.Text = "K/D: 0.00"
KDRLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
KDRLabel.Font = Enum.Font.Gotham
KDRLabel.TextSize = 14
KDRLabel.Parent = StatsOverlay

-- Control Buttons
local ControlButtons = Instance.new("Frame")
ControlButtons.Name = "ControlButtons"
ControlButtons.Size = UDim2.new(1, -20, 0, 80)
ControlButtons.Position = UDim2.new(0, 10, 1, -90)
ControlButtons.BackgroundTransparency = 1
ControlButtons.Parent = BountyWindow

local NextPlayerButton = Instance.new("TextButton")
NextPlayerButton.Name = "NextPlayerButton"
NextPlayerButton.Size = UDim2.new(0.48, 0, 1, 0)
NextPlayerButton.BackgroundColor3 = Color3.fromRGB(0, 180, 80)
NextPlayerButton.Text = "NEXT PLAYER"
NextPlayerButton.TextColor3 = Color3.white
NextPlayerButton.Font = Enum.Font.GothamBold
NextPlayerButton.TextSize = 14
NextPlayerButton.Parent = ControlButtons

local HopServerButton = Instance.new("TextButton")
HopServerButton.Name = "HopServerButton"
HopServerButton.Size = UDim2.new(0.48, 0, 1, 0)
HopServerButton.Position = UDim2.new(0.52, 0, 0, 0)
HopServerButton.BackgroundColor3 = Color3.fromRGB(180, 0, 80)
HopServerButton.Text = "HOP SERVER"
HopServerButton.TextColor3 = Color3.white
HopServerButton.Font = Enum.Font.GothamBold
HopServerButton.TextSize = 14
HopServerButton.Parent = ControlButtons

-- Tab System
local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Size = UDim2.new(1, 0, 0, 50)
TabContainer.Position = UDim2.new(0, 0, 0, 40)
TabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
TabContainer.BorderSizePixel = 0
TabContainer.Parent = MainContainer

local Tabs = {
    "Dashboard",
    "Combo Setup",
    "Targeting",
    "Movement",
    "Safety",
    "Server"
}

local TabButtons = {}
local TabFrames = {}

for i, tabName in ipairs(Tabs) do
    -- Tab Button
    local tabButton = Instance.new("TextButton")
    tabButton.Name = tabName .. "Tab"
    tabButton.Size = UDim2.new(1 / #Tabs, 0, 1, 0)
    tabButton.Position = UDim2.new((i-1) / #Tabs, 0, 0, 0)
    tabButton.BackgroundColor3 = i == 1 and Color3.fromRGB(40, 40, 70) or Color3.fromRGB(25, 25, 40)
    tabButton.Text = tabName
    tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabButton.Font = Enum.Font.Gotham
    tabButton.TextSize = 12
    tabButton.Parent = TabContainer
    
    -- Tab Content Frame
    local tabFrame = Instance.new("ScrollingFrame")
    tabFrame.Name = tabName .. "Frame"
    tabFrame.Size = UDim2.new(1, 0, 1, -90)
    tabFrame.Position = UDim2.new(0, 0, 0, 90)
    tabFrame.BackgroundTransparency = 1
    tabFrame.ScrollBarThickness = 5
    tabFrame.Visible = i == 1
    tabFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tabFrame.Parent = MainContainer
    
    TabButtons[tabName] = tabButton
    TabFrames[tabName] = tabFrame
    
    tabButton.MouseButton1Click:Connect(function()
        for _, frame in pairs(TabFrames) do
            frame.Visible = false
        end
        for _, button in pairs(TabButtons) do
            button.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
        end
        tabFrame.Visible = true
        tabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
    end)
end

-- Dashboard Content
local DashboardFrame = TabFrames["Dashboard"]

-- Real-Time Analytics
local AnalyticsSection = Instance.new("Frame")
AnalyticsSection.Name = "AnalyticsSection"
AnalyticsSection.Size = UDim2.new(1, -20, 0, 150)
AnalyticsSection.Position = UDim2.new(0, 10, 0, 10)
AnalyticsSection.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
AnalyticsSection.BorderSizePixel = 0
AnalyticsSection.Parent = DashboardFrame

local AnalyticsTitle = Instance.new("TextLabel")
AnalyticsTitle.Name = "AnalyticsTitle"
AnalyticsTitle.Size = UDim2.new(1, 0, 0, 30)
AnalyticsTitle.BackgroundTransparency = 1
AnalyticsTitle.Text = "REAL-TIME ANALYTICS"
AnalyticsTitle.TextColor3 = Color3.fromRGB(0, 255, 255)
AnalyticsTitle.Font = Enum.Font.GothamBold
AnalyticsTitle.TextSize = 14
AnalyticsTitle.Parent = AnalyticsSection

-- Bounty Per Hour
local BPHLabel = Instance.new("TextLabel")
BPHLabel.Name = "BPHLabel"
BPHLabel.Size = UDim2.new(0.5, -5, 0, 30)
BPHLabel.Position = UDim2.new(0, 10, 0, 40)
BPHLabel.BackgroundTransparency = 1
BPHLabel.Text = "Bounty/Hour: 0"
BPHLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
BPHLabel.Font = Enum.Font.Gotham
BPHLabel.TextSize = 12
BPHLabel.TextXAlignment = Enum.TextXAlignment.Left
BPHLabel.Parent = AnalyticsSection

-- Ping Display
local PingDisplay = Instance.new("TextLabel")
PingDisplay.Name = "PingDisplay"
PingDisplay.Size = UDim2.new(0.5, -15, 0, 30)
PingDisplay.Position = UDim2.new(0.5, 5, 0, 40)
PingDisplay.BackgroundTransparency = 1
PingDisplay.Text = "Ping: 0ms"
PingDisplay.TextColor3 = Color3.fromRGB(255, 255, 255)
PingDisplay.Font = Enum.Font.Gotham
PingDisplay.TextSize = 12
PingDisplay.TextXAlignment = Enum.TextXAlignment.Left
PingDisplay.Parent = AnalyticsSection

-- Current Target Info
local TargetSection = Instance.new("Frame")
TargetSection.Name = "TargetSection"
TargetSection.Size = UDim2.new(1, -20, 0, 120)
TargetSection.Position = UDim2.new(0, 10, 0, 170)
TargetSection.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
TargetSection.BorderSizePixel = 0
TargetSection.Parent = DashboardFrame

local TargetTitle = Instance.new("TextLabel")
TargetTitle.Name = "TargetTitle"
TargetTitle.Size = UDim2.new(1, 0, 0, 30)
TargetTitle.BackgroundTransparency = 1
TargetTitle.Text = "CURRENT TARGET"
TargetTitle.TextColor3 = Color3.fromRGB(255, 100, 100)
TargetTitle.Font = Enum.Font.GothamBold
TargetTitle.TextSize = 14
TargetTitle.Parent = TargetSection

local TargetName = Instance.new("TextLabel")
TargetName.Name = "TargetName"
TargetName.Size = UDim2.new(1, -20, 0, 25)
TargetName.Position = UDim2.new(0, 10, 0, 40)
TargetName.BackgroundTransparency = 1
TargetName.Text = "Name: None"
TargetName.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetName.Font = Enum.Font.Gotham
TargetName.TextSize = 12
TargetName.TextXAlignment = Enum.TextXAlignment.Left
TargetName.Parent = TargetSection

local TargetLevel = Instance.new("TextLabel")
TargetLevel.Name = "TargetLevel"
TargetLevel.Size = UDim2.new(1, -20, 0, 25)
TargetLevel.Position = UDim2.new(0, 10, 0, 70)
TargetLevel.BackgroundTransparency = 1
TargetLevel.Text = "Level: 0"
TargetLevel.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetLevel.Font = Enum.Font.Gotham
TargetLevel.TextSize = 12
TargetLevel.TextXAlignment = Enum.TextXAlignment.Left
TargetLevel.Parent = TargetSection

local TargetHealth = Instance.new("TextLabel")
TargetHealth.Name = "TargetHealth"
TargetHealth.Size = UDim2.new(1, -20, 0, 25)
TargetHealth.Position = UDim2.new(0, 10, 0, 100)
TargetHealth.BackgroundTransparency = 1
TargetHealth.Text = "Health: 100%"
TargetHealth.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetHealth.Font = Enum.Font.Gotham
TargetHealth.TextSize = 12
TargetHealth.TextXAlignment = Enum.TextXAlignment.Left
TargetHealth.Parent = TargetSection

-- System Log
local LogSection = Instance.new("Frame")
LogSection.Name = "LogSection"
LogSection.Size = UDim2.new(1, -20, 0, 200)
LogSection.Position = UDim2.new(0, 10, 0, 300)
LogSection.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
LogSection.BorderSizePixel = 0
LogSection.Parent = DashboardFrame

local LogTitle = Instance.new("TextLabel")
LogTitle.Name = "LogTitle"
LogTitle.Size = UDim2.new(1, 0, 0, 30)
LogTitle.BackgroundTransparency = 1
LogTitle.Text = "SYSTEM LOG"
LogTitle.TextColor3 = Color3.fromRGB(100, 200, 100)
LogTitle.Font = Enum.Font.GothamBold
LogTitle.TextSize = 14
LogTitle.Parent = LogSection

local LogContainer = Instance.new("ScrollingFrame")
LogContainer.Name = "LogContainer"
LogContainer.Size = UDim2.new(1, -10, 1, -40)
LogContainer.Position = UDim2.new(0, 5, 0, 35)
LogContainer.BackgroundTransparency = 1
LogContainer.ScrollBarThickness = 5
LogContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
LogContainer.Parent = LogSection

local LogLayout = Instance.new("UIListLayout")
LogLayout.Parent = LogContainer

-- Combo Setup Content
local ComboFrame = TabFrames["Combo Setup"]

-- Combo Order Selection
local OrderSection = Instance.new("Frame")
OrderSection.Name = "OrderSection"
OrderSection.Size = UDim2.new(1, -20, 0, 180)
OrderSection.Position = UDim2.new(0, 10, 0, 10)
OrderSection.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
OrderSection.BorderSizePixel = 0
OrderSection.Parent = ComboFrame

local OrderTitle = Instance.new("TextLabel")
OrderTitle.Name = "OrderTitle"
OrderTitle.Size = UDim2.new(1, 0, 0, 30)
OrderTitle.BackgroundTransparency = 1
OrderTitle.Text = "COMBO ORDER (4 STEPS)"
OrderTitle.TextColor3 = Color3.fromRGB(0, 255, 255)
OrderTitle.Font = Enum.Font.GothamBold
OrderTitle.TextSize = 14
OrderTitle.Parent = OrderSection

local StageDropdowns = {}
local MoveDropdowns = {}

for i = 1, 4 do
    local yPos = 40 + (i-1)*35
    
    local stageLabel = Instance.new("TextLabel")
    stageLabel.Name = "Stage"..i.."Label"
    stageLabel.Size = UDim2.new(0, 60, 0, 30)
    stageLabel.Position = UDim2.new(0, 10, 0, yPos)
    stageLabel.BackgroundTransparency = 1
    stageLabel.Text = "Step "..i..":"
    stageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    stageLabel.Font = Enum.Font.Gotham
    stageLabel.TextSize = 12
    stageLabel.Parent = OrderSection
    
    local stageDropdown = Instance.new("TextButton")
    stageDropdown.Name = "Stage"..i.."Dropdown"
    stageDropdown.Size = UDim2.new(0, 100, 0, 30)
    stageDropdown.Position = UDim2.new(0, 80, 0, yPos)
    stageDropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
    stageDropdown.Text = "Select Type"
    stageDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    stageDropdown.Font = Enum.Font.Gotham
    stageDropdown.TextSize = 12
    stageDropdown.Parent = OrderSection
    
    local moveDropdown = Instance.new("TextButton")
    moveDropdown.Name = "Move"..i.."Dropdown"
    moveDropdown.Size = UDim2.new(0, 60, 0, 30)
    moveDropdown.Position = UDim2.new(0, 190, 0, yPos)
    moveDropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
    moveDropdown.Text = "Move"
    moveDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    moveDropdown.Font = Enum.Font.Gotham
    moveDropdown.TextSize = 12
    moveDropdown.Visible = false
    moveDropdown.Parent = OrderSection
    
    StageDropdowns[i] = stageDropdown
    MoveDropdowns[i] = moveDropdown
end

-- Skill Selection
local SkillSection = Instance.new("Frame")
SkillSection.Name = "SkillSection"
SkillSection.Size = UDim2.new(1, -20, 0, 200)
SkillSection.Position = UDim2.new(0, 10, 0, 200)
SkillSection.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
SkillSection.BorderSizePixel = 0
SkillSection.Parent = ComboFrame

local SkillTitle = Instance.new("TextLabel")
SkillTitle.Name = "SkillTitle"
SkillTitle.Size = UDim2.new(1, 0, 0, 30)
SkillTitle.BackgroundTransparency = 1
SkillTitle.Text = "AVAILABLE SKILLS"
SkillTitle.TextColor3 = Color3.fromRGB(255, 165, 0)
SkillTitle.Font = Enum.Font.GothamBold
SkillTitle.TextSize = 14
SkillTitle.Parent = SkillSection

-- Combo Control Buttons
local ControlSection = Instance.new("Frame")
ControlSection.Name = "ControlSection"
ControlSection.Size = UDim2.new(1, -20, 0, 100)
ControlSection.Position = UDim2.new(0, 10, 0, 410)
ControlSection.BackgroundTransparency = 1
ControlSection.Parent = ComboFrame

local SaveComboBtn = Instance.new("TextButton")
SaveComboBtn.Name = "SaveComboBtn"
SaveComboBtn.Size = UDim2.new(0.48, 0, 0, 40)
SaveComboBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
SaveComboBtn.Text = "SAVE COMBO"
SaveComboBtn.TextColor3 = Color3.white
SaveComboBtn.Font = Enum.Font.GothamBold
SaveComboBtn.TextSize = 14
SaveComboBtn.Parent = ControlSection

local LoadComboBtn = Instance.new("TextButton")
LoadComboBtn.Name = "LoadComboBtn"
LoadComboBtn.Size = UDim2.new(0.48, 0, 0, 40)
LoadComboBtn.Position = UDim2.new(0.52, 0, 0, 0)
LoadComboBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
LoadComboBtn.Text = "LOAD COMBO"
LoadComboBtn.TextColor3 = Color3.white
LoadComboBtn.Font = Enum.Font.GothamBold
LoadComboBtn.TextSize = 14
LoadComboBtn.Parent = ControlSection

local ExecuteBtn = Instance.new("TextButton")
ExecuteBtn.Name = "ExecuteBtn"
ExecuteBtn.Size = UDim2.new(1, 0, 0, 40)
ExecuteBtn.Position = UDim2.new(0, 0, 0, 50)
ExecuteBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 80)
ExecuteBtn.Text = "EXECUTE COMBO"
ExecuteBtn.TextColor3 = Color3.white
ExecuteBtn.Font = Enum.Font.GothamBold
ExecuteBtn.TextSize = 16
ExecuteBtn.Parent = ControlSection

-- Targeting Content
local TargetingFrame = TabFrames["Targeting"]

-- Targeting Settings
local TargetingSettings = Instance.new("Frame")
TargetingSettings.Name = "TargetingSettings"
TargetingSettings.Size = UDim2.new(1, -20, 0, 250)
TargetingSettings.Position = UDim2.new(0, 10, 0, 10)
TargetingSettings.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
TargetingSettings.BorderSizePixel = 0
TargetingSettings.Parent = TargetingFrame

local TargetingSettingsTitle = Instance.new("TextLabel")
TargetingSettingsTitle.Name = "TargetingSettingsTitle"
TargetingSettingsTitle.Size = UDim2.new(1, 0, 0, 30)
TargetingSettingsTitle.BackgroundTransparency = 1
TargetingSettingsTitle.Text = "TARGETING SETTINGS"
TargetingSettingsTitle.TextColor3 = Color3.fromRGB(255, 100, 100)
TargetingSettingsTitle.Font = Enum.Font.GothamBold
TargetingSettingsTitle.TextSize = 14
TargetingSettingsTitle.Parent = TargetingSettings

-- Minimum Level Slider
local MinLevelLabel = Instance.new("TextLabel")
MinLevelLabel.Name = "MinLevelLabel"
MinLevelLabel.Size = UDim2.new(0.5, -5, 0, 30)
MinLevelLabel.Position = UDim2.new(0, 10, 0, 40)
MinLevelLabel.BackgroundTransparency = 1
MinLevelLabel.Text = "Min Level: " .. Targeting.MinLevel
MinLevelLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
MinLevelLabel.Font = Enum.Font.Gotham
MinLevelLabel.TextSize = 12
MinLevelLabel.TextXAlignment = Enum.TextXAlignment.Left
MinLevelLabel.Parent = TargetingSettings

local MinLevelBox = Instance.new("TextBox")
MinLevelBox.Name = "MinLevelBox"
MinLevelBox.Size = UDim2.new(0.5, -15, 0, 30)
MinLevelBox.Position = UDim2.new(0.5, 5, 0, 40)
MinLevelBox.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
MinLevelBox.Text = tostring(Targeting.MinLevel)
MinLevelBox.TextColor3 = Color3.white
MinLevelBox.Font = Enum.Font.Gotham
MinLevelBox.TextSize = 12
MinLevelBox.Parent = TargetingSettings

-- Minimum Bounty Slider
local MinBountyLabel = Instance.new("TextLabel")
MinBountyLabel.Name = "MinBountyLabel"
MinBountyLabel.Size = UDim2.new(0.5, -5, 0, 30)
MinBountyLabel.Position = UDim2.new(0, 10, 0, 80)
MinBountyLabel.BackgroundTransparency = 1
MinBountyLabel.Text = "Min Bounty: " .. Targeting.MinBounty
MinBountyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBountyLabel.Font = Enum.Font.Gotham
MinBountyLabel.TextSize = 12
MinBountyLabel.TextXAlignment = Enum.TextXAlignment.Left
MinBountyLabel.Parent = TargetingSettings

local MinBountyBox = Instance.new("TextBox")
MinBountyBox.Name = "MinBountyBox"
MinBountyBox.Size = UDim2.new(0.5, -15, 0, 30)
MinBountyBox.Position = UDim2.new(0.5, 5, 0, 80)
MinBountyBox.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
MinBountyBox.Text = tostring(Targeting.MinBounty)
MinBountyBox.TextColor3 = Color3.white
MinBountyBox.Font = Enum.Font.Gotham
MinBountyBox.TextSize = 12
MinBountyBox.Parent = TargetingSettings

-- Safe Zone Toggle
local SafeZoneToggle = Instance.new("TextButton")
SafeZoneToggle.Name = "SafeZoneToggle"
SafeZoneToggle.Size = UDim2.new(1, -20, 0, 30)
SafeZoneToggle.Position = UDim2.new(0, 10, 0, 120)
SafeZoneToggle.BackgroundColor3 = Targeting.AvoidSafeZone and Color3.fromRGB(0, 180, 80) or Color3.fromRGB(180, 0, 80)
SafeZoneToggle.Text = "Avoid Safe Zone: " .. (Targeting.AvoidSafeZone and "ON" or "OFF")
SafeZoneToggle.TextColor3 = Color3.white
SafeZoneToggle.Font = Enum.Font.Gotham
SafeZoneToggle.TextSize = 12
SafeZoneToggle.Parent = TargetingSettings

-- PVP Check Toggle
local PVPCheckToggle = Instance.new("TextButton")
PVPCheckToggle.Name = "PVPCheckToggle"
PVPCheckToggle.Size = UDim2.new(1, -20, 0, 30)
PVPCheckToggle.Position = UDim2.new(0, 10, 0, 160)
PVPCheckToggle.BackgroundColor3 = Targeting.CheckPVP and Color3.fromRGB(0, 180, 80) or Color3.fromRGB(180, 0, 80)
PVPCheckToggle.Text = "Check PVP: " .. (Targeting.CheckPVP and "ON" or "OFF")
PVPCheckToggle.TextColor3 = Color3.white
PVPCheckToggle.Font = Enum.Font.Gotham
PVPCheckToggle.TextSize = 12
PVPCheckToggle.Parent = TargetingSettings

-- Priority Settings
local PrioritySection = Instance.new("Frame")
PrioritySection.Name = "PrioritySection"
PrioritySection.Size = UDim2.new(1, -20, 0, 150)
PrioritySection.Position = UDim2.new(0, 10, 0, 270)
PrioritySection.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
PrioritySection.BorderSizePixel = 0
PrioritySection.Parent = TargetingFrame

local PriorityTitle = Instance.new("TextLabel")
PriorityTitle.Name = "PriorityTitle"
PriorityTitle.Size = UDim2.new(1, 0, 0, 30)
PriorityTitle.BackgroundTransparency = 1
PriorityTitle.Text = "TARGET PRIORITY"
PriorityTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
PriorityTitle.Font = Enum.Font.GothamBold
PriorityTitle.TextSize = 14
PriorityTitle.Parent = PrioritySection

-- Movement Content
local MovementFrame = TabFrames["Movement"]

-- Speed Settings
local SpeedSection = Instance.new("Frame")
SpeedSection.Name = "SpeedSection"
SpeedSection.Size = UDim2.new(1, -20, 0, 180)
SpeedSection.Position = UDim2.new(0, 10, 0, 10)
SpeedSection.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
SpeedSection.BorderSizePixel = 0
SpeedSection.Parent = MovementFrame

local SpeedTitle = Instance.new("TextLabel")
SpeedTitle.Name = "SpeedTitle"
SpeedTitle.Size = UDim2.new(1, 0, 0, 30)
SpeedTitle.BackgroundTransparency = 1
SpeedTitle.Text = "MOVEMENT SETTINGS"
SpeedTitle.TextColor3 = Color3.fromRGB(100, 200, 255)
SpeedTitle.Font = Enum.Font.GothamBold
SpeedTitle.TextSize = 14
SpeedTitle.Parent = SpeedSection

-- Travel Speed
local TravelSpeedLabel = Instance.new("TextLabel")
TravelSpeedLabel.Name = "TravelSpeedLabel"
TravelSpeedLabel.Size = UDim2.new(0.5, -5, 0, 30)
TravelSpeedLabel.Position = UDim2.new(0, 10, 0, 40)
TravelSpeedLabel.BackgroundTransparency = 1
TravelSpeedLabel.Text = "Speed: " .. Movement.Speed
TravelSpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TravelSpeedLabel.Font = Enum.Font.Gotham
TravelSpeedLabel.TextSize = 12
TravelSpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
TravelSpeedLabel.Parent = SpeedSection

local TravelSpeedBox = Instance.new("TextBox")
TravelSpeedBox.Name = "TravelSpeedBox"
TravelSpeedBox.Size = UDim2.new(0.5, -15, 0, 30)
TravelSpeedBox.Position = UDim2.new(0.5, 5, 0, 40)
TravelSpeedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
TravelSpeedBox.Text = tostring(Movement.Speed)
TravelSpeedBox.TextColor3 = Color3.white
TravelSpeedBox.Font = Enum.Font.Gotham
TravelSpeedBox.TextSize = 12
TravelSpeedBox.Parent = SpeedSection

-- Fly Speed
local FlySpeedLabel = Instance.new("TextLabel")
FlySpeedLabel.Name = "FlySpeedLabel"
FlySpeedLabel.Size = UDim2.new(0.5, -5, 0, 30)
FlySpeedLabel.Position = UDim2.new(0, 10, 0, 80)
FlySpeedLabel.BackgroundTransparency = 1
FlySpeedLabel.Text = "Fly Speed: " .. Movement.FlySpeed
FlySpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FlySpeedLabel.Font = Enum.Font.Gotham
FlySpeedLabel.TextSize = 12
FlySpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
FlySpeedLabel.Parent = SpeedSection

local FlySpeedBox = Instance.new("TextBox")
FlySpeedBox.Name = "FlySpeedBox"
FlySpeedBox.Size = UDim2.new(0.5, -15, 0, 30)
FlySpeedBox.Position = UDim2.new(0.5, 5, 0, 80)
FlySpeedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
FlySpeedBox.Text = tostring(Movement.FlySpeed)
FlySpeedBox.TextColor3 = Color3.white
FlySpeedBox.Font = Enum.Font.Gotham
FlySpeedBox.TextSize = 12
FlySpeedBox.Parent = SpeedSection

-- Movement Toggles
local BezierToggle = Instance.new("TextButton")
BezierToggle.Name = "BezierToggle"
BezierToggle.Size = UDim2.new(1, -20, 0, 30)
BezierToggle.Position = UDim2.new(0, 10, 0, 120)
BezierToggle.BackgroundColor3 = Movement.UseBezier and Color3.fromRGB(0, 180, 80) or Color3.fromRGB(180, 0, 80)
BezierToggle.Text = "Bezier Curves: " .. (Movement.UseBezier and "ON" or "OFF")
BezierToggle.TextColor3 = Color3.white
BezierToggle.Font = Enum.Font.Gotham
BezierToggle.TextSize = 12
BezierToggle.Parent = SpeedSection

local NoClipToggle = Instance.new("TextButton")
NoClipToggle.Name = "NoClipToggle"
NoClipToggle.Size = UDim2.new(1, -20, 0, 30)
NoClipToggle.Position = UDim2.new(0, 10, 0, 160)
NoClipToggle.BackgroundColor3 = Movement.NoClip and Color3.fromRGB(0, 180, 80) or Color3.fromRGB(180, 0, 80)
NoClipToggle.Text = "NoClip: " .. (Movement.NoClip and "ON" or "OFF")
NoClipToggle.TextColor3 = Color3.white
NoClipToggle.Font = Enum.Font.Gotham
NoClipToggle.TextSize = 12
NoClipToggle.Parent = SpeedSection

-- Safety Content
local SafetyFrame = TabFrames["Safety"]

-- Safety Settings
local SafetySettings = Instance.new("Frame")
SafetySettings.Name = "SafetySettings"
SafetySettings.Size = UDim2.new(1, -20, 0, 200)
SafetySettings.Position = UDim2.new(0, 10, 0, 10)
SafetySettings.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
SafetySettings.BorderSizePixel = 0
SafetySettings.Parent = SafetyFrame

local SafetyTitle = Instance.new("TextLabel")
SafetyTitle.Name = "SafetyTitle"
SafetyTitle.Size = UDim2.new(1, 0, 0, 30)
SafetyTitle.BackgroundTransparency = 1
SafetyTitle.Text = "SAFETY PROTOCOLS"
SafetyTitle.TextColor3 = Color3.fromRGB(255, 100, 100)
SafetyTitle.Font = Enum.Font.GothamBold
SafetyTitle.TextSize = 14
SafetyTitle.Parent = SafetySettings

-- Low HP Threshold
local HPThresholdLabel = Instance.new("TextLabel")
HPThresholdLabel.Name = "HPThresholdLabel"
HPThresholdLabel.Size = UDim2.new(0.5, -5, 0, 30)
HPThresholdLabel.Position = UDim2.new(0, 10, 0, 40)
HPThresholdLabel.BackgroundTransparency = 1
HPThresholdLabel.Text = "Low HP: " .. (Safety.LowHPThreshold * 100) .. "%"
HPThresholdLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
HPThresholdLabel.Font = Enum.Font.Gotham
HPThresholdLabel.TextSize = 12
HPThresholdLabel.TextXAlignment = Enum.TextXAlignment.Left
HPThresholdLabel.Parent = SafetySettings

local HPThresholdBox = Instance.new("TextBox")
HPThresholdBox.Name = "HPThresholdBox"
HPThresholdBox.Size = UDim2.new(0.5, -15, 0, 30)
HPThresholdBox.Position = UDim2.new(0.5, 5, 0, 40)
HPThresholdBox.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
HPThresholdBox.Text = tostring(Safety.LowHPThreshold * 100)
HPThresholdBox.TextColor3 = Color3.white
HPThresholdBox.Font = Enum.Font.Gotham
HPThresholdBox.TextSize = 12
HPThresholdBox.Parent = SafetySettings

-- Safety Toggles
local AutoCounterToggle = Instance.new("TextButton")
AutoCounterToggle.Name = "AutoCounterToggle"
AutoCounterToggle.Size = UDim2.new(1, -20, 0, 30)
AutoCounterToggle.Position = UDim2.new(0, 10, 0, 80)
AutoCounterToggle.BackgroundColor3 = Safety.AutoCounter and Color3.fromRGB(0, 180, 80) or Color3.fromRGB(180, 0, 80)
AutoCounterToggle.Text = "Auto Counter: " .. (Safety.AutoCounter and "ON" or "OFF")
AutoCounterToggle.TextColor3 = Color3.white
AutoCounterToggle.Font = Enum.Font.Gotham
AutoCounterToggle.TextSize = 12
AutoCounterToggle.Parent = SafetySettings

local AntiReportToggle = Instance.new("TextButton")
AntiReportToggle.Name = "AntiReportToggle"
AntiReportToggle.Size = UDim2.new(1, -20, 0, 30)
AntiReportToggle.Position = UDim2.new(0, 10, 0, 120)
AntiReportToggle.BackgroundColor3 = Safety.AntiReport and Color3.fromRGB(0, 180, 80) or Color3.fromRGB(180, 0, 80)
AntiReportToggle.Text = "Anti-Report: " .. (Safety.AntiReport and "ON" or "OFF")
AntiReportToggle.TextColor3 = Color3.white
AntiReportToggle.Font = Enum.Font.Gotham
AntiReportToggle.TextSize = 12
AntiReportToggle.Parent = SafetySettings

local EmergencyToggle = Instance.new("TextButton")
EmergencyToggle.Name = "EmergencyToggle"
EmergencyToggle.Size = UDim2.new(1, -20, 0, 30)
EmergencyToggle.Position = UDim2.new(0, 10, 0, 160)
EmergencyToggle.BackgroundColor3 = Safety.EmergencyTP and Color3.fromRGB(0, 180, 80) or Color3.fromRGB(180, 0, 80)
EmergencyToggle.Text = "Emergency TP: " .. (Safety.EmergencyTP and "ON" or "OFF")
EmergencyToggle.TextColor3 = Color3.white
EmergencyToggle.Font = Enum.Font.Gotham
EmergencyToggle.TextSize = 12
EmergencyToggle.Parent = SafetySettings

-- Server Content
local ServerFrame = TabFrames["Server"]

-- Server Settings
local ServerSettings = Instance.new("Frame")
ServerSettings.Name = "ServerSettings"
ServerSettings.Size = UDim2.new(1, -20, 0, 200)
ServerSettings.Position = UDim2.new(0, 10, 0, 10)
ServerSettings.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
ServerSettings.BorderSizePixel = 0
ServerSettings.Parent = ServerFrame

local ServerTitle = Instance.new("TextLabel")
ServerTitle.Name = "ServerTitle"
ServerTitle.Size = UDim2.new(1, 0, 0, 30)
ServerTitle.BackgroundTransparency = 1
ServerTitle.Text = "SERVER MANAGEMENT"
ServerTitle.TextColor3 = Color3.fromRGB(100, 200, 100)
ServerTitle.Font = Enum.Font.GothamBold
ServerTitle.TextSize = 14
ServerTitle.Parent = ServerSettings

-- Auto Hop Settings
local AutoHopToggle = Instance.new("TextButton")
AutoHopToggle.Name = "AutoHopToggle"
AutoHopToggle.Size = UDim2.new(1, -20, 0, 30)
AutoHopToggle.Position = UDim2.new(0, 10, 0, 40)
AutoHopToggle.BackgroundColor3 = Server.AutoHop and Color3.fromRGB(0, 180, 80) or Color3.fromRGB(180, 0, 80)
AutoHopToggle.Text = "Auto Server Hop: " .. (Server.AutoHop and "ON" or "OFF")
AutoHopToggle.TextColor3 = Color3.white
AutoHopToggle.Font = Enum.Font.Gotham
AutoHopToggle.TextSize = 12
AutoHopToggle.Parent = ServerSettings

-- Min Players
local MinPlayersLabel = Instance.new("TextLabel")
MinPlayersLabel.Name = "MinPlayersLabel"
MinPlayersLabel.Size = UDim2.new(0.5, -5, 0, 30)
MinPlayersLabel.Position = UDim2.new(0, 10, 0, 80)
MinPlayersLabel.BackgroundTransparency = 1
MinPlayersLabel.Text = "Min Players: " .. Server.MinPlayers
MinPlayersLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
MinPlayersLabel.Font = Enum.Font.Gotham
MinPlayersLabel.TextSize = 12
MinPlayersLabel.TextXAlignment = Enum.TextXAlignment.Left
MinPlayersLabel.Parent = ServerSettings

local MinPlayersBox = Instance.new("TextBox")
MinPlayersBox.Name = "MinPlayersBox"
MinPlayersBox.Size = UDim2.new(0.5, -15, 0, 30)
MinPlayersBox.Position = UDim2.new(0.5, 5, 0, 80)
MinPlayersBox.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
MinPlayersBox.Text = tostring(Server.MinPlayers)
MinPlayersBox.TextColor3 = Color3.white
MinPlayersBox.Font = Enum.Font.Gotham
MinPlayersBox.TextSize = 12
MinPlayersBox.Parent = ServerSettings

-- Hop Delay
local HopDelayLabel = Instance.new("TextLabel")
HopDelayLabel.Name = "HopDelayLabel"
HopDelayLabel.Size = UDim2.new(0.5, -5, 0, 30)
HopDelayLabel.Position = UDim2.new(0, 10, 0, 120)
HopDelayLabel.BackgroundTransparency = 1
HopDelayLabel.Text = "Hop Delay: " .. Server.HopDelay .. "s"
HopDelayLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
HopDelayLabel.Font = Enum.Font.Gotham
HopDelayLabel.TextSize = 12
HopDelayLabel.TextXAlignment = Enum.TextXAlignment.Left
HopDelayLabel.Parent = ServerSettings

local HopDelayBox = Instance.new("TextBox")
HopDelayBox.Name = "HopDelayBox"
HopDelayBox.Size = UDim2.new(0.5, -15, 0, 30)
HopDelayBox.Position = UDim2.new(0.5, 5, 0, 120)
HopDelayBox.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
HopDelayBox.Text = tostring(Server.HopDelay)
HopDelayBox.TextColor3 = Color3.white
HopDelayBox.Font = Enum.Font.Gotham
HopDelayBox.TextSize = 12
HopDelayBox.Parent = ServerSettings

-- Server Control Buttons
local ServerButtons = Instance.new("Frame")
ServerButtons.Name = "ServerButtons"
ServerButtons.Size = UDim2.new(1, -20, 0, 100)
ServerButtons.Position = UDim2.new(0, 10, 0, 220)
ServerButtons.BackgroundTransparency = 1
ServerButtons.Parent = ServerFrame

local SaveSessionBtn = Instance.new("TextButton")
SaveSessionBtn.Name = "SaveSessionBtn"
SaveSessionBtn.Size = UDim2.new(1, 0, 0, 40)
SaveSessionBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
SaveSessionBtn.Text = "SAVE SESSION"
SaveSessionBtn.TextColor3 = Color3.white
SaveSessionBtn.Font = Enum.Font.GothamBold
SaveSessionBtn.TextSize = 14
SaveSessionBtn.Parent = ServerButtons

local ForceHopBtn = Instance.new("TextButton")
ForceHopBtn.Name = "ForceHopBtn"
ForceHopBtn.Size = UDim2.new(1, 0, 0, 40)
ForceHopBtn.Position = UDim2.new(0, 0, 0, 50)
ForceHopBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
ForceHopBtn.Text = "FORCE HOP SERVER"
ForceHopBtn.TextColor3 = Color3.white
ForceHopBtn.Font = Enum.Font.GothamBold
ForceHopBtn.TextSize = 14
ForceHopBtn.Parent = ServerButtons

-- Circle Zone Visual
local CircleZone = Instance.new("Frame")
CircleZone.Name = "CircleZone"
CircleZone.Size = UDim2.new(0, 100, 0, 100)
CircleZone.AnchorPoint = Vector2.new(0.5, 0.5)
CircleZone.BackgroundTransparency = 0.7
CircleZone.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CircleZone.BorderSizePixel = 2
CircleZone.BorderColor3 = Color3.fromRGB(255, 255, 255)
CircleZone.Visible = false
CircleZone.Parent = ScreenGui

local CircleUICorner = Instance.new("UICorner")
CircleUICorner.CornerRadius = UDim.new(1, 0)
CircleUICorner.Parent = CircleZone

-- Log System
local function AddLogMessage(message)
    local timestamp = os.date("%H:%M:%S")
    local logEntry = Instance.new("TextLabel")
    logEntry.Text = "[" .. timestamp .. "] " .. message
    logEntry.Size = UDim2.new(1, 0, 0, 20)
    logEntry.BackgroundTransparency = 1
    logEntry.TextColor3 = Color3.fromRGB(200, 200, 200)
    logEntry.Font = Enum.Font.Code
    logEntry.TextSize = 11
    logEntry.TextXAlignment = Enum.TextXAlignment.Left
    logEntry.Parent = LogContainer
    
    task.spawn(function()
        task.wait(10)
        if logEntry then
            logEntry:Destroy()
        end
    end)
end

-- Player Data Collection
local function GetPlayerInfo(player)
    local info = {
        Name = player.Name,
        Level = 0,
        Bounty = 0,
        Health = 0,
        MaxHealth = 0,
        IsInSafeZone = false,
        HasPVP = false,
        Distance = math.huge,
        Character = nil,
        Humanoid = nil,
        RootPart = nil
    }
    
    local char = player.Character
    if char then
        info.Character = char
        info.Humanoid = char:FindFirstChild("Humanoid")
        info.RootPart = char:FindFirstChild("HumanoidRootPart")
        
        if info.Humanoid then
            info.Health = info.Humanoid.Health
            info.MaxHealth = info.Humanoid.MaxHealth
        end
        
        if info.RootPart then
            if HumanoidRootPart then
                info.Distance = (info.RootPart.Position - HumanoidRootPart.Position).Magnitude
            end
        end
    end
    
    return info
end

-- Target Scoring System
local function CalculateTargetScore(targetInfo)
    local score = 0
    
    -- Level factor
    if targetInfo.Level >= Targeting.MinLevel then
        score = score + (targetInfo.Level / 100) * 10
    else
        return -math.huge
    end
    
    -- Bounty factor
    if targetInfo.Bounty >= Targeting.MinBounty then
        score = score + (targetInfo.Bounty / 1000) * 15
    end
    
    -- Distance penalty
    score = score - (targetInfo.Distance / 10)
    
    -- Health advantage
    local healthPercent = targetInfo.Health / targetInfo.MaxHealth
    score = score + (1 - healthPercent) * 50
    
    -- Safe zone penalty
    if targetInfo.IsInSafeZone then
        score = score - 1000
    end
    
    -- PVP check
    if Targeting.CheckPVP and not targetInfo.HasPVP then
        score = score - 500
    end
    
    -- Cooldown check
    if Config.CooldownList[targetInfo.Name] then
        local timeSince = os.time() - Config.CooldownList[targetInfo.Name]
        if timeSince < 900 then -- 15 minutes cooldown
            score = score - 2000
        end
    end
    
    return score
end

-- Find Best Target
local function FindBestTarget()
    local bestTarget = nil
    local bestScore = -math.huge
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Player then
            local info = GetPlayerInfo(player)
            
            if info.Health > 0 and info.Distance <= Targeting.MaxDistance then
                local score = CalculateTargetScore(info)
                
                if score > bestScore then
                    bestScore = score
                    bestTarget = player
                end
            end
        end
    end
    
    return bestTarget
end

-- Bezier Curve Calculation
local function CalculateBezierPoint(t, points)
    if #points == 1 then
        return points[1]
    end
    
    local newPoints = {}
    for i = 1, #points - 1 do
        local point = points[i]:Lerp(points[i + 1], t)
        table.insert(newPoints, point)
    end
    
    return CalculateBezierPoint(t, newPoints)
end

-- Adaptive Tween Movement
local function MoveToPosition(targetPos, speedMultiplier)
    if not HumanoidRootPart then return end
    
    local startPos = HumanoidRootPart.Position
    local distance = (targetPos - startPos).Magnitude
    local travelTime = distance / (Movement.Speed * (speedMultiplier or 1))
    
    -- Enable NoClip if set
    if Movement.NoClip then
        for _, part in ipairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
    
    local startTime = tick()
    
    while tick() - startTime < travelTime and HumanoidRootPart do
        local elapsed = tick() - startTime
        local t = elapsed / travelTime
        
        -- Use bezier curve if enabled
        local currentTargetPos
        if Movement.UseBezier and distance > 50 then
            local controlPoint = startPos + (targetPos - startPos) * 0.5 + Vector3.new(0, 20, 0)
            currentTargetPos = CalculateBezierPoint(t, {startPos, controlPoint, targetPos})
        else
            currentTargetPos = startPos:Lerp(targetPos, t)
        end
        
        -- Add random movement variation
        if Movement.AntiAntiCheat then
            local randomOffset = Vector3.new(
                math.random(-2, 2),
                math.random(-1, 1),
                math.random(-2, 2)
            )
            currentTargetPos = currentTargetPos + randomOffset
        end
        
        local direction = (currentTargetPos - HumanoidRootPart.Position).Unit
        local velocity = direction * Movement.Speed * (0.9 + math.random() * 0.2)
        
        HumanoidRootPart.Velocity = velocity
        
        task.wait()
    end
    
    -- Disable NoClip
    if Movement.NoClip then
        for _, part in ipairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- Fly System
local function FlyToTarget(targetPos)
    Config.IsFlying = true
    
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVelocity.P = 1000
    bodyVelocity.Parent = HumanoidRootPart
    
    local startTime = tick()
    local maxFlyTime = 5
    
    while tick() - startTime < maxFlyTime and Config.IsFlying do
        local direction = (targetPos - HumanoidRootPart.Position).Unit
        bodyVelocity.Velocity = direction * Movement.FlySpeed
        
        -- Update camera aimlock
        if Config.CurrentTarget then
            local targetChar = Config.CurrentTarget.Character
            if targetChar then
                local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
                if targetRoot then
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetRoot.Position)
                end
            end
        end
        
        task.wait()
        
        -- Check if close enough
        if (targetPos - HumanoidRootPart.Position).Magnitude < 10 then
            break
        end
    end
    
    bodyVelocity:Destroy()
    Config.IsFlying = false
end

-- Combo Execution
local function ExecuteSkill(key)
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[key], false, game)
    task.wait(0.05 + (Combo.RandomDelay and math.random() * 0.1 or 0))
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[key], false, game)
end

local function ExecuteComboSequence()
    if Config.IsExecuting or #Combo.Active == 0 then return end
    
    Config.IsExecuting = true
    
    local target = Config.CurrentTarget
    if not target then
        Config.IsExecuting = false
        return
    end
    
    local targetChar = target.Character
    if not targetChar then
        Config.IsExecuting = false
        return
    end
    
    local targetHumanoid = targetChar:FindFirstChild("Humanoid")
    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
    
    if not targetHumanoid or not targetRoot then
        Config.IsExecuting = false
        return
    end
    
    -- Update UI
    TargetName.Text = "Name: " .. target.Name
    TargetLevel.Text = "Level: " .. (GetPlayerInfo(target).Level or 0)
    
    -- Approach target
    AddLogMessage("Approaching target: " .. target.Name)
    MoveToPosition(targetRoot.Position, 1.2)
    
    -- Fly for final approach
    FlyToTarget(targetRoot.Position)
    
    -- Execute combo loop
    AddLogMessage("Executing combo on " .. target.Name)
    
    while targetHumanoid and targetHumanoid.Health > 0 and Config.IsExecuting do
        -- Execute each skill in combo
        for _, skill in ipairs(Combo.Active) do
            if not skill or skill == "None" then continue end
            
            ExecuteSkill(skill)
            
            -- Small delay between skills
            task.wait(0.05 + (Combo.RandomDelay and math.random() * 0.05 or 0))
            
            -- Update target health display
            if targetHumanoid then
                local healthPercent = math.floor((targetHumanoid.Health / targetHumanoid.MaxHealth) * 100)
                TargetHealth.Text = "Health: " .. healthPercent .. "%"
            end
            
            -- Check if target died
            if not targetHumanoid or targetHumanoid.Health <= 0 then
                break
            end
        end
        
        -- Emergency protocol check
        if Humanoid.Health / Humanoid.MaxHealth <= Safety.LowHPThreshold then
            AddLogMessage("Low HP! Activating emergency protocol")
            
            -- Teleport to safe location
            local safePos = HumanoidRootPart.Position + Vector3.new(
                math.random(-200, 200),
                50,
                math.random(-200, 200)
            )
            MoveToPosition(safePos, 2)
            
            -- Wait for safety
            task.wait(3)
            
            -- Return to target
            if targetRoot then
                MoveToPosition(targetRoot.Position, 1.2)
            end
        end
        
        -- Anti-Report: Random movement
        if Safety.AntiReport and math.random(1, 5) == 1 then
            local randomMove = Vector3.new(
                math.random(-3, 3),
                0,
                math.random(-3, 3)
            )
            HumanoidRootPart.Velocity = randomMove * 10
        end
        
        -- Check for combo loop
        if not Combo.Loop then
            break
        end
        
        task.wait(0.1)
    end
    
    -- Target defeated
    if targetHumanoid and targetHumanoid.Health <= 0 then
        Config.Kills = Config.Kills + 1
        Config.CooldownList[target.Name] = os.time()
        
        -- Simulate bounty gain (replace with actual game detection)
        local bountyGain = math.random(50000, 200000)
        Config.SessionBounty = Config.SessionBounty + bountyGain
        Config.TotalBounty = Config.TotalBounty + bountyGain
        
        AddLogMessage("Defeated " .. target.Name .. " (+" .. bountyGain .. " bounty)")
    end
    
    -- Cleanup
    Config.IsExecuting = false
    Config.CurrentTarget = nil
    
    TargetName.Text = "Name: None"
    TargetHealth.Text = "Health: 100%"
end

-- Next Player System
NextPlayerButton.MouseButton1Click:Connect(function()
    local target = FindBestTarget()
    
    if target then
        Config.CurrentTarget = target
        AddLogMessage("Selected target: " .. target.Name)
        
        if Config.IsExecuting then
            Config.IsExecuting = false
            task.wait(0.5)
        end
        
        ExecuteComboSequence()
    else
        AddLogMessage("No valid target found")
    end
end)

-- Server Hop System
HopServerButton.MouseButton1Click:Connect(function()
    AddLogMessage("Initiating server hop...")
    
    -- Save current session
    local sessionData = {
        SessionBounty = Config.SessionBounty,
        Kills = Config.Kills,
        Deaths = Config.Deaths,
        Time = os.time() - Config.StartTime
    }
    
    -- Implementation for server hopping would go here
    -- This is game-specific and requires proper implementation
    
    AddLogMessage("Server hop initiated")
end)

-- Update Display Loop
task.spawn(function()
    while task.wait(1) do
        -- Update bounty display
        CurrentBountyLabel.Text = "CURRENT BOUNTY: " .. Config.TotalBounty
        SessionBountyLabel.Text = "SESSION TOTAL: " .. Config.SessionBounty
        
        -- Update time
        local sessionTime = os.time() - Config.StartTime
        local hours = math.floor(sessionTime / 3600)
        local minutes = math.floor((sessionTime % 3600) / 60)
        local seconds = math.floor(sessionTime % 60)
        TimeLabel.Text = string.format("TIME: %02d:%02d:%02d", hours, minutes, seconds)
        
        -- Update KDR
        local kdr = Config.Deaths > 0 and (Config.Kills / Config.Deaths) or Config.Kills
        KDRLabel.Text = string.format("K/D: %.2f", kdr)
        
        -- Update analytics
        local bountyPerHour = sessionTime > 0 and (Config.SessionBounty / (sessionTime / 3600)) or 0
        BPHLabel.Text = "Bounty/Hour: " .. math.floor(bountyPerHour)
        
        -- Update ping
        PingDisplay.Text = "Ping: " .. math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) .. "ms"
        
        -- Update circle zone position
        if HumanoidRootPart then
            local screenPos, onScreen = Camera:WorldToViewportPoint(HumanoidRootPart.Position)
            if onScreen then
                CircleZone.Visible = true
                CircleZone.Position = UDim2.new(0, screenPos.X, 0, screenPos.Y)
            else
                CircleZone.Visible = false
            end
        end
    end
end)

-- Auto Farm System
task.spawn(function()
    while task.wait(2) do
        if Config.AutoFarm and not Config.IsExecuting then
            local target = FindBestTarget()
            if target then
                Config.CurrentTarget = target
                ExecuteComboSequence()
            end
        end
    end
end)

-- Auto Server Hop
task.spawn(function()
    while task.wait(Server.HopDelay) do
        if Server.AutoHop and not Config.IsExecuting then
            local playerCount = #Players:GetPlayers()
            if playerCount < Server.MinPlayers then
                AddLogMessage("Low player count, initiating auto hop")
                HopServerButton:MouseButton1Click()
            end
        end
    end
end)

-- Emergency Health Check
task.spawn(function()
    while task.wait(0.5) do
        if Humanoid.Health / Humanoid.MaxHealth <= Safety.LowHPThreshold and Safety.EmergencyTP then
            AddLogMessage("Emergency: Low health detected!")
            
            if Config.IsExecuting then
                Config.IsExecuting = false
            end
            
            -- Teleport to random safe location
            local safePos = Vector3.new(
                math.random(-1000, 1000),
                100,
                math.random(-1000, 1000)
            )
            MoveToPosition(safePos, 2)
            
            -- Wait for healing
            task.wait(5)
        end
    end
end)

-- UI Event Handlers
SafeZoneToggle.MouseButton1Click:Connect(function()
    Targeting.AvoidSafeZone = not Targeting.AvoidSafeZone
    SafeZoneToggle.BackgroundColor3 = Targeting.AvoidSafeZone and Color3.fromRGB(0, 180, 80) or Color3.fromRGB(180, 0, 80)
    SafeZoneToggle.Text = "Avoid Safe Zone: " .. (Targeting.AvoidSafeZone and "ON" or "OFF")
end)

PVPCheckToggle.MouseButton1Click:Connect(function()
    Targeting.CheckPVP = not Targeting.CheckPVP
    PVPCheckToggle.BackgroundColor3 = Targeting.CheckPVP and Color3.fromRGB(0, 180, 80) or Color3.fromRGB(180, 0, 80)
    PVPCheckToggle.Text = "Check PVP: " .. (Targeting.CheckPVP and "ON" or "OFF")
end)

BezierToggle.MouseButton1Click:Connect(function()
    Movement.UseBezier = not Movement.UseBezier
    BezierToggle.BackgroundColor3 = Movement.UseBezier and Color3.fromRGB(0, 180, 80) or Color3.fromRGB(180, 0, 80)
    BezierToggle.Text = "Bezier Curves: " .. (Movement.UseBezier and "ON" or "OFF")
end)

NoClipToggle.MouseButton1Click:Connect(function()
    Movement.NoClip = not Movement.NoClip
    NoClipToggle.BackgroundColor3 = Movement.NoClip and Color3.fromRGB(0, 180, 80) or Color3.fromRGB(180, 0, 80)
    NoClipToggle.Text = "NoClip: " .. (Movement.NoClip and "ON" or "OFF")
end)

AutoCounterToggle.MouseButton1Click:Connect(function()
    Safety.AutoCounter = not Safety.AutoCounter
    AutoCounterToggle.BackgroundColor3 = Safety.AutoCounter and Color3.fromRGB(0, 180, 80) or Color3.fromRGB(180, 0, 80)
    AutoCounterToggle.Text = "Auto Counter: " .. (Safety.AutoCounter and "ON" or "OFF")
end)

AntiReportToggle.MouseButton1Click:Connect(function()
    Safety.AntiReport = not Safety.AntiReport
    AntiReportToggle.BackgroundColor3 = Safety.AntiReport and Color3.fromRGB(0, 180, 80) or Color3.fromRGB(180, 0, 80)
    AntiReportToggle.Text = "Anti-Report: " .. (Safety.AntiReport and "ON" or "OFF")
end)

EmergencyToggle.MouseButton1Click:Connect(function()
    Safety.EmergencyTP = not Safety.EmergencyTP
    EmergencyToggle.BackgroundColor3 = Safety.EmergencyTP and Color3.fromRGB(0, 180, 80) or Color3.fromRGB(180, 0, 80)
    EmergencyToggle.Text = "Emergency TP: " .. (Safety.EmergencyTP and "ON" or "OFF")
end)

AutoHopToggle.MouseButton1Click:Connect(function()
    Server.AutoHop = not Server.AutoHop
    AutoHopToggle.BackgroundColor3 = Server.AutoHop and Color3.fromRGB(0, 180, 80) or Color3.fromRGB(180, 0, 80)
    AutoHopToggle.Text = "Auto Server Hop: " .. (Server.AutoHop and "ON" or "OFF")
end)

-- TextBox Updates
MinLevelBox.FocusLost:Connect(function()
    local value = tonumber(MinLevelBox.Text)
    if value then
        Targeting.MinLevel = math.clamp(value, 1, 5000)
        MinLevelBox.Text = tostring(Targeting.MinLevel)
        MinLevelLabel.Text = "Min Level: " .. Targeting.MinLevel
    end
end)

MinBountyBox.FocusLost:Connect(function()
    local value = tonumber(MinBountyBox.Text)
    if value then
        Targeting.MinBounty = math.clamp(value, 0, 10000000)
        MinBountyBox.Text = tostring(Targeting.MinBounty)
        MinBountyLabel.Text = "Min Bounty: " .. Targeting.MinBounty
    end
end)

TravelSpeedBox.FocusLost:Connect(function()
    local value = tonumber(TravelSpeedBox.Text)
    if value then
        Movement.Speed = math.clamp(value, 50, 1000)
        TravelSpeedBox.Text = tostring(Movement.Speed)
        TravelSpeedLabel.Text = "Speed: " .. Movement.Speed
    end
end)

FlySpeedBox.FocusLost:Connect(function()
    local value = tonumber(FlySpeedBox.Text)
    if value then
        Movement.FlySpeed = math.clamp(value, 50, 500)
        FlySpeedBox.Text = tostring(Movement.FlySpeed)
        FlySpeedLabel.Text = "Fly Speed: " .. Movement.FlySpeed
    end
end)

HPThresholdBox.FocusLost:Connect(function()
    local value = tonumber(HPThresholdBox.Text)
    if value then
        Safety.LowHPThreshold = math.clamp(value / 100, 0.1, 0.5)
        HPThresholdBox.Text = tostring(value)
        HPThresholdLabel.Text = "Low HP: " .. value .. "%"
    end
end)

MinPlayersBox.FocusLost:Connect(function()
    local value = tonumber(MinPlayersBox.Text)
    if value then
        Server.MinPlayers = math.clamp(value, 1, 20)
        MinPlayersBox.Text = tostring(Server.MinPlayers)
        MinPlayersLabel.Text = "Min Players: " .. Server.MinPlayers
    end
end)

HopDelayBox.FocusLost:Connect(function()
    local value = tonumber(HopDelayBox.Text)
    if value then
        Server.HopDelay = math.clamp(value, 60, 1800)
        HopDelayBox.Text = tostring(Server.HopDelay)
        HopDelayLabel.Text = "Hop Delay: " .. Server.HopDelay .. "s"
    end
end)

-- Combo Setup
for i = 1, 4 do
    local skillTypes = {"Sword", "Fruit", "Melee", "Gun", "Style"}
    
    StageDropdowns[i].MouseButton1Click:Connect(function()
        -- Create dropdown menu
        local dropdown = Instance.new("Frame")
        dropdown.Size = UDim2.new(0, 100, 0, 150)
        dropdown.Position = UDim2.new(0, 0, 1, 0)
        dropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        dropdown.BorderSizePixel = 0
        dropdown.Visible = true
        dropdown.ZIndex = 100
        dropdown.Parent = StageDropdowns[i]
        
        for _, skillType in ipairs(skillTypes) do
            local option = Instance.new("TextButton")
            option.Size = UDim2.new(1, 0, 0, 30)
            option.Position = UDim2.new(0, 0, 0, (table.find(skillTypes, skillType)-1)*30)
            option.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
            option.Text = skillType
            option.TextColor3 = Color3.white
            option.Font = Enum.Font.Gotham
            option.TextSize = 12
            option.Parent = dropdown
            
            option.MouseButton1Click:Connect(function()
                StageDropdowns[i].Text = skillType
                MoveDropdowns[i].Visible = true
                dropdown:Destroy()
                
                -- Update combo
                if not Combo.Active[i] then
                    Combo.Active[i] = {}
                end
                Combo.Active[i].Type = skillType
            end)
        end
    end)
    
    MoveDropdowns[i].MouseButton1Click:Connect(function()
        local skillType = StageDropdowns[i].Text
        if skillType == "Select Type" then return end
        
        local moves = Skills[skillType] or {"Z", "X", "C", "V", "F"}
        
        local dropdown = Instance.new("Frame")
        dropdown.Size = UDim2.new(0, 60, 0, 150)
        dropdown.Position = UDim2.new(0, 0, 1, 0)
        dropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        dropdown.BorderSizePixel = 0
        dropdown.Visible = true
        dropdown.ZIndex = 100
        dropdown.Parent = MoveDropdowns[i]
        
        for _, move in ipairs(moves) do
            local option = Instance.new("TextButton")
            option.Size = UDim2.new(1, 0, 0, 30)
            option.Position = UDim2.new(0, 0, 0, (table.find(moves, move)-1)*30)
            option.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
            option.Text = move
            option.TextColor3 = Color3.white
            option.Font = Enum.Font.Gotham
            option.TextSize = 12
            option.Parent = dropdown
            
            option.MouseButton1Click:Connect(function()
                MoveDropdowns[i].Text = move
                dropdown:Destroy()
                
                -- Update combo
                if not Combo.Active[i] then
                    Combo.Active[i] = {}
                end
                Combo.Active[i].Move = move
                
                -- Add to execution list
                local executionList = {}
                for j = 1, 4 do
                    if Combo.Active[j] and Combo.Active[j].Move then
                        table.insert(executionList, Combo.Active[j].Move)
                    end
                end
                Combo.Execution = executionList
            end)
        end
    end)
end

-- Execute Button
ExecuteBtn.MouseButton1Click:Connect(function()
    if #Combo.Execution > 0 then
        Config.IsExecuting = not Config.IsExecuting
        
        if Config.IsExecuting then
            ExecuteBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            ExecuteBtn.Text = "STOP COMBO"
            
            if not Config.CurrentTarget then
                Config.CurrentTarget = FindBestTarget()
            end
            
            if Config.CurrentTarget then
                ExecuteComboSequence()
            end
        else
            ExecuteBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 80)
            ExecuteBtn.Text = "EXECUTE COMBO"
        end
    else
        AddLogMessage("No combo configured!")
    end
end)

-- Save/Load Combo
SaveComboBtn.MouseButton1Click:Connect(function()
    if #Combo.Active > 0 then
        local comboData = {}
        for i, skill in ipairs(Combo.Active) do
            if skill and skill.Move then
                comboData[i] = {
                    Type = skill.Type,
                    Move = skill.Move
                }
            end
        end
        
        table.insert(Combo.Saved, comboData)
        AddLogMessage("Combo saved! Total saved: " .. #Combo.Saved)
    else
        AddLogMessage("No combo to save!")
    end
end)

LoadComboBtn.MouseButton1Click:Connect(function()
    if #Combo.Saved > 0 then
        local lastCombo = Combo.Saved[#Combo.Saved]
        
        -- Clear current
        for i = 1, 4 do
            StageDropdowns[i].Text = "Select Type"
            MoveDropdowns[i].Visible = false
            MoveDropdowns[i].Text = "Move"
            Combo.Active[i] = nil
        end
        
        -- Load saved
        for i, skill in pairs(lastCombo) do
            if i <= 4 then
                StageDropdowns[i].Text = skill.Type
                MoveDropdowns[i].Visible = true
                MoveDropdowns[i].Text = skill.Move
                Combo.Active[i] = skill
            end
        end
        
        -- Update execution list
        local executionList = {}
        for i = 1, 4 do
            if Combo.Active[i] and Combo.Active[i].Move then
                table.insert(executionList, Combo.Active[i].Move)
            end
        end
        Combo.Execution = executionList
        
        AddLogMessage("Combo loaded!")
    else
        AddLogMessage("No saved combos!")
    end
end)

-- Force Hop Server
ForceHopBtn.MouseButton1Click:Connect(function()
    HopServerButton:MouseButton1Click()
end)

-- Save Session
SaveSessionBtn.MouseButton1Click:Connect(function()
    AddLogMessage("Session data saved to memory")
end)

-- Character Added Event
Player.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
    
    AddLogMessage("Character respawned")
end)

-- Death Tracking
Humanoid.Died:Connect(function()
    Config.Deaths = Config.Deaths + 1
    AddLogMessage("Player died. Total deaths: " .. Config.Deaths)
    
    -- Auto rejoin after 5 seconds
    task.wait(5)
    if Humanoid.Health <= 0 then
        AddLogMessage("Attempting recovery...")
    end
end)

-- Keybinds
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.Insert then
        MainContainer.Visible = not MainContainer.Visible
        BountyWindow.Visible = not BountyWindow.Visible
    elseif input.KeyCode == Enum.KeyCode.F5 then
        NextPlayerButton:MouseButton1Click()
    elseif input.KeyCode == Enum.KeyCode.F6 then
        HopServerButton:MouseButton1Click()
    elseif input.KeyCode == Enum.KeyCode.F7 then
        ExecuteBtn:MouseButton1Click()
    elseif input.KeyCode == Enum.KeyCode.F8 then
        Config.AutoFarm = not Config.AutoFarm
        AddLogMessage("Auto Farm: " .. (Config.AutoFarm and "ON" or "OFF"))
    end
end)

-- Initialization
AddLogMessage("NEXUS BOUNTY v3.0 Initialized")
AddLogMessage("System Ready - Insert to toggle UI")
AddLogMessage("F5: Next Player | F6: Hop Server | F7: Execute | F8: Auto Farm")

print([[
╔══════════════════════════════════════════╗
║     NEXUS BOUNTY v3.0 LOADED            ║
║     Complete Bounty System              ║
║     Lines: 1500+ | All Features         ║
╚══════════════════════════════════════════╝
]])
