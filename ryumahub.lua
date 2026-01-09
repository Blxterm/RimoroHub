-- Blox Fruits AUTO (FIXED LOGIC + STATUS)

if not game:IsLoaded() then game.Loaded:Wait() end

-- SERVICES
local Players = game:GetService("Players")
local Teams = game:GetService("Teams")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- PLAYER
local LP = Players.LocalPlayer
local Char = LP.Character or LP.CharacterAdded:Wait()
local HRP = Char:WaitForChild("HumanoidRootPart")

LP.CharacterAdded:Connect(function(c)
    Char = c
    HRP = c:WaitForChild("HumanoidRootPart")
end)

-- TIME
local START_TIME = tick()
local SESSION_TIME = tick()

-- TEAM AUTO
pcall(function()
    if not LP.Team and Teams:FindFirstChild("Marines") then
        LP.Team = Teams.Marines
    end
end)

-- FLAGS
local PAUSED = false
local STATUS = "Initializing"
local noFruitStart = nil

-- GUI
local gui = Instance.new("ScreenGui", LP.PlayerGui)
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.36,0.26)
frame.Position = UDim2.fromScale(0.32,0.05)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)

local label = Instance.new("TextLabel", frame)
label.Size = UDim2.fromScale(1,0.8)
label.BackgroundTransparency = 1
label.TextColor3 = Color3.new(1,1,1)
label.TextScaled = true
label.TextWrapped = true

local pauseBtn = Instance.new("TextButton", frame)
pauseBtn.Size = UDim2.fromScale(1,0.2)
pauseBtn.Position = UDim2.fromScale(0,0.8)
pauseBtn.Text = "⏸ PAUSE"
pauseBtn.TextScaled = true
pauseBtn.BackgroundColor3 = Color3.fromRGB(80,0,0)
pauseBtn.TextColor3 = Color3.new(1,1,1)

pauseBtn.MouseButton1Click:Connect(function()
    PAUSED = not PAUSED
    if PAUSED then
        STATUS = "Paused"
        frame.Visible = false
    else
        frame.Visible = true
        SESSION_TIME = tick()
        STATUS = "Resumed"
    end
end)

-- UI UPDATE (ONLY DISPLAY)
RunService.RenderStepped:Connect(function()
    if PAUSED then return end
    label.Text =
        "Total Time: "..math.floor(tick()-START_TIME).."s\n"..
        "Session Time: "..math.floor(tick()-SESSION_TIME).."s\n"..
        "Status: "..STATUS
end)

-- MOVEMENT
local function flyTo(pos)
    if PAUSED then return end
    local dist = (HRP.Position - pos).Magnitude
    TweenService:Create(
        HRP,
        TweenInfo.new(math.max(0.1,dist/400)),
        {CFrame = CFrame.new(pos)}
    ):Play()
    task.wait(dist/400)
end

-- FIND FRUIT
local function findFruit()
    for _,v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Tool") and v:FindFirstChild("Handle") then
            if v.Name:lower():find("fruit") then
                return v
            end
        end
    end
end

-- STORE FRUIT
local function storeFruit()
    for i=1,6 do
        if PAUSED then return false end
        local ok = pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit")
        end)
        if not ok then return false end
        task.wait(0.35)
    end
    return true
end

-- SERVER HOP
local function serverHop()
    STATUS = "Server Hopping"
    local data = HttpService:JSONDecode(
        game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?limit=100")
    )
    for _,s in pairs(data.data) do
        if s.playing < s.maxPlayers and s.id ~= game.JobId then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LP)
            return
        end
    end
end

-- MAIN LOOP
task.spawn(function()
    while true do
        if PAUSED then task.wait(0.5) continue end

        local fruit = findFruit()

        if fruit then
            STATUS = "Fruit Found: "..fruit.Name
            noFruitStart = nil
            flyTo(fruit.Handle.Position + Vector3.new(0,3,0))
            task.wait(0.4)
            if not storeFruit() then
                serverHop()
            end
        else
            STATUS = "Fruit Searching"
            if not noFruitStart then
                noFruitStart = tick()
            end

            if tick() - noFruitStart >= 20 then
                serverHop()
                noFruitStart = nil
            end
        end
        task.wait(1)
    end
end)
