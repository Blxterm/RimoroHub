--==================================================
-- AUTO BLOX FRUITS V2 PRO
--==================================================

--==================== SERVICES ====================
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

--==================== CONFIG ======================
local FRUIT_SEARCH_TIME = 20
local FACTORY_TIME = 10
local GACHA_TIME = 10
local STORE_TRIES = 6
local REGIONS = {"germany","singapore"}
local JOIN_TIMEOUT = 8
local MAX_JOIN_TRIES = 5

--==================== STATE =======================
local START_TIME = tick()
local SESSION_START = tick()
local PAUSED = false
local STATUS = "Idle"

--==================== UTILS =======================
local function click(ui)
    if not ui then return end
    local pos = ui.AbsolutePosition + (ui.AbsoluteSize / 2)
    VirtualInputManager:SendMouseButtonEvent(pos.X,pos.Y,0,true,game,0)
    task.wait(0.05)
    VirtualInputManager:SendMouseButtonEvent(pos.X,pos.Y,0,false,game,0)
end

local function setStatus(t)
    STATUS = t
    print("[STATUS]",t)
end

--==================== UI ==========================
local ScreenGui = Instance.new("ScreenGui",PlayerGui)
ScreenGui.Name = "AutoV2UI"

local Frame = Instance.new("Frame",ScreenGui)
Frame.Size = UDim2.fromScale(0.28,0.14)
Frame.Position = UDim2.fromScale(0.36,0.04)
Frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
Frame.BackgroundTransparency = 0.25

local Label = Instance.new("TextLabel",Frame)
Label.Size = UDim2.fromScale(1,1)
Label.BackgroundTransparency = 1
Label.TextColor3 = Color3.new(1,1,1)
Label.TextScaled = true

Frame.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        PAUSED = not PAUSED
        setStatus(PAUSED and "PAUSED" or "RESUMED")
    end
end)

RunService.RenderStepped:Connect(function()
    if PAUSED then
        Label.Text = "PAUSED"
        return
    end
    Label.Text =
        "Total: "..math.floor(tick()-START_TIME).."s\n"..
        "Session: "..math.floor(tick()-SESSION_START).."s\n"..
        "Status: "..STATUS
end)

--==================== TEAM SELECT =================
local function isBlue(c)
    return c.B > 0.6 and c.B > c.R and c.B > c.G
end

local function selectMarines()
    local screenX = Workspace.CurrentCamera.ViewportSize.X
    local screenY = Workspace.CurrentCamera.ViewportSize.Y

    for _,v in pairs(PlayerGui:GetDescendants()) do
        if v:IsA("ImageButton") then
            local pos,size = v.AbsolutePosition,v.AbsoluteSize
            if pos.X > screenX*0.45 and pos.Y > screenY*0.35 then
                if size.X > 100 and size.Y > 100 then
                    if isBlue(v.ImageColor3) or isBlue(v.BackgroundColor3) then
                        click(v)
                        task.wait(1)
                        return true
                    end
                end
            end
        end
    end
    return false
end

--==================== FRUIT =======================
local function findFruit()
    for _,v in pairs(Workspace:GetChildren()) do
        if v:IsA("Tool") and v:FindFirstChild("Handle") then
            if v.Name:lower():find("fruit") then
                return v
            end
        end
    end
end

local function storeFruit()
    setStatus("Storing Fruit")
    for i=1,STORE_TRIES do
        for _,v in pairs(PlayerGui:GetDescendants()) do
            if v:IsA("TextButton") and v.Text:lower():find("store") then
                click(v)
                task.wait(0.4)
            end
        end
        task.wait(0.6)
    end
end

--==================== SERVER HOP ==================
local function serverHop()
    setStatus("Server Hop")
    for _,v in pairs(PlayerGui:GetDescendants()) do
        if v:IsA("ImageButton") and v.Name:lower():find("server") then
            click(v)
            task.wait(1)
            break
        end
    end

    for _,region in ipairs(REGIONS) do
        for _,v in pairs(PlayerGui:GetDescendants()) do
            if v:IsA("TextBox") and v.PlaceholderText:lower():find("region") then
                v.Text = region
                task.wait(1)
            end
        end

        for try=1,MAX_JOIN_TRIES do
            for _,v in pairs(PlayerGui:GetDescendants()) do
                if v:IsA("TextButton") and v.Text:lower()=="join" then
                    click(v)
                    task.wait(JOIN_TIMEOUT)
                end
            end
        end
    end
end

--==================== MAIN ========================
task.spawn(function()
    repeat task.wait(1) until selectMarines()

    while true do
        task.wait(1)
        if PAUSED then continue end

        -- Fruit Search
        setStatus("Fruit Searching")
        local t0 = tick()
        while tick()-t0 < FRUIT_SEARCH_TIME do
            local fruit = findFruit()
            if fruit and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                setStatus("Fruit Found: "..fruit.Name)
                fruit.Handle.CFrame = Player.Character.HumanoidRootPart.CFrame
                task.wait(1)
                storeFruit()
                break
            end
            task.wait(0.5)
        end

        -- Factory / Pirates / Gacha skipped → Hop
        setStatus("No Fruit - Hop")
        serverHop()
        task.wait(5)
    end
end)
