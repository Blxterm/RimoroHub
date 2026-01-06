--==================================================
-- Blox Fruits Auto Combo Complete
--==================================================

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local VirtualInput = game:GetService("VirtualInputManager")

-- Player
local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

-- Combo Data
local combo = {}
local executing = false
local target = nil
local aimlockEnabled = false

-- Circle Part
local circlePart = Instance.new("Part")
circlePart.Anchored = true
circlePart.CanCollide = false
circlePart.Size = Vector3.new(15*2,0.1,15*2)
circlePart.Material = Enum.Material.Neon
circlePart.Color = Color3.fromRGB(255,0,0)
circlePart.Transparency = 0.3
circlePart.Name = "ComboZone"
local mesh = Instance.new("CylinderMesh",circlePart)
circlePart.Orientation = Vector3.new(0,0,90)
local circleEnabled = true
local circleRadius = 15

-- Update Circle Position
RunService.RenderStepped:Connect(function()
    if circleEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        circlePart.Position = player.Character.HumanoidRootPart.Position
        circlePart.Parent = Workspace
    end
    if aimlockEnabled and target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        camera.CFrame = CFrame.new(camera.CFrame.Position,target.Character.HumanoidRootPart.Position)
    end
end)

-- Helper Functions
local function validTarget(plr)
    if not plr or plr == player then return false end
    if not plr.Character then return false end
    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum or hum.Health <= 0 then return false end
    local myHRP = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP then return false end
    local dist = (myHRP.Position - hrp.Position).Magnitude
    if dist > circleRadius then return false end
    return true
end

local function getTargetInCircle()
    local closest, minDist = nil, circleRadius
    for _,p in pairs(Players:GetPlayers()) do
        if validTarget(p) then
            local d = (player.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
            if d < minDist then
                minDist = d
                closest = p
            end
        end
    end
    return closest
end

-- GUI
local gui = Instance.new("ScreenGui",game.CoreGui)
gui.Name = "AutoComboGUI"

local frame = Instance.new("Frame",gui)
frame.Size = UDim2.new(0,500,0,600)
frame.Position = UDim2.new(0.5,-250,0.5,-300)
frame.BackgroundColor3 = Color3.fromRGB(30,30,40)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel",frame)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundColor3 = Color3.fromRGB(20,20,30)
title.Text = "Blox Fruits Auto Combo GUI"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20

-- Select Order 4 Steps
local selectOrder = {}
local orderDropdowns = {}
local options = {"Sword","Fruit","Style","Gun"}

for i=1,4 do
    local lbl = Instance.new("TextLabel",frame)
    lbl.Size = UDim2.new(0.4,0,0,30)
    lbl.Position = UDim2.new(0.05,0,0.05+0.12*i,0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "Step "..i
    lbl.TextColor3 = Color3.fromRGB(255,255,255)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local dropdown = Instance.new("TextButton",frame)
    dropdown.Size = UDim2.new(0.5,0,0,30)
    dropdown.Position = UDim2.new(0.45,0,0.05+0.12*i,0)
    dropdown.Text = "Select Tool"
    dropdown.Font = Enum.Font.GothamBold
    dropdown.TextSize = 14
    dropdown.TextColor3 = Color3.fromRGB(255,255,255)
    dropdown.BackgroundColor3 = Color3.fromRGB(60,60,80)

    local menu = Instance.new("Frame",frame)
    menu.Size = UDim2.new(0.5,0,0,#options*30)
    menu.Position = UDim2.new(0.45,0,0.05+0.12*i+0.03,0)
    menu.BackgroundColor3 = Color3.fromRGB(50,50,70)
    menu.Visible = false

    for j,opt in pairs(options) do
        local optBtn = Instance.new("TextButton",menu)
        optBtn.Size = UDim2.new(1,0,0,30)
        optBtn.Position = UDim2.new(0,0,(j-1)*30,0)
        optBtn.Text = opt
        optBtn.Font = Enum.Font.Gotham
        optBtn.TextSize = 14
        optBtn.BackgroundColor3 = Color3.fromRGB(70,70,100)
        optBtn.TextColor3 = Color3.fromRGB(255,255,255)

        optBtn.MouseButton1Click:Connect(function()
            dropdown.Text = opt
            selectOrder[i] = opt
            menu.Visible = false
            for k=i+1,4 do
                if orderDropdowns[k] and selectOrder[k]==opt then
                    selectOrder[k] = nil
                    orderDropdowns[k].Text = "Select Tool"
                end
            end
        end)
    end

    dropdown.MouseButton1Click:Connect(function()
        menu.Visible = not menu.Visible
    end)

    orderDropdowns[i] = dropdown
end

-- Moves Dropdowns
local moveOptions = {
    Sword={"Z","X","C","V"},
    Fruit={"Z","X","C","V"},
    Style={"Z","X","C","V"},
    Gun={"Z","X","C","V"}
}

local moveSelections = {} -- لكل أداة الحركات المختارة
local yPos = 0.55
for i, tool in pairs(options) do
    local lbl = Instance.new("TextLabel",frame)
    lbl.Size = UDim2.new(0.4,0,0,30)
    lbl.Position = UDim2.new(0.05,0,yPos,0)
    lbl.BackgroundTransparency = 1
    lbl.Text = tool.." Moves"
    lbl.TextColor3 = Color3.fromRGB(255,255,255)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 14
    yPos = yPos + 0.06

    local movesDropdown = Instance.new("TextButton",frame)
    movesDropdown.Size = UDim2.new(0.5,0,0,30)
    movesDropdown.Position = UDim2.new(0.45,0,yPos,0)
    movesDropdown.Text = "Select Moves"
    movesDropdown.Font = Enum.Font.GothamBold
    movesDropdown.TextSize = 14
    movesDropdown.TextColor3 = Color3.fromRGB(255,255,255)
    movesDropdown.BackgroundColor3 = Color3.fromRGB(60,60,80)

    local menu = Instance.new("Frame",frame)
    menu.Size = UDim2.new(0.5,0,0,#moveOptions[tool]*30)
    menu.Position = UDim2.new(0.45,0,yPos+0.03,0)
    menu.BackgroundColor3 = Color3.fromRGB(50,50,70)
    menu.Visible = false

    moveSelections[tool] = {}

    for j,opt in pairs(moveOptions[tool]) do
        local optBtn = Instance.new("TextButton",menu)
        optBtn.Size = UDim2.new(1,0,0,30)
        optBtn.Position = UDim2.new(0,0,(j-1)*30,0)
        optBtn.Text = opt
        optBtn.Font = Enum.Font.Gotham
        optBtn.TextSize = 14
        optBtn.BackgroundColor3 = Color3.fromRGB(70,70,100)
        optBtn.TextColor3 = Color3.fromRGB(255,255,255)

        optBtn.MouseButton1Click:Connect(function()
            table.insert(moveSelections[tool], opt)
            movesDropdown.Text = table.concat(moveSelections[tool],",")
        end)
    end

    movesDropdown.MouseButton1Click:Connect(function()
        menu.Visible = not menu.Visible
    end)

    yPos = yPos + 0.06
end

-- Save & Execute
local saveBtn = Instance.new("TextButton",frame)
saveBtn.Size = UDim2.new(0.9,0,0,40)
saveBtn.Position = UDim2.new(0.05,0,0.92,0)
saveBtn.Text = "Save Combo"
saveBtn.Font = Enum.Font.GothamBold
saveBtn.TextSize = 16
saveBtn.TextColor3 = Color3.fromRGB(255,255,255)
saveBtn.BackgroundColor3 = Color3.fromRGB(80,80,120)

saveBtn.MouseButton1Click:Connect(function()
    combo = {}
    for i=1,#selectOrder do
        local tool = selectOrder[i]
        if tool then
            for _, mv in pairs(moveSelections[tool]) do
                table.insert(combo,{tool=tool,move=mv})
            end
        end
    end
    frame.Visible = false

    -- زر تنفيذ الكومبو
    local execBtn = Instance.new("TextButton",gui)
    execBtn.Size = UDim2.new(0.3,0,0,40)
    execBtn.Position = UDim2.new(0.35,0,0.92,0)
    execBtn.Text = "Execute Combo"
    execBtn.Font = Enum.Font.GothamBold
    execBtn.TextSize = 16
    execBtn.TextColor3 = Color3.fromRGB(255,255,255)
    execBtn.BackgroundColor3 = Color3.fromRGB(255,50,50)

    execBtn.MouseButton1Click:Connect(function()
        target = getTargetInCircle()
        if not target then
            warn("No target in circle!")
            return
        end

        -- Fly سريع + Aimlock
        local hrp = player.Character.HumanoidRootPart
        local tgtHRP = target.Character.HumanoidRootPart
        aimlockEnabled = true
        local flySpeed = 150
        local reached = false
        while target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and not reached do
            local dir = (tgtHRP.Position - hrp.Position)
            if dir.Magnitude < 3 then
                reached = true
            else
                hrp.CFrame = hrp.CFrame + dir.Unit * flySpeed * RunService.RenderStepped:Wait()
            end
            camera.CFrame = CFrame.new(camera.CFrame.Position, tgtHRP.Position)
        end

        -- تنفيذ الكومبو
        local keyMap = {Z=Enum.KeyCode.Z,X=Enum.KeyCode.X,C=Enum.KeyCode.C,V=Enum.KeyCode.V}
        for _, act in pairs(combo) do
            local key = keyMap[act.move]
            if key then
                VirtualInput:SendKeyEvent(true,key,false,game)
                wait(0.1)
                VirtualInput:SendKeyEvent(false,key,false,game)
                wait(0.2)
            end
        end

        aimlockEnabled = false
    end)
end)

print("✅ Blox Fruits Auto Combo Ultimate Loaded")
