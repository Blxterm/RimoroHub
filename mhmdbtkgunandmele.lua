--[[
    ═══════════════════════════════════════
           محمد البتك HUB — Aura Attack
    ═══════════════════════════════════════
    - يضرب كل الأهداف داخل المجال في نفس الوقت
    - لاعبين + NPCs
    - ما يوقف حركة اللاعب
]]

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService  = game:GetService("UserInputService")
local Workspace         = game:GetService("Workspace")

local LP = Players.LocalPlayer

local STUD_TO_METER = 0.28
local METER_TO_STUD = 1 / STUD_TO_METER  -- ≈ 3.571

local CONFIG = {
    AIM_Y_OFFSET = 1.5,
}

local auraOn      = false
local cooldown    = 0.1
local rangeMeters = 500

-- ═══════ الريموتات ═══════
local Net            = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net")
local RegisterAttack = Net:WaitForChild("RE/RegisterAttack")
local RegisterHit    = Net:WaitForChild("RE/RegisterHit")

-- ═══════ GUI ═══════
local gui = Instance.new("ScreenGui")
gui.Name = "MohamedAlbatakHub"
gui.ResetOnSpawn = false
gui.Parent = LP:WaitForChild("PlayerGui")

-- ═══════ الدائرة ═══════
local circleBtn = Instance.new("TextButton")
circleBtn.Size = UDim2.new(0, 55, 0, 55)
circleBtn.Position = UDim2.new(0, 30, 0.5, -27)
circleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
circleBtn.Text = "⚔️"
circleBtn.TextColor3 = Color3.fromRGB(200, 150, 255)
circleBtn.TextSize = 26
circleBtn.Font = Enum.Font.GothamBold
circleBtn.Active = true
circleBtn.Draggable = true
circleBtn.Parent = gui
Instance.new("UICorner", circleBtn).CornerRadius = UDim.new(1, 0)

local circleStroke = Instance.new("UIStroke", circleBtn)
circleStroke.Color = Color3.fromRGB(160, 60, 220)
circleStroke.Thickness = 2

-- ═══════ اللوحة ═══════
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 290)
mainFrame.Position = UDim2.new(0, 30, 0.5, -145)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = false
mainFrame.Parent = gui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 14)

local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Color = Color3.fromRGB(160, 60, 220)
mainStroke.Thickness = 2

local titleLbl = Instance.new("TextLabel")
titleLbl.Size = UDim2.new(1, 0, 0, 38)
titleLbl.BackgroundColor3 = Color3.fromRGB(50, 30, 75)
titleLbl.Text = "محمد البتك HUB"
titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLbl.TextSize = 16
titleLbl.Font = Enum.Font.GothamBlack
titleLbl.Parent = mainFrame
Instance.new("UICorner", titleLbl).CornerRadius = UDim.new(0, 14)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 26, 0, 26)
closeBtn.Position = UDim2.new(1, -30, 0, 6)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 14
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = mainFrame
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.9, 0, 0, 45)
toggleBtn.Position = UDim2.new(0.05, 0, 0, 50)
toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
toggleBtn.Text = "AURA: OFF"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize = 15
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Parent = mainFrame
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 10)

-- مربع المجال
local rangeTitle = Instance.new("TextLabel")
rangeTitle.Size = UDim2.new(0.9, 0, 0, 20)
rangeTitle.Position = UDim2.new(0.05, 0, 0, 105)
rangeTitle.BackgroundTransparency = 1
rangeTitle.Text = "📏 المجال (بالأمتار):"
rangeTitle.TextColor3 = Color3.fromRGB(200, 200, 230)
rangeTitle.TextSize = 12
rangeTitle.Font = Enum.Font.GothamBold
rangeTitle.TextXAlignment = Enum.TextXAlignment.Left
rangeTitle.Parent = mainFrame

local rangeBox = Instance.new("TextBox")
rangeBox.Size = UDim2.new(0.9, 0, 0, 32)
rangeBox.Position = UDim2.new(0.05, 0, 0, 128)
rangeBox.BackgroundColor3 = Color3.fromRGB(32, 32, 45)
rangeBox.Text = "500"
rangeBox.PlaceholderText = "500"
rangeBox.TextColor3 = Color3.fromRGB(180, 255, 200)
rangeBox.TextSize = 14
rangeBox.Font = Enum.Font.Code
rangeBox.ClearTextOnFocus = false
rangeBox.Parent = mainFrame
Instance.new("UICorner", rangeBox).CornerRadius = UDim.new(0, 8)

-- مربع الكولداون
local cdTitle = Instance.new("TextLabel")
cdTitle.Size = UDim2.new(0.9, 0, 0, 20)
cdTitle.Position = UDim2.new(0.05, 0, 0, 168)
cdTitle.BackgroundTransparency = 1
cdTitle.Text = "⏱️ الكولداون (بالثواني):"
cdTitle.TextColor3 = Color3.fromRGB(200, 200, 230)
cdTitle.TextSize = 12
cdTitle.Font = Enum.Font.GothamBold
cdTitle.TextXAlignment = Enum.TextXAlignment.Left
cdTitle.Parent = mainFrame

local cdBox = Instance.new("TextBox")
cdBox.Size = UDim2.new(0.9, 0, 0, 32)
cdBox.Position = UDim2.new(0.05, 0, 0, 191)
cdBox.BackgroundColor3 = Color3.fromRGB(32, 32, 45)
cdBox.Text = "0.1"
cdBox.PlaceholderText = "0.1"
cdBox.TextColor3 = Color3.fromRGB(180, 220, 255)
cdBox.TextSize = 14
cdBox.Font = Enum.Font.Code
cdBox.ClearTextOnFocus = false
cdBox.Parent = mainFrame
Instance.new("UICorner", cdBox).CornerRadius = UDim.new(0, 8)

-- معلومات
local infoLbl = Instance.new("TextLabel")
infoLbl.Size = UDim2.new(0.9, 0, 0, 22)
infoLbl.Position = UDim2.new(0.05, 0, 0, 228)
infoLbl.BackgroundTransparency = 1
infoLbl.Text = "Range: 500m | Cooldown: 0.1s | Targets: 0"
infoLbl.TextColor3 = Color3.fromRGB(130, 200, 160)
infoLbl.TextSize = 11
infoLbl.Font = Enum.Font.Gotham
infoLbl.Parent = mainFrame

local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, 0, 0, 22)
footer.Position = UDim2.new(0, 0, 1, -24)
footer.BackgroundTransparency = 1
footer.Text = "محمد البتك HUB © Aura"
footer.TextColor3 = Color3.fromRGB(120, 120, 150)
footer.TextSize = 11
footer.Font = Enum.Font.Gotham
footer.Parent = mainFrame

-- ═══════ فتح/إغلاق ═══════
circleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- ═══════ ON/OFF ═══════
toggleBtn.MouseButton1Click:Connect(function()
    auraOn = not auraOn
    if auraOn then
        toggleBtn.Text = "AURA: ON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 200, 100)
        circleStroke.Color = Color3.fromRGB(80, 220, 120)
    else
        toggleBtn.Text = "AURA: OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
        circleStroke.Color = Color3.fromRGB(160, 60, 220)
    end
end)

-- ═══════ المعلومات ═══════
local targetsCount = 0

local function updateInfo()
    infoLbl.Text = string.format("Range: %.0fm | Cooldown: %.3fs | Targets: %d",
        rangeMeters, cooldown, targetsCount)
end

rangeBox.FocusLost:Connect(function()
    local num = tonumber(rangeBox.Text)
    if not num or num <= 0 then
        rangeBox.Text = tostring(rangeMeters)
        return
    end
    if num < 1 then num = 1 end
    if num > 5000 then num = 5000 end
    rangeMeters = num
    rangeBox.Text = tostring(num)
    updateInfo()
end)

cdBox.FocusLost:Connect(function()
    local num = tonumber(cdBox.Text)
    if not num or num <= 0 then
        cdBox.Text = tostring(cooldown)
        return
    end
    if num < 0.00000001 then num = 0.00000001 end
    if num > 10 then num = 10 end
    cooldown = num
    cdBox.Text = tostring(num)
    updateInfo()
end)

-- ═══════ دوال مساعدة ═══════
local function isAlive(char)
    if not char then return false end
    local h = char:FindFirstChildOfClass("Humanoid")
    return h and h.Health > 0
end

-- يجمع كل الأهداف (لاعبين + NPCs) داخل المجال
local function getAllTargets()
    local list = {}
    local myChar = LP.Character
    if not myChar then return list end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return list end

    local rangeStuds = rangeMeters * METER_TO_STUD

    -- اللاعبين
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character and isAlive(plr.Character) then
            local root = plr.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local d = (root.Position - myRoot.Position).Magnitude
                if d <= rangeStuds then
                    table.insert(list, plr.Character)
                end
            end
        end
    end

    -- NPCs في المجلدات المعروفة
    local folders = {"Enemies", "NPCs", "Characters", "Mobs", "Monsters", "Bosses"}
    for _, folderName in ipairs(folders) do
        local folder = Workspace:FindFirstChild(folderName)
        if folder then
            for _, e in ipairs(folder:GetChildren()) do
                if e ~= myChar and isAlive(e) then
                    local root = e:FindFirstChild("HumanoidRootPart")
                    if root then
                        local d = (root.Position - myRoot.Position).Magnitude
                        if d <= rangeStuds then
                            table.insert(list, e)
                        end
                    end
                end
            end
        end
    end

    return list
end

-- ═══════ الضربة (بدون ما توقف اللاعب) ═══════
local function attackTarget(target, myRoot)
    local tRoot = target:FindFirstChild("HumanoidRootPart")
    local tHead = target:FindFirstChild("Head")
    if not tRoot then return end

    local aimPos = tRoot.Position + Vector3.new(0, CONFIG.AIM_Y_OFFSET, 0)
    local dir = (aimPos - myRoot.Position).Unit

    local char = LP.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if tool and tool:FindFirstChild("LeftClickRemote") then
        pcall(function() tool.LeftClickRemote:FireServer(dir, 1) end)
    end

    pcall(function() RegisterAttack:FireServer(0.1, 1) end)

    local hitList = {}
    if tHead then table.insert(hitList, {target, tHead}) end
    table.insert(hitList, {target, tRoot})
    pcall(function() RegisterHit:FireServer(tRoot, hitList) end)
end

-- ═══════ الحلقة الرئيسية — يضرب كل الأهداف دفعة وحدة ═══════
local lastAttack = 0

task.spawn(function()
    while true do
        task.wait(0)
        if auraOn then
            local now = tick()
            if now - lastAttack >= cooldown then
                local char = LP.Character
                local myRoot = char and char:FindFirstChild("HumanoidRootPart")
                if myRoot then
                    local targets = getAllTargets()
                    targetsCount = #targets

                    -- يضرب كلهم في نفس الوقت (loop سريع بدون wait)
                    for _, t in ipairs(targets) do
                        attackTarget(t, myRoot)
                    end

                    lastAttack = now
                    updateInfo()
                end
            end
        else
            targetsCount = 0
        end
    end
end)

updateInfo()

print("═══════════════════════════════════")
print("   محمد البتك HUB — Aura Attack Loaded ✅")
print("   Targets: Players + NPCs (All at once)")
print("═══════════════════════════════════")
