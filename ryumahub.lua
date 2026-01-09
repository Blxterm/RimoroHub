-- Blox Fruits Auto Fruit / Factory + Session Time UI

if not game:IsLoaded() then game.Loaded:Wait() end

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")

local LP = Players.LocalPlayer
local Char = LP.Character or LP.CharacterAdded:Wait()
local HRP = Char:WaitForChild("HumanoidRootPart")

LP.CharacterAdded:Connect(function(c)
    Char = c
    HRP = c:WaitForChild("HumanoidRootPart")
end)

-- ================= TIME TRACKING =================
local scriptStart = os.clock()
local sessionStart = os.clock()

-- ================= GUI =================
local gui = Instance.new("ScreenGui", LP.PlayerGui)
gui.Name = "AutoFruitUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.32, 0.18)
frame.Position = UDim2.fromScale(0.34, 0.05)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)

local totalLabel = Instance.new("TextLabel", frame)
totalLabel.Size = UDim2.fromScale(1, 0.45)
totalLabel.TextScaled = true
totalLabel.TextColor3 = Color3.new(1,1,1)
totalLabel.BackgroundTransparency = 1

local sessionLabel = Instance.new("TextLabel", frame)
sessionLabel.Size = UDim2.fromScale(1, 0.45)
sessionLabel.Position = UDim2.fromScale(0, 0.5)
sessionLabel.TextScaled = true
sessionLabel.TextColor3 = Color3.new(1,1,1)
sessionLabel.BackgroundTransparency = 1

RunService.RenderStepped:Connect(function()
    totalLabel.Text =
        "Total Runtime: " .. math.floor(os.clock() - scriptStart) .. "s"
    sessionLabel.Text =
        "Session Time: " .. math.floor(os.clock() - sessionStart) .. "s"
end)

-- ================= MOVEMENT =================
local function flyTo(pos)
    local dist = (HRP.Position - pos).Magnitude
    local time = math.max(0.1, dist / 350)
    TweenService:Create(
        HRP,
        TweenInfo.new(time, Enum.EasingStyle.Linear),
        {CFrame = CFrame.new(pos)}
    ):Play()
    task.wait(time)
end

-- ================= FRUIT DETECTION =================
local function findFruit()
    for _,v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Tool") and v.Name:lower():find("fruit") then
            return v
        end
    end
end

-- ================= STORE FRUIT =================
local function storeFruit()
    for i = 1, 6 do
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(
                "StoreFruit"
            )
        end)
        task.wait(0.3)
    end
end

-- ================= FACTORY (SECOND SEA) =================
local function inSecondSea()
    return game.PlaceId == 4442272183
end

local function findFactory()
    return Workspace:FindFirstChild("Factory")
end

-- ================= SERVER HOP =================
local function serverHop()
    local data = HttpService:JSONDecode(
        game:HttpGet(
            "https://games.roblox.com/v1/games/" ..
            game.PlaceId ..
            "/servers/Public?limit=100"
        )
    )
    for _,s in pairs(data.data) do
        if s.playing < s.maxPlayers and s.id ~= game.JobId then
            TeleportService:TeleportToPlaceInstance(
                game.PlaceId,
                s.id,
                LP
            )
            return
        end
    end
end

-- ================= MAIN LOGIC =================
task.spawn(function()
    while true do
        -- 1️⃣ Fruit
        local fruit = findFruit()
        if fruit and fruit:FindFirstChild("Handle") then
            flyTo(fruit.Handle.Position)
            task.wait(0.5)
            storeFruit()
            task.wait(2)
        else
            -- 2️⃣ Factory
            if inSecondSea() then
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
        task.wait(2)
    end
end)
