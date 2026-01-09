--[[ 
Blox Fruits AUTO SCRIPT
Features:
- Auto Marines
- Auto Fruit + Store
- Factory (Second Sea)
- Pirates (Third Sea)
- GUI Server Hop (Germany / Singapore) with Retry
- Status + Pause
]]

if not game:IsLoaded() then game.Loaded:Wait() end

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")

local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")

-- CONSTANTS
local SECOND_SEA = 4442272183
local THIRD_SEA  = 7449423635
local NO_FRUIT_TIMEOUT = 20
local REGIONS = {"germany","singapore"}
local MAX_JOIN_RETRY = 5
local JOIN_WAIT = 8

-- FLAGS
local PAUSED = false
local STATUS = "Initializing"
local noFruitStart = nil

-- TIME
local START_TIME = tick()
local SESSION_TIME = tick()

-- ================= CHARACTER =================
local function getChar()
    local c = LP.Character or LP.CharacterAdded:Wait()
    return c, c:WaitForChild("HumanoidRootPart"), c:WaitForChild("Humanoid")
end

-- ================= AUTO TEAM (MARINES) =================
task.spawn(function()
    repeat task.wait() until PlayerGui:FindFirstChild("ChooseTeam", true)
    local gui = PlayerGui:FindFirstChild("ChooseTeam", true)
    if gui and gui:FindFirstChild("Marines", true) then
        STATUS = "Choosing Marines"
        pcall(function()
            gui.Marines.Activate:Fire()
        end)
    end
end)

-- ================= GUI =================
local gui = Instance.new("ScreenGui", PlayerGui)
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.35,0.26)
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
pauseBtn.BackgroundColor3 = Color3.fromRGB(90,0,0)
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

RunService.RenderStepped:Connect(function()
    label.Text =
        "Total: "..math.floor(tick()-START_TIME).."s\n"..
        "Session: "..math.floor(tick()-SESSION_TIME).."s\n"..
        "Status: "..STATUS
end)

-- ================= MOVEMENT =================
local function flyTo(pos)
    if PAUSED then return end
    local _, hrp = getChar()
    local d = (hrp.Position - pos).Magnitude
    TweenService:Create(
        hrp,
        TweenInfo.new(math.max(0.1, d/350)),
        {CFrame = CFrame.new(pos)}
    ):Play()
    task.wait(d/350)
end

-- ================= COMBAT =================
local function key(k)
    VirtualInputManager:SendKeyEvent(true,k,false,game)
    task.wait()
    VirtualInputManager:SendKeyEvent(false,k,false,game)
end

local function click()
    VirtualInputManager:SendMouseButtonEvent(0,0,0,true,game,0)
    task.wait()
    VirtualInputManager:SendMouseButtonEvent(0,0,0,false,game,0)
end

local function combo()
    click()
    key(Enum.KeyCode.Z)
    key(Enum.KeyCode.X)
    key(Enum.KeyCode.C)
end

-- ================= FRUIT =================
local function findFruit()
    for _,v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Tool") and v:FindFirstChild("Handle")
        and v.Name:lower():find("fruit") then
            return v
        end
    end
end

local function storeFruit()
    for i=1,6 do
        pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit")
        end)
        task.wait(0.3)
    end
end

-- ================= FACTORY =================
local function findFactory()
    return Workspace:FindFirstChild("Factory")
end

-- ================= PIRATES =================
local function findPirate()
    if not Workspace:FindFirstChild("Enemies") then return end
    for _,v in pairs(Workspace.Enemies:GetChildren()) do
        if v:FindFirstChild("HumanoidRootPart")
        and v:FindFirstChild("Humanoid")
        and v.Name:lower():find("pirate") then
            return v
        end
    end
end

-- ================= SERVER HOP (GUI) =================
local function clickUI(ui)
    local pos = ui.AbsolutePosition + (ui.AbsoluteSize / 2)
    VirtualInputManager:SendMouseButtonEvent(pos.X,pos.Y,0,true,game,0)
    task.wait()
    VirtualInputManager:SendMouseButtonEvent(pos.X,pos.Y,0,false,game,0)
end

local function serverHopGUI(region)
    STATUS = "Server Hop: "..region

    -- open server list
    for _,v in pairs(PlayerGui:GetDescendants()) do
        if v:IsA("ImageButton") and v.Name:lower():find("server") then
            clickUI(v)
            task.wait(1)
            break
        end
    end

    -- search box
    local search
    for _,v in pairs(PlayerGui:GetDescendants()) do
        if v:IsA("TextBox") then
            search = v
            break
        end
    end
    if not search then return end

    search.Text = region
    task.wait(1)

    -- join
    for _,v in pairs(PlayerGui:GetDescendants()) do
        if v:IsA("TextButton") and v.Text:lower():find("join") then
            clickUI(v)
            return
        end
    end
end

local function smartServerHop()
    for i=1,MAX_JOIN_RETRY do
        local region = REGIONS[(i-1)%#REGIONS+1]
        STATUS = "Trying "..region.." ("..i..")"
        serverHopGUI(region)
        task.wait(JOIN_WAIT)
    end
    STATUS = "Server Hop Failed"
end

-- ================= MAIN LOOP =================
task.spawn(function()
    while true do
        if PAUSED then task.wait(1) continue end

        local fruit = findFruit()

        if fruit then
            STATUS = "Fruit Found: "..fruit.Name
            noFruitStart = nil
            flyTo(fruit.Handle.Position + Vector3.new(0,3,0))
            task.wait(0.4)
            storeFruit()

        else
            STATUS = "Searching Fruit"
            if not noFruitStart then
                noFruitStart = tick()
            end

            if tick() - noFruitStart >= NO_FRUIT_TIMEOUT then
                if game.PlaceId == SECOND_SEA then
                    STATUS = "Searching Factory"
                    local f = findFactory()
                    if f and f:FindFirstChild("HumanoidRootPart") then
                        flyTo(f.HumanoidRootPart.Position)
                        repeat task.wait(0.3) combo() until not f.Parent
                    else
                        smartServerHop()
                    end
                elseif game.PlaceId == THIRD_SEA then
                    STATUS = "Searching Pirates"
                    local p = findPirate()
                    if p then
                        flyTo(p.HumanoidRootPart.Position)
                        repeat task.wait(0.3) combo() until p.Humanoid.Health <= 0
                    else
                        smartServerHop()
                    end
                else
                    smartServerHop()
                end
                noFruitStart = nil
            end
        end

        task.wait(1)
    end
end)
