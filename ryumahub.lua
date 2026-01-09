-- Blox Fruits AUTO: Fruit / Factory / Pirates / Server Hop + PAUSE

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
local Humanoid = Char:WaitForChild("Humanoid")

LP.CharacterAdded:Connect(function(c)
    Char = c
    HRP = c:WaitForChild("HumanoidRootPart")
    Humanoid = c:WaitForChild("Humanoid")
end)

-- TIME
local startTime = tick()
local sessionTime = tick()

-- TEAM AUTO (MARINES)
pcall(function()
    if not LP.Team and Teams:FindFirstChild("Marines") then
        LP.Team = Teams.Marines
    end
end)

-- ================= PAUSE FLAG =================
local PAUSED = false

-- ================= GUI =================
local gui = Instance.new("ScreenGui", LP.PlayerGui)
gui.Name = "AutoBF_UI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.34,0.24)
frame.Position = UDim2.fromScale(0.33,0.05)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)

local label = Instance.new("TextLabel", frame)
label.Size = UDim2.fromScale(1,0.8)
label.BackgroundTransparency = 1
label.TextColor3 = Color3.new(1,1,1)
label.TextScaled = true
label.TextWrapped = true

-- PAUSE BUTTON
local pauseBtn = Instance.new("TextButton", frame)
pauseBtn.Size = UDim2.fromScale(1,0.2)
pauseBtn.Position = UDim2.fromScale(0,0.8)
pauseBtn.Text = "⏸️ PAUSE"
pauseBtn.TextScaled = true
pauseBtn.BackgroundColor3 = Color3.fromRGB(60,0,0)
pauseBtn.TextColor3 = Color3.new(1,1,1)

pauseBtn.MouseButton1Click:Connect(function()
    PAUSED = not PAUSED
    if PAUSED then
        frame.Visible = false
    else
        frame.Visible = true
        sessionTime = tick() -- إعادة حساب جلسة جديدة
    end
end)

-- UI UPDATE
RunService.RenderStepped:Connect(function()
    if PAUSED then return end
    label.Text =
        "Total: "..math.floor(tick()-startTime).."s\n"..
        "Session: "..math.floor(tick()-sessionTime).."s\n"
end)

-- ================= MOVEMENT =================
local function flyTo(pos)
    if PAUSED then return end
    local dist = (HRP.Position - pos).Magnitude
    local t = math.max(0.1, dist/400)
    TweenService:Create(
        HRP,
        TweenInfo.new(t, Enum.EasingStyle.Linear),
        {CFrame = CFrame.new(pos)}
    ):Play()
    task.wait(t)
end

-- ================= INPUT =================
local function click()
    if PAUSED then return end
    VirtualInputManager:SendMouseButtonEvent(0,0,0,true,game,0)
    task.wait()
    VirtualInputManager:SendMouseButtonEvent(0,0,0,false,game,0)
end

local function key(k)
    if PAUSED then return end
    VirtualInputManager:SendKeyEvent(true,k,false,game)
    task.wait()
    VirtualInputManager:SendKeyEvent(false,k,false,game)
end

local function combo()
    click()
    key(Enum.KeyCode.Z)
    key(Enum.KeyCode.X)
    key(Enum.KeyCode.C)
end

-- ================= FIND FRUIT =================
local function findFruit()
    for _,v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Tool") and v:FindFirstChild("Handle") then
            if v.Name:lower():find("fruit") then
                return v
            end
        end
    end
end

-- ================= STORE FRUIT =================
local function storeFruit()
    for i=1,6 do
        if PAUSED then return false end
        local ok = pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit")
        end)
        if not ok then return false end
        task.wait(0.4)
    end
    return true
end

-- ================= WORLDS =================
local SECOND_SEA = 4442272183
local THIRD_SEA  = 7449423635

local function findFactory()
    return Workspace:FindFirstChild("Factory")
end

local function findPirates()
    if not Workspace:FindFirstChild("Enemies") then return end
    for _,v in pairs(Workspace.Enemies:GetChildren()) do
        if v:FindFirstChild("HumanoidRootPart")
        and v:FindFirstChild("Humanoid")
        and v.Name:lower():find("pirate") then
            return v
        end
    end
end

-- ================= SERVER HOP =================
local function serverHop()
    if PAUSED then return end
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

-- ================= MAIN LOOP =================
local noFruitTimer = nil

task.spawn(function()
    while true do
        if PAUSED then
            task.wait(0.5)
            continue
        end

        local fruit = findFruit()

        if fruit then
            noFruitTimer = nil
            local dist = math.floor((HRP.Position - fruit.Handle.Position).Magnitude)
            label.Text ..= "Status: Fruit "..fruit.Name.." ("..dist.."m)\n"

            flyTo(fruit.Handle.Position + Vector3.new(0,3,0))
            task.wait(0.5)

            if not storeFruit() then
                serverHop()
            end
        else
            if not noFruitTimer then
                noFruitTimer = tick()
            end

            local elapsed = tick() - noFruitTimer
            label.Text ..= "No Fruit: "..math.floor(elapsed).."/20s\n"

            if elapsed >= 20 then
                if game.PlaceId == SECOND_SEA then
                    local factory = findFactory()
                    if factory and factory:FindFirstChild("HumanoidRootPart") then
                        flyTo(factory.HumanoidRootPart.Position)
                        repeat
                            if PAUSED then break end
                            combo()
                            task.wait(0.3)
                        until not factory or not factory.Parent
                    else
                        serverHop()
                    end
                elseif game.PlaceId == THIRD_SEA then
                    local pirate = findPirates()
                    if pirate then
                        flyTo(pirate.HumanoidRootPart.Position)
                        repeat
                            if PAUSED then break end
                            combo()
                            task.wait(0.3)
                        until pirate.Humanoid.Health <= 0
                    else
                        serverHop()
                    end
                else
                    serverHop()
                end
                noFruitTimer = nil
            end
        end
        task.wait(1)
    end
end)
