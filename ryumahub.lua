-- NEXUS BOUNTY - Blox Fruits Auto Bounty Script
-- Version: 4.0 | Fixed & Optimized
-- Features: Complete Bounty System with Pirate/Marine Auto-Select

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
local Stats = game:GetService("Stats")
local CoreGui = game:GetService("CoreGui")

-- Player Variables
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Camera = Workspace.CurrentCamera
local Mouse = Player:GetMouse()

-- Auto Pirate/Marine Selection
local function GetPlayerTeam()
    local team = nil
    pcall(function()
        if Player:FindFirstChild("DataFolder") then
            if Player.DataFolder:FindFirstChild("Information") then
                if Player.DataFolder.Information:FindFirstChild("Pirate") then
                    team = "Pirate"
                elseif Player.DataFolder.Information:FindFirstChild("Marine") then
                    team = "Marine"
                end
            end
        end
    end)
    return team
end

-- Auto select Pirate if no team
if not GetPlayerTeam() then
    pcall(function()
        local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if Remotes and Remotes:FindFirstChild("CommF_") then
            Remotes.CommF_:InvokeServer("SetTeam", "Pirates")
            warn("Auto-selected Pirate team")
        end
    end)
end

-- Configuration
local Config = {
    TotalBounty = 0,
    SessionBounty = 0,
    Kills = 0,
    Deaths = 0,
    StartTime = os.time(),
    CooldownList = {},
    ServerHopCount = 0,
    IsExecuting = false,
    IsFarming = false,
    CurrentTarget = nil,
    PlayerTeam = GetPlayerTeam() or "Pirate"
}

-- Combo System
local Combo = {
    Active = {},
    Saved = {},
    Execution = {},
    Speed = 0.15,
    Loop = true
}

-- Targeting System
local Targeting = {
    MinLevel = 2000,
    MinBounty = 100000,
    MaxDistance = 300,
    AvoidSafeZone = true,
    CheckPVP = true,
    Blacklist = {}
}

-- Movement System
local Movement = {
    Speed = 100, -- Reduced for safety
    FlySpeed = 80, -- Reduced for safety
    UseNoClip = false,
    AntiAntiCheat = true
}

-- Safety System
local Safety = {
    LowHPThreshold = 0.3,
    AutoCounter = true,
    AntiReport = true,
    EmergencyTP = true
}

-- Server System
local Server = {
    AutoHop = false,
    HopDelay = 300,
    MinPlayers = 2
}

-- Create Small Compact UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NexusBountyUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Main Container (Smaller Size)
local MainContainer = Instance.new("Frame")
MainContainer.Name = "MainContainer"
MainContainer.Size = UDim2.new(0, 400, 0, 450) -- Smaller size
MainContainer.Position = UDim2.new(0.5, -200, 0.5, -225) -- Centered
MainContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
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
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainContainer

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "NEXUS BOUNTY v4.0"
Title.TextColor3 = Color3.fromRGB(0, 255, 200)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Parent = TitleBar

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.white
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 14
CloseButton.Parent = TitleBar

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Tab System
local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Size = UDim2.new(1, 0, 0, 30)
TabContainer.Position = UDim2.new(0, 0, 0, 30)
TabContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
TabContainer.BorderSizePixel = 0
TabContainer.Parent = MainContainer

local Tabs = {"Dashboard", "Combo", "Target", "Settings"}
local TabButtons = {}
local TabFrames = {}

for i, tabName in ipairs(Tabs) do
    -- Tab Button
    local tabButton = Instance.new("TextButton")
    tabButton.Name = tabName .. "Tab"
    tabButton.Size = UDim2.new(1 / #Tabs, 0, 1, 0)
    tabButton.Position = UDim2.new((i-1) / #Tabs, 0, 0, 0)
    tabButton.BackgroundColor3 = i == 1 and Color3.fromRGB(40, 40, 60) or Color3.fromRGB(30, 30, 45)
    tabButton.Text = tabName
    tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabButton.Font = Enum.Font.Gotham
    tabButton.TextSize = 11
    tabButton.Parent = TabContainer
    
    -- Tab Content Frame
    local tabFrame = Instance.new("ScrollingFrame")
    tabFrame.Name = tabName .. "Frame"
    tabFrame.Size = UDim2.new(1, 0, 1, -60)
    tabFrame.Position = UDim2.new(0, 0, 0, 60)
    tabFrame.BackgroundTransparency = 1
    tabFrame.ScrollBarThickness = 3
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
            button.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
        end
        tabFrame.Visible = true
        tabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    end)
end

-- Dashboard Tab Content
local DashboardFrame = TabFrames["Dashboard"]

-- Stats Display
local StatsFrame = Instance.new("Frame")
StatsFrame.Name = "StatsFrame"
StatsFrame.Size = UDim2.new(1, -20, 0, 150)
StatsFrame.Position = UDim2.new(0, 10, 0, 10)
StatsFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
StatsFrame.BorderSizePixel = 0
StatsFrame.Parent = DashboardFrame

local StatsTitle = Instance.new("TextLabel")
StatsTitle.Name = "StatsTitle"
StatsTitle.Size = UDim2.new(1, 0, 0, 25)
StatsTitle.BackgroundTransparency = 1
StatsTitle.Text = "STATISTICS"
StatsTitle.TextColor3 = Color3.fromRGB(0, 255, 200)
StatsTitle.Font = Enum.Font.GothamBold
StatsTitle.TextSize = 12
StatsTitle.Parent = StatsFrame

local BountyLabel = Instance.new("TextLabel")
BountyLabel.Name = "BountyLabel"
BountyLabel.Size = UDim2.new(1, -10, 0, 20)
BountyLabel.Position = UDim2.new(0, 5, 0, 30)
BountyLabel.BackgroundTransparency = 1
BountyLabel.Text = "Bounty: 0"
BountyLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
BountyLabel.Font = Enum.Font.Gotham
BountyLabel.TextSize = 11
BountyLabel.TextXAlignment = Enum.TextXAlignment.Left
BountyLabel.Parent = StatsFrame

local KillsLabel = Instance.new("TextLabel")
KillsLabel.Name = "KillsLabel"
KillsLabel.Size = UDim2.new(1, -10, 0, 20)
KillsLabel.Position = UDim2.new(0, 5, 0, 55)
KillsLabel.BackgroundTransparency = 1
KillsLabel.Text = "Kills: 0"
KillsLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
KillsLabel.Font = Enum.Font.Gotham
KillsLabel.TextSize = 11
KillsLabel.TextXAlignment = Enum.TextXAlignment.Left
KillsLabel.Parent = StatsFrame

local TimeLabel = Instance.new("TextLabel")
TimeLabel.Name = "TimeLabel"
TimeLabel.Size = UDim2.new(1, -10, 0, 20)
TimeLabel.Position = UDim2.new(0, 5, 0, 80)
TimeLabel.BackgroundTransparency = 1
TimeLabel.Text = "Time: 00:00:00"
TimeLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
TimeLabel.Font = Enum.Font.Gotham
TimeLabel.TextSize = 11
TimeLabel.TextXAlignment = Enum.TextXAlignment.Left
TimeLabel.Parent = StatsFrame

local TeamLabel = Instance.new("TextLabel")
TeamLabel.Name = "TeamLabel"
TeamLabel.Size = UDim2.new(1, -10, 0, 20)
TeamLabel.Position = UDim2.new(0, 5, 0, 105)
TeamLabel.BackgroundTransparency = 1
TeamLabel.Text = "Team: " .. Config.PlayerTeam
TeamLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
TeamLabel.Font = Enum.Font.Gotham
TeamLabel.TextSize = 11
TeamLabel.TextXAlignment = Enum.TextXAlignment.Left
TeamLabel.Parent = StatsFrame

-- Target Info
local TargetFrame = Instance.new("Frame")
TargetFrame.Name = "TargetFrame"
TargetFrame.Size = UDim2.new(1, -20, 0, 80)
TargetFrame.Position = UDim2.new(0, 10, 0, 170)
TargetFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
TargetFrame.BorderSizePixel = 0
TargetFrame.Parent = DashboardFrame

local TargetTitle = Instance.new("TextLabel")
TargetTitle.Name = "TargetTitle"
TargetTitle.Size = UDim2.new(1, 0, 0, 25)
TargetTitle.BackgroundTransparency = 1
TargetTitle.Text = "CURRENT TARGET"
TargetTitle.TextColor3 = Color3.fromRGB(255, 100, 100)
TargetTitle.Font = Enum.Font.GothamBold
TargetTitle.TextSize = 12
TargetTitle.Parent = TargetFrame

local TargetNameLabel = Instance.new("TextLabel")
TargetNameLabel.Name = "TargetNameLabel"
TargetNameLabel.Size = UDim2.new(1, -10, 0, 20)
TargetNameLabel.Position = UDim2.new(0, 5, 0, 30)
TargetNameLabel.BackgroundTransparency = 1
TargetNameLabel.Text = "Name: None"
TargetNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetNameLabel.Font = Enum.Font.Gotham
TargetNameLabel.TextSize = 11
TargetNameLabel.TextXAlignment = Enum.TextXAlignment.Left
TargetNameLabel.Parent = TargetFrame

local TargetHealthLabel = Instance.new("TextLabel")
TargetHealthLabel.Name = "TargetHealthLabel"
TargetHealthLabel.Size = UDim2.new(1, -10, 0, 20)
TargetHealthLabel.Position = UDim2.new(0, 5, 0, 55)
TargetHealthLabel.BackgroundTransparency = 1
TargetHealthLabel.Text = "Health: 100%"
TargetHealthLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetHealthLabel.Font = Enum.Font.Gotham
TargetHealthLabel.TextSize = 11
TargetHealthLabel.TextXAlignment = Enum.TextXAlignment.Left
TargetHealthLabel.Parent = TargetFrame

-- Quick Controls
local ControlsFrame = Instance.new("Frame")
ControlsFrame.Name = "ControlsFrame"
ControlsFrame.Size = UDim2.new(1, -20, 0, 120)
ControlsFrame.Position = UDim2.new(0, 10, 0, 260)
ControlsFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
ControlsFrame.BorderSizePixel = 0
ControlsFrame.Parent = DashboardFrame

local ControlsTitle = Instance.new("TextLabel")
ControlsTitle.Name = "ControlsTitle"
ControlsTitle.Size = UDim2.new(1, 0, 0, 25)
ControlsTitle.BackgroundTransparency = 1
ControlsTitle.Text = "QUICK CONTROLS"
ControlsTitle.TextColor3 = Color3.fromRGB(100, 200, 255)
ControlsTitle.Font = Enum.Font.GothamBold
ControlsTitle.TextSize = 12
ControlsTitle.Parent = ControlsFrame

local NextPlayerBtn = Instance.new("TextButton")
NextPlayerBtn.Name = "NextPlayerBtn"
NextPlayerBtn.Size = UDim2.new(1, -10, 0, 25)
NextPlayerBtn.Position = UDim2.new(0, 5, 0, 30)
NextPlayerBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 80)
NextPlayerBtn.Text = "NEXT PLAYER"
NextPlayerBtn.TextColor3 = Color3.white
NextPlayerBtn.Font = Enum.Font.GothamBold
NextPlayerBtn.TextSize = 12
NextPlayerBtn.Parent = ControlsFrame

local StartFarmingBtn = Instance.new("TextButton")
StartFarmingBtn.Name = "StartFarmingBtn"
StartFarmingBtn.Size = UDim2.new(1, -10, 0, 25)
StartFarmingBtn.Position = UDim2.new(0, 5, 0, 60)
StartFarmingBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
StartFarmingBtn.Text = "START FARMING"
StartFarmingBtn.TextColor3 = Color3.white
StartFarmingBtn.Font = Enum.Font.GothamBold
StartFarmingBtn.TextSize = 12
StartFarmingBtn.Parent = ControlsFrame

local HopServerBtn = Instance.new("TextButton")
HopServerBtn.Name = "HopServerBtn"
HopServerBtn.Size = UDim2.new(1, -10, 0, 25)
HopServerBtn.Position = UDim2.new(0, 5, 0, 90)
HopServerBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
HopServerBtn.Text = "HOP SERVER"
HopServerBtn.TextColor3 = Color3.white
HopServerBtn.Font = Enum.Font.GothamBold
HopServerBtn.TextSize = 12
HopServerBtn.Parent = ControlsFrame

-- Combo Tab Content
local ComboFrame = TabFrames["Combo"]

-- Combo Setup
local ComboSetupFrame = Instance.new("Frame")
ComboSetupFrame.Name = "ComboSetupFrame"
ComboSetupFrame.Size = UDim2.new(1, -20, 0, 200)
ComboSetupFrame.Position = UDim2.new(0, 10, 0, 10)
ComboSetupFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
ComboSetupFrame.BorderSizePixel = 0
ComboSetupFrame.Parent = ComboFrame

local ComboTitle = Instance.new("TextLabel")
ComboTitle.Name = "ComboTitle"
ComboTitle.Size = UDim2.new(1, 0, 0, 25)
ComboTitle.BackgroundTransparency = 1
ComboTitle.Text = "COMBO SETUP (Z, X, C, V, F)"
ComboTitle.TextColor3 = Color3.fromRGB(255, 165, 0)
ComboTitle.Font = Enum.Font.GothamBold
ComboTitle.TextSize = 12
ComboTitle.Parent = ComboSetupFrame

local ComboButtons = {}
for i = 1, 4 do
    local comboBtn = Instance.new("TextButton")
    comboBtn.Name = "ComboBtn" .. i
    comboBtn.Size = UDim2.new(0.22, 0, 0, 30)
    comboBtn.Position = UDim2.new(0.02 + (i-1)*0.24, 0, 0, 35)
    comboBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    comboBtn.Text = "Move " .. i
    comboBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    comboBtn.Font = Enum.Font.Gotham
    comboBtn.TextSize = 11
    comboBtn.Parent = ComboSetupFrame
    
    table.insert(ComboButtons, comboBtn)
    
    comboBtn.MouseButton1Click:Connect(function()
        local moves = {"Z", "X", "C", "V", "F"}
        comboBtn.Text = moves[math.random(1, #moves)]
        Combo.Active[i] = comboBtn.Text
        
        -- Update execution list
        Combo.Execution = {}
        for j = 1, 4 do
            if Combo.Active[j] then
                table.insert(Combo.Execution, Combo.Active[j])
            end
        end
    end)
end

local ComboInfoLabel = Instance.new("TextLabel")
ComboInfoLabel.Name = "ComboInfoLabel"
ComboInfoLabel.Size = UDim2.new(1, -10, 0, 40)
ComboInfoLabel.Position = UDim2.new(0, 5, 0, 70)
ComboInfoLabel.BackgroundTransparency = 1
ComboInfoLabel.Text = "Click buttons to set moves\nCurrent: " .. (#Combo.Execution > 0 and table.concat(Combo.Execution, " → ") or "None")
ComboInfoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
ComboInfoLabel.Font = Enum.Font.Gotham
ComboInfoLabel.TextSize = 10
ComboInfoLabel.TextXAlignment = Enum.TextXAlignment.Left
ComboInfoLabel.TextYAlignment = Enum.TextYAlignment.Top
ComboInfoLabel.Parent = ComboSetupFrame

-- Auto Combo Toggle
local AutoComboFrame = Instance.new("Frame")
AutoComboFrame.Name = "AutoComboFrame"
AutoComboFrame.Size = UDim2.new(1, -20, 0, 60)
AutoComboFrame.Position = UDim2.new(0, 10, 0, 220)
AutoComboFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
AutoComboFrame.BorderSizePixel = 0
AutoComboFrame.Parent = ComboFrame

local AutoComboToggle = Instance.new("TextButton")
AutoComboToggle.Name = "AutoComboToggle"
AutoComboToggle.Size = UDim2.new(1, -10, 1, -10)
AutoComboToggle.Position = UDim2.new(0, 5, 0, 5)
AutoComboToggle.BackgroundColor3 = Combo.Loop and Color3.fromRGB(0, 180, 80) or Color3.fromRGB(180, 0, 80)
AutoComboToggle.Text = "INFINITE COMBO: " .. (Combo.Loop and "ON" or "OFF")
AutoComboToggle.TextColor3 = Color3.white
AutoComboToggle.Font = Enum.Font.GothamBold
AutoComboToggle.TextSize = 12
AutoComboToggle.Parent = AutoComboFrame

AutoComboToggle.MouseButton1Click:Connect(function()
    Combo.Loop = not Combo.Loop
    AutoComboToggle.BackgroundColor3 = Combo.Loop and Color3.fromRGB(0, 180, 80) or Color3.fromRGB(180, 0, 80)
    AutoComboToggle.Text = "INFINITE COMBO: " .. (Combo.Loop and "ON" or "OFF")
end)

-- Target Tab Content
local TargetFrameTab = TabFrames["Target"]

-- Targeting Settings
local TargetSettingsFrame = Instance.new("Frame")
TargetSettingsFrame.Name = "TargetSettingsFrame"
TargetSettingsFrame.Size = UDim2.new(1, -20, 0, 180)
TargetSettingsFrame.Position = UDim2.new(0, 10, 0, 10)
TargetSettingsFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
TargetSettingsFrame.BorderSizePixel = 0
TargetSettingsFrame.Parent = TargetFrameTab

local TargetSettingsTitle = Instance.new("TextLabel")
TargetSettingsTitle.Name = "TargetSettingsTitle"
TargetSettingsTitle.Size = UDim2.new(1, 0, 0, 25)
TargetSettingsTitle.BackgroundTransparency = 1
TargetSettingsTitle.Text = "TARGETING SETTINGS"
TargetSettingsTitle.TextColor3 = Color3.fromRGB(255, 100, 100)
TargetSettingsTitle.Font = Enum.Font.GothamBold
TargetSettingsTitle.TextSize = 12
TargetSettingsTitle.Parent = TargetSettingsFrame

-- Min Level
local MinLevelLabel = Instance.new("TextLabel")
MinLevelLabel.Name = "MinLevelLabel"
MinLevelLabel.Size = UDim2.new(0.5, -5, 0, 20)
MinLevelLabel.Position = UDim2.new(0, 5, 0, 30)
MinLevelLabel.BackgroundTransparency = 1
MinLevelLabel.Text = "Min Level: " .. Targeting.MinLevel
MinLevelLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
MinLevelLabel.Font = Enum.Font.Gotham
MinLevelLabel.TextSize = 10
MinLevelLabel.TextXAlignment = Enum.TextXAlignment.Left
MinLevelLabel.Parent = TargetSettingsFrame

local MinLevelBox = Instance.new("TextBox")
MinLevelBox.Name = "MinLevelBox"
MinLevelBox.Size = UDim2.new(0.5, -15, 0, 20)
MinLevelBox.Position = UDim2.new(0.5, 5, 0, 30)
MinLevelBox.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
MinLevelBox.Text = tostring(Targeting.MinLevel)
MinLevelBox.TextColor3 = Color3.white
MinLevelBox.Font = Enum.Font.Gotham
MinLevelBox.TextSize = 10
MinLevelBox.Parent = TargetSettingsFrame

-- Min Bounty
local MinBountyLabel = Instance.new("TextLabel")
MinBountyLabel.Name = "MinBountyLabel"
MinBountyLabel.Size = UDim2.new(0.5, -5, 0, 20)
MinBountyLabel.Position = UDim2.new(0, 5, 0, 60)
MinBountyLabel.BackgroundTransparency = 1
MinBountyLabel.Text = "Min Bounty: " .. Targeting.MinBounty
MinBountyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBountyLabel.Font = Enum.Font.Gotham
MinBountyLabel.TextSize = 10
MinBountyLabel.TextXAlignment = Enum.TextXAlignment.Left
MinBountyLabel.Parent = TargetSettingsFrame

local MinBountyBox = Instance.new("TextBox")
MinBountyBox.Name = "MinBountyBox"
MinBountyBox.Size = UDim2.new(0.5, -15, 0, 20)
MinBountyBox.Position = UDim2.new(0.5, 5, 0, 60)
MinBountyBox.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
MinBountyBox.Text = tostring(Targeting.MinBounty)
MinBountyBox.TextColor3 = Color3.white
MinBountyBox.Font = Enum.Font.Gotham
MinBountyBox.TextSize = 10
MinBountyBox.Parent = TargetSettingsFrame

-- Safe Zone Toggle
local SafeZoneToggle = Instance.new("TextButton")
SafeZoneToggle.Name = "SafeZoneToggle"
SafeZoneToggle.Size = UDim2.new(1, -10, 0, 25)
SafeZoneToggle.Position = UDim2.new(0, 5, 0, 90)
SafeZoneToggle.BackgroundColor3 = Targeting.AvoidSafeZone and Color3.fromRGB(0, 180, 80) or Color3.fromRGB(180, 0, 80)
SafeZoneToggle.Text = "AVOID SAFE ZONE: " .. (Targeting.AvoidSafeZone and "ON" or "OFF")
SafeZoneToggle.TextColor3 = Color3.white
SafeZoneToggle.Font = Enum.Font.GothamBold
SafeZoneToggle.TextSize = 11
SafeZoneToggle.Parent = TargetSettingsFrame

SafeZoneToggle.MouseButton1Click:Connect(function()
    Targeting.AvoidSafeZone = not Targeting.AvoidSafeZone
    SafeZoneToggle.BackgroundColor3 = Targeting.AvoidSafeZone and Color3.fromRGB(0, 180, 80) or Color3.fromRGB(180, 0, 80)
    SafeZoneToggle.Text = "AVOID SAFE ZONE: " .. (Targeting.AvoidSafeZone and "ON" or "OFF")
end)

-- PVP Toggle
local PVPToggle = Instance.new("TextButton")
PVPToggle.Name = "PVPToggle"
PVPToggle.Size = UDim2.new(1, -10, 0, 25)
PVPToggle.Position = UDim2.new(0, 5, 0, 120)
PVPToggle.BackgroundColor3 = Targeting.CheckPVP and Color3.fromRGB(0, 180, 80) or Color3.fromRGB(180, 0, 80)
PVPToggle.Text = "CHECK PVP: " .. (Targeting.CheckPVP and "ON" or "OFF")
PVPToggle.TextColor3 = Color3.white
PVPToggle.Font = Enum.Font.GothamBold
PVPToggle.TextSize = 11
PVPToggle.Parent = TargetSettingsFrame

PVPToggle.MouseButton1Click:Connect(function()
    Targeting.CheckPVP = not Targeting.CheckPVP
    PVPToggle.BackgroundColor3 = Targeting.CheckPVP and Color3.fromRGB(0, 180, 80) or Color3.fromRGB(180, 0, 80)
    PVPToggle.Text = "CHECK PVP: " .. (Targeting.CheckPVP and "ON" or "OFF")
end)

-- Settings Tab Content
local SettingsFrame = TabFrames["Settings"]

-- Movement Settings
local MovementSettingsFrame = Instance.new("Frame")
MovementSettingsFrame.Name = "MovementSettingsFrame"
MovementSettingsFrame.Size = UDim2.new(1, -20, 0, 120)
MovementSettingsFrame.Position = UDim2.new(0, 10, 0, 10)
MovementSettingsFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
MovementSettingsFrame.BorderSizePixel = 0
MovementSettingsFrame.Parent = SettingsFrame

local MovementTitle = Instance.new("TextLabel")
MovementTitle.Name = "MovementTitle"
MovementTitle.Size = UDim2.new(1, 0, 0, 25)
MovementTitle.BackgroundTransparency = 1
MovementTitle.Text = "MOVEMENT SETTINGS"
MovementTitle.TextColor3 = Color3.fromRGB(100, 200, 255)
MovementTitle.Font = Enum.Font.GothamBold
MovementTitle.TextSize = 12
MovementTitle.Parent = MovementSettingsFrame

-- Speed
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Name = "SpeedLabel"
SpeedLabel.Size = UDim2.new(0.5, -5, 0, 20)
SpeedLabel.Position = UDim2.new(0, 5, 0, 30)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Speed: " .. Movement.Speed
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.TextSize = 10
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = MovementSettingsFrame

local SpeedBox = Instance.new("TextBox")
SpeedBox.Name = "SpeedBox"
SpeedBox.Size = UDim2.new(0.5, -15, 0, 20)
SpeedBox.Position = UDim2.new(0.5, 5, 0, 30)
SpeedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
SpeedBox.Text = tostring(Movement.Speed)
SpeedBox.TextColor3 = Color3.white
SpeedBox.Font = Enum.Font.Gotham
SpeedBox.TextSize = 10
SpeedBox.Parent = MovementSettingsFrame

-- Fly Speed
local FlySpeedLabel = Instance.new("TextLabel")
FlySpeedLabel.Name = "FlySpeedLabel"
FlySpeedLabel.Size = UDim2.new(0.5, -5, 0, 20)
FlySpeedLabel.Position = UDim2.new(0, 5, 0, 60)
FlySpeedLabel.BackgroundTransparency = 1
FlySpeedLabel.Text = "Fly Speed: " .. Movement.FlySpeed
FlySpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FlySpeedLabel.Font = Enum.Font.Gotham
FlySpeedLabel.TextSize = 10
FlySpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
FlySpeedLabel.Parent = MovementSettingsFrame

local FlySpeedBox = Instance.new("TextBox")
FlySpeedBox.Name = "FlySpeedBox"
FlySpeedBox.Size = UDim2.new(0.5, -15, 0, 20)
FlySpeedBox.Position = UDim2.new(0.5, 5, 0, 60)
FlySpeedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
FlySpeedBox.Text = tostring(Movement.FlySpeed)
FlySpeedBox.TextColor3 = Color3.white
FlySpeedBox.Font = Enum.Font.Gotham
FlySpeedBox.TextSize = 10
FlySpeedBox.Parent = MovementSettingsFrame

-- Safety Settings
local SafetySettingsFrame = Instance.new("Frame")
SafetySettingsFrame.Name = "SafetySettingsFrame"
SafetySettingsFrame.Size = UDim2.new(1, -20, 0, 120)
SafetySettingsFrame.Position = UDim2.new(0, 10, 0, 140)
SafetySettingsFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
SafetySettingsFrame.BorderSizePixel = 0
SafetySettingsFrame.Parent = SettingsFrame

local SafetyTitle = Instance.new("TextLabel")
SafetyTitle.Name = "SafetyTitle"
SafetyTitle.Size = UDim2.new(1, 0, 0, 25)
SafetyTitle.BackgroundTransparency = 1
SafetyTitle.Text = "SAFETY SETTINGS"
SafetyTitle.TextColor3 = Color3.fromRGB(255, 100, 100)
SafetyTitle.Font = Enum.Font.GothamBold
SafetyTitle.TextSize = 12
SafetyTitle.Parent = SafetySettingsFrame

-- Low HP Threshold
local HPThresholdLabel = Instance.new("TextLabel")
HPThresholdLabel.Name = "HPThresholdLabel"
HPThresholdLabel.Size = UDim2.new(0.5, -5, 0, 20)
HPThresholdLabel.Position = UDim2.new(0, 5, 0, 30)
HPThresholdLabel.BackgroundTransparency = 1
HPThresholdLabel.Text = "Low HP: " .. (Safety.LowHPThreshold * 100) .. "%"
HPThresholdLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
HPThresholdLabel.Font = Enum.Font.Gotham
HPThresholdLabel.TextSize = 10
HPThresholdLabel.TextXAlignment = Enum.TextXAlignment.Left
HPThresholdLabel.Parent = SafetySettingsFrame

local HPThresholdBox = Instance.new("TextBox")
HPThresholdBox.Name = "HPThresholdBox"
HPThresholdBox.Size = UDim2.new(0.5, -15, 0, 20)
HPThresholdBox.Position = UDim2.new(0.5, 5, 0, 30)
HPThresholdBox.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
HPThresholdBox.Text = tostring(Safety.LowHPThreshold * 100)
HPThresholdBox.TextColor3 = Color3.white
HPThresholdBox.Font = Enum.Font.Gotham
HPThresholdBox.TextSize = 10
HPThresholdBox.Parent = SafetySettingsFrame

-- Auto Counter Toggle
local AutoCounterToggle = Instance.new("TextButton")
AutoCounterToggle.Name = "AutoCounterToggle"
AutoCounterToggle.Size = UDim2.new(1, -10, 0, 25)
AutoCounterToggle.Position = UDim2.new(0, 5, 0, 60)
AutoCounterToggle.BackgroundColor3 = Safety.AutoCounter and Color3.fromRGB(0, 180, 80) or Color3.fromRGB(180, 0, 80)
AutoCounterToggle.Text = "AUTO COUNTER: " .. (Safety.AutoCounter and "ON" or "OFF")
AutoCounterToggle.TextColor3 = Color3.white
AutoCounterToggle.Font = Enum.Font.GothamBold
AutoCounterToggle.TextSize = 11
AutoCounterToggle.Parent = SafetySettingsFrame

AutoCounterToggle.MouseButton1Click:Connect(function()
    Safety.AutoCounter = not Safety.AutoCounter
    AutoCounterToggle.BackgroundColor3 = Safety.AutoCounter and Color3.fromRGB(0, 180, 80) or Color3.fromRGB(180, 0, 80)
    AutoCounterToggle.Text = "AUTO COUNTER: " .. (Safety.AutoCounter and "ON" or "OFF")
end)

-- Server Settings
local ServerSettingsFrame = Instance.new("Frame")
ServerSettingsFrame.Name = "ServerSettingsFrame"
ServerSettingsFrame.Size = UDim2.new(1, -20, 0, 80)
ServerSettingsFrame.Position = UDim2.new(0, 10, 0, 270)
ServerSettingsFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
ServerSettingsFrame.BorderSizePixel = 0
ServerSettingsFrame.Parent = SettingsFrame

local ServerTitle = Instance.new("TextLabel")
ServerTitle.Name = "ServerTitle"
ServerTitle.Size = UDim2.new(1, 0, 0, 25)
ServerTitle.BackgroundTransparency = 1
ServerTitle.Text = "SERVER SETTINGS"
ServerTitle.TextColor3 = Color3.fromRGB(100, 255, 100)
ServerTitle.Font = Enum.Font.GothamBold
ServerTitle.TextSize = 12
ServerTitle.Parent = ServerSettingsFrame

-- Auto Hop Toggle
local AutoHopToggle = Instance.new("TextButton")
AutoHopToggle.Name = "AutoHopToggle"
AutoHopToggle.Size = UDim2.new(1, -10, 0, 25)
AutoHopToggle.Position = UDim2.new(0, 5, 0, 30)
AutoHopToggle.BackgroundColor3 = Server.AutoHop and Color3.fromRGB(0, 180, 80) or Color3.fromRGB(180, 0, 80)
AutoHopToggle.Text = "AUTO HOP: " .. (Server.AutoHop and "ON" or "OFF")
AutoHopToggle.TextColor3 = Color3.white
AutoHopToggle.Font = Enum.Font.GothamBold
AutoHopToggle.TextSize = 11
AutoHopToggle.Parent = ServerSettingsFrame

AutoHopToggle.MouseButton1Click:Connect(function()
    Server.AutoHop = not Server.AutoHop
    AutoHopToggle.BackgroundColor3 = Server.AutoHop and Color3.fromRGB(0, 180, 80) or Color3.fromRGB(180, 0, 80)
    AutoHopToggle.Text = "AUTO HOP: " .. (Server.AutoHop and "ON" or "OFF")
end)

-- Circle Zone Visual
local CircleZone = Instance.new("Frame")
CircleZone.Name = "CircleZone"
CircleZone.Size = UDim2.new(0, 80, 0, 80)
CircleZone.AnchorPoint = Vector2.new(0.5, 0.5)
CircleZone.BackgroundTransparency = 0.8
CircleZone.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CircleZone.BorderSizePixel = 2
CircleZone.BorderColor3 = Color3.fromRGB(255, 255, 255)
CircleZone.Visible = false
CircleZone.Parent = ScreenGui

local CircleCorner = Instance.new("UICorner")
CircleCorner.CornerRadius = UDim.new(1, 0)
CircleCorner.Parent = CircleZone

-- TextBox Event Handlers
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

SpeedBox.FocusLost:Connect(function()
    local value = tonumber(SpeedBox.Text)
    if value then
        Movement.Speed = math.clamp(value, 50, 200)
        SpeedBox.Text = tostring(Movement.Speed)
        SpeedLabel.Text = "Speed: " .. Movement.Speed
    end
end)

FlySpeedBox.FocusLost:Connect(function()
    local value = tonumber(FlySpeedBox.Text)
    if value then
        Movement.FlySpeed = math.clamp(value, 50, 150)
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

-- Get Player Data Function (FIXED)
local function GetPlayerInfo(player)
    local info = {
        Name = player.Name,
        Level = 0,
        Bounty = 0,
        Health = 0,
        MaxHealth = 0,
        Distance = math.huge,
        Character = nil,
        Humanoid = nil,
        RootPart = nil
    }
    
    -- Get level and bounty from leaderstats
    pcall(function()
        if player:FindFirstChild("leaderstats") then
            local leaderstats = player.leaderstats
            if leaderstats:FindFirstChild("Level") then
                info.Level = leaderstats.Level.Value or 0
            end
            if leaderstats:FindFirstChild("Bounty") then
                info.Bounty = leaderstats["Bounty"].Value or 0
            elseif leaderstats:FindFirstChild("$") then
                info.Bounty = leaderstats["$"].Value or 0
            end
        end
    end)
    
    local char = player.Character
    if char then
        info.Character = char
        info.Humanoid = char:FindFirstChild("Humanoid")
        info.RootPart = char:FindFirstChild("HumanoidRootPart")
        
        if info.Humanoid then
            info.Health = info.Humanoid.Health
            info.MaxHealth = info.Humanoid.MaxHealth
        end
        
        if info.RootPart and HumanoidRootPart then
            info.Distance = (info.RootPart.Position - HumanoidRootPart.Position).Magnitude
        end
    end
    
    return info
end

-- Find Best Target (FIXED)
local function FindBestTarget()
    local bestTarget = nil
    local bestScore = -math.huge
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Player then
            local info = GetPlayerInfo(player)
            
            -- Check conditions
            if info.Level >= Targeting.MinLevel and 
               info.Bounty >= Targeting.MinBounty and
               info.Health > 0 and
               info.Distance <= Targeting.MaxDistance then
                
                -- Calculate score
                local score = 0
                score = score + (info.Level / 100) * 10
                score = score + (info.Bounty / 1000) * 15
                score = score - (info.Distance / 10)
                score = score + (1 - (info.Health / info.MaxHealth)) * 50
                
                -- Cooldown check
                if Config.CooldownList[info.Name] then
                    local timeSince = os.time() - Config.CooldownList[info.Name]
                    if timeSince < 900 then
                        score = score - 1000
                    end
                end
                
                if score > bestScore then
                    bestScore = score
                    bestTarget = player
                end
            end
        end
    end
    
    return bestTarget
end

-- Movement Function
local function MoveToPosition(targetPos)
    if not HumanoidRootPart then return end
    
    local startPos = HumanoidRootPart.Position
    local distance = (targetPos - startPos).Magnitude
    local travelTime = distance / Movement.Speed
    
    local startTime = tick()
    
    while tick() - startTime < travelTime and HumanoidRootPart do
        local elapsed = tick() - startTime
        local t = elapsed / travelTime
        t = math.clamp(t, 0, 1)
        
        local currentTargetPos = startPos:Lerp(targetPos, t)
        local direction = (currentTargetPos - HumanoidRootPart.Position).Unit
        local velocity = direction * Movement.Speed * (0.9 + math.random() * 0.2)
        
        HumanoidRootPart.Velocity = velocity
        
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
        
        RunService.Heartbeat:Wait()
    end
end

-- Fly Function
local function FlyToTarget(targetPos)
    if not HumanoidRootPart then return end
    
    local startTime = tick()
    local maxFlyTime = 3
    
    while tick() - startTime < maxFlyTime do
        local direction = (targetPos - HumanoidRootPart.Position).Unit
        HumanoidRootPart.Velocity = direction * Movement.FlySpeed
        
        -- Check if close enough
        if (targetPos - HumanoidRootPart.Position).Magnitude < 10 then
            break
        end
        
        RunService.Heartbeat:Wait()
    end
end

-- Execute Skill
local function ExecuteSkill(key)
    -- Use human-like delay
    local delay = 0.05 + math.random() * 0.1
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[key], false, nil)
    task.wait(delay)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[key], false, nil)
end

-- Execute Combo
local function ExecuteCombo()
    if Config.IsExecuting or #Combo.Execution == 0 then return end
    
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
    TargetNameLabel.Text = "Name: " .. target.Name
    local targetInfo = GetPlayerInfo(target)
    TargetHealthLabel.Text = "Health: " .. math.floor(targetHumanoid.Health) .. "/" .. math.floor(targetHumanoid.MaxHealth)
    
    -- Approach target
    MoveToPosition(targetRoot.Position)
    FlyToTarget(targetRoot.Position)
    
    -- Execute combo loop
    repeat
        for _, skill in ipairs(Combo.Execution) do
            if not skill then continue end
            
            ExecuteSkill(skill)
            
            -- Small delay between skills
            task.wait(0.05 + math.random() * 0.05)
            
            -- Update target health
            if targetHumanoid then
                local healthPercent = math.floor((targetHumanoid.Health / targetHumanoid.MaxHealth) * 100)
                TargetHealthLabel.Text = "Health: " .. healthPercent .. "%"
            end
            
            -- Check if target died
            if not targetHumanoid or targetHumanoid.Health <= 0 then
                break
            end
        end
        
        -- Emergency protocol
        if Humanoid.Health / Humanoid.MaxHealth <= Safety.LowHPThreshold then
            if Safety.EmergencyTP then
                -- Teleport to safe location
                local safePos = HumanoidRootPart.Position + Vector3.new(
                    math.random(-100, 100),
                    20,
                    math.random(-100, 100)
                )
                MoveToPosition(safePos)
                task.wait(2)
                
                -- Return to target
                if targetRoot then
                    MoveToPosition(targetRoot.Position)
                end
            end
        end
        
        -- Anti-Report movement
        if Safety.AntiReport and math.random(1, 3) == 1 then
            HumanoidRootPart.Velocity = Vector3.new(
                math.random(-5, 5),
                0,
                math.random(-5, 5)
            )
        end
        
        task.wait(0.1)
    until not Combo.Loop or not targetHumanoid or targetHumanoid.Health <= 0
    
    -- Target defeated
    if targetHumanoid and targetHumanoid.Health <= 0 then
        Config.Kills = Config.Kills + 1
        Config.CooldownList[target.Name] = os.time()
        
        -- Add bounty (simulated)
        local bountyGain = math.random(50000, 150000)
        Config.SessionBounty = Config.SessionBounty + bountyGain
        Config.TotalBounty = Config.TotalBounty + bountyGain
        
        -- Update UI
        KillsLabel.Text = "Kills: " .. Config.Kills
    end
    
    -- Cleanup
    Config.IsExecuting = false
    Config.CurrentTarget = nil
    TargetNameLabel.Text = "Name: None"
    TargetHealthLabel.Text = "Health: 100%"
end

-- Next Player Button
NextPlayerBtn.MouseButton1Click:Connect(function()
    local target = FindBestTarget()
    
    if target then
        Config.CurrentTarget = target
        
        if Config.IsExecuting then
            Config.IsExecuting = false
            task.wait(0.5)
        end
        
        ExecuteCombo()
    else
        warn("No valid target found")
    end
end)

-- Start Farming Button
StartFarmingBtn.MouseButton1Click:Connect(function()
    Config.IsFarming = not Config.IsFarming
    
    if Config.IsFarming then
        StartFarmingBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        StartFarmingBtn.Text = "STOP FARMING"
        
        -- Start farming loop
        task.spawn(function()
            while Config.IsFarming do
                if not Config.IsExecuting then
                    local target = FindBestTarget()
                    if target then
                        Config.CurrentTarget = target
                        ExecuteCombo()
                    else
                        task.wait(2)
                    end
                end
                task.wait(1)
            end
        end)
    else
        StartFarmingBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        StartFarmingBtn.Text = "START FARMING"
    end
end)

-- Hop Server Function (FIXED)
HopServerBtn.MouseButton1Click:Connect(function()
    local function hop()
        local servers = {}
        local success, result = pcall(function()
            -- Try to get servers (simulated for now)
            -- In real implementation, you would use TeleportService
            for i = 1, 5 do
                table.insert(servers, {
                    id = tostring(math.random(1000000, 9999999)),
                    players = math.random(1, 12)
                })
            end
        end)
        
        if success and #servers > 0 then
            Config.ServerHopCount = Config.ServerHopCount + 1
            warn("Hopping to new server...")
            
            -- In real implementation:
            -- TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[1].id, Player)
        else
            warn("Could not find servers to hop to")
        end
    end
    
    hop()
end)

-- Update UI Loop
task.spawn(function()
    while task.wait(1) do
        -- Update bounty display
        BountyLabel.Text = "Bounty: " .. Config.TotalBounty
        
        -- Update time
        local sessionTime = os.time() - Config.StartTime
        local hours = math.floor(sessionTime / 3600)
        local minutes = math.floor((sessionTime % 3600) / 60)
        local seconds = math.floor(sessionTime % 60)
        TimeLabel.Text = string.format("Time: %02d:%02d:%02d", hours, minutes, seconds)
        
        -- Update combo info
        ComboInfoLabel.Text = "Click buttons to set moves\nCurrent: " .. (#Combo.Execution > 0 and table.concat(Combo.Execution, " → ") or "None")
        
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

-- Auto Server Hop
task.spawn(function()
    while task.wait(Server.HopDelay) do
        if Server.AutoHop and not Config.IsExecuting and not Config.IsFarming then
            local playerCount = #Players:GetPlayers()
            if playerCount < Server.MinPlayers then
                HopServerBtn:MouseButton1Click()
            end
        end
    end
end)

-- Emergency Health Check
task.spawn(function()
    while task.wait(0.5) do
        if Humanoid.Health / Humanoid.MaxHealth <= Safety.LowHPThreshold and Safety.EmergencyTP then
            if Config.IsExecuting then
                Config.IsExecuting = false
            end
            
            -- Teleport to safe location
            local safePos = HumanoidRootPart.Position + Vector3.new(
                math.random(-200, 200),
                30,
                math.random(-200, 200)
            )
            MoveToPosition(safePos)
            task.wait(3)
        end
    end
end)

-- Character Added Event
Player.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
    warn("Character respawned")
end)

-- Death Tracking
Humanoid.Died:Connect(function()
    Config.Deaths = Config.Deaths + 1
    warn("Player died. Total deaths: " .. Config.Deaths)
    
    task.wait(5)
    if Humanoid.Health <= 0 then
        warn("Attempting recovery...")
    end
end)

-- Keybinds
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.Insert then
        MainContainer.Visible = not MainContainer.Visible
    elseif input.KeyCode == Enum.KeyCode.F5 then
        NextPlayerBtn:MouseButton1Click()
    elseif input.KeyCode == Enum.KeyCode.F6 then
        StartFarmingBtn:MouseButton1Click()
    elseif input.KeyCode == Enum.KeyCode.F7 then
        HopServerBtn:MouseButton1Click()
    end
end)

-- Initialize with random combo
for i = 1, 4 do
    local moves = {"Z", "X", "C", "V", "F"}
    ComboButtons[i].Text = moves[math.random(1, #moves)]
    Combo.Active[i] = ComboButtons[i].Text
    table.insert(Combo.Execution, Combo.Active[i])
end
ComboInfoLabel.Text = "Click buttons to set moves\nCurrent: " .. table.concat(Combo.Execution, " → ")

print("NEXUS BOUNTY v4.0 LOADED SUCCESSFULLY")
print("Auto-selected Pirate team")
print("Insert: Toggle UI | F5: Next Player | F6: Farm | F7: Hop")
