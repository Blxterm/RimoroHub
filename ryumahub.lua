-- Blox Fruits Auto Fruit + Factory + Smart Server Hop

if not game:IsLoaded() then game.Loaded:Wait() end

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Stats = game:GetService("Stats")

local LP = Players.LocalPlayer
local Char = LP.Character or LP.CharacterAdded:Wait()
local HRP = Char:WaitForChild("HumanoidRootPart")

LP.CharacterAdded:Connect(function(c)
    Char = c
    HRP = c:WaitForChild("HumanoidRootPart")
end)

-- ================= TIME =================
local startTime = os.clock()
local sessionTime = os.clock()

-- ================= GUI =================
local gui = Instance.new("ScreenGui", LP.PlayerGui)
gui.Name = "AutoFruitUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.34, 0.22)
frame.Position = UDim2.fromScale(0.33, 0.04)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)

local info = Instance.new("TextLabel", frame)
info.Size = UDim2.fromScale(1,1)
info.TextWrapped = true
info.TextScaled = true
info.TextColor3 = Color3.new(1,1,1)
info.BackgroundTransparency = 1

-- ================= MOVEMENT =================
local function flyTo(pos)
    local dist = (HRP.Position - pos).Magnitude
    local t = math.max(0.1, dist / 380)
    TweenService:Create(
        HRP,
        TweenInfo.new(t, Enum.EasingStyle.Linear),
        {CFrame = CFrame.new(pos)}
    ):Play()
    task.wait(t)
end

-- ================= FRUIT FIND =================
local function findFruit()
    for _,v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Tool") and v:FindFirstChild("Handle") then
            if v.Name:lower():find("fruit") then
                return v
            end
        end
    end
end

-- ================= FRUIT INDICATOR =================
local function attachIndicator(fruit)
    if fruit.Handle:FindFirstChild("FruitESP") then return end
    local bill = Instance.new("BillboardGui", fruit.Handle)
    bill.Name = "FruitESP"
    bill.Size = UDim2.fromScale(5,2)
    bill.AlwaysOnTop = true

    local txt = Instance.new("TextLabel", bill)
    txt.Size = UDim2.fromScale(1,1)
    txt.BackgroundTransparency = 1
    txt.TextScaled = true
    txt.TextColor3 = Color3.new(1,0.5,0)
    txt.Text = fruit.Name
end

-- ================= STORE FRUIT =================
local function storeFruit()
    for i=1,6 do
        pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit")
        end)
        task.wait(0.35)
    end
end

-- ================= SECOND SEA =================
local function isSecondSea()
    return game.PlaceId == 4442272183
end

local function findFactory()
    return Workspace:FindFirstChild("Factory")
end

-- ================= SERVER HOP (LOW PING) =================
local function getPing()
    return Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
end

local function serverHop()
    local data = HttpService:JSONDecode(
        game:HttpGet(
            "https://games.roblox.com/v1/games/"..
            game.PlaceId..
            "/servers/Public?limit=100"
        )
    )

    local bestServer
    for _,s in pairs(data.data) do
        if s.playing < s.maxPlayers and s.id ~= game.JobId then
            if not bestServer or s.ping < bestServer.ping then
                bestServer = s
            end
        end
    end

    if bestServer then
        TeleportService:TeleportToPlaceInstance(
            game.PlaceId,
            bestServer.id,
            LP
        )
    end
end

-- ================= MAIN LOOP =================
task.spawn(function()
    while true do
        local fruit = findFruit()

        if fruit and fruit:FindFirstChild("Handle") then
            attachIndicator(fruit)

            local dist = math.floor(
                (HRP.Position - fruit.Handle.Position).Magnitude
            )

            info.Text =
                "Total Time: "..math.floor(os.clock()-startTime).."s\n"..
                "Session Time: "..math.floor(os.clock()-sessionTime).."s\n"..
                "Fruit: "..fruit.Name.."\n"..
                "Distance: "..dist.."m"

            flyTo(fruit.Handle.Position + Vector3.new(0,3,0))
            task.wait(0.5)
            storeFruit()
            task.wait(2)

        else
            info.Text =
                "Total Time: "..math.floor(os.clock()-startTime).."s\n"..
                "Session Time: "..math.floor(os.clock()-sessionTime).."s\n"..
                "Fruit: None\nSearching..."

            if isSecondSea() then
                local factory = findFactory()
                if factory and factory:FindFirstChild("HumanoidRootPart") then
                    flyTo(factory.HumanoidRootPart.Position)
                else
                    serverHop()
                end
            else
                serverHop()
            end
        end

        task.wait(1.5)
    end
end)
