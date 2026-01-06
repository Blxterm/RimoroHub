-- سكربت كومبو تلقائي لـ Blox Fruits مع Aimlock والدائرة الشخصية
-- بواسطة: مساعد روبلوكس

-- Global Variables
local combo = {}
local savedCombos = {}
local comboFile = "combos.txt"
local isRecording = false
local isExecuting = false
local target = nil
local aimlockEnabled = false
local circleEnabled = false
local circleVisual = nil
local circleRadius = 15 -- نصف الدائرة
local player = game:GetService("Players").LocalPlayer
local mouse = player:GetMouse()
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

-- GUI Creation
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")

-- إنشاء واجهة المستخدم
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Name = "AutoComboGUI"

MainFrame.Size = UDim2.new(0, 400, 0, 500)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Title.Text = "Blox Fruits Auto Combo Script"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = MainFrame

-- دالة إنشاء حقل إدخال
local function createInputField(yPos, labelText, placeholder)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.9, 0, 0, 25)
    label.Position = UDim2.new(0.05, 0, yPos, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = MainFrame
    
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0.9, 0, 0, 30)
    textBox.Position = UDim2.new(0.05, 0, yPos + 0.05, 0)
    textBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.PlaceholderText = placeholder
    textBox.Font = Enum.Font.Gotham
    textBox.TextSize = 14
    textBox.Parent = MainFrame
    
    return textBox
end

-- إنشاء حقول الإدخال
local SwordBox = createInputField(0.1, "اسماء السيوف (افصل بفاصلة):", "Sword 1, Sword 2, ...")
local FruitBox = createInputField(0.2, "اسم الفاكهة:", "Fruit Name")
local GunBox = createInputField(0.3, "اسم السلاح:", "Gun Name")
local StyleBox = createInputField(0.4, "اسم الاسلوب:", "Style Name")
local MovementsBox = createInputField(0.5, "الحركات (افصل بفاصلة):", "Z, X, C, V, F, ...")

-- دالة إنشاء زر
local function createButton(yPos, text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.9, 0, 0, 35)
    button.Position = UDim2.new(0.05, 0, yPos, 0)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Text = text
    button.Font = Enum.Font.GothamBold
    button.TextSize = 14
    button.Parent = MainFrame
    
    button.MouseButton1Click:Connect(callback)
    return button
end

-- دالة التحقق من شروط اللاعب
local function checkPlayerConditions(otherPlayer)
    if not otherPlayer or not otherPlayer.Character then
        return false
    end
    
    -- الشرط 1: ليس في safe zone (تحتاج إلى تعديل حسب اللعبة)
    local isInSafeZone = false
    -- إضافة منطق الكشف عن safe zone هنا
    
    -- الشرط 2: مفعل PvP (افتراضي true)
    local isInPvP = true
    
    -- الشرط 3: مستوى فوق 2200 (تحتاج إلى تعديل حسب اللعبة)
    local playerLevel = 2500 -- قيمة افتراضية، تحتاج إلى جلب المستوى الحقيقي
    
    return not isInSafeZone and isInPvP and playerLevel > 2200
end

-- دالة إنشاء دائرة حمراء حول اللاعب
local function createRedCircle()
    if circleVisual then
        circleVisual:Destroy()
    end
    
    circleVisual = Instance.new("Part")
    circleVisual.Size = Vector3.new(circleRadius * 2, 0.1, circleRadius * 2)
    circleVisual.Anchored = true
    circleVisual.CanCollide = false
    circleVisual.Material = EnumMaterial.Neon
    circleVisual.Color = Color3.fromRGB(255, 0, 0)
    circleVisual.Transparency = 0.3
    circleVisual.Name = "ComboZone"
    
    local mesh = Instance.new("CylinderMesh")
    mesh.Parent = circleVisual
    
    return circleVisual
end

-- دالة تحديث موقع الدائرة
local function updateCirclePosition()
    if circleEnabled and circleVisual and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        circleVisual.Position = player.Character.HumanoidRootPart.Position - Vector3.new(0, 3, 0)
        circleVisual.Parent = Workspace
    elseif circleVisual then
        circleVisual.Parent = nil
    end
end

-- دالة للبحث عن لاعب داخل الدائرة
local function findTargetInCircle()
    if not circleEnabled or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return nil
    end
    
    local playerPosition = player.Character.HumanoidRootPart.Position
    local closestPlayer = nil
    local closestDistance = circleRadius
    
    for _, otherPlayer in pairs(game:GetService("Players"):GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (playerPosition - otherPlayer.Character.HumanoidRootPart.Position).Magnitude
            
            if distance <= circleRadius then
                -- التحقق من الشروط
                if checkPlayerConditions(otherPlayer) then
                    if distance < closestDistance then
                        closestDistance = distance
                        closestPlayer = otherPlayer
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

-- دالة Aimlock
local function aimlock()
    if aimlockEnabled and target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local camera = Workspace.CurrentCamera
        local targetPosition = target.Character.HumanoidRootPart.Position
        camera.CFrame = CFrame.new(camera.CFrame.Position, targetPosition)
    end
end

-- دالة تنفيذ الكومبو
local function executeCombo()
    if #combo == 0 then
        warn("No combo loaded!")
        return
    end
    
    -- البحث عن هدف داخل الدائرة
    local foundTarget = findTargetInCircle()
    if not foundTarget then
        warn("No valid target inside the circle!")
        return
    end
    
    target = foundTarget
    isExecuting = true
    aimlockEnabled = true
    
    print("Executing combo on: " .. target.Name)
    
    for i, action in ipairs(combo) do
        if not isExecuting or not target or not target.Character then break end
        
        -- محاكاة الضغط على الزر (تحتاج إلى تعديل حسب اللعبة)
        local keyCode = getKeyCodeFromAction(action)
        if keyCode then
            -- Press the key
            local virtualInput = game:GetService("VirtualInputManager")
            virtualInput:SendKeyEvent(true, keyCode, false, game)
            wait(0.1)
            virtualInput:SendKeyEvent(false, keyCode, false, game)
        end
        
        -- انتظار بين الحركات
        wait(0.3)
        
        -- تحديث Aimlock مع تحرك الهدف
        aimlock()
    end
    
    isExecuting = false
    aimlockEnabled = false
    print("Combo execution finished!")
end

-- دالة مساعدة لتحويل اسم الحركة إلى KeyCode
local function getKeyCodeFromAction(action)
    local keyMap = {
        ["Z"] = Enum.KeyCode.Z,
        ["X"] = Enum.KeyCode.X,
        ["C"] = Enum.KeyCode.C,
        ["V"] = Enum.KeyCode.V,
        ["F"] = Enum.KeyCode.F,
        ["Q"] = Enum.KeyCode.Q,
        ["E"] = Enum.KeyCode.E,
        ["R"] = Enum.KeyCode.R,
        ["T"] = Enum.KeyCode.T,
        ["Y"] = Enum.KeyCode.Y,
        ["G"] = Enum.KeyCode.G,
        ["H"] = Enum.KeyCode.H,
        ["1"] = Enum.KeyCode.One,
        ["2"] = Enum.KeyCode.Two,
        ["3"] = Enum.KeyCode.Three,
        ["4"] = Enum.KeyCode.Four,
        ["Mouse1"] = Enum.KeyCode.ButtonX,
        ["Mouse2"] = Enum.KeyCode.ButtonY
    }
    
    return keyMap[action:upper()] or keyMap[action]
end

-- دالة حفظ الكومبو
local function saveCombo()
    combo = {}
    
    -- تحليل السيوف
    local swords = SwordBox.Text:split(",")
    for _, sword in pairs(swords) do
        table.insert(combo, sword:trim())
    end
    
    -- إضافة الفاكهة
    if FruitBox.Text ~= "" then
        table.insert(combo, FruitBox.Text)
    end
    
    -- إضافة السلاح
    if GunBox.Text ~= "" then
        table.insert(combo, GunBox.Text)
    end
    
    -- إضافة الأسلوب
    if StyleBox.Text ~= "" then
        table.insert(combo, StyleBox.Text)
    end
    
    -- تحليل الحركات
    local movements = MovementsBox.Text:split(",")
    for _, movement in pairs(movements) do
        table.insert(combo, movement:trim())
    end
    
    -- حفظ في الذاكرة
    table.insert(savedCombos, {
        name = (SwordBox.Text:split(",")[1] or "Unknown") .. " Combo",
        combo = combo
    })
    
    -- إغلاق الواجهة
    MainFrame.Visible = false
    
    print("Combo saved successfully!")
    print("Actions: " .. table.concat(combo, ", "))
end

-- دالة تحميل الكومبو
local function loadCombo()
    if #savedCombos > 0 then
        combo = savedCombos[#savedCombos].combo
        print("Combo loaded: " .. savedCombos[#savedCombos].name)
        print("Actions: " .. table.concat(combo, ", "))
    else
        warn("No saved combos found!")
    end
end

-- دالة تفعيل/تعطيل الدائرة
local function toggleCircle()
    circleEnabled = not circleEnabled
    
    if circleEnabled then
        createRedCircle()
        print("Red circle enabled around player!")
    else
        if circleVisual then
            circleVisual:Destroy()
            circleVisual = nil
        end
        print("Red circle disabled!")
    end
end

-- إنشاء الأزرار
createButton(0.65, "حفظ الكومبو وإغلاق", saveCombo)
createButton(0.7, "تفعيل/تعطيل الدائرة", toggleCircle)
createButton(0.75, "تفعيل/تعطيل Aimlock", function()
    aimlockEnabled = not aimlockEnabled
    print("Aimlock: " .. (aimlockEnabled and "Enabled" or "Disabled"))
end)
createButton(0.8, "تحميل كومبو محفوظ", loadCombo)
createButton(0.85, "تنفيذ الكومبو", executeCombo)

-- إعداد مفاتيح التشغيل السريع
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F1 then -- زر تنفيذ الكومبو
        executeCombo()
    elseif input.KeyCode == Enum.KeyCode.F2 then -- زر تفعيل الدائرة
        toggleCircle()
    elseif input.KeyCode == Enum.KeyCode.F3 then -- زر Aimlock
        aimlockEnabled = not aimlockEnabled
        print("Aimlock toggled: " .. (aimlockEnabled and "ON" : "OFF"))
    end
end)

-- دالة تحديث الدائرة باستمرار
RunService.RenderStepped:Connect(function()
    -- تحديث موقع الدائرة
    updateCirclePosition()
    
    -- تحديث Aimlock
    if aimlockEnabled and target and target.Character then
        aimlock()
    end
    
    -- عرض معلومات التصحيح
    if circleEnabled then
        local targetInCircle = findTargetInCircle()
        if targetInCircle then
            game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("Target in circle: " .. targetInCircle.Name)
        end
    end
end)

-- دالة إنشاء إشعار القتل
local function createKillNotification()
    local notification = Instance.new("ScreenGui")
    local frame = Instance.new("Frame")
    local text = Instance.new("TextLabel")
    
    notification.Name = "KillNotification"
    notification.Parent = game:GetService("CoreGui")
    notification.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    frame.Size = UDim2.new(0, 300, 0, 80)
    frame.Position = UDim2.new(0.5, -150, 0.05, 0) -- أعلى الشاشة
    frame.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    frame.BorderSizePixel = 0
    frame.Parent = notification
    
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = "ELIMINATED!"
    text.TextColor3 = Color3.fromRGB(255, 255, 255)
    text.Font = Enum.Font.GothamBold
    text.TextSize = 24
    text.Parent = frame
    
    -- التدمير بعد 3 ثواني
    delay(3, function()
        notification:Destroy()
    end)
end

print("======================================")
print("Blox Fruits Auto Combo Script Loaded!")
print("======================================")
print("How to use:")
print("1. Enter your combo details in the GUI")
print("2. Click 'Save Combo' to save")
print("3. Enable circle with F2 or button")
print("4. When enemy enters circle, press F1")
print("5. Combo will execute automatically")
print("Hotkeys: F1=Combo, F2=Circle, F3=Aimlock")
print("======================================")
