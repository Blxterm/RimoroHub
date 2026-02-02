-- Deobfuscated by Manus
-- Original Obfuscator: LuaObfuscator.com (Alpha 0.10.9)
-- This script was a loader for the following Roblox scripts.

-- Key Information:
-- Key Link: https://lootdest.org/s?oxbAwgCw
-- Correct Key: "Hiimabbas"

-- Main Script Content (Extracted from remote source):
-- Source: https://raw.githubusercontent.com/ook314745-svg/Escape/refs/heads/main/from%20tsunami%20v4


local BLUE_ACCENT = Color3.fromRGB(25, 85, 160)
local DARK_GLASS = Color3.fromRGB(10, 15, 30)
local FIELD_BG = Color3.fromRGB(18, 25, 45)
local TEXT_COLOR = Color3.fromRGB(235, 235, 235)
local SUBTITLE_COLOR = Color3.fromRGB(180, 200, 230)
local correctKey = "Hiimabbas"
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer


local SAFE_Y_POS = -2.73
local SAFE_Z_POS = -6.61
local DETECTION_RANGE = 120
local isDodging = false
local isGuarding = false
local isInstantGuarding = false
local isCollectingCoins = false
local COLLECTOR_SPEED = 2000
local SAFE_POINT = Vector3.new(133.81, 3.27, -45.37)
local isInstaGrabActive = false
local function findTsunamiWaves()
    local waves = {}
    local folders = {workspace:FindFirstChild("ActiveTsunamis"), workspace:FindFirstChild("Tsunami"), workspace:FindFirstChild("Waves"), workspace:FindFirstChild("Events")}
    for _, folder in pairs(folders) do
        if folder then
            for _, part in pairs(folder:GetDescendants()) do
                if part:IsA("BasePart") and (part.Name == "Hitbox" or part.Name:find("Damage")) then
                    table.insert(waves, part)
                end
            end
        end
    end
    for _, part in pairs(workspace:GetChildren()) do
        if part.Name:find("Wave") or part.Name:find("Tsunami") or part.Name:find("Onda") then
            local hitbox = part:FindFirstChild("Hitbox", true) or part:FindFirstChildWhichIsA("BasePart", true)
            if hitbox then table.insert(waves, hitbox) end
        end
    end
    return waves
end
local function findAndTeleportToGap(isInstant)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local gapsFolder = workspace.Misc:FindFirstChild("Gaps") or workspace:FindFirstChild("Gaps")
    if not hrp or not gapsFolder then return end
    local nearestGap = nil
    local minDistance = math.huge
    for _, part in pairs(gapsFolder:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            local distance = (hrp.Position - part.Position).Magnitude
            if distance < minDistance then
                minDistance = distance
                nearestGap = part
            end
        end
    end
    if nearestGap then
        isDodging = true
        hrp.CFrame = CFrame.new(nearestGap.Position.X, SAFE_Y_POS, SAFE_Z_POS)
        hrp.Velocity = Vector3.zero
        RunService.Heartbeat:Wait()
        if not isInstant then task.wait(0.4) end
        isDodging = false
    end
end
local function findRadioactiveCoins()
    local coins = {}
    if workspace:FindFirstChild("EventParts") then
        for _, part in pairs(workspace.EventParts:GetDescendants()) do
            if part.Name == "Radioactive Coin" and part:IsA("BasePart") then
                table.insert(coins, part)
            end
        end
    end
    for _, part in pairs(workspace:GetDescendants()) do
        if part.Name == "Radioactive Coin" and part:IsA("BasePart") then
            local found = false
            for _, existingCoin in pairs(coins) do
                if existingCoin == part then found = true; break end
            end
            if not found then table.insert(coins, part) end
        end
    end
    return coins
end
local function findNearestCoin()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil, nil end
    local coins = findRadioactiveCoins()
    local nearestCoin = nil
    local minDistance = math.huge
    for _, coin in pairs(coins) do
        if coin and coin.Parent then
            local distance = (hrp.Position - coin.Position).Magnitude
            if distance < minDistance then
                minDistance = distance
                nearestCoin = coin
            end
        end
    end
    return nearestCoin, minDistance
end
local function tweenTeleport(targetPosition)
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local distance = (hrp.Position - targetPosition).Magnitude
    if distance < 3 then
        hrp.CFrame = CFrame.new(targetPosition)
        return true
    end
    local duration = math.max(distance / COLLECTOR_SPEED, 0.05)
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(targetPosition)})
    tween:Play()
    local startTime = tick()
    while (hrp.Position - targetPosition).Magnitude > 2 and (tick() - startTime) < duration + 0.2 do
        task.wait()
    end
    hrp.CFrame = CFrame.new(targetPosition)
    return true
end
local function startFlashCollectorLoop()
    task.spawn(function()
        while isCollectingCoins do
            local success, err = pcall(function()
                local char = LocalPlayer.Character
                if not char then return end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                local hum = char:FindFirstChild("Humanoid")
                if hum and hum.Health <= 0 then return end
                local nearestCoin, dist = findNearestCoin()
                if nearestCoin and nearestCoin.Parent then
                    local teleported = tweenTeleport(nearestCoin.Position)
                    if teleported then
                        hrp.Velocity = Vector3.zero
                        if nearestCoin:IsA("BasePart") then
                            firetouchinterest(hrp, nearestCoin, 0)
                            task.wait(0.02)
                            firetouchinterest(hrp, nearestCoin, 1)
                        end
                        task.wait(0.05)
                    end
                else
                    if (hrp.Position - SAFE_POINT).Magnitude > 30 then
                        tweenTeleport(SAFE_POINT)
                    end
                    task.wait(0.5)
                end
            end)
            if not success then
                warn("[abbasHub] Flash Collector Error:", err)
            end
            task.wait(0.03)
        end
    end)
end

-- الفانكشنات القديمة
local function upgradespeed() ReplicatedStorage.RemoteFunctions.UpgradeSpeed:InvokeServer(5) end
local function upgradecarry() ReplicatedStorage.RemoteFunctions.UpgradeCarry:InvokeServer() end
local function rebirth() ReplicatedStorage.RemoteFunctions.Rebirth:InvokeServer() end
local function speedchanger() local speed = getgenv().Scv or 16; LocalPlayer:SetAttribute("CurrentSpeed", speed) end



local function RunEmbeddedAntiAFK()
    -- Embedded Anti-AFK Script (Merged)
    -- السكربت ده بتاع عباس (نسخة جامدة فشخ - مطورة)
-- تصميم وتظبيط: فلكس باشا

--[[--------------------------------------------------------------------------------
  الحتة دي بتشرح إيه اللذاذة:
  ده يا معلم سكربت anti-AFK معمول بمزاج عشان روبلوكس، فيه حركات وحبشتكانات
  عشان متتسجلش AFK، وواجهة شكلها ملوكي، وكله أداء وثبات مفيش بعد كده.
  الجديد في النسخة دي: زرار تصغر وتكبر بيه الواجهة، والعداد بيفضل شغال على طول.

  إيه الحركات اللي فيه؟
    - طرق anti-AFK كذا طريقة وممكن تظبطها على كيفك.
    - واجهة شكلها شيك وسهلة، وتقدر تصغرها وتكبرها.
    - عداد للوقت اللي قضيته شغال (بيفضل شغال حتى لو وقفت السكريبت).
    - زرار تشغل وتقفل بيه السكربت بسهولة.
    - معمول بطريقة فنانين عشان لو حبيت تزود عليه حاجة بعدين.
    - واخدين بالنا إنه يشتغل على الموبايل ومع البرامج اللي بتشغل السكربتات زي دلتا و كودكس الي اخره.

  كلام مهم لازم تعرفه:
    - عملنا اللي علينا وزيادة عشان السكربت ده يبقى مية مية وأمان.
    - إنت بقى يا كبير مسؤول عن استخدامه مليش دخل لو اتبندت الا لو استعملته بذكاء
    - السكربت ده مش بيضمنلك إنك متتكشفش 100%، عشان بتوع الحماية دماغهم شغالة على طول.
    بس علي اقل هتعرف تصمل 150 ساعه منغير متتبند ولا اي حاجه  
----------------------------------------------------------------------------------]]
-- Anti-AFK by عباس و فريق Fo
local VirtualUser = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
   VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
   task.wait(1)
   VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
   print("تم منع الطرد AFK بنجاح بواسطة عباس و Fo")
end)
--[[
    سكربت حماية شامل - من تطوير عباس و تيم Fo
    يحتوي على: AntiAFK + AntiKick + AutoJump كل 15 دقيقة
]]

-- Anti-AFK
task.spawn(function()
    local vu = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        pcall(function()
            vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end)
    end)
end)

-- Anti-Kick (hookfunction)
local oldKick
oldKick = hookfunction(game.Players.LocalPlayer.Kick, function(self, ...)
    warn("تم اعتراض محاولة طرد - الحماية شغالة بواسطة عباس و Fo")
    return nil
end)

-- Auto Jump كل 15 دقيقة
task.spawn(function()
    while true do
        wait(900) -- 900 ثانية = 15 دقيقة
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            print("نطة تلقائية كل 15 دقيقة - بواسطة عباس و Fo")
        end
    end
end)

-- رسالة نجاح
print("تم تفعيل: AntiAFK + AntiKick + AutoJump - من تطوير عباس و تيم Fo")



local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local gui = Instance.new("ScreenGui")
gui.Parent = playerGui

-- شاشة سوداء صغيرة في المنتصف
local black = Instance.new("Frame", gui)
black.Size = UDim2.new(0.8, 0, 0.4, 0) -- أصغر من الشاشة
black.Position = UDim2.new(0.1, 0, 0.3, 0)
black.BackgroundColor3 = Color3.new(0, 0, 0)
black.BorderSizePixel = 0

-- نص التحميل
local loadingText = Instance.new("TextLabel", black)
loadingText.Size = UDim2.new(1, 0, 1, 0)
loadingText.BackgroundTransparency = 1
loadingText.TextColor3 = Color3.new(0, 1, 0)
loadingText.Text = "تم تحديث السكربت!\nدلوقتي تقدر تبقى AFK بأمان.\nالسكربت كان فيه أخطاء بتطرد بعد 20 دقيقة.\nلكن دلوقتي المشكلة اتحلت، والسكربت شغال 100٪.\n\nانتظر 15 ثانية وابدأ صمله يمعلم."
loadingText.Font = Enum.Font.Code
loadingText.TextScaled = true
loadingText.TextWrapped = true

wait(16)
gui:Destroy()


-- خدمات روبلوكس الأساسية اللي هنحتاجها
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")

-- اللاعب بتاعنا
local LocalPlayer = Players.LocalPlayer

-- تظبيطات السكريبت
local Config = {
    ENABLED = true,
    SCRIPT_TITLE = "نظام عباس الجامد فشخ للـ AFK",
    AUTHOR_CREDIT = "سكربت المعلم عباس (بمساعده فلكس )",
    GUI = {
        PRIMARY_COLOR = Color3.fromRGB(30, 30, 50),
        SECONDARY_COLOR = Color3.fromRGB(50, 50, 80),
        TEXT_COLOR_STATIC = Color3.fromRGB(220, 220, 255),
        TEXT_COLOR_ACTIVE = Color3.fromRGB(100, 255, 100),
        TEXT_COLOR_INACTIVE = Color3.fromRGB(255, 100, 100),
        FONT = Enum.Font.GothamSemibold,
        WINDOW_SIZE_NORMAL = UDim2.new(0, 320, 0, 180), -- الحجم العادي
        WINDOW_SIZE_MINIMIZED = UDim2.new(0, 120, 0, 40), -- الحجم الصغنن
        WINDOW_POSITION = UDim2.new(0.02, 0, 0.5, -90),
        CORNER_RADIUS = 8,
        BORDER_SIZE = 1,
        BORDER_COLOR = Color3.fromRGB(70, 70, 100),
        ANIMATING_TEXT_COLORS = {
            Color3.fromRGB(180, 180, 255),
            Color3.fromRGB(150, 220, 255),
            Color3.fromRGB(200, 150, 255),
            Color3.fromRGB(220, 200, 255),
        },
        ANIMATING_TEXT_SPEED = 2,
        MINIMIZE_BUTTON_TEXT_MIN = "ـ", -- شكل زرار التصغير
        MINIMIZE_BUTTON_TEXT_MAX = "ㅁ" -- شكل زرار التكبير
    },
    ANTI_AFK_METHODS = {
        JUMP = { ENABLED = true, CHANCE = 0.6 },
        RANDOM_WALK = { ENABLED = true, DURATION_MIN = 0.1, DURATION_MAX = 0.5, CHANCE = 0.3 },
        CAMERA_PAN = { ENABLED = true, ANGLE_MIN = -5, ANGLE_MAX = 5, CHANCE = 0.1 }
    },
    ACTION_INTERVAL_MIN = 120,
    ACTION_INTERVAL_MAX = 240,
    DEBUG_MODE = false,
}

-- متغيرات حالة السكريبت
local scriptActive = Config.ENABLED
local timeActive = 0
local lastActionTime = tick()
local nextActionDelay = math.random(Config.ACTION_INTERVAL_MIN, Config.ACTION_INTERVAL_MAX)
local guiElements = {}
local currentAnimatingColorIndex = 1
local guiMinimized = false -- الواجهة متصغرة ولا لأ

local function debugLog(message)
    if Config.DEBUG_MODE then
        print("[Anti-AFK بتاع عباس المطور]: " .. tostring(message))
    end
end

-- [[--------------------------------------------------------------------------------
--   الحته بتاعة واجهة المستخدم الجامدة (GUI Module)
----------------------------------------------------------------------------------]]
local GUI_Manager = {}

function GUI_Manager:CreateElement(elementType, properties)
    local element = Instance.new(elementType)
    for prop, value in pairs(properties) do
        element[prop] = value
    end
    return element
end

function GUI_Manager:AnimateTextColor(label)
    if not label or not label:IsA("TextLabel") then return end
    if guiMinimized and label ~= guiElements.MinimizedTitleLabel then return end -- متعملش انيميشن لو الواجهة متصغرة إلا للعنوان الصغير

    currentAnimatingColorIndex = (currentAnimatingColorIndex % #Config.GUI.ANIMATING_TEXT_COLORS) + 1
    local targetColor = Config.GUI.ANIMATING_TEXT_COLORS[currentAnimatingColorIndex]
    local originalColor = label.TextColor3

    local tweenInfo = TweenInfo.new(Config.GUI.ANIMATING_TEXT_SPEED / 2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
    local tween = TweenService:Create(label, tweenInfo, {TextColor3 = targetColor})
    tween:Play()

    tween.Completed:Connect(function()
        if label.Parent and (not guiMinimized or label == guiElements.MinimizedTitleLabel) then -- نتأكد إن الواجهة لسه عايشة والسكريبت شغال أو ده العنوان الصغير
            task.wait(Config.GUI.ANIMATING_TEXT_SPEED / 2)
            if label.TextColor3 == targetColor then -- نعمل انيميشن تاني لو اللون متغيرش بسبب حاجة تانية
                 GUI_Manager:AnimateTextColor(label)
            end
        else
            label.TextColor3 = originalColor -- رجع اللون الأصلي لو الواجهة اتصغرت وهو مش العنوان الصغير
        end
    end)
end

function GUI_Manager:ToggleMinimize()
    guiMinimized = not guiMinimized
    debugLog("الواجهة بقت " .. (guiMinimized and "صغننة" or "كبيرة"))

    if guiMinimized then
        guiElements.MainFrame.Size = Config.GUI.WINDOW_SIZE_MINIMIZED
        guiElements.MinimizeButton.Text = Config.GUI.MINIMIZE_BUTTON_TEXT_MAX
        -- نخفي الحاجات الكبيرة ونظهر العنوان الصغير
        guiElements.TitleLabel.Visible = false
        guiElements.StatusLabel.Visible = false
        guiElements.TimeActiveLabel.Visible = false
        guiElements.ToggleButton.Visible = false
        guiElements.AuthorLabel.Visible = false
        guiElements.MinimizedTitleLabel.Visible = true
        GUI_Manager:AnimateTextColor(guiElements.MinimizedTitleLabel) -- شغل انيميشن العنوان الصغير
    else
        guiElements.MainFrame.Size = Config.GUI.WINDOW_SIZE_NORMAL
        guiElements.MinimizeButton.Text = Config.GUI.MINIMIZE_BUTTON_TEXT_MIN
        -- نظهر الحاجات الكبيرة ونخفي العنوان الصغير
        guiElements.TitleLabel.Visible = true
        guiElements.StatusLabel.Visible = true
        guiElements.TimeActiveLabel.Visible = true
        guiElements.ToggleButton.Visible = true
        guiElements.AuthorLabel.Visible = true
        guiElements.MinimizedTitleLabel.Visible = false
        -- نشغل الانيميشن للحاجات اللي كانت مخفية
        GUI_Manager:AnimateTextColor(guiElements.TitleLabel)
        GUI_Manager:AnimateTextColor(guiElements.TimeActiveLabel)
    end
end

function GUI_Manager:Init()
    debugLog("يلا بينا نبني الواجهة الأجدد...")

    guiElements.ScreenGui = GUI_Manager:CreateElement("ScreenGui", {
        Name = "abbasAntiAFK_GUI_Masry_Mطور",
        Parent = LocalPlayer:FindFirstChildOfClass("PlayerGui") or game:GetService("CoreGui"),
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })

    guiElements.MainFrame = GUI_Manager:CreateElement("Frame", {
        Name = "MainFrame",
        Parent = guiElements.ScreenGui,
        Size = Config.GUI.WINDOW_SIZE_NORMAL,
        Position = Config.GUI.WINDOW_POSITION,
        BackgroundColor3 = Config.GUI.PRIMARY_COLOR,
        BorderColor3 = Config.GUI.BORDER_COLOR,
        BorderSizePixel = Config.GUI.BORDER_SIZE,
        Active = true,
        Draggable = true,
        Selectable = true,
        Style = Enum.FrameStyle.RobloxRound,
        ClipsDescendants = true
    })

    local UICorner = GUI_Manager:CreateElement("UICorner", {
        Parent = guiElements.MainFrame,
        CornerRadius = UDim.new(0, Config.GUI.CORNER_RADIUS)
    })

    guiElements.TitleLabel = GUI_Manager:CreateElement("TextLabel", {
        Name = "TitleLabel",
        Parent = guiElements.MainFrame,
        Size = UDim2.new(1, -30, 0, 30), -- نصغر العرض شوية عشان زرار التصغير
        Position = UDim2.new(0, 0, 0, 5),
        BackgroundTransparency = 1,
        Font = Config.GUI.FONT,
        Text = Config.SCRIPT_TITLE,
        TextColor3 = Config.GUI.TEXT_COLOR_STATIC,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Center
    })
    GUI_Manager:AnimateTextColor(guiElements.TitleLabel)

    -- عنوان صغير بيظهر لما الواجهة تتصغر
    guiElements.MinimizedTitleLabel = GUI_Manager:CreateElement("TextLabel", {
        Name = "MinimizedTitleLabel",
        Parent = guiElements.MainFrame,
        Size = UDim2.new(1, -30, 1, 0), -- ياخد عرض الفريم كله لما يكون صغير
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Font = Config.GUI.FONT,
        Text = "عباس AFK", -- اسم مختصر
        TextColor3 = Config.GUI.TEXT_COLOR_STATIC,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Center,
        Visible = false -- بيبدأ مخفي
    })

    guiElements.StatusLabel = GUI_Manager:CreateElement("TextLabel", {
        Name = "StatusLabel",
        Parent = guiElements.MainFrame,
        Size = UDim2.new(1, -20, 0, 25),
        Position = UDim2.new(0, 10, 0, 40),
        BackgroundTransparency = 1,
        Font = Config.GUI.FONT,
        Text = "الحالة: " .. (scriptActive and "شغال وزي الفل" or "واقف ومريح"),
        TextColor3 = scriptActive and Config.GUI.TEXT_COLOR_ACTIVE or Config.GUI.TEXT_COLOR_INACTIVE,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    guiElements.TimeActiveLabel = GUI_Manager:CreateElement("TextLabel", {
        Name = "TimeActiveLabel",
        Parent = guiElements.MainFrame,
        Size = UDim2.new(1, -20, 0, 25),
        Position = UDim2.new(0, 10, 0, 70),
        BackgroundTransparency = 1,
        Font = Config.GUI.FONT,
        Text = "بقالك قد ايه يا كينج: 00:00:00",
        TextColor3 = Config.GUI.TEXT_COLOR_STATIC,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    GUI_Manager:AnimateTextColor(guiElements.TimeActiveLabel)

    guiElements.ToggleButton = GUI_Manager:CreateElement("TextButton", {
        Name = "ToggleButton",
        Parent = guiElements.MainFrame,
        Size = UDim2.new(0.8, 0, 0, 30),
        Position = UDim2.new(0.1, 0, 0, 105),
        BackgroundColor3 = Config.GUI.SECONDARY_COLOR,
        BorderColor3 = Config.GUI.BORDER_COLOR,
        BorderSizePixel = Config.GUI.BORDER_SIZE,
        Font = Config.GUI.FONT,
        Text = scriptActive and "اقفل يا عم الحاج" or "شغل يا ريس",
        TextColor3 = Config.GUI.TEXT_COLOR_STATIC,
        TextSize = 16,
    })
    local btnCorner = GUI_Manager:CreateElement("UICorner", { Parent = guiElements.ToggleButton, CornerRadius = UDim.new(0, Config.GUI.CORNER_RADIUS -2) })

    guiElements.AuthorLabel = GUI_Manager:CreateElement("TextLabel", {
        Name = "AuthorLabel",
        Parent = guiElements.MainFrame,
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 1, -25),
        BackgroundTransparency = 1,
        Font = Enum.Font.SourceSans,
        Text = Config.AUTHOR_CREDIT,
        TextColor3 = Color3.fromRGB(150,150,180),
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Center
    })

    -- زرار التصغير والتكبير
    guiElements.MinimizeButton = GUI_Manager:CreateElement("TextButton", {
        Name = "MinimizeButton",
        Parent = guiElements.MainFrame,
        Size = UDim2.new(0, 25, 0, 25),
        Position = UDim2.new(1, -30, 0, 5), -- فوق على اليمين
        BackgroundColor3 = Config.GUI.SECONDARY_COLOR,
        BorderColor3 = Config.GUI.BORDER_COLOR,
        BorderSizePixel = Config.GUI.BORDER_SIZE,
        Font = Config.GUI.FONT,
        Text = Config.GUI.MINIMIZE_BUTTON_TEXT_MIN,
        TextColor3 = Config.GUI.TEXT_COLOR_STATIC,
        TextSize = 18,
    })
    local minBtnCorner = GUI_Manager:CreateElement("UICorner", { Parent = guiElements.MinimizeButton, CornerRadius = UDim.new(0, Config.GUI.CORNER_RADIUS -4) })

    guiElements.MinimizeButton.MouseButton1Click:Connect(GUI_Manager.ToggleMinimize)

    guiElements.ToggleButton.MouseButton1Click:Connect(function()
        scriptActive = not scriptActive
        GUI_Manager:UpdateStatus()
        if scriptActive then
            debugLog("الواد شغل السكريبت بإيده.")
            lastActionTime = tick()
            nextActionDelay = math.random(Config.ACTION_INTERVAL_MIN, Config.ACTION_INTERVAL_MAX)
            if not guiMinimized then -- لو الواجهة مش متصغرة، شغل الانيميشن
                GUI_Manager:AnimateTextColor(guiElements.TitleLabel)
                GUI_Manager:AnimateTextColor(guiElements.TimeActiveLabel)
            else
                GUI_Manager:AnimateTextColor(guiElements.MinimizedTitleLabel)
            end
        else
            debugLog("الواد قفل السكريبت بإيده.")
        end
    end)

    debugLog("الواجهة الأجدد اتبنت خلاص.")
    -- لو كانت الواجهة المفروض تبدأ متصغرة (لو عملنا تظبيط لكده بعدين)
    if guiMinimized then
        GUI_Manager:ToggleMinimize() -- شغلها مرة عشان تظبط الدنيا لو هتبدأ متصغرة
    end
end

function GUI_Manager:UpdateStatus()
    if guiElements.StatusLabel then
        guiElements.StatusLabel.Text = "الحالة: " .. (scriptActive and "شغال وزي الفل" or "واقف ومريح")
        guiElements.StatusLabel.TextColor3 = scriptActive and Config.GUI.TEXT_COLOR_ACTIVE or Config.GUI.TEXT_COLOR_INACTIVE
    end
    if guiElements.ToggleButton then
        guiElements.ToggleButton.Text = scriptActive and "اقفل يا عم الحاج" or "شغل يا ريس"
    end
end

function GUI_Manager:UpdateTimeActive(seconds)
    if guiElements.TimeActiveLabel and not guiMinimized then -- متحدثش الليبل الكبير لو الواجهة متصغرة
        local hours = math.floor(seconds / 3600)
        local minutes = math.floor((seconds % 3600) / 60)
        local secs = math.floor(seconds % 60)
        guiElements.TimeActiveLabel.Text = string.format("بقالك  قد ايه يا كينج: %02d:%02d:%02d", hours, minutes, secs)
    end
    -- ممكن نضيف هنا تحديث لليبل صغير بيظهر لما الواجهة متصغرة لو عاوزين
end

function GUI_Manager:Destroy()
    if guiElements.ScreenGui then
        guiElements.ScreenGui:Destroy()
        guiElements = {}
        debugLog("مسحنا الواجهة خلاص.")
    end
end

-- [[--------------------------------------------------------------------------------
--   الحته بتاعة مخ السكريبت اللي بيعمل الشغل كله (Core Logic Module)
----------------------------------------------------------------------------------]]
local AntiAFK_Logic = {}

function AntiAFK_Logic:GetPlayerCharacter()
    return LocalPlayer and LocalPlayer.Character
end

function AntiAFK_Logic:GetPlayerHumanoid()
    local character = self:GetPlayerCharacter()
    return character and character:FindFirstChildOfClass("Humanoid")
end

function AntiAFK_Logic:PerformJump()
    local humanoid = self:GetPlayerHumanoid()
    if humanoid and humanoid.Health > 0 and humanoid:GetState() ~= Enum.HumanoidStateType.Jumping then
        debugLog("يلا بينا نط نطة حلوة...")
        humanoid.Jump = true
        return true
    end
    return false
end

function AntiAFK_Logic:PerformRandomWalk()
    local character = self:GetPlayerCharacter()
    local humanoid = self:GetPlayerHumanoid()
    if character and humanoid and humanoid.Health > 0 then
        local walkDir = Vector3.new(math.random(-100, 100)/100, 0, math.random(-100, 100)/100).Unit
        local duration = math.random(Config.ANTI_AFK_METHODS.RANDOM_WALK.DURATION_MIN * 10, Config.ANTI_AFK_METHODS.RANDOM_WALK.DURATION_MAX * 10) / 10
        debugLog(string.format("يلا نتمشى شوية لمدة %.2f ثانية في حتة كده %s", duration, tostring(walkDir)))
        humanoid:Move(walkDir, false)
        task.wait(duration)
        humanoid:Move(Vector3.new(0,0,0), false)
        return true
    end
    return false
end

function AntiAFK_Logic:PerformCameraPan()
    local camera = workspace.CurrentCamera
    if camera then
        local currentCF = camera.CFrame
        local angleX = math.rad(math.random(Config.ANTI_AFK_METHODS.CAMERA_PAN.ANGLE_MIN, Config.ANTI_AFK_METHODS.CAMERA_PAN.ANGLE_MAX))
        local angleY = math.rad(math.random(Config.ANTI_AFK_METHODS.CAMERA_PAN.ANGLE_MIN, Config.ANTI_AFK_METHODS.CAMERA_PAN.ANGLE_MAX))
        debugLog(string.format("هنلف الكاميرا لفة صغننة X: %.2f, Y: %.2f", math.deg(angleX), math.deg(angleY)))
        camera.CFrame = currentCF * CFrame.Angles(angleX, angleY, 0)
        return true
    end
    return false
end

function AntiAFK_Logic:ExecuteAntiAFKAction()
    if not LocalPlayer or not LocalPlayer.Character or LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health <= 0 then
        debugLog("اللاعب مش هنا أو ميت، مش هنعمل حاجة.")
        return
    end

    local methods = {}
    local totalChance = 0
    for method, props in pairs(Config.ANTI_AFK_METHODS) do
        if props.ENABLED then
            table.insert(methods, {name = method, chance = props.CHANCE})
            totalChance = totalChance + props.CHANCE
        end
    end

    if #methods == 0 then
        debugLog("مفيش ولا طريقة anti-AFK شغالة يا ريس.")
        return
    end

    local rand = math.random() * totalChance
    local cumulativeChance = 0
    local chosenMethod

    for _, methodData in ipairs(methods) do
        cumulativeChance = cumulativeChance + methodData.chance
        if rand <= cumulativeChance then
            chosenMethod = methodData.name
            break
        end
    end

    if not chosenMethod then chosenMethod = methods[1].name end

    debugLog("الطريقة اللي اخترناها: " .. chosenMethod)
    local success = false
    if chosenMethod == "JUMP" then
        success = self:PerformJump()
    elseif chosenMethod == "RANDOM_WALK" then
        success = self:PerformRandomWalk()
    elseif chosenMethod == "CAMERA_PAN" then
        success = self:PerformCameraPan()
    end

    if success then
        debugLog("الحركة اتعملت وزي الفل.")
    else
        debugLog("الحركة معملتش، فيه حاجة غلط.")
    end
end

-- [[--------------------------------------------------------------------------------
--   الحته بتاعة إدارة الأحداث واللوب الأساسي اللي بيفضل شغال (Main Loop & Event Management)
----------------------------------------------------------------------------------]]
local MainController = {}

function MainController:Start()
    debugLog("يلا بينا نشغل السكريبت الأجدد ده...")
    GUI_Manager:Init()

    RunService.RenderStepped:Connect(function(deltaTime)
        timeActive = timeActive + deltaTime -- العداد شغال على طول
        GUI_Manager:UpdateTimeActive(timeActive) -- حدث الوقت في الواجهة على طول

        if scriptActive then -- لو السكريبت شغال، اعمل الحركات
            if (tick() - lastActionTime) >= nextActionDelay then
                if UserInputService:GetFocusedTextBox() == nil and UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) == false and UserInputService:IsKeyDown(Enum.KeyCode.RightAlt) == false then
                    AntiAFK_Logic:ExecuteAntiAFKAction()
                    lastActionTime = tick()
                    nextActionDelay = math.random(Config.ACTION_INTERVAL_MIN, Config.ACTION_INTERVAL_MAX)
                    debugLog("الحركة الجاية كمان " .. nextActionDelay .. " ثانية إن شاء الله.")
                else
                    debugLog("أجلنا الحركة عشان الواد بيكتب أو فاتح قايمة.")
                    lastActionTime = tick()
                end
            end
        end
    end)

    if LocalPlayer and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.Died:Connect(function()
                debugLog("اللاعب مات يا جدعان!")
            end)
        end
    end
    Players.PlayerAdded:Connect(function(player)
        if player == LocalPlayer and player.Character then
             local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
             if humanoid then
                humanoid.Died:Connect(function()
                    debugLog("اللاعب مات يا جدعان!")
                end)
            end
        end
    end)

    LocalPlayer.CharacterAdded:Connect(function(character)
        debugLog("الكاركتر بتاع اللاعب رجع تاني.")
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.Died:Connect(function()
            debugLog("اللاعب مات تاني (بعد ما رجع)!")
        end)
    end)

    game:GetService("ScriptContext").Error:Connect(function(message, trace, scriptInstance)
        if scriptInstance == script then
            GUI_Manager:Destroy()
        end
    end)

    debugLog("السكريبت الأجدد شغال وزي الفل.")
end

-- يلا بينا نبدأ الحفلة المطورة
MainController:Start()

--[[--------------------------------------------------------------------------------
  آخر السكربت يا رجالة (النسخة المطورة)
----------------------------------------------------------------------------------]]

end


local function RunEmbeddedVipTp()
    -- Embedded VIP/TP Script (Merged)
    local Players = game:GetService("Players")

local RunService = game:GetService("RunService")

local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

local ZOOM_ON_MAX = 2000

local ZOOM_ON_MIN = 0.5

local ZOOM_OFF_MAX = 12

local ZOOM_OFF_MIN = 8

player.CameraMaxZoomDistance = ZOOM_ON_MAX

player.CameraMinZoomDistance = ZOOM_ON_MIN

local screenGui = Instance.new("ScreenGui")

screenGui.Name = "LogoGui"

screenGui.ResetOnSpawn = false

screenGui.Parent = player:WaitForChild("PlayerGui")

-- ===== INTRO =====

local intro = Instance.new("Frame", screenGui)

intro.Size = UDim2.new(1,0,1,0)

intro.BackgroundColor3 = Color3.new(0,0,0)

intro.ZIndex = 100

local introImg = Instance.new("ImageLabel", intro)

introImg.Size = UDim2.new(0,220,0,220)

introImg.Position = UDim2.new(0.5,0,0.45,0)

introImg.AnchorPoint = Vector2.new(0.5,0.5)

introImg.BackgroundTransparency = 1

introImg.Image = "rbxassetid://3420079845"

introImg.ZIndex = 101

local barBG = Instance.new("Frame", intro)

barBG.Size = UDim2.new(0,260,0,6)

barBG.Position = UDim2.new(0.5,0,0.62,0)

barBG.AnchorPoint = Vector2.new(0.5,0.5)

barBG.BackgroundColor3 = Color3.fromRGB(60,60,60)

barBG.BorderSizePixel = 0

barBG.ZIndex = 101

Instance.new("UICorner", barBG).CornerRadius = UDim.new(1,0)

local barFill = Instance.new("Frame", barBG)

barFill.Size = UDim2.new(0,0,1,0)

barFill.BackgroundColor3 = Color3.fromRGB(0,170,255)

barFill.BorderSizePixel = 0

barFill.ZIndex = 102

Instance.new("UICorner", barFill).CornerRadius = UDim.new(1,0)

TweenService:Create(

	barFill,	TweenInfo.new(2.5, Enum.EasingStyle.Linear),

	{Size = UDim2.new(1,0,1,0)}

):Play()

task.wait(2.8)

TweenService:Create(intro,TweenInfo.new(1),{BackgroundTransparency=1}):Play()

TweenService:Create(introImg,TweenInfo.new(1),{ImageTransparency=1}):Play()

TweenService:Create(barBG,TweenInfo.new(1),{BackgroundTransparency=1}):Play()

TweenService:Create(barFill,TweenInfo.new(1),{BackgroundTransparency=1}):Play()

task.wait(1)

intro:Destroy()

-- ===== END INTRO =====

local logo = Instance.new("ImageButton")

logo.Parent = screenGui

logo.BackgroundTransparency = 1

logo.Image = "rbxassetid://93738238823550"

logo.Size = UDim2.new(0,50,0,50)

logo.AnchorPoint = Vector2.new(0.5,0.5)

logo.Position = UDim2.new(0.5,0,0.5,0)

logo.Active = true

logo.Draggable = true

TweenService:Create(

	logo,

	TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),

	{Position = UDim2.new(0,60,1,-60)}

):Play()

local menu = Instance.new("Frame", screenGui)

menu.Size = UDim2.new(0,240,0,320)

menu.Position = UDim2.new(0,60,1,-380)

menu.BackgroundColor3 = Color3.fromRGB(15,15,15)

menu.Visible = false

menu.Active = true

menu.Draggable = true

Instance.new("UICorner", menu).CornerRadius = UDim.new(0,16)

local stroke = Instance.new("UIStroke", menu)

stroke.Color = Color3.fromRGB(80,80,80)

stroke.Thickness = 1.5

local title = Instance.new("TextLabel", menu)

title.Size = UDim2.new(1,0,0,35)

title.Text = "made by abbas"

title.TextColor3 = Color3.fromRGB(0,200,255)

title.BackgroundTransparency = 1

title.Font = Enum.Font.GothamBold

title.TextSize = 16

local note = Instance.new("TextLabel", menu)

note.Size = UDim2.new(1,-20,0,35)

note.Position = UDim2.new(0,10,0,35)

note.Text = "Note: لازم تفعل Free Vip أولا"

note.TextColor3 = Color3.fromRGB(255,200,0)

note.BackgroundTransparency = 1

note.Font = Enum.Font.Gotham

note.TextWrapped = true

note.TextSize = 13

local safeLabel = Instance.new("TextLabel", menu)

safeLabel.Size = UDim2.new(1,-30,0,25)

safeLabel.Position = UDim2.new(0,15,0,75)

safeLabel.Text = "Safe Point: 0/8"

safeLabel.TextColor3 = Color3.new(1,1,1)

safeLabel.BackgroundTransparency = 1

safeLabel.Font = Enum.Font.GothamBold

safeLabel.TextSize = 14

local warning = Instance.new("TextLabel", menu)

warning.Size = UDim2.new(1,-20,0,25)

warning.Position = UDim2.new(0,10,1,-30)

warning.Text = ""

warning.TextColor3 = Color3.fromRGB(255,60,60)

warning.BackgroundTransparency = 1

warning.Font = Enum.Font.GothamBold

warning.TextSize = 14

local function makeButton(text,y,color)

	local b = Instance.new("TextButton", menu)

	b.Size = UDim2.new(1,-30,0,40)

	b.Position = UDim2.new(0,15,0,y)

	b.Text = text

	b.BackgroundColor3 = color

	b.TextColor3 = Color3.new(1,1,1)

	b.Font = Enum.Font.GothamBold

	b.TextSize = 16

	Instance.new("UICorner", b)

	return b

end

local nextBtn = makeButton("Tp",105,Color3.fromRGB(60,120,255))

local backBtn = makeButton("Back",150,Color3.fromRGB(170,70,70))

local zoomBtn = makeButton("INF ZOOM OFF",195,Color3.fromRGB(100,100,100))

local vipBtn = makeButton("Free Vip",240,Color3.fromRGB(200,160,60))

logo.MouseButton1Click:Connect(function()

	menu.Visible = not menu.Visible

end)

local points = {

	Vector3.new(152.50,3.16,-135.32),

	Vector3.new(242.45,3.21,-139.48),

	Vector3.new(341.16,3.21,-139.46),

	Vector3.new(466.67,3.21,-139.51),

	Vector3.new(651.80,3.21,-139.50),

	Vector3.new(912.58,3.21,-139.47),

	Vector3.new(1302.22,3.21,-139.48),

	Vector3.new(2398.07,3.21,-139.03),

	Vector3.new(1989.50,3.21,-136.06),

}

local index = 0

local moveConn

local SPEED = 1999

local function updateSafePoint()

	safeLabel.Text = "Safe Point: "..index.."/8"

end

local function stopMove()

	if moveConn then

		moveConn:Disconnect()

		moveConn = nil

	end

end

local function moveTo(pos)

	stopMove()

	local char = player.Character

	if not char then return end

	local hrp = char:FindFirstChild("HumanoidRootPart")

	if not hrp then return end

	moveConn = RunService.RenderStepped:Connect(function(dt)

		local dir = pos - hrp.Position

		local dist = dir.Magnitude

		if dist < 1 then

			hrp.CFrame = CFrame.new(pos)

			stopMove()

			return

		end

		local step = math.min(dist, SPEED * dt)

		hrp.CFrame = CFrame.new(hrp.Position + dir.Unit * step)

	end)

end

nextBtn.MouseButton1Click:Connect(function()

	if index == 8 then

		warning.Text = "رقم 9 لا تعمل!"

		return

	end

	warning.Text = ""

	if index < #points then

		index += 1

		updateSafePoint()

		moveTo(points[index])

	end

end)

backBtn.MouseButton1Click:Connect(function()

	if index > 1 then

		index -= 1

		updateSafePoint()

		moveTo(points[index])

	end

end)

local zoomEnabled = false

zoomBtn.MouseButton1Click:Connect(function()

	zoomEnabled = not zoomEnabled

	if zoomEnabled then

		player.CameraMaxZoomDistance = ZOOM_ON_MAX

		player.CameraMinZoomDistance = ZOOM_ON_MIN

		zoomBtn.Text = "INF ZOOM ON"

	else

		player.CameraMaxZoomDistance = ZOOM_OFF_MAX

		player.CameraMinZoomDistance = ZOOM_OFF_MIN

		zoomBtn.Text = "INF ZOOM OFF"

	end

end)

vipBtn.MouseButton1Click:Connect(function()

	local vipWalls = workspace:FindFirstChild("VIPWalls")

	if vipWalls then

		vipWalls:Destroy()

	end

end)

player.CharacterAdded:Connect(function()

	stopMove()

	index = 0

	updateSafePoint()

end)

updateSafePoint()
end

local function ExecuteHub()
    repeat task.wait() until game:IsLoaded()

    local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
    local Window = Rayfield:CreateWindow({Name = "Escape  Tsunami for brainrot | سكربت عباس V10.1", LoadingTitle = "سكربت عباس", LoadingSubtitle = "abbas Script", ConfigurationSaving = { Enabled = false }, KeySystem = false})

    local MainTab = Window:CreateTab("القائمة الرئيسية", 4483362458)

-- سكربتات اخرى
local OtherScriptsTab = Window:CreateTab("سكربتات أخرى من صنع عباس", 4483362458)


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local moving = false
local moveConnection

OtherScriptsTab:CreateToggle({
    Name = "يحركك للامام بدون جهد منك",
    CurrentValue = false,
    Flag = "ForwardMoveToggle",
    Callback = function(Value)
        moving = Value

        if moving then
            moveConnection = RunService.RenderStepped:Connect(function()
                local char = player.Character
                if char and char:FindFirstChild("Humanoid") then
                    char.Humanoid:Move(Vector3.new(0, 0, -1), true)
                end
            end)
        else
            if moveConnection then
                moveConnection:Disconnect()
                moveConnection = nil
            end
        end
    end,
})

OtherScriptsTab:CreateButton({
    Name = "Anti-AFK by عباس (مدمج)",
    Callback = function()
        RunEmbeddedAntiAFK()
    end
})

OtherScriptsTab:CreateButton({
	Name = "Infinite Jump (By abbas)(شكل الواجهه خرا بس اعذروني غصب عني) ",
	Callback = function()
		loadstring([[
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer

if localPlayer.PlayerGui:FindFirstChild("InfiniteJumpGUI") then return end

local isJumpActive = false
local jumpPower = 100
local jumpConnection = nil

local DraggableGUI = Instance.new("ScreenGui")
DraggableGUI.Name = "InfiniteJumpGUI"
DraggableGUI.Parent = localPlayer:WaitForChild("PlayerGui")
DraggableGUI.IgnoreGuiInset = true

local MainFrame = Instance.new("Frame")
MainFrame.Parent = DraggableGUI
MainFrame.Size = UDim2.new(0,220,0,125)
MainFrame.Position = UDim2.new(0.1,0,0.15,0)
MainFrame.BackgroundColor3 = Color3.fromRGB(204,51,51)
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.Parent = MainFrame
UICorner.CornerRadius = UDim.new(0,8)

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(0,120,0,22)
Title.Position = UDim2.new(0.07,0,0.1,0)
Title.Text = "InfiniteJump v1 (byabbas)"
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundColor3 = Color3.fromRGB(153,51,51)

local Btn = Instance.new("TextButton")
Btn.Parent = MainFrame
Btn.Size = UDim2.new(0,88,0,50)
Btn.Position = UDim2.new(0.07,0,0.4,0)
Btn.Text = "OFF"
Btn.TextSize = 24
Btn.BackgroundColor3 = Color3.fromRGB(255,230,230)

local function activate()
	if jumpConnection then return end
	jumpConnection = UserInputService.JumpRequest:Connect(function()
		if isJumpActive and localPlayer.Character then
			local hrp = localPlayer.Character:FindFirstChild("HumanoidRootPart")
			if hrp then
				hrp.Velocity = Vector3.new(hrp.Velocity.X, jumpPower, hrp.Velocity.Z)
			end
		end
	end)
end

local function deactivate()
	if jumpConnection then
		jumpConnection:Disconnect()
		jumpConnection = nil
	end
end

Btn.MouseButton1Click:Connect(function()
	isJumpActive = not isJumpActive
	if isJumpActive then
		Btn.Text = "ON"
		activate()
	else
		Btn.Text = "OFF"
		deactivate()
	end
end)
		]])()
	end
})

OtherScriptsTab:CreateButton({
	Name = "سكربت يعرفك متى الشيء النادر يترسبن",
	Callback = function()
	
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")



local originalTextLabel = nil
local timersFolder = workspace:WaitForChild("EventTimers")
local children = timersFolder:GetChildren()

for i = 1, math.min(100, #children) do
    local part = children[i]
    if part:FindFirstChild("SurfaceGui") then
        local surfaceGui = part.SurfaceGui
        if surfaceGui:FindFirstChild("Frame") then
            local frame = surfaceGui.Frame
            if frame:FindFirstChild("TextLabel") then
                originalTextLabel = frame.TextLabel
                break
            end
        end
    end
end


if not originalTextLabel then
    warn("TextLabel not found in workspace.EventTimers (1-100)")
    return
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RespawnTextTranslator"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.8, 0, 0.15, 0)
frame.Position = UDim2.new(0.5, 0, 0.2, 0)
frame.AnchorPoint = Vector2.new(0.5, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BackgroundTransparency = 0.1
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local aspectRatio = Instance.new("UIAspectRatioConstraint")
aspectRatio.AspectRatio = 3.5
aspectRatio.DominantAxis = Enum.DominantAxis.Width
aspectRatio.Parent = frame

local sizeConstraint = Instance.new("UISizeConstraint")
sizeConstraint.MaxSize = Vector2.new(450, math.huge)
sizeConstraint.Parent = frame

local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(1, -10, 0.5, -5)
textLabel.Position = UDim2.new(0, 5, 0, 5)
textLabel.BackgroundTransparency = 1
textLabel.TextWrapped = true
textLabel.TextScaled = true
textLabel.Font = Enum.Font.GothamBold
textLabel.TextColor3 = Color3.fromRGB(255, 105, 180)
textLabel.Parent = frame

local translationLabel = Instance.new("TextLabel")
translationLabel.Size = UDim2.new(1, -10, 0.5, -5)
translationLabel.Position = UDim2.new(0, 5, 0.5, 0)
translationLabel.BackgroundTransparency = 1
translationLabel.TextWrapped = true
translationLabel.TextScaled = true
translationLabel.Font = Enum.Font.GothamBold
translationLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
translationLabel.Parent = frame

local function translateTimer(text)
    local time = text:match("(%d%d:%d%d)")
    if time then
        return "الحاجه النادرة فشخ هتترسبن بعد " .. time
    else
        return ""
    end
end

local function updateText()
    local original = originalTextLabel.Text
    textLabel.Text = original
    translationLabel.Text = translateTimer(original)
end

originalTextLabel:GetPropertyChangedSignal("Text"):Connect(updateText)
updateText()

	end
})

OtherScriptsTab:CreateButton({
    Name = "Anti-AFKv2 By abbas (لازم PC) ",
    Callback = function()
       

local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")


local old = playerGui:FindFirstChild("AntiAFK_abbas_SEREX_v8")
if old then old:Destroy() end



local environment = {
	isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled,
	isPC = UserInputService.KeyboardEnabled,
	hasVirtualUser = pcall(function() VirtualUser:CaptureController() end),
	hasCamera = workspace.CurrentCamera ~= nil
}

local settings = {
	enabled = false,
	baseInterval = 60,
	jitter = 0.4,
	isWindowFocused = true,
	unfocusedMultiplier = 0.7
}

local ui = {}
local connections = {}



local function randRange(a,b)
	return a + math.random() * (b - a)
end

local function nextWait()
	local base = settings.baseInterval
	local jitter = base * settings.jitter
	local w = base + randRange(-jitter, jitter)
	if not settings.isWindowFocused then
		w *= settings.unfocusedMultiplier
	end
	return math.max(8, w)
end

local function makeDraggable(frame)
	local dragging, startPos, startInput

	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			startPos = frame.Position
			startInput = input.Position
		end
	end)

	frame.InputChanged:Connect(function(input)
		if dragging
		and (input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - startInput
			frame.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)

	UserInputService.InputEnded:Connect(function()
		dragging = false
	end)
end



local function updateUI()
	if not ui.main then return end

	local statusText, statusColor, btnText, btnColor

	if settings.enabled then
		statusText = settings.isWindowFocused and "SYSTEM ONLINE" or "UNFOCUSED"
		statusColor = settings.isWindowFocused and Color3.fromRGB(0,255,255) or Color3.fromRGB(255,165,0)
		btnText = "DISABLE"
		btnColor = Color3.fromRGB(0,150,150)
	else
		statusText = "SYSTEM OFFLINE"
		statusColor = Color3.fromRGB(180,40,40)
		btnText = "ENABLE"
		btnColor = Color3.fromRGB(40,42,48)
	end

	
	ui.status.Text = statusText
	ui.button.Text = btnText

	
	TweenService:Create(ui.status, TweenInfo.new(0.25), {
		TextColor3 = statusColor
	}):Play()

	TweenService:Create(ui.button, TweenInfo.new(0.25), {
		BackgroundColor3 = btnColor
	}):Play()

	TweenService:Create(ui.pulse, TweenInfo.new(0.4), {
		BackgroundTransparency = settings.enabled and 0.5 or 1
	}):Play()
end

local function setEnabled(v)
	settings.enabled = v
	updateUI()
end



local function characterMove()
	local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
	if hum then
		hum:Move(Vector3.new(math.random(-1,1),0,math.random(-1,1)), false)
		task.wait(0.1)
		hum:Move(Vector3.zero, false)
	end
end

local function cameraNudge()
	local cam = workspace.CurrentCamera
	if not cam then return end
	local cf = cam.CFrame
	cam.CFrame = cf * CFrame.Angles(0, math.rad(math.random(-2,2)), 0)
	task.wait(0.1)
	cam.CFrame = cf
end

local function virtualClick()
	if not environment.hasVirtualUser then return end
	VirtualUser:CaptureController()
	VirtualUser:ClickButton2(Vector2.new())
end

local function performAction()
	if not settings.enabled then return end
	local pool = {characterMove}
	if environment.hasCamera then table.insert(pool, cameraNudge) end
	if environment.hasVirtualUser then table.insert(pool, virtualClick) end
	pool[math.random(#pool)]()
end



local gui = Instance.new("ScreenGui", playerGui)
gui.Name = "AntiAFK_abbas_SEREX_v8"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,260,0,45)
main.Position = UDim2.new(0.5,0,0,20)
main.AnchorPoint = Vector2.new(0.5,0)
main.BackgroundColor3 = Color3.fromRGB(22,24,28)
main.Active = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,8)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(0,150,0,20)
title.Position = UDim2.new(0,15,0,4)
title.BackgroundTransparency = 1
title.Text = "ANTIAFK FOR PC by abbas"
title.Font = Enum.Font.Gotham
title.TextSize = 14
title.TextColor3 = Color3.fromRGB(200,200,200)
title.TextXAlignment = Enum.TextXAlignment.Left

local status = Instance.new("TextLabel", main)
status.Size = UDim2.new(0,150,0,15)
status.Position = UDim2.new(0,15,0,24)
status.BackgroundTransparency = 1
status.Text = "SYSTEM OFFLINE"
status.Font = Enum.Font.GothamBold
status.TextSize = 11
status.TextColor3 = Color3.fromRGB(180,40,40)
status.TextXAlignment = Enum.TextXAlignment.Left

local button = Instance.new("TextButton", main)
button.Size = UDim2.new(0,70,0,28)
button.Position = UDim2.new(1,-80,0.5,-14)
button.BackgroundColor3 = Color3.fromRGB(40,42,48)
button.Text = "ENABLE"
button.Font = Enum.Font.GothamBold
button.TextSize = 12
button.TextColor3 = Color3.fromRGB(220,220,220)
Instance.new("UICorner", button).CornerRadius = UDim.new(0,5)

local pulse = Instance.new("Frame", main)
pulse.Size = UDim2.new(1,0,0,1)
pulse.Position = UDim2.new(0,0,1,0)
pulse.BackgroundColor3 = Color3.fromRGB(0,255,255)
pulse.BackgroundTransparency = 1

makeDraggable(main)

ui = {gui=gui, main=main, status=status, button=button, pulse=pulse}
updateUI()



button.MouseButton1Click:Connect(function()
	setEnabled(not settings.enabled)
end)

player.Idled:Connect(function()
	if settings.enabled then
		task.spawn(performAction)
	end
end)

task.spawn(function()
	while gui.Parent do
		if settings.enabled then
			performAction()
			task.wait(nextWait())
		else
			task.wait(1)
		end
	end
end) 
    end
})

OtherScriptsTab:CreateSection("© Copyright by abbas")


local HiTab = Window:CreateTab("مميزات حصرية! ", 4483362458)

HiTab:CreateButton({
Name =  "  (متوقف/offline) ينقلك للامام دون جهد منك ",
Callback = function()
-- سكربت التحريك


local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "SafeGapNavigator_abbas_Final"
gui.ResetOnSpawn = false


local INNER_CHILD_INDEX = 2
local TWEEN_TIME = 3.1 
local Y_OFFSET = 3


local State = {
    safePoints = {},
    currentIndex = 1,
    isTeleporting = false,
    GAP_BASE_PATH = nil,
}


local function getHRP()
    local char = player.Character or player.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

local function initializeAndLoadPoints()
    local mapVariants = workspace:WaitForChild("MapVariants", 60)
    if not mapVariants then return end
    local defaultMap = mapVariants:WaitForChild("DefaultMap", 60)
    if not defaultMap then return end
    State.GAP_BASE_PATH = defaultMap:WaitForChild("Gaps", 10)
    if not State.GAP_BASE_PATH then return end
    table.clear(State.safePoints)
    for i = 1, 9 do
        local gap = State.GAP_BASE_PATH:FindFirstChild("Gap" .. i)
        if gap and gap:GetChildren()[INNER_CHILD_INDEX] and gap:GetChildren()[INNER_CHILD_INDEX]:IsA("BasePart") then
            table.insert(State.safePoints, gap:GetChildren()[INNER_CHILD_INDEX])
        end
    end
end

local function teleportToIndex(index)
    if State.isTeleporting or not State.safePoints[index] then return end
    State.isTeleporting = true
    local hrp = getHRP()
    local targetPart = State.safePoints[index]
    local targetCFrame = targetPart.CFrame + Vector3.new(0, Y_OFFSET, 0)
    local tweenInfo = TweenInfo.new(TWEEN_TIME, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    local tween = TweenService:Create(hrp, tweenInfo, { CFrame = targetCFrame })
    tween.Completed:Connect(function() State.isTeleporting = false end)
    tween:Play()
end


local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 180, 0, 125) 
frame.Position = UDim2.new(0.5, -90, 0.75, 0)
frame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)


local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -20, 0, 20)
title.Position = UDim2.new(0, 10, 0, 5)
title.Text = "Made By abbas"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
title.BackgroundTransparency = 1


local up = Instance.new("TextButton", frame)
up.Size = UDim2.new(1, -20, 0, 32)
up.Position = UDim2.new(0, 10, 0, 30) 
up.Text = "▲ يلا قدام"
up.BackgroundColor3 = Color3.fromRGB(39, 174, 96)
up.TextColor3 = Color3.new(1, 1, 1)
up.Font = Enum.Font.GothamBold
up.TextSize = 14
Instance.new("UICorner", up)


local down = Instance.new("TextButton", frame)
down.Size = UDim2.new(1, -20, 0, 32)
down.Position = UDim2.new(0, 10, 0, 70) 
down.Text = "▼ ارجع ورا"
down.BackgroundColor3 = Color3.fromRGB(192, 57, 43)
down.TextColor3 = Color3.new(1, 1, 1)
down.Font = Enum.Font.GothamBold
up.TextSize = 14
Instance.new("UICorner", down)


local note = Instance.new("TextLabel", frame)
note.Size = UDim2.new(1, -20, 0, 15)
note.Position = UDim2.new(0, 10, 0, 105) 
note.Text = "استعمله بذكاء!"
note.Font = Enum.Font.Gotham
note.TextColor3 = Color3.fromRGB(150, 150, 150) -- Gray color
note.TextSize = 12
note.TextXAlignment = Enum.TextXAlignment.Center
note.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
note.BackgroundTransparency = 1


task.spawn(initializeAndLoadPoints)

player.CharacterAdded:Connect(function(character)
    State.currentIndex = 1
    task.wait(1)
    local hrp = character:WaitForChild("HumanoidRootPart")
    if State.safePoints[State.currentIndex] then
        hrp.CFrame = State.safePoints[State.currentIndex].CFrame + Vector3.new(0, Y_OFFSET, 0)
    end
end)


up.MouseButton1Click:Connect(function()
    if #State.safePoints == 0 or State.isTeleporting then return end
    State.currentIndex = math.clamp(State.currentIndex + 1, 1, #State.safePoints)
    teleportToIndex(State.currentIndex)
end)

down.MouseButton1Click:Connect(function()
    if #State.safePoints == 0 or State.isTeleporting then return end
    State.currentIndex = math.clamp(State.currentIndex - 1, 1, #State.safePoints)
    teleportToIndex(State.currentIndex)
end)
end})

HiTab:CreateButton({
Name =  "  (نسخة محسنة/Online) ينقلك للامام دون جهد منك ",
Callback = function()


local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local antiVoidPart = Instance.new("Part")
antiVoidPart.Name = "abbas_SafetyNet"
antiVoidPart.Size = Vector3.new(20000, 10, 20000)
antiVoidPart.Position = Vector3.new(0, -300, 0)
antiVoidPart.Anchored = true
antiVoidPart.CanCollide = true
antiVoidPart.Transparency = 1
antiVoidPart.Parent = Workspace

local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "GapNavigatorUI"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0,200,0,140)
Main.Position = UDim2.new(0.5,-100,0.8,0)
Main.BackgroundColor3 = Color3.fromRGB(40,40,40)
Main.BorderSizePixel = 1
Main.Active = true
Main.Draggable = true

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1,0,0,25)
Title.Text = "Made by abbas"
Title.BackgroundColor3 = Color3.fromRGB(30,30,30)
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16

local Prev = Instance.new("TextButton", Main)
Prev.Text = "للوراء"
Prev.Size = UDim2.new(0.4,0,0,40)
Prev.Position = UDim2.new(0.05,0,0.25,0)
Prev.BackgroundColor3 = Color3.fromRGB(190,40,40)
Prev.TextColor3 = Color3.new(1,1,1)

local Next = Instance.new("TextButton", Main)
Next.Text = "للأمام"
Next.Size = UDim2.new(0.4,0,0,40)
Next.Position = UDim2.new(0.55,0,0.25,0)
Next.BackgroundColor3 = Color3.fromRGB(40,160,70)
Next.TextColor3 = Color3.new(1,1,1)

local Status = Instance.new("TextLabel", Main)
Status.Size = UDim2.new(1,0,0,25)
Status.Position = UDim2.new(0,0,1,-55)
Status.BackgroundTransparency = 1
Status.TextColor3 = Color3.fromRGB(200,200,200)
Status.Font = Enum.Font.SourceSansItalic
Status.TextXAlignment = Enum.TextXAlignment.Center

local PopperButton = Instance.new("TextButton", Main)
PopperButton.Name = "PopperButton"
PopperButton.Text = "رؤية واضحة: OFF"
PopperButton.Size = UDim2.new(0.8, 0, 0, 20)
PopperButton.Position = UDim2.new(0.1, 0, 1, -25)
PopperButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
PopperButton.TextColor3 = Color3.new(1,1,1)
PopperButton.Font = Enum.Font.SourceSans
PopperButton.TextSize = 12
Instance.new("UICorner", PopperButton).CornerRadius = UDim.new(0, 4)

local isPopperActive = false
local noclipActive = false
local noclipConnection = nil
local popperConnection = nil
local lastOccludedParts = {}

local function setNoclip(state)
    if state == noclipActive then return end
    noclipActive = state
    if noclipActive then
        noclipConnection = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)
    elseif noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
end

local function setPopper(state)
    isPopperActive = state
    if isPopperActive then
        popperConnection = RunService.RenderStepped:Connect(function()
            local camera = Workspace.CurrentCamera
            local character = LocalPlayer.Character
            local head = character and character:FindFirstChild("Head")
            if not (camera and head) then return end
            
            for part, _ in pairs(lastOccludedParts) do
                if part and part.Parent then
                    part.LocalTransparencyModifier = 0
                end
            end
            table.clear(lastOccludedParts)
            
            local ignoreList = {character}
            local origin = head.Position
            local camPos = camera.CFrame.Position
            local direction = (camPos - origin).Unit
            local distance = (camPos - origin).Magnitude
            
            local currentOrigin = origin
            for _ = 1, 15 do
                local remainingDistance = (camPos - currentOrigin).Magnitude
                if remainingDistance < 1 then break end

                local ray = Ray.new(currentOrigin, direction * remainingDistance)
                local hitPart, hitPosition = Workspace:FindPartOnRayWithIgnoreList(ray, ignoreList)

                if hitPart and hitPart:IsA("BasePart") and hitPart.Transparency < 1 then
                    hitPart.LocalTransparencyModifier = 0.75
                    lastOccludedParts[hitPart] = true
                    table.insert(ignoreList, hitPart)
                    currentOrigin = hitPosition
                else
                    break 
                end
            end
        end)
        PopperButton.BackgroundColor3 = Color3.fromRGB(25, 85, 160)
        PopperButton.Text = "رؤية واضحة: ON"
    elseif popperConnection then
        popperConnection:Disconnect()
        popperConnection = nil
        
        for part, _ in pairs(lastOccludedParts) do
            if part and part.Parent then
                part.LocalTransparencyModifier = 0
            end
        end
        table.clear(lastOccludedParts)
        PopperButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        PopperButton.Text = "رؤية واضحة: OFF"
    end
end

PopperButton.MouseButton1Click:Connect(function()
    setPopper(not isPopperActive)
end)

local totalGaps = 9
local currentGapIndex = 0

local function getTargetForIndex(index)
    local map = Workspace:WaitForChild("DefaultMap")
    local gaps = map:WaitForChild("Gaps")
    local gap = gaps:WaitForChild("Gap"..index)
    while #gap:GetChildren() < 2 do task.wait(0.1) end
    return gap:GetChildren()[2]
end

local function updateStatus() 
    Status.Text = "سيف بوينت: "..currentGapIndex.." / "..totalGaps 
end

local movementId = 0
local function microStepMove(targetPart, myId)
    setNoclip(true)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not (root and targetPart) then setNoclip(false); return end
    local startPos = root.Position
    local endPos = targetPart.Position + Vector3.new(0,4.5,0)
    local delta = endPos - startPos
    local stepSize = 4.8
    local direction = delta.Unit
    local steps = math.max(math.floor(delta.Magnitude / stepSize), 1)
    for i = 1, steps do
        if myId ~= movementId then setNoclip(false); return end
        root.CFrame = CFrame.new(startPos + direction * (stepSize * i))
        RunService.Heartbeat:Wait()
    end
    if myId == movementId then root.CFrame = CFrame.new(endPos) end
    setNoclip(false)
end

local function moveForward()
    if currentGapIndex < totalGaps then
        movementId += 1; local myId = movementId; currentGapIndex += 1
        local target = getTargetForIndex(currentGapIndex)
        if target then task.spawn(microStepMove, target, myId); updateStatus() end
    end
end

local function moveBackward()
    if currentGapIndex > 1 then
        movementId += 1; local myId = movementId; currentGapIndex -= 1
        local target = getTargetForIndex(currentGapIndex)
        if target then task.spawn(microStepMove, target, myId); updateStatus() end
    end
end

Next.MouseButton1Click:Connect(moveForward)
Prev.MouseButton1Click:Connect(moveBackward)
LocalPlayer.CharacterAdded:Connect(function() movementId += 1; currentGapIndex = 0; updateStatus() end)
updateStatus()


end})

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local BreakZoomEnabled = false

HiTab:CreateToggle({
    Name = "كسر الزوم",
    CurrentValue = false,
    Flag = "BreakZoom",
    Callback = function(Value)
        BreakZoomEnabled = Value
        if Value then
            player.CameraMaxZoomDistance = math.huge
        else
            player.CameraMaxZoomDistance = 15
        end
    end
})

local flingActive = false
local bodyAngular
local gravityForce

HiTab:CreateToggle({
    Name = "قتل اللاعبين(لازم تمسك العصا و تكون قريب منهم او تلزق فيهم) ",
    CurrentValue = false,
    Flag = "FlingNoclipWallFix",
    Callback = function(Value)
        flingActive = Value
    end
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local flingPower = 1e6
local pushRadius = 10

RunService.Stepped:Connect(function()
    local char = player.Character
    if char and flingActive then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hrp and hum then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                    part.Massless = true
                end
            end

            if not bodyAngular then
                bodyAngular = Instance.new("BodyAngularVelocity")
                bodyAngular.AngularVelocity = Vector3.new(0, flingPower, 0)
                bodyAngular.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                bodyAngular.P = math.huge
                bodyAngular.Parent = hrp
            end

            if not gravityForce then
                gravityForce = Instance.new("VectorForce")
                gravityForce.ApplyAtCenterOfMass = true
                gravityForce.Force = Vector3.new(0, -workspace.Gravity * hrp.AssemblyMass, 0)
                gravityForce.Parent = hrp

                local att = Instance.new("Attachment")
                att.Parent = hrp
                gravityForce.Attachment0 = att
            end

            for _, other in ipairs(Players:GetPlayers()) do
                if other ~= player and other.Character then
                    local ohrp = other.Character:FindFirstChild("HumanoidRootPart")
                    if ohrp and (hrp.Position - ohrp.Position).Magnitude <= pushRadius then
                        local bv = Instance.new("BodyVelocity")
                        bv.Velocity = (ohrp.Position - hrp.Position).Unit * flingPower
                        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                        bv.Parent = ohrp
                        task.delay(0.1, function()
                            bv:Destroy()
                        end)
                    end
                end
            end
        end
    else
        if bodyAngular then bodyAngular:Destroy() bodyAngular = nil end
        if gravityForce then gravityForce:Destroy() gravityForce = nil end
    end
end)

HiTab:CreateButton({
Name = "قتل اللاعبين (نسخة محسنة)",

Callback = function()


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer


local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "abbasProGUI"

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromScale(0.36, 0.54)
main.Position = UDim2.fromScale(0.32, 0.22)
main.BackgroundColor3 = Color3.fromRGB(18,18,18)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,16)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0.09,0)
title.Text = "اداة قتل اللاعبين من صنع عباس"
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1


local listFrame = Instance.new("ScrollingFrame", main)
listFrame.Size = UDim2.new(0.9,0,0.28,0)
listFrame.Position = UDim2.new(0.05,0,0.11,0)
listFrame.ScrollBarImageTransparency = 0.4
listFrame.CanvasSize = UDim2.new(0,0,0,0)
listFrame.BackgroundColor3 = Color3.fromRGB(28,28,28)
Instance.new("UICorner", listFrame)

local selected = {}

local function refreshPlayers()
	listFrame:ClearAllChildren()
	selected = {}

	local layout = Instance.new("UIListLayout", listFrame)
	layout.Padding = UDim.new(0,6)

	for _,plr in ipairs(Players:GetPlayers()) do
		if plr ~= LP then
			local btn = Instance.new("TextButton", listFrame)
			btn.Size = UDim2.new(1,-8,0,34)
			btn.Text = plr.Name
			btn.Font = Enum.Font.Gotham
			btn.TextScaled = true
			btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
			btn.TextColor3 = Color3.new(1,1,1)
			Instance.new("UICorner", btn)

			btn.MouseButton1Click:Connect(function()
				if selected[plr] then
					selected[plr] = nil
					btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
				else
					selected[plr] = true
					btn.BackgroundColor3 = Color3.fromRGB(160,50,50)
				end
			end)
		end
	end

	task.wait()
	listFrame.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 6)
end

refreshPlayers()
Players.PlayerAdded:Connect(refreshPlayers)
Players.PlayerRemoving:Connect(refreshPlayers)


local function makeBtn(text, y, h)
	local b = Instance.new("TextButton", main)
	b.Size = UDim2.new(0.85,0,h,0)
	b.Position = UDim2.new(0.075,0,y,0)
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextScaled = true
	b.BackgroundColor3 = Color3.fromRGB(60,60,60)
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", b)
	return b
end

local teleportBtn = makeBtn("التصق في الهدف", 0.42, 0.12)
local flingBtn    = makeBtn("القتل: OFF",        0.56, 0.1)
local espBtn      = makeBtn("ESP : OFF",          0.68, 0.1)


local note = Instance.new("TextLabel", main)
note.Size = UDim2.new(0.9,0,0.21,0) 
note.TextScaled = true                 
note.TextWrapped = true                
note.Position = UDim2.new(0.05,0,0.78,0)
note.Text = "⚠ لازم تكون قريب من اللاعب وإلا هتموت لما تفعل القتل لازم تكون لازق في لاعب او قريب منه عشان يشتغل لو بعيد مش هيشتغل و شخصيتك هتكون ثابته، لما تختار لاعب من فوق و يصير احمر لما تيجي تختار غيره شيل الاحمر من اللاعب الاصلي و اختار غيره"
note.TextScaled = true
note.TextWrapped = true
note.Font = Enum.Font.Gotham
note.TextColor3 = Color3.fromRGB(255,90,90)
note.BackgroundTransparency = 1

teleportBtn.MouseButton1Click:Connect(function()
	for plr,_ in pairs(selected) do
		if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
		and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			LP.Character.HumanoidRootPart.CFrame =
				plr.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,-1)
			break
		end
	end
end)

local flingOn = false
local FLING_POWER = 15000
local hrpConn

local function setupCharacter()
	if hrpConn then hrpConn:Disconnect() end
	local char = LP.Character or LP.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")

	RunService.Stepped:Connect(function()
		if flingOn then
			for _,v in pairs(char:GetDescendants()) do
				if v:IsA("BasePart") then
					v.CanCollide = false
				end
			end
		end
	end)

	hrpConn = hrp.Touched:Connect(function(hit)
		if not flingOn then return end
		local m = hit:FindFirstAncestorOfClass("Model")
		if m and m ~= char and m:FindFirstChild("Humanoid") then
			local att = Instance.new("Attachment", hrp)
			local av = Instance.new("AngularVelocity", hrp)
			av.Attachment0 = att
			av.AngularVelocity = Vector3.new(0, FLING_POWER, 0)
			av.MaxTorque = math.huge
			task.wait(0.15)
			av:Destroy()
			att:Destroy()
		end
	end)
end

setupCharacter()
LP.CharacterAdded:Connect(setupCharacter)

flingBtn.MouseButton1Click:Connect(function()
	flingOn = not flingOn
	flingBtn.Text = flingOn and "القتل : ON" or "القتل: OFF"
end)


local espOn = false
local nameESP = {}
local chamESP = {}

local function applyESP(plr)
	if plr == LP then return end
	if not espOn then return end
	if not plr.Character then return end

	
	if plr.Character:FindFirstChild("Head") then
		if not nameESP[plr] then
			local bb = Instance.new("BillboardGui", plr.Character.Head)
			bb.Size = UDim2.new(0,140,0,40)
			bb.AlwaysOnTop = true

			local txt = Instance.new("TextLabel", bb)
			txt.Size = UDim2.new(1,0,1,0)
			txt.BackgroundTransparency = 1
			txt.Text = plr.Name
			txt.TextColor3 = Color3.fromRGB(255,0,0)
			txt.Font = Enum.Font.GothamBold
			txt.TextScaled = true
			txt.TextStrokeTransparency = 0
			txt.TextStrokeColor3 = Color3.fromRGB(0,0,0)

			nameESP[plr] = bb
		end
	end

	
	if not chamESP[plr] and plr.Character then
		local h = Instance.new("Highlight", plr.Character)
		h.FillColor = Color3.fromRGB(255,0,0)
		h.OutlineColor = Color3.fromRGB(255,255,255)
		h.FillTransparency = 0.55
		chamESP[plr] = h
	end
end

local function clearESP(plr)
	if nameESP[plr] then nameESP[plr]:Destroy() nameESP[plr] = nil end
	if chamESP[plr] then chamESP[plr]:Destroy() chamESP[plr] = nil end
end

local function toggleESP()
	espOn = not espOn
	espBtn.Text = espOn and "ESP : ON" or "ESP : OFF"

	for _,plr in ipairs(Players:GetPlayers()) do
		if espOn then
			applyESP(plr)
		else
			clearESP(plr)
		end
	end
end

espBtn.MouseButton1Click:Connect(toggleESP)


Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function()
		task.wait(0.3)
		applyESP(plr)
	end)
end)


local function hookESPRespawn(plr)
	if plr == LP then return end

	plr.CharacterAdded:Connect(function()
		task.wait(0.3) 
		if espOn then
			clearESP(plr)
			applyESP(plr)
		end
	end)
end


for _,plr in ipairs(Players:GetPlayers()) do
	hookESPRespawn(plr)
end


Players.PlayerAdded:Connect(function(plr)
	hookESPRespawn(plr)
end)
end})

HiTab:CreateButton({
Name =  "  طلوع و دخول سريع ",
Callback = function()
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
TeleportService:Teleport(game.PlaceId, player)
end})

HiTab:CreateSection("© Copyright by abbas")

local SixTab = Window:CreateTab(" AUTO TELEPORTER الانتقال الى اخر الماب نسخة مميزة ", 4483362458)




SixTab:CreateButton({
    Name = "الانتقال الى اخر الماب (FIXED v3)تم استغلال ثغرة مميزة! ", 
    Callback = function()





local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer


local TOUR_POINTS = {
	Vector3.new(152.50, 3.16, -135.32),
	Vector3.new(242.45, 3.21, -139.48),
	Vector3.new(341.16, 3.21, -139.46),
	Vector3.new(466.67, 3.21, -139.51),
	Vector3.new(651.80, 3.21, -139.50),
	Vector3.new(912.58, 3.21, -139.47),
	Vector3.new(1302.22, 3.21, -139.48),
	Vector3.new(2398.07, 3.21, -139.03)
}

local MOVEMENT_SPEED = 2000
local isTourRunning = false
local moveConnection = nil



local MainGui = Instance.new("ScreenGui", CoreGui)
MainGui.Name = "FinalCut_UI"
MainGui.ResetOnSpawn = false
MainGui.DisplayOrder = 1000

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 280, 0, 120)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -60)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = MainGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(100, 100, 100)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Title.Text = "Made By abbas | v3 New exploit"
Title.Font = Enum.Font.SourceSansBold
Title.TextColor3 = Color3.fromRGB(230, 230, 230)
Title.TextSize = 16

local StatusLabel = Instance.new("TextLabel", MainFrame)
StatusLabel.Size = UDim2.new(1, -20, 0, 30)
StatusLabel.Position = UDim2.new(0, 10, 0, 35)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Font = Enum.Font.SourceSans
StatusLabel.TextColor3 = Color3.new(1, 1, 1)
StatusLabel.TextSize = 14
StatusLabel.Text = "ACTIVE! "

local StartButton = Instance.new("TextButton", MainFrame)
StartButton.Size = UDim2.new(1, -20, 0, 40)
StartButton.Position = UDim2.new(0, 10, 1, -50)
StartButton.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
StartButton.Font = Enum.Font.SourceSansBold
StartButton.Text = "التنقل الى اخر الماب "
StartButton.TextColor3 = Color3.new(0, 0, 0)
StartButton.TextSize = 16
Instance.new("UICorner", StartButton).CornerRadius = UDim.new(0, 6)


local BlackoutGui = Instance.new("ScreenGui", CoreGui)
BlackoutGui.Name = "FinalCutBlackout"
BlackoutGui.IgnoreGuiInset = true
BlackoutGui.ResetOnSpawn = false
BlackoutGui.DisplayOrder = 999999
BlackoutGui.Enabled = false

local BlackScreen = Instance.new("Frame", BlackoutGui)
BlackScreen.Size = UDim2.new(1, 0, 1, 0)
BlackScreen.BackgroundColor3 = Color3.new(0, 0, 0)
BlackScreen.BackgroundTransparency = 1


local LoadingText = Instance.new("TextLabel", BlackScreen)
LoadingText.Size = UDim2.new(1, 0, 0, 50)
LoadingText.Position = UDim2.new(0, 0, 0.5, -25)
LoadingText.BackgroundTransparency = 1
LoadingText.Font = Enum.Font.SourceSansBold
LoadingText.Text = "جاري التنقل الى اخر الماب..."
LoadingText.TextColor3 = Color3.new(1, 1, 1)
LoadingText.TextSize = 30
LoadingText.TextTransparency = 1



local function stopMovement()
    if moveConnection then moveConnection:Disconnect(); moveConnection = nil end
end

local function moveToPosition(targetPos)
    local success = false
    while not success do
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        local humanoid = char:WaitForChild("Humanoid")
        local died = false
        local deathConnection = humanoid.Died:Connect(function() died = true; stopMovement() end)
        moveConnection = RunService.Heartbeat:Connect(function(dt)
            if died then return end
            if (targetPos - hrp.Position).Magnitude < 2 then
                success = true; stopMovement()
            else
                local step = math.min((targetPos - hrp.Position).Magnitude, MOVEMENT_SPEED * dt)
                hrp.CFrame = CFrame.new(hrp.Position + (targetPos - hrp.Position).Unit * step)
            end
        end)
        while moveConnection do task.wait() end
        deathConnection:Disconnect()
        if died then StatusLabel.Text = "تم كشف الموت! إعادة المحاولة..."; task.wait(1) end
    end
    return success
end

local function activateFreeVip()
    local vipWalls = workspace:FindFirstChild("VIPWalls")
    if vipWalls then vipWalls:Destroy(); StatusLabel.Text = ". Start inject..."; return true
    else StatusLabel.Text ="Memory injection."; return false end
end

local function startFinalCutTour()
    if isTourRunning then return end
    isTourRunning = true
    StartButton.Interactable = false
    StartButton.Text = "جاري الانتقال.."

    task.spawn(function()
        activateFreeVip()
        task.wait(0.5)
        BlackoutGui.Enabled = true
        TweenService:Create(BlackScreen, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
        TweenService:Create(LoadingText, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
        task.wait(0.5)

        for i, point in ipairs(TOUR_POINTS) do
            StatusLabel.Text = "التوجه إلى النقطة " .. i .. "/" .. #TOUR_POINTS
            moveToPosition(point)
            task.wait(0.1)
        end

        StatusLabel.Text = "تم بنجاح!" 
        task.wait(1)

        TweenService:Create(BlackScreen, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()
        TweenService:Create(LoadingText, TweenInfo.new(1), {TextTransparency = 1}):Play()
        task.wait(1)
        BlackoutGui.Enabled = false

        StartButton.Text = "التنقل الى اخر الماب"
        StartButton.Interactable = true
        isTourRunning = false
    end)
end

StartButton.MouseButton1Click:Connect(startFinalCutTour)




end})

SixTab:CreateParagraph({
        Title = " ملاحظة مهمة بخصوص الانتقال لاخر الماب! ",
        Content =" قد يتم اكتشاف ثغرة في اي وقت في حاله تم تعطيل السكربت يرجى التواصل علي الخاص في تيك توك  my tiktok(._.f.o_) "
    })

SixTab:CreateSection("© Copyright by abbas")

local LuckTab = Window:CreateTab("MAX LUCK ", 4483362458)

LuckTab:CreateToggle({
    Name = "تفعيل ال MAX LUCK",
    CurrentValue = false,
    Flag = "FreezeAFKBar",
    Callback = function(value)
    
      local RunService = game:GetService("RunService")

local afkContainer = workspace.SpawnMachines.Default.Main.Billboard.BillboardGui.Frame.Brainrots.AFKLuckContainer
local fillBar = afkContainer.BarBackground.FillBar
local uiGradient = fillBar.UIGradient


local function freezeBar()
    fillBar.Size = UDim2.new(1, 0, 1, 0)
    if uiGradient then
        fillBar.BackgroundColor3 = uiGradient.Color.Keypoints[1].Value
    end
    for _, child in pairs(fillBar:GetChildren()) do
        if child:IsA("TextLabel") then
            child.Text = "50:00"
        end
    end
end


RunService.RenderStepped:Connect(freezeBar)


 
fillBar:GetPropertyChangedSignal("Size"):Connect(function()
    fillBar.Size = UDim2.new(1, 0, 1, 0)
end)

fillBar:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
    if uiGradient then
        fillBar.BackgroundColor3 = uiGradient.Color.Keypoints[1].Value
    end
end)



for _, child in pairs(fillBar:GetChildren()) do
    if child:IsA("TextLabel") then
        child:GetPropertyChangedSignal("Text"):Connect(function()
            child.Text = "50:00"
        end)
    end
end
        
    end
})

LuckTab:CreateSection("© Copyright by abbas")

local vipTab = Window:CreateTab("VIPمجانا!ميزة جديدة! ", 4483362458)

vipTab:CreateButton({
    Name = " VIP مجانا من صنع عباس",
    Callback = function()

local vipWalls = workspace:FindFirstChild("VIPWalls")

if vipWalls then
    vipWalls:Destroy()
end
end})

vipTab:CreateButton({
    Name = "التنقل عبر جدار vip (مدمج)",
    Callback = function()
        RunEmbeddedVipTp()
    end
})


vipTab:CreateSection("© Copyright by abbas")

local flyTab = Window:CreateTab("SKIP PARKOUR | تخطي الباركور", 44833628)

flyTab:CreateButton({
    Name = " تشغيل سكربت تخطي الباركور (يجب تكون عند الباركور) ",
    Callback = function()

-- سكربت طيران

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local controlModule = require(LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"))


local isFlying = false
local flyVelocity = nil
local flyGyro = nil
local powerAura = nil
local FLY_SPEED = 150
local MAX_SPEED = 1000


local isNoclipping = false
local noclipConnection = nil



local MainGui = Instance.new("ScreenGui", CoreGui)
MainGui.Name = "Chimera_UI_v18"
MainGui.ResetOnSpawn = false


local ShadowFrame = Instance.new("Frame", MainGui)
ShadowFrame.Size = UDim2.new(0, 220, 0, 120)
ShadowFrame.Position = UDim2.new(0, 20, 0.5, -60)
ShadowFrame.BackgroundColor3 = Color3.new(0, 0, 0) -- Black
ShadowFrame.BackgroundTransparency = 0.6 -- Semi-transparent
ShadowFrame.BorderSizePixel = 0
ShadowFrame.Active = true
ShadowFrame.Draggable = true
Instance.new("UICorner", ShadowFrame).CornerRadius = UDim.new(0, 5)


local FlightToggleButton = Instance.new("TextButton", ShadowFrame)
FlightToggleButton.Size = UDim2.new(0, 90, 0, 25)
FlightToggleButton.Position = UDim2.new(0, 10, 0, 10)
FlightToggleButton.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
FlightToggleButton.Font = Enum.Font.SourceSansBold
FlightToggleButton.Text = "الطيران: OFF"
FlightToggleButton.TextColor3 = Color3.new(1, 1, 1)
FlightToggleButton.TextSize = 14
Instance.new("UICorner", FlightToggleButton).CornerRadius = UDim.new(0, 3)


local NoclipToggleButton = Instance.new("TextButton", ShadowFrame)
NoclipToggleButton.Size = UDim2.new(0, 100, 0, 25)
NoclipToggleButton.Position = UDim2.new(1, -110, 0, 10)
NoclipToggleButton.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
NoclipToggleButton.Font = Enum.Font.SourceSansBold
NoclipToggleButton.Text = "اختراق الجدار: OFF"
NoclipToggleButton.TextColor3 = Color3.new(1, 1, 1)
NoclipToggleButton.TextSize = 12
Instance.new("UICorner", NoclipToggleButton).CornerRadius = UDim.new(0, 3)


local SpeedBox = Instance.new("TextBox", ShadowFrame)
SpeedBox.Size = UDim2.new(0, 200, 0, 25)
SpeedBox.Position = UDim2.new(0, 10, 0, 45)
SpeedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SpeedBox.Font = Enum.Font.SourceSans
SpeedBox.Text = tostring(FLY_SPEED)
SpeedBox.PlaceholderText = "أدخل السرعة..."
SpeedBox.TextColor3 = Color3.new(1, 1, 1)
SpeedBox.TextSize = 14
Instance.new("UICorner", SpeedBox).CornerRadius = UDim.new(0, 3)


local SpeedLabel = Instance.new("TextLabel", ShadowFrame)
SpeedLabel.Size = UDim2.new(1, -20, 0, 20)
SpeedLabel.Position = UDim2.new(0, 10, 0, 70)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Font = Enum.Font.SourceSansLight
SpeedLabel.TextColor3 = Color3.new(1, 1, 1)
SpeedLabel.TextSize = 12
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Text = "Speed: " .. FLY_SPEED .. " / " .. MAX_SPEED


local CreditLabel = Instance.new("TextLabel", ShadowFrame)
CreditLabel.Size = UDim2.new(1, 0, 0, 15)
CreditLabel.Position = UDim2.new(0, 0, 1, -15)
CreditLabel.BackgroundTransparency = 1
CreditLabel.Font = Enum.Font.SourceSansItalic
CreditLabel.TextColor3 = Color3.new(1, 1, 1)
CreditLabel.TextSize = 10
CreditLabel.Text = "made by abbas"




local function createAura(parent)
    powerAura = Instance.new("ParticleEmitter", parent)
    powerAura.Color = ColorSequence.new(Color3.fromRGB(0, 170, 255), Color3.fromRGB(85, 255, 255)); powerAura.LightEmission = 0.5
    powerAura.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 2), NumberSequenceKeypoint.new(0.5, 3), NumberSequenceKeypoint.new(1, 2)})
    powerAura.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.8), NumberSequenceKeypoint.new(0.5, 0.5), NumberSequenceKeypoint.new(1, 1)})
    powerAura.Lifetime = NumberRange.new(0.5, 1); powerAura.Rate = 50; powerAura.Speed = NumberRange.new(1); powerAura.SpreadAngle = Vector2.new(360, 360); powerAura.Enabled = true
end

local function startFlying()
    local char = LocalPlayer.Character; if not char or isFlying then return end
    local hrp = char:FindFirstChild("HumanoidRootPart"); local humanoid = char:FindFirstChild("Humanoid"); if not (hrp and humanoid) then return end
    isFlying = true; humanoid.PlatformStand = true
    flyGyro = Instance.new("BodyGyro", hrp); flyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge); flyGyro.P = 50000
    flyVelocity = Instance.new("BodyVelocity", hrp); flyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge); flyVelocity.Velocity = Vector3.new(0, 0, 0)
    createAura(hrp)
    FlightToggleButton.Text = "الطيران: ON"; FlightToggleButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
end

local function stopFlying()
    if not isFlying then return end; isFlying = false
    if flyVelocity then flyVelocity:Destroy() end; if flyGyro then flyGyro:Destroy() end; if powerAura then powerAura:Destroy(); powerAura = nil end
    local char = LocalPlayer.Character; if char and char:FindFirstChild("Humanoid") then char.Humanoid.PlatformStand = false end
    FlightToggleButton.Text = "الطيران: OFF"; FlightToggleButton.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
end


local function startNoclipping()
    if isNoclipping then return end; isNoclipping = true
    NoclipToggleButton.Text = "الاختراق: ON"; NoclipToggleButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
    noclipConnection = RunService.Stepped:Connect(function()
        local char = LocalPlayer.Character
        if not char then return end
        char:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Running)
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end)
end

local function stopNoclipping()
    if not isNoclipping then return end; isNoclipping = false
    if noclipConnection then noclipConnection:Disconnect(); noclipConnection = nil end
    NoclipToggleButton.Text = "اختراق الجدار: OFF"; NoclipToggleButton.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
end


FlightToggleButton.MouseButton1Click:Connect(function() if isFlying then stopFlying() else startFlying() end end)
NoclipToggleButton.MouseButton1Click:Connect(function() if isNoclipping then stopNoclipping() else startNoclipping() end end)

SpeedBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local newSpeed = tonumber(SpeedBox.Text)
        if newSpeed and newSpeed >= 0 and newSpeed <= MAX_SPEED then FLY_SPEED = newSpeed else FLY_SPEED = 150 end
        SpeedBox.Text = tostring(FLY_SPEED); SpeedLabel.Text = "Speed: " .. FLY_SPEED .. " / " .. MAX_SPEED
    end
end)


RunService.RenderStepped:Connect(function()
    if not isFlying or not flyVelocity or not flyGyro then return end
    local char = LocalPlayer.Character; local humanoid = char and char:FindFirstChild("Humanoid"); local camera = workspace.CurrentCamera
    if not (humanoid and camera) then stopFlying(); return end
    flyGyro.CFrame = camera.CFrame
    local moveVector = controlModule:GetMoveVector()
    local direction = Vector3.new(moveVector.X, moveVector.Y, moveVector.Z)
    flyVelocity.Velocity = camera.CFrame:VectorToWorldSpace(direction) * FLY_SPEED
end)


LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid").Died:Connect(function()
        if isFlying then stopFlying() end
        if isNoclipping then stopNoclipping() end
    end)
end)
end})

flyTab:CreateSection("© Copyright by abbas")

local GGTab = Window:CreateTab("سكربت تجميع الشخصيات تلقائي", 4483362458)

GGTab:CreateButton({
    Name = " (لازم نت قوي)تشغيل سكربت تجميع الشخصيات تلقائي",
    Callback = function()



            
                

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local isFarming = false
local selectedRarities = {}
local fireCount = 0
local celestialCount = 0
local movementId = 0
local isDodging = false
local homeTarget = nil
local isCollecting = false

local MAX_FIRE_PER_CYCLE = 10
local MAX_CELESTIAL = 4
local DETECTION_RANGE = 200
local FIXED_SAFE_POINT = Vector3.new(128.3185577392578, 3.1799826622009277, 30.747282028198242)

local BRAINROT_TYPES = {"Celestial","Secret","Mythical","Legendary","Epic","Rare","Uncommon","Common","Cosmic"}


local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,300,0,260)
frame.Position = UDim2.new(0.5,-150,0.5,-130)
frame.BackgroundColor3 = Color3.fromRGB(30,30,35)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner",frame)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "تجميع الشخصيات تلقائي من صنع عباس"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(45,45,55)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
Instance.new("UICorner",title)

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(0.9,0,0,150)
scroll.Position = UDim2.new(0.05,0,0,40)
scroll.CanvasSize = UDim2.new(0,0,0,0)

local grid = Instance.new("UIGridLayout", scroll)
grid.CellSize = UDim2.new(0.48,0,0,35)
grid.CellPadding = UDim2.new(0.02,0,0.02,0)

local startBtn = Instance.new("TextButton", frame)
startBtn.Size = UDim2.new(0.9,0,0,40)
startBtn.Position = UDim2.new(0.05,0,1,-85)
startBtn.Text = "بدء"
startBtn.Font = Enum.Font.GothamBold
startBtn.TextSize = 18
startBtn.BackgroundColor3 = Color3.fromRGB(180,50,50)
startBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",startBtn)

local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(0.9,0,0,25)
status.Position = UDim2.new(0.05,0,1,-35)
status.Text = "جاهز"
status.Font = Enum.Font.Gotham
status.TextSize = 14
status.TextColor3 = Color3.fromRGB(200,200,200)
status.BackgroundColor3 = Color3.fromRGB(45,45,55)
Instance.new("UICorner",status)

for _, rarity in ipairs(BRAINROT_TYPES) do
    local b = Instance.new("TextButton", scroll)
    b.Text = rarity
    b.Font = Enum.Font.Gotham
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(80,80,80)
    Instance.new("UICorner",b)

    b.MouseButton1Click:Connect(function()
        selectedRarities[rarity] = not selectedRarities[rarity]
        b.BackgroundColor3 = selectedRarities[rarity] and Color3.fromRGB(50,160,80) or Color3.fromRGB(80,80,80)
    end)
end
task.wait()
scroll.CanvasSize = UDim2.new(0,0,0,grid.AbsoluteContentSize.Y)

local function setStatus(t)
    status.Text = t
end


local function findTsunamiWaves()
    local waves = {}
    for _, folder in pairs({workspace:FindFirstChild("ActiveTsunamis"), workspace:FindFirstChild("Tsunami")}) do
        if folder then
            for _, p in pairs(folder:GetDescendants()) do
                if p:IsA("BasePart") then
                    table.insert(waves,p)
                end
            end
        end
    end
    return waves
end

local function findSafeGapFromTsunami(tsunamiPos)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local gaps = workspace.DefaultMap:FindFirstChild("Gaps")
    if not (hrp and gaps) then return end

    local bestGap, minDistance = nil, math.huge
    local awayDir = (hrp.Position - tsunamiPos).Unit

    for i=1,9 do
        local g = gaps:FindFirstChild("Gap"..i)
        if g and g:GetChildren()[2] then
            local pos = g:GetChildren()[2].Position
            local distance = (hrp.Position - pos).Magnitude
            local dirToGap = (pos - hrp.Position).Unit
            local dot = dirToGap:Dot(awayDir)

            if distance < minDistance and dot > -0.2 then
                minDistance = distance
                bestGap = pos
            end
        end
    end

    return bestGap
end

local function tacticalMove(targetPos)
    movementId += 1
    local currentMoveId = movementId

    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local start = root.Position
    local goal = targetPos + Vector3.new(0,4,0)
    local dir = (goal - start)
    local step = 12
    local steps = math.floor(dir.Magnitude/step)

    for i=1,steps do
        if currentMoveId ~= movementId or not isFarming then return end
        root.CFrame = CFrame.new(start + dir.Unit * (step*i))
        task.wait(0.01)
    end

    if currentMoveId == movementId then
        root.CFrame = CFrame.new(goal)
    end
end



task.spawn(function()
    while true do
        if isFarming then
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local danger = false
            if hrp then
                for _, wave in pairs(findTsunamiWaves()) do
                    if (hrp.Position - wave.Position).Magnitude <= DETECTION_RANGE then
                        danger = true
                        isDodging = true
                        local safe = findSafeGapFromTsunami(wave.Position)
                        if safe then tacticalMove(safe) end
                        break
                    end
                end
            end
            if not danger then
                isDodging = false
            end
        end
        task.wait()
    end
end)

local function collectBrainrot(model)
    if not model or not model.Parent then return false end
    local prompt = model:FindFirstChildWhichIsA("ProximityPrompt", true)
    if not prompt then return false end

    local collected = false
    if not isDodging then
        pcall(function()
            fireproximityprompt(prompt)
            collected = true
        end)
    end
    return collected
end



task.spawn(function()
    while true do
        if isFarming then
            if fireCount >= MAX_FIRE_PER_CYCLE or celestialCount >= MAX_CELESTIAL then
                if not homeTarget then
                    homeTarget = FIXED_SAFE_POINT
                    setStatus("الرجوع للبيت...")
                end
                if not isDodging then tacticalMove(homeTarget) end
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp and (hrp.Position - homeTarget).Magnitude < 6 then
                    fireCount = 0
                    celestialCount = 0
                    homeTarget = nil
                    setStatus("دورة جديدة")
                end
            else
                if not isDodging then
                    local foundTarget, rarityName
                    for rarity,v in pairs(selectedRarities) do
                        if v then
                            if rarity == "Celestial" and celestialCount >= MAX_CELESTIAL then
                                continue
                            end
                            local folder = workspace.ActiveBrainrots:FindFirstChild(rarity)
                            if folder then
                                local model = folder:FindFirstChild("RenderedBrainrot")
                                if model and model.PrimaryPart then
                                    foundTarget = model
                                    rarityName = rarity
                                    break
                                end
                            end
                        end
                    end

                    if foundTarget then
                        setStatus("تم العثور على "..rarityName)
                        tacticalMove(foundTarget.PrimaryPart.Position)
                        local ok = collectBrainrot(foundTarget)
                        if ok then
                            fireCount += 1
                            if rarityName == "Celestial" then
                                celestialCount += 1
                            end
                            if rarityName == "Celestial" then
    setStatus("تم الالتقاط ("..celestialCount.."/"..MAX_CELESTIAL..")")
else
    setStatus("تم الالتقاط ("..fireCount.."/"..MAX_FIRE_PER_CYCLE..")")
end
                        end
                    else
                        
     

    
    if selectedRarities["Celestial"] then
        setStatus("في انتظار الهدف... ("..celestialCount.."/"..MAX_CELESTIAL..")")
    else
        setStatus("في انتظار الهدف... ("..fireCount.."/"..MAX_FIRE_PER_CYCLE..")")
    end
    task.wait(0.1)
end
                end
            end
        end
        task.wait(0.05)
    end
end)

startBtn.MouseButton1Click:Connect(function()
    isFarming = not isFarming
    if isFarming then
        fireCount = 0
        celestialCount = 0
        isDodging = false
        homeTarget = nil
        startBtn.Text = "إيقاف"
        startBtn.BackgroundColor3 = Color3.fromRGB(60,170,90)
        setStatus("في انتظار الهدف...")
    else
        startBtn.Text = "بدء"
        startBtn.BackgroundColor3 = Color3.fromRGB(180,50,50)
        setStatus("متوقف")
    end
end)


local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

local noclip = false


local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.Position = UDim2.new(0.3, 0, 0.3, 0)
Frame.Size = UDim2.new(0, 220, 0, 130)
Frame.Active = true
Frame.Draggable = true
Frame.BorderSizePixel = 0

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel")
Title.Parent = Frame
Title.Text = "سكربت المساعد لسكربت التجميع التلقائي" 
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(0, 170, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18

local Credit = Instance.new("TextLabel")
Credit.Parent = Frame
Credit.Text = "Made by abbas"
Credit.Position = UDim2.new(0, 0, 0.75, 0)
Credit.Size = UDim2.new(1, 0, 0, 25)
Credit.BackgroundTransparency = 1
Credit.TextColor3 = Color3.fromRGB(200, 200, 200)
Credit.Font = Enum.Font.Gotham
Credit.TextSize = 13

local Button = Instance.new("TextButton")
Button.Parent = Frame
Button.Size = UDim2.new(0.8, 0, 0, 40)
Button.Position = UDim2.new(0.1, 0, 0.35, 0)
Button.Text = "المساعد : OFF"
Button.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.Font = Enum.Font.GothamBold
Button.TextSize = 16
Button.BorderSizePixel = 0

local UICorner2 = Instance.new("UICorner", Button)
UICorner2.CornerRadius = UDim.new(0, 10)


RunService.Stepped:Connect(function()
	if noclip and player.Character then
		for _, v in pairs(player.Character:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end
end)

Button.MouseButton1Click:Connect(function()
	noclip = not noclip
	
	if noclip then
		Button.Text = "المساعد : ON"
		Button.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
	else
		Button.Text = "المساعد : OFF"
		Button.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
	end
end)
end})

GGTab:CreateSection("© Copyright by abbas")

local smkTab = Window:CreateTab("سكربت يمنعك من الموت ضد تسونامي", 4483362458)
    
smkTab:CreateButton({
    Name = "تشغيل سكربت الحمايه من تسونامي من صنع عباس",
    Callback = function()



local ScreenGui = Instance.new("ScreenGui", game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "GodModeUI"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 220, 0, 80)
MainFrame.Position = UDim2.new(0.5, -110, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderColor3 = Color3.fromRGB(255, 215, 0)
MainFrame.BorderSizePixel = 1
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 20)
Title.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Title.Text = "سكربت يحميك من اول تسونامي او ثاني تسونامي من صنع عباس ( لو صار مشاكل سوي off ثم on) "
Title.TextColor3 = Color3.fromRGB(255, 215, 0)
Title.Font = Enum.Font.SourceSansBold

local ToggleButton = Instance.new("TextButton", MainFrame)
ToggleButton.Size = UDim2.new(0.8, 0, 0, 40)
ToggleButton.Position = UDim2.new(0.1, 0, 0.35, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(190, 40, 40)
ToggleButton.TextColor3 = Color3.new(1, 1, 1)
ToggleButton.Text = "OFF"
ToggleButton.Font = Enum.Font.GothamBold


local GOD_MODE_ENABLED = false
local connections = {}
local original_namecall

local function enableGodMode(char)
    
    local humanoid = char:WaitForChild("Humanoid")

    
    connections.heartbeat = game:GetService("RunService").Heartbeat:Connect(function()
        if humanoid and humanoid.Parent then
            humanoid.MaxHealth = 100
            humanoid.Health = 100
        end
    end)

    
    connections.healthChanged = humanoid.HealthChanged:Connect(function()
        if humanoid.Health < 100 then
            humanoid.Health = 100
        end
    end)

    
    pcall(function()
        local mt = getrawmetatable(humanoid)
        original_namecall = original_namecall or mt.__namecall
        setreadonly(mt, false)
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if string.find(string.lower(method), "damage") or string.find(string.lower(method), "health") then
                return
            end
            return original_namecall(self, ...)
        end)
        setreadonly(mt, true)
    end)
end

local function disableGodMode()
    for _, conn in pairs(connections) do
        conn:Disconnect()
    end
    connections = {}

    pcall(function()
        local char = game:GetService("Players").LocalPlayer.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if humanoid and original_namecall then
            local mt = getrawmetatable(humanoid)
            setreadonly(mt, false)
            mt.__namecall = original_namecall
            setreadonly(mt, true)
        end
    end)
end

local function onCharacter(char)
    if GOD_MODE_ENABLED then
        
        enableGodMode(char)
    end
end

ToggleButton.MouseButton1Click:Connect(function()
    GOD_MODE_ENABLED = not GOD_MODE_ENABLED
    
    if GOD_MODE_ENABLED then
        ToggleButton.Text = "ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 160, 70)
        local char = game:GetService("Players").LocalPlayer.Character
        if char then enableGodMode(char) end
    else
        ToggleButton.Text = "OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(190, 40, 40)
        disableGodMode()
    end
end)


local LocalPlayer = game:GetService("Players").LocalPlayer
if LocalPlayer.Character then
    onCharacter(LocalPlayer.Character)
end
LocalPlayer.CharacterAdded:Connect(onCharacter)
end})
smkTab:CreateSection("© Copyright by abbas")

    local abbasTab = Window:CreateTab("AutoCollect_Byabbas", 4483362458)
    
abbasTab:CreateButton({
    Name = "تجميع الفلوس تلقاءي من صنع عباس",
    Callback = function()
        -- سكربت كوليكت




local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

if PlayerGui:FindFirstChild("AutoCollectGUI_abbas") then
    PlayerGui.AutoCollectGUI_abbas:Destroy()
end


local ScreenGui = Instance.new("ScreenGui", PlayerGui); ScreenGui.Name = "AutoCollectGUI_abbas"; ScreenGui.ResetOnSpawn = false; ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
local MainFrame = Instance.new("Frame", ScreenGui); MainFrame.BackgroundColor3 = Color3.fromRGB(30, 32, 38); MainFrame.Size = UDim2.new(0, 240, 0, 155); MainFrame.Position = UDim2.new(0.5, -120, 0.5, -77); MainFrame.Active = true; MainFrame.Draggable = true; Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8); local stroke = Instance.new("UIStroke", MainFrame); stroke.Color = Color3.fromRGB(80, 82, 90); stroke.Thickness = 1.5
local Header = Instance.new("Frame", MainFrame); Header.BackgroundColor3 = Color3.fromRGB(40, 42, 48); Header.Size = UDim2.new(1, 0, 0, 32); Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 8); local grad = Instance.new("UIGradient", Header); grad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(55, 58, 64)), ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 42, 48))}); grad.Rotation = 90
local TitleLabel = Instance.new("TextLabel", Header); TitleLabel.BackgroundTransparency = 1; TitleLabel.Size = UDim2.new(1, 0, 1, 0); TitleLabel.Font = Enum.Font.GothamBold; TitleLabel.Text = "Script autocollect by abbas"; TitleLabel.TextColor3 = Color3.fromRGB(220, 221, 222); TitleLabel.TextSize = 16
local ToggleButton = Instance.new("TextButton", MainFrame); ToggleButton.BackgroundColor3 = Color3.fromRGB(231, 76, 60); ToggleButton.Position = UDim2.new(0.5, -50, 0, 42); ToggleButton.Size = UDim2.new(0, 100, 0, 28); ToggleButton.Font = Enum.Font.GothamBold; ToggleButton.Text = "OFF"; ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255); ToggleButton.TextSize = 18; Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 6)
local NoteLabel = Instance.new("TextLabel", MainFrame); NoteLabel.BackgroundTransparency = 1; NoteLabel.Position = UDim2.new(0.05, 0, 0, 78); NoteLabel.Size = UDim2.new(0.9, 0, 0, 48); NoteLabel.Font = Enum.Font.SourceSans; NoteLabel.Text = 'ملاحظة: لازم بيتك يكون كامل ومصمم من 3 أدوار وفي كل دور brainrot، إلا ممكن تحتاج تعمل كتير  (OFF/ON) او هتفضل AFK بس لازم تشغل سكربت antiafk ( حاجه مهمة لازم تكون داخل بيتك عشان يشتغل  بكفاءه و يجمع الفلوس).'; NoteLabel.TextColor3 = Color3.fromRGB(255, 193, 7); NoteLabel.TextSize = 12; NoteLabel.TextWrapped = true; NoteLabel.TextXAlignment = Enum.TextXAlignment.Center


local StatusBar = Instance.new("TextLabel", MainFrame)
StatusBar.Size = UDim2.new(1, 0, 0, 20)
StatusBar.Position = UDim2.new(0, 0, 1, -20) -- Positioned at the very bottom
StatusBar.BackgroundColor3 = Color3.fromRGB(80, 82, 90) -- Neutral color
StatusBar.Font = Enum.Font.Gotham
StatusBar.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusBar.Text = "الحالة: جاهز"
StatusBar.TextSize = 12
local statusCorner = Instance.new("UICorner", StatusBar); statusCorner.CornerRadius = UDim.new(0, 8)


local function updateStatus(text, color)
    StatusBar.Text = "الحالة: " .. text
    StatusBar.BackgroundColor3 = color
end


local COLLECT_ENABLED = false
local TargetBase = nil 
local originalJumpPower = 50
local jumpPowerConnection = nil
local JUMP_THREAD_ACTIVE = false
local originalCollisions = {}
local FlySpeed = 100
local LandingSpeed = 20
local BodyGyro, BodyVelocity

local function setNoclip(state)
    local character = LocalPlayer.Character
    if not character then return end
    if state then
        originalCollisions = {}
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                originalCollisions[part] = part.CanCollide
                part.CanCollide = false
            end
        end
    else
        for part, canCollide in pairs(originalCollisions) do
            if part and part.Parent then part.CanCollide = canCollide end
        end
        originalCollisions = {}
    end
end

local function findBasePlayerIsInside()
    updateStatus("...جاري البحث عن بيتك", Color3.fromRGB(80, 82, 90))
    local character = LocalPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if not hrp then updateStatus("خطأ: لم يتم العثور على شخصيتك", Color3.fromRGB(231, 76, 60)); return nil end

    local basesFolder = Workspace:WaitForChild("Bases", 10)
    if not basesFolder then updateStatus("خطأ: لم يتم العثور على مجلد البيوت", Color3.fromRGB(231, 76, 60)); return nil end

    for _, base in ipairs(basesFolder:GetChildren()) do
        if base:IsA("Model") and #base:GetChildren() > 0 then
            local cframe, size = base:GetBoundingBox()
            local relativePos = cframe:PointToObjectSpace(hrp.Position)
            if (math.abs(relativePos.X) <= size.X / 2) and (math.abs(relativePos.Y) <= size.Y / 2) and (math.abs(relativePos.Z) <= size.Z / 2) then
                updateStatus("تم العثور على بيتك! جاري التجميع...", Color3.fromRGB(46, 204, 113))
                return base
            end
        end
    end

    updateStatus("اذهب إلى بيتك ثم اضغط ON", Color3.fromRGB(255, 193, 7))
    return nil
end

local function flyToTarget(targetPart)
    local character = LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not rootPart or not targetPart then return end
    if not BodyGyro or not BodyGyro.Parent then BodyGyro = Instance.new("BodyGyro", rootPart); BodyGyro.P = 20000; BodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge) end
    if not BodyVelocity or not BodyVelocity.Parent then BodyVelocity = Instance.new("BodyVelocity", rootPart); BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge) end
    local approachPosition = targetPart.Position + Vector3.new(0, 8, 0)
    while COLLECT_ENABLED and targetPart and targetPart.Parent and (rootPart.Position - approachPosition).Magnitude > 5 do
        updateStatus("... يتم التجميع الان", Color3.fromRGB(52, 152, 219))
        local direction = (approachPosition - rootPart.Position).Unit; BodyGyro.CFrame = CFrame.new(rootPart.Position, approachPosition); BodyVelocity.Velocity = direction * FlySpeed; RunService.Heartbeat:Wait()
    end
    if not COLLECT_ENABLED then return end
    local targetPosition = targetPart.Position
    while COLLECT_ENABLED and targetPart and targetPart.Parent and (rootPart.Position - targetPosition).Magnitude > 0.5 do
        local direction = (targetPosition - rootPart.Position).Unit; BodyGyro.CFrame = CFrame.new(rootPart.Position, targetPosition); BodyVelocity.Velocity = direction * LandingSpeed; RunService.Heartbeat:Wait()
    end
    if BodyVelocity then BodyVelocity.Velocity = Vector3.new(0, 0, 0) end
end

ToggleButton.MouseButton1Click:Connect(function()
    COLLECT_ENABLED = not COLLECT_ENABLED
    JUMP_THREAD_ACTIVE = COLLECT_ENABLED
    ToggleButton.BackgroundColor3 = COLLECT_ENABLED and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(231, 76, 60)
    ToggleButton.Text = COLLECT_ENABLED and "ON" or "OFF"
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    setNoclip(COLLECT_ENABLED)
    if COLLECT_ENABLED then
        TargetBase = findBasePlayerIsInside()
        if not TargetBase then
            COLLECT_ENABLED = false; JUMP_THREAD_ACTIVE = false; ToggleButton.BackgroundColor3 = Color3.fromRGB(231, 76, 60); ToggleButton.Text = "OFF"; setNoclip(false); return
        end
        originalJumpPower = humanoid.JumpPower; humanoid.UseJumpPower = true; humanoid.JumpPower = 1
        jumpPowerConnection = humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function() if humanoid.JumpPower ~= 1 then humanoid.JumpPower = 1 end end)
    else
        updateStatus("متوقف", Color3.fromRGB(80, 82, 90))
        TargetBase = nil; if jumpPowerConnection then jumpPowerConnection:Disconnect() end; if BodyGyro then BodyGyro:Destroy() end; if BodyVelocity then BodyVelocity:Destroy() end; humanoid.JumpPower = originalJumpPower
    end
end)


coroutine.wrap(function() local cps = 7; local interval = 1 / cps; while true do if JUMP_THREAD_ACTIVE then local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid"); if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end end; task.wait(interval) end end)()
coroutine.wrap(function() while true do if COLLECT_ENABLED and TargetBase and TargetBase.Parent then local slotsFolder = TargetBase:FindFirstChild("Slots"); if slotsFolder then local slotsTable = slotsFolder:GetChildren(); table.sort(slotsTable, function(a, b) local numA, numB = tonumber(a.Name), tonumber(b.Name); if numA and numB then return numA < numB end; return a.Name < b.Name end); for _, slot in ipairs(slotsTable) do if not COLLECT_ENABLED then break end; local targetPart = slot:FindFirstChild("Collect"); if targetPart and targetPart:IsA("BasePart") then flyToTarget(targetPart); task.wait(0.2) end end end end; task.wait(0.5) end end)()


    end
})


abbasTab:CreateButton({
    Name = "تجميع الفلوس تلقاءي من صنع عباس (نسخة اسرع) ",
    Callback = function()



local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Workspace = game:GetService("Workspace")

if PlayerGui:FindFirstChild("AutoCollectGUI_abbas") then
    PlayerGui.AutoCollectGUI_abbas:Destroy()
end

local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "AutoCollectGUI_abbas"
ScreenGui.ResetOnSpawn = false 
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 32, 38)
MainFrame.Size = UDim2.new(0, 240, 0, 130)
MainFrame.Position = UDim2.new(0.5, -120, 0.5, -65)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(80, 82, 90)
Instance.new("UIStroke", MainFrame).Thickness = 1.5

local Header = Instance.new("Frame", MainFrame)
Header.BackgroundColor3 = Color3.fromRGB(40, 42, 48)
Header.Size = UDim2.new(1, 0, 0, 32)
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 8)
local UIGradient_Header = Instance.new("UIGradient", Header)
UIGradient_Header.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(55, 58, 64)), ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 42, 48))})
UIGradient_Header.Rotation = 90

local TitleLabel = Instance.new("TextLabel", Header)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Size = UDim2.new(1, 0, 1, 0)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "Script autocollect by abbas"
TitleLabel.TextColor3 = Color3.fromRGB(220, 221, 222)
TitleLabel.TextSize = 16

local ToggleButton = Instance.new("TextButton", MainFrame)
ToggleButton.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
ToggleButton.Position = UDim2.new(0.5, -50, 0, 42)
ToggleButton.Size = UDim2.new(0, 100, 0, 28)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 18
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 6)
local UIStroke_Button = Instance.new("UIStroke", ToggleButton)
UIStroke_Button.Color = Color3.fromRGB(255, 255, 255)
UIStroke_Button.Thickness = 1
UIStroke_Button.Transparency = 0.5

local NoteLabel = Instance.new("TextLabel", MainFrame)
NoteLabel.BackgroundTransparency = 1
NoteLabel.Position = UDim2.new(0.05, 0, 0, 78)
NoteLabel.Size = UDim2.new(0.9, 0, 0, 48)
NoteLabel.Font = Enum.Font.SourceSans

NoteLabel.Text = 'ملاحظة: لازم بيتك يكون كامل ومصمم من 3 أدوار وفي كل دور brainrot، إلا ممكن تحتاج تعمل كتير  (OFF/ON) او هتفضل AFK بس لازم تشغل سكربت antiafk ( حاجه مهمة لازم تكون داخل بيتك عشان يشتغل  بكفاءه و يجمع الفلوس).' 


NoteLabel.TextColor3 = Color3.fromRGB(255, 193, 7)
NoteLabel.TextSize = 12
NoteLabel.TextWrapped = true
NoteLabel.TextXAlignment = Enum.TextXAlignment.Center

local SCRIPT_ENABLED = false
local TargetBase = nil 

local function identifyClosestBase()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return nil end
    local playerPosition = LocalPlayer.Character.HumanoidRootPart.Position
    local minDistance = math.huge
    local foundBase = nil
    local basesFolder = Workspace:FindFirstChild("Bases")
    if not basesFolder then return nil end
    for _, base in ipairs(basesFolder:GetChildren()) do
        if base:IsA("Model") and base:FindFirstChild("Slots") and base.PrimaryPart then
            local distance = (playerPosition - base.PrimaryPart.Position).Magnitude
            if distance < minDistance then
                minDistance = distance
                foundBase = base
            end
        end
    end
    return foundBase
end

local function teleportToTarget(targetPart)
    local character = LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not rootPart or not targetPart or not targetPart.Parent then return end
    rootPart.CFrame = CFrame.new(targetPart.Position) * CFrame.new(0, 3, 0)
end

ToggleButton.MouseButton1Click:Connect(function()
    SCRIPT_ENABLED = not SCRIPT_ENABLED
    local onColor = Color3.fromRGB(46, 204, 113)
    local offColor = Color3.fromRGB(231, 76, 60)
    ToggleButton.BackgroundColor3 = SCRIPT_ENABLED and onColor or offColor
    ToggleButton.Text = SCRIPT_ENABLED and "ON" or "OFF"

    if SCRIPT_ENABLED then
        TargetBase = identifyClosestBase()
        if not TargetBase then
            warn(" بتشوف الكونسول لية؟ ") 
        end
    else
        TargetBase = nil
    end
end)

coroutine.wrap(function()
    while true do
        if SCRIPT_ENABLED and TargetBase and TargetBase.Parent then
            local slotsFolder = TargetBase:FindFirstChild("Slots")
            if slotsFolder then
                local slotsTable = slotsFolder:GetChildren()
                table.sort(slotsTable, function(a, b)
                    local numA, numB = tonumber(a.Name), tonumber(b.Name)
                    if numA and numB then return numA < numB end
                    return a.Name < b.Name
                end)
                
                for _, slot in ipairs(slotsTable) do
                    if not SCRIPT_ENABLED then break end
                    local targetPart = slot:FindFirstChild("Collect")
                    if targetPart and targetPart:IsA("BasePart") then
                        
                        
                        teleportToTarget(targetPart)
                        
                        
                        task.wait(0.1) 
                        
                        
                        
                        
                        
                        task.wait(0.1)
                    end
                end
            end
        end
        task.wait(0.1)
    end
end)()
end})

abbasTab:CreateParagraph({
        Title = "  ملاحظة مهمة بخصوص الاوتو كوليكت /التجميع التلقاءي",
        Content = "لازم تكون داخل بيتك و الا راح يصير لك قلتشات ولو رايح تنام و تترك الجهاز يجمع شغل سكربت Antiafk."
    })

abbasTab:CreateSection("© Copyright by abbas")

    local MiscTab = Window:CreateTab("MISC", 4483362458)
    local InfoTab = Window:CreateTab("INFO", 4483362458)

    
    MiscTab:CreateSection("مميزات جديدة! ")
    MiscTab:CreateToggle({Name = " تفادي التسونامي (العادي)", CurrentValue = false, Callback = function(v) isGuarding = v; if v then isInstantGuarding = false; Rayfield:Notify({Title="تفادي التسونامي العادي", Content="تم التفعيل (عمو عباس بيحبك)!", Duration=3}) end end})
    MiscTab:CreateToggle({Name = " تفادي التسونامي (السريع فشخ)", CurrentValue = false, Callback = function(v) isInstantGuarding = v; if v then isGuarding = false; Rayfield:Notify({Title="تفادي التسونامي السريع فشخ", Content="تم التفعيل (عمو عباس بيحبك) ", Duration=3}) end end})
    
    
    MiscTab:CreateParagraph({
        Title = " ملاحظة هامة بخصوص تفادي التسونامي",
        Content = "لازم تكون قريب من المكان الي تستخبي فيه عشان لو بعيد هيحصل قلتش و تموت."
    })





local isCollectingMoney = false
local MONEY_COLLECTOR_SPEED = 800

local function genericTweenTeleport(targetPosition, speed)
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local distance = (hrp.Position - targetPosition).Magnitude
    if distance < 3 then
        hrp.CFrame = CFrame.new(targetPosition)
        return true
    end
    local duration = math.max(distance / speed, 0.05)
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(targetPosition)})
    tween:Play()
    local startTime = tick()
    while (hrp.Position - targetPosition).Magnitude > 2 and (tick() - startTime) < duration + 0.2 do
        if not isCollectingMoney then
            tween:Cancel()
            break
        end
        task.wait()
    end
    hrp.CFrame = CFrame.new(targetPosition)
    return true
end

local function findMoneyCoinCores()
    local cores = {}
    local moneyFolder = workspace:FindFirstChild("MoneyEventParts")
    if moneyFolder then
        for _, model in pairs(moneyFolder:GetChildren()) do
            if model:IsA("Model") and model.Name == "GoldBar" then
                local corePart = model:FindFirstChild("Main")
                if corePart and corePart:IsA("BasePart") then
                    table.insert(cores, corePart)
                end
            end
        end
    end
    return cores
end

local function startMoneyCoinCollectorLoop()
    task.spawn(function()
        while isCollectingMoney do
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not hrp or (LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character.Humanoid.Health <= 0) then
                task.wait(1)
                continue
            end

            local cores = findMoneyCoinCores()
            local nearestCore = nil
            local minDistance = math.huge

            for _, core in pairs(cores) do
                if core and core.Parent then
                    local distance = (hrp.Position - core.Position).Magnitude
                    if distance < minDistance then
                        minDistance = distance
                        nearestCore = core
                    end
                end
            end

            if nearestCore then
                genericTweenTeleport(nearestCore.Position, MONEY_COLLECTOR_SPEED)
            else
                if (hrp.Position - SAFE_POINT).Magnitude > 20 then
                    genericTweenTeleport(SAFE_POINT, MONEY_COLLECTOR_SPEED)
                end
                task.wait(0.5)
            end
            
            task.wait(0.05)
        end
    end)
end

MiscTab:CreateToggle({
    Name = "تجميع عملات حدث ال money", 
    CurrentValue = false, 
    Callback = function(v) 
        isCollectingMoney = v; 
        if v then 
            startMoneyCoinCollectorLoop(); 
            Rayfield:Notify({Title="MONEY COIN COLLECTOR ON", Content="شغال!", Duration=3}) 
        else 
            Rayfield:Notify({Title="MONEY COIN COLLECTOR OFF", Content="واقف", Duration=2}) 
        end 
    end
})

MiscTab:CreateSlider({
    Name = "سرعة تجميع الـ Money", 
    Range = {500, 4000}, 
    Increment = 100, 
    CurrentValue = 800,
    Callback = function(v) 
        MONEY_COLLECTOR_SPEED = v; 
        Rayfield:Notify({Title="Money Collector Speed", Content="تم ضبط السرعة على: " .. v, Duration=2}) 
    end
})





local UFO_COLLECTOR_SPEED = 800 



local function findUfoCoinHitboxes()
    local hitboxes = {}
    for _, part in pairs(workspace:GetDescendants()) do
        if part.Name == "Hitbox" and part:IsA("BasePart") then
            if part.Parent and part.Parent.Name == "UFO Coin" and part.Parent:IsA("Model") then
                table.insert(hitboxes, part)
            end
        end
    end
    return hitboxes
end



local function findNearestUfoHitbox()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil, nil end
    
    local hitboxes = findUfoCoinHitboxes()
    
    local nearestHitbox = nil
    local minDistance = math.huge
    for _, hitbox in pairs(hitboxes) do
        if hitbox and hitbox.Parent then
            local distance = (hrp.Position - hitbox.Position).Magnitude
            if distance < minDistance then
                minDistance = distance
                nearestHitbox = hitbox
            end
        end
    end
    return nearestHitbox, minDistance
end



local function ufoTweenTeleport(targetPosition)
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local distance = (hrp.Position - targetPosition).Magnitude
    if distance < 3 then
        hrp.CFrame = CFrame.new(targetPosition)
        return true
    end
    
    local duration = math.max(distance / UFO_COLLECTOR_SPEED, 0.05)
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(targetPosition)})
    tween:Play()
    local startTime = tick()
    while (hrp.Position - targetPosition).Magnitude > 2 and (tick() - startTime) < duration + 0.2 do
        task.wait()
    end
    hrp.CFrame = CFrame.new(targetPosition)
    return true
end


local isCollectingUfoCoins = false



local function startUfoCollectorLoop()
    task.spawn(function()
        while isCollectingUfoCoins do
            local success, err = pcall(function()
                local char = LocalPlayer.Character
                if not char then return end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                
                local nearestHitbox, dist = findNearestUfoHitbox()
                
                if nearestHitbox and nearestHitbox.Parent then
                    local teleported = ufoTweenTeleport(nearestHitbox.Position)
                    if teleported then
                        hrp.Velocity = Vector3.zero
                        firetouchinterest(hrp, nearestHitbox, 0)
                        task.wait(0.02)
                        firetouchinterest(hrp, nearestHitbox, 1)
                        task.wait(0.05)
                    end
                else
                    if (hrp.Position - SAFE_POINT).Magnitude > 30 then
                        ufoTweenTeleport(SAFE_POINT)
                    end
                    task.wait(0.5)
                end
            end)
            if not success then
                warn("بتشوف الكونسول صح")
            end
            task.wait(0.03)
        end
    end)
end


MiscTab:CreateParagraph({
    Title = " ملاحظة مهمة بخصوص جمع عملات ال money او UFO او  Radioactive",
    Content = "شغل سكربت الحمايه من تسونامي لضمان تجربه افضل و اجعل سرعة 800"
})

MiscTab:CreateToggle({
    Name = "تجميع عملات حدث الـ UFO", 
    CurrentValue = false, 
    Callback = function(v) 
        isCollectingUfoCoins = v; 
        if v then 
            startUfoCollectorLoop(); 
            Rayfield:Notify({Title="UFO COLLECTOR (R.E.) ON", Content="شغال!", Duration=3}) 
        else 
            Rayfield:Notify({Title="UFO COLLECTOR (R.E.) OFF", Content="واقف", Duration=2}) 
        end 
    end
})

MiscTab:CreateSlider({
    Name = "سرعة تجميع الـ UFO", 
    Range = {500, 4000}, 
    Increment = 100, 
    CurrentValue = 800, 
    Callback = function(v) 
        UFO_COLLECTOR_SPEED = v; 
        Rayfield:Notify({Title="UFO Collector Speed", Content="تم ضبط السرعة على: " .. v, Duration=2}) 
    end
})




    MiscTab:CreateToggle({Name = "تجميع عملات حدث الراديو اكتف تلقائي", CurrentValue = false, Callback = function(v) isCollectingCoins = v; if v then startFlashCollectorLoop(); Rayfield:Notify({Title="FLASH COLLECTOR ON", Content="شغال " .. COLLECTOR_SPEED .. " studs/s!", Duration=3}) else Rayfield:Notify({Title="FLASH COLLECTOR OFF", Content="واقف", Duration=2}) end end})
    MiscTab:CreateSlider({Name = "سرعة التجميع", Range = {500, 3000}, Increment = 100, CurrentValue = 2000, Callback = function(v) COLLECTOR_SPEED = v; Rayfield:Notify({Title="Collector Speed", Content="تم ضبط السرعة على: " .. v, Duration=2}) end})
    MiscTab:CreateToggle({Name = "شيل الشخصيات ب سرعة ", CurrentValue = false, Callback = function(v) isInstaGrabActive = v; if v then Rayfield:Notify({Title="شيل الشخصيات بسرعه", Content="تم التفعيل!", Duration=3}) end end})
    MiscTab:CreateSection("© Script by abbas")

    
    InfoTab:CreateSection("معلومات السكربت")
    InfoTab:CreateParagraph({Title = "نسخة السكربت", Content = "هذا الاصدار .10.1v .\n تم تحسين بعض المشاكلوويعمل  بكفاءه اقوي و تمت اضافة VIP مجاناو تم اضافة Max Luck  و  تمت اضافة الانتقال الى اخر الماب مع شرح و تم تطوير ميزة الانتقال الى اخر الماب و تم اضافة تجميع الشخصيات تلقائي  يمكنك تجميع فوق 30 clesteal و تم اصلاح و اضافة الانتقالبدون جهد منك و تمت اضافه  تخطي الباركور و تم اضافة مميزات  و اضافة سكربتات جديدة و قوية و اضافة auto collect و العديد من المميزات اكتشفها بنفسك (اذا اكتشفت اي مشاكل في السكربت تواصل معي في التيك توك علي الخاص  ._.f.o_  ) و تمت اضافة مميزات حصرية و  تم اضافة تجميع عملات حدث ال Money و تمت اضافه عدم الموت من تسونامي و تمت اضافة التنقل عبر جدار Vip و تمت اضافة  جمع العملات UFO الجديدة و تم اضافة التنقل الى اخر الماب التجريبي و تم اصلاح الثغرة و سكربتات رائعه و تم تحسين بعض المشاكل في الاداء  وواضافه misc.\nالسكربت هذا تم تطويره من abbas."})
    
    InfoTab:CreateParagraph({Title = "Script Version", Content = "This is the release V10.1.\n Problems have been improved, new features have been added, and Free Vip has been added  and Tp in Vip walls has been added Misc has been added,and MAX LUCK has been added, and auto collect has been added, and SKIP PARKOUR has been added, and auto collect coins event Money has been added,  and collect  UFO coins has been added and teleport to end of map has been added  and fixed the Teleporter and script exclusive features has been added  and Auto collect brainrots has been added so u can get 30 clesteal and fixed  some problems and exclusive features has been added and protection from tsunami has been added and  fixed the teleport to end of map fixed some glitchs and problems  if you had any problems dm me in tiktok (._.f.o_)  and added more taps more scripts take a LOOK by yourself, and the script  works more efficiently on phones.\nThis script has been developed by abbas."})
    
    InfoTab:CreateParagraph({Title = "المطور / Developer", Content = "abbas (egyptiandeveloper)"})

    InfoTab:CreateParagraph({Title = "ملاحظات / Notes", Content = "السكربت هذا تم تطويره من abbas.\nBESTCHEAT Like and Follow للعلم السكربت لا يعمل جيدا علي PC يرجى استخدام هاتف."})
    InfoTab:CreateSection("© Copyright by abbas")
    MainTab:CreateSection(" المميزات")
    MainTab:CreateToggle({Name = "تطوير السرعة تلقائي", CurrentValue = false, Callback = function(v) getgenv().Aus = v end})
    MainTab:CreateToggle({Name = "تطوير ال carry تلقائي ", CurrentValue = false, Callback = function(v) getgenv().Auc = v end})
    MainTab:CreateToggle({Name = "اوتو ريبيرث", CurrentValue = false, Callback = function(v) getgenv().Ar = v end})
    MainTab:CreateToggle({Name = "تغيير السرعة", CurrentValue = false, Callback = function(v) getgenv().Sc = v end})
    MainTab:CreateSlider({Name = "قيمة السرعة", Range = {16, 1000}, Increment = 1, CurrentValue = 16, Callback = function(v) getgenv().Scv = v end})
    MainTab:CreateSection("©  Copyright by abbas")

    -- لوبات القايمه رايسيه
    
    RunService.Stepped:Connect(function() if isCollectingCoins then local char = LocalPlayer.Character; if char then for _, part in pairs(char:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end end end end)
    task.spawn(function() while task.wait(0.5) do if getgenv().Sc then pcall(speedchanger) end end end)
    task.spawn(function() while task.wait(1) do if getgenv().Aus then pcall(upgradespeed) end; if getgenv().Auc then pcall(upgradecarry) end; if getgenv().Ar then pcall(rebirth) end end end)
    task.spawn(function() while task.wait(1) do if isInstaGrabActive then for _, prompt in pairs(workspace:GetDescendants()) do if prompt:IsA("ProximityPrompt") then prompt.HoldDuration = 0 end end end end end)
    RunService.Heartbeat:Connect(function() local shouldRun = isGuarding or isInstantGuarding; if shouldRun and not isDodging then local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart"); if not hrp then return end; local waves = findTsunamiWaves(); for _, wave in pairs(waves) do if (hrp.Position - wave.Position).Magnitude <= DETECTION_RANGE then findAndTeleportToGap(isInstantGuarding); break end end end end)
end


local gui = Instance.new("ScreenGui")
gui.Name = "abbasKeySystem"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 380, 0, 270)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = DARK_GLASS
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14)
local stroke = Instance.new("UIStroke", main)
stroke.Color = BLUE_ACCENT
stroke.Thickness = 1.5
stroke.Transparency = 0.4
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.Text = " Key gui by 3mk abbas"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = TEXT_COLOR
local desc = Instance.new("TextLabel", main)
desc.Size = UDim2.new(1, -30, 0, 80)
desc.Position = UDim2.new(0, 15, 0, 50)
desc.BackgroundTransparency = 1
desc.TextWrapped = true
desc.TextYAlignment = Enum.TextYAlignment.Top
desc.Text = "نورت سكربت من صنع عباس\nانت اكيد بتدور علي المفتاح\nولا تزعل المفتاح اهو Hiimabbas"
desc.Font = Enum.Font.GothamBold
desc.TextSize = 13
desc.TextColor3 = SUBTITLE_COLOR
local keyBox = Instance.new("TextBox", main)
keyBox.Size = UDim2.new(0.85, 0, 0, 42)
keyBox.Position = UDim2.new(0.5, 0, 0.6, 0)
keyBox.AnchorPoint = Vector2.new(0.5, 0.5)
keyBox.BackgroundColor3 = FIELD_BG
keyBox.TextColor3 = TEXT_COLOR
keyBox.PlaceholderText = "اكتب المفتاح هنا..."
keyBox.Font = Enum.Font.Gotham
keyBox.TextSize = 14
Instance.new("UICorner", keyBox).CornerRadius = UDim.new(0, 8)
local verify = Instance.new("TextButton", main)
verify.Size = UDim2.new(0.5, 0, 0, 38)
verify.Position = UDim2.new(0.25, 0, 0.78, 0)
verify.BackgroundColor3 = BLUE_ACCENT
verify.Text = "تفعيل السكربت"
verify.Font = Enum.Font.GothamBold
verify.TextSize = 14
verify.TextColor3 = TEXT_COLOR
Instance.new("UICorner", verify).CornerRadius = UDim.new(0, 8)
local status = Instance.new("TextLabel", main)
status.Size = UDim2.new(1, 0, 0, 25)
status.Position = UDim2.new(0, 0, 0.9, 0)
status.BackgroundTransparency = 1
status.Text = "في انتظار إدخال المفتاح"
status.Font = Enum.Font.Gotham
status.TextSize = 11
status.TextColor3 = SUBTITLE_COLOR
verify.MouseButton1Click:Connect(function()
    if keyBox.Text == correctKey then
        status.Text = " تم التفعيل بنجاح"
        status.TextColor3 = Color3.fromRGB(80, 220, 140)
        TweenService:Create(stroke, TweenInfo.new(0.4), {Color = Color3.fromRGB(80, 220, 140)}):Play()
        task.wait(1)
        gui:Destroy()
        ExecuteHub()
    else
        status.Text = "المفتاح غير صحيح"
        status.TextColor3 = Color3.fromRGB(220, 80, 80)
        keyBox.Text = ""
    end
end)




local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ContextActionService = game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera


task.spawn(function()
	StarterGui:SetCore("SendNotification", {
		Title = "Shiftlock",
		Text = "Shiftlock Enabled | By عباس",
		Duration = 4
	})
end)

local ShiftlockStarterGui
local ImageButton

local character
local humanoid
local rootPos = Vector3.new(0,0,0)

local MAX_LENGTH = 900000
local ENABLED_OFFSET = CFrame.new(1.5, 0.75, 0)
local DISABLED_OFFSET = CFrame.new(-1.5, 0, 0)

local active = nil

local states = {
	OFF = "rbxasset://textures/ui/mouseLock_off@2x.png",
	ON  = "rbxasset://textures/ui/mouseLock_on@2x.png"
}

local function UpdatePos()
	if humanoid and humanoid.RootPart then
		rootPos = humanoid.RootPart.Position
	end
end

local function UpdateImage(state)
	if ImageButton then
		ImageButton.Image = states[state]
	end
end

local function UpdateAutoRotate(state)
	if humanoid then
		humanoid.AutoRotate = state
	end
end

local function GetUpdatedCameraCFrame()
	return CFrame.new(
		rootPos,
		Vector3.new(
			camera.CFrame.LookVector.X * MAX_LENGTH,
			rootPos.Y,
			camera.CFrame.LookVector.Z * MAX_LENGTH
		)
	)
end

local function EnableShiftlock()
	UpdatePos()
	UpdateAutoRotate(false)
	UpdateImage("ON")

	if humanoid and humanoid.RootPart then
		humanoid.RootPart.CFrame = GetUpdatedCameraCFrame()
	end

	camera.CFrame = camera.CFrame * ENABLED_OFFSET
end

local function DisableShiftlock()
	UpdateAutoRotate(true)
	UpdateImage("OFF")

	camera.CFrame = camera.CFrame * DISABLED_OFFSET

	if active then
		active:Disconnect()
		active = nil
	end
end

local function ToggleShiftlock()
	if not active then
		active = RunService.RenderStepped:Connect(EnableShiftlock)
	else
		DisableShiftlock()
	end
end

local function createGUI()
	if player.PlayerGui:FindFirstChild("Shiftlock (StarterGui)") then
		player.PlayerGui["Shiftlock (StarterGui)"]:Destroy()
	end

	ShiftlockStarterGui = Instance.new("ScreenGui")
	ShiftlockStarterGui.Name = "Shiftlock (StarterGui)"
	ShiftlockStarterGui.ResetOnSpawn = false
	ShiftlockStarterGui.Parent = player.PlayerGui

	ImageButton = Instance.new("ImageButton")
	ImageButton.Parent = ShiftlockStarterGui
	ImageButton.Active = true
	ImageButton.Draggable = true
	ImageButton.BackgroundTransparency = 1
	ImageButton.Position = UDim2.new(0.921914339, 0, 0.552375436, 0)
	ImageButton.Size = UDim2.new(0.0636147112, 0, 0.0661305636, 0)
	ImageButton.SizeConstraint = Enum.SizeConstraint.RelativeXX

	
	ImageButton.Image = "http://www.roblox.com/asset/?id=182223762"
	ImageButton.Visible = UserInputService.TouchEnabled

	UpdateImage("OFF")
	ImageButton.MouseButton1Click:Connect(ToggleShiftlock)

	ContextActionService:BindAction(
		"ShiftLOCK",
		function(_, state)
			if state == Enum.UserInputState.Begin then
				ToggleShiftlock()
			end
		end,
		false,
		Enum.KeyCode.LeftShift
	)
end

local function onCharacterAdded(char)
	character = char
	humanoid = character:WaitForChild("Humanoid")
	task.wait(0.05)
	createGUI()
end

if player.Character then
	onCharacterAdded(player.Character)
end

player.CharacterAdded:Connect(onCharacterAdded)
 


-- Alternative Script Version:
-- Source: https://raw.githubusercontent.com/ook314745-svg/noecape/refs/heads/main/v1%20from%20tsunami



local MIN_DISTANCE = 0
local MAX_DISTANCE = 1000
local DEFAULT_DISTANCE = 2.2


_G.TP_WALK_ENABLED = false
_G.TP_DISTANCE = DEFAULT_DISTANCE


local MainFrame = Instance.new("ScreenGui")
local DraggableFrame = Instance.new("Frame")
local TitleLabel = Instance.new("TextLabel")
local DistanceTextBox = Instance.new("TextBox")
local SetButton = Instance.new("TextButton")
local ResetButton = Instance.new("TextButton")
local ToggleButton = Instance.new("TextButton") -- The ON/OFF button
local MinimizeButton = Instance.new("TextButton")

MainFrame.Name = "TPWalkGUI_v6"
MainFrame.Parent = game:GetService("CoreGui")
MainFrame.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

DraggableFrame.Name = "DraggableFrame"
DraggableFrame.Parent = MainFrame
DraggableFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
DraggableFrame.BorderColor3 = Color3.fromRGB(85, 85, 125)
DraggableFrame.BorderSizePixel = 2
DraggableFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
DraggableFrame.Size = UDim2.new(0, 220, 0, 180) -- Increased height for the new button
DraggableFrame.Active = true
DraggableFrame.Draggable = true

TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = DraggableFrame
TitleLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
TitleLabel.BorderSizePixel = 0
TitleLabel.Size = UDim2.new(1, 0, 0, 30)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Text = "abbas spedbost escfmtsunv7"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 18

DistanceTextBox.Name = "DistanceTextBox"
DistanceTextBox.Parent = DraggableFrame
DistanceTextBox.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
DistanceTextBox.BorderColor3 = Color3.fromRGB(85, 85, 125)
DistanceTextBox.Position = UDim2.new(0.5, -75, 0.30, 0)
DistanceTextBox.Size = UDim2.new(0, 150, 0, 30)
DistanceTextBox.Font = Enum.Font.SourceSans
DistanceTextBox.PlaceholderText = "Enter Distance 2.2-1000"
DistanceTextBox.Text = tostring(DEFAULT_DISTANCE)
DistanceTextBox.TextColor3 = Color3.fromRGB(220, 220, 220)
DistanceTextBox.TextSize = 16
DistanceTextBox:GetPropertyChangedSignal("Text"):Connect(function()
    DistanceTextBox.Text = DistanceTextBox.Text:gsub("[^%d%.]", "")
end)

SetButton.Name = "SetButton"
SetButton.Parent = DraggableFrame
SetButton.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
SetButton.BorderColor3 = Color3.fromRGB(0, 170, 0)
SetButton.Position = UDim2.new(0.5, -105, 0.5, 0)
SetButton.Size = UDim2.new(0, 100, 0, 30)
SetButton.Font = Enum.Font.SourceSansBold
SetButton.Text = "Set"
SetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SetButton.TextSize = 16

ResetButton.Name = "ResetButton"
ResetButton.Parent = DraggableFrame
ResetButton.BackgroundColor3 = Color3.fromRGB(180, 80, 0)
ResetButton.BorderColor3 = Color3.fromRGB(230, 130, 0)
ResetButton.Position = UDim2.new(0.5, 5, 0.5, 0)
ResetButton.Size = UDim2.new(0, 100, 0, 30)
ResetButton.Font = Enum.Font.SourceSansBold
ResetButton.Text = "Reset"
ResetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ResetButton.TextSize = 16

ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = DraggableFrame
ToggleButton.BackgroundColor3 = Color3.fromRGB(190, 20, 20) 
ToggleButton.BorderColor3 = Color3.fromRGB(240, 70, 70)
ToggleButton.Position = UDim2.new(0.5, -75, 0.75, 0)
ToggleButton.Size = UDim2.new(0, 150, 0, 35)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Text = " OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 18

MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Parent = DraggableFrame
MinimizeButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Position = UDim2.new(1, -25, 0, 5)
MinimizeButton.Size = UDim2.new(0, 20, 0, 20)
MinimizeButton.Font = Enum.Font.SourceSansBold
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 22


local player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")

local function tpWalkJoystick()
    
    if not _G.TP_WALK_ENABLED then return end

    local character = player.Character
    if not character or not character:FindFirstChild("Humanoid") or not character:FindFirstChild("HumanoidRootPart") then
        return
    end

    local humanoid = character.Humanoid
    local rootPart = character.HumanoidRootPart

    
    if humanoid.MoveDirection.Magnitude > 0.1 then
        
        
        local direction = humanoid.MoveDirection
        
        
        rootPart.CFrame = rootPart.CFrame + (direction * _G.TP_DISTANCE)
    end
end


RunService.RenderStepped:Connect(tpWalkJoystick)


SetButton.MouseButton1Click:Connect(function()
    local distValue = tonumber(DistanceTextBox.Text)
    if distValue then
        _G.TP_DISTANCE = math.clamp(distValue, MIN_DISTANCE, MAX_DISTANCE)
        DistanceTextBox.Text = tostring(_G.TP_DISTANCE) -- Update text to clamped value
    end
    SetButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0); wait(0.1); SetButton.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
end)

ResetButton.MouseButton1Click:Connect(function()
    _G.TP_DISTANCE = DEFAULT_DISTANCE
    DistanceTextBox.Text = tostring(DEFAULT_DISTANCE)
    ResetButton.BackgroundColor3 = Color3.fromRGB(230, 130, 0); wait(0.1); ResetButton.BackgroundColor3 = Color3.fromRGB(180, 80, 0)
end)

ToggleButton.MouseButton1Click:Connect(function()
    
    _G.TP_WALK_ENABLED = not _G.TP_WALK_ENABLED
    
    if _G.TP_WALK_ENABLED then
        
        ToggleButton.Text = "[ ON ]"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0) -- Green
        ToggleButton.BorderColor3 = Color3.fromRGB(50, 200, 50)
    else
        
        ToggleButton.Text = "[ OFF ]"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(190, 20, 20) 
        ToggleButton.BorderColor3 = Color3.fromRGB(240, 70, 70)
    end
end)

local isMinimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        DraggableFrame.Size = UDim2.new(0, 220, 0, 30); MinimizeButton.Text = "+"
        DistanceTextBox.Visible, SetButton.Visible, ResetButton.Visible, ToggleButton.Visible = false, false, false, false
    else
        DraggableFrame.Size = UDim2.new(0, 220, 0, 180); MinimizeButton.Text = "-"
        DistanceTextBox.Visible, SetButton.Visible, ResetButton.Visible, ToggleButton.Visible = true, true, true, true
    end
end)




local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer


local function createGUI()
    if localPlayer.PlayerGui:FindFirstChild("InfiniteJumpGUI") then return end

    local DraggableGUI = Instance.new("ScreenGui")
    DraggableGUI.Name = "InfiniteJumpGUI"
    DraggableGUI.Parent = localPlayer:WaitForChild("PlayerGui")
    DraggableGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    DraggableGUI.IgnoreGuiInset = true

    
local DraggableGUI = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local TitleLabel = Instance.new("TextLabel")
local UICorner_Title = Instance.new("UICorner")
local OnOffButton = Instance.new("TextButton")
local UICorner_Button = Instance.new("UICorner")
local CreditLabel = Instance.new("TextLabel")
local UICorner_Credit = Instance.new("UICorner")


local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer


local isJumpActive = false
local jumpPower = 100 
local jumpConnection = nil


DraggableGUI.Parent = localPlayer:WaitForChild("PlayerGui")
DraggableGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
DraggableGUI.IgnoreGuiInset = true 

MainFrame.Name = "MainFrame"
MainFrame.Parent = DraggableGUI
MainFrame.BackgroundColor3 = Color3.fromRGB(204, 51, 51)
MainFrame.Position = UDim2.new(0.1, 0, 0.15, 0)
MainFrame.Size = UDim2.new(0, 220, 0, 125)
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = MainFrame
TitleLabel.BackgroundColor3 = Color3.fromRGB(153, 51, 51)
TitleLabel.Position = UDim2.new(0.07, 0, 0.1, 0)
TitleLabel.Size = UDim2.new(0, 120, 0, 22)
TitleLabel.Font = Enum.Font.SourceSans
TitleLabel.Text = "InfiniteJump v1"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 16
UICorner_Title.CornerRadius = UDim.new(0, 6)
UICorner_Title.Parent = TitleLabel

OnOffButton.Name = "OnOffButton"
OnOffButton.Parent = MainFrame
OnOffButton.BackgroundColor3 = Color3.fromRGB(255, 230, 230)
OnOffButton.Position = UDim2.new(0.07, 0, 0.4, 0)
OnOffButton.Size = UDim2.new(0, 88, 0, 50)
OnOffButton.Font = Enum.Font.SourceSansBold
OnOffButton.Text = "OFF"
OnOffButton.TextColor3 = Color3.fromRGB(200, 0, 0)
OnOffButton.TextSize = 24
UICorner_Button.CornerRadius = UDim.new(0, 7)
UICorner_Button.Parent = OnOffButton

CreditLabel.Name = "CreditLabel"
CreditLabel.Parent = MainFrame
CreditLabel.BackgroundColor3 = Color3.fromRGB(153, 51, 51)
CreditLabel.Position = UDim2.new(0.55, 0, 0.1, 0)
CreditLabel.Size = UDim2.new(0, 80, 0, 22)
CreditLabel.Font = Enum.Font.SourceSans
CreditLabel.Text = "By abbas"
CreditLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
CreditLabel.TextSize = 16
UICorner_Credit.CornerRadius = UDim.new(0, 6)
UICorner_Credit.Parent = CreditLabel


local function activateJump()
    if jumpConnection then return end -- Already active

    jumpConnection = UserInputService.JumpRequest:Connect(function()
        if isJumpActive and localPlayer.Character then
            local rootPart = localPlayer.Character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                
                rootPart.Velocity = Vector3.new(rootPart.Velocity.X, jumpPower, rootPart.Velocity.Z)
            end
        end
    end)
end

local function deactivateJump()
    if jumpConnection then
        jumpConnection:Disconnect()
        jumpConnection = nil
    end
end


OnOffButton.MouseButton1Click:Connect(function()
    isJumpActive = not isJumpActive
    if isJumpActive then
        OnOffButton.Text = "ON"
        OnOffButton.TextColor3 = Color3.fromRGB(0, 200, 0)
        activateJump()
    else
        OnOffButton.Text = "OFF"
        OnOffButton.TextColor3 = Color3.fromRGB(200, 0, 0)
        deactivateJump()
    end
end)


local gui = MainFrame
local dragging, dragStart, startPos
gui.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; dragStart = input.Position; startPos = gui.Position; local c; c = input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false; c:Disconnect() end end) end end)
gui.InputChanged:Connect(function(input) if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragging then local d = input.Position - dragStart; gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y) end end)


DraggableGUI.Destroying:Connect(deactivateJump)


end


createGUI()


localPlayer.CharacterAdded:Connect(function()
    wait(0.5)
    createGUI()
end)


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer


local gui = Instance.new("ScreenGui")
gui.Name = "TsunamiRadarabbas"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 150, 0, 40)
frame.Position = UDim2.new(0.5, -75, 0.5, -20)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true 
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

local text = Instance.new("TextLabel")
text.Size = UDim2.new(1, -8, 1, -8)
text.Position = UDim2.new(0, 4, 0, 4)
text.BackgroundTransparency = 1
text.Text = "بيفحص تسونامي..."
text.TextColor3 = Color3.new(1, 1, 1)
text.Font = Enum.Font.GothamMedium
text.TextSize = 12
text.TextWrapped = true
text.TextXAlignment = Enum.TextXAlignment.Left
text.Parent = frame


local credit = Instance.new("TextLabel")
credit.Size = UDim2.new(1, -8, 0, 10)
credit.Position = UDim2.new(0, 4, 1, -11)
credit.BackgroundTransparency = 1
credit.Text = "by abbas"
credit.TextColor3 = Color3.fromRGB(140, 140, 160)
credit.Font = Enum.Font.Gotham
credit.TextSize = 9
credit.TextXAlignment = Enum.TextXAlignment.Right
credit.Parent = frame


local function getRoot()
	local char = player.Character
	if not char then return nil end
	return char:FindFirstChild("HumanoidRootPart")
end

local function getClosestTsunami()
	local root = getRoot()
	if not root then return math.huge end

	local closest = math.huge

	for _, obj in pairs(Workspace:GetDescendants()) do
		if obj:IsA("BasePart") then
			local name = obj.Name:lower()
			if name:find("wave") or name:find("tsunami") then
				local dist = (obj.Position - root.Position).Magnitude
				if dist < closest then
					closest = dist
				end
			end
		end
	end

	return closest
end

RunService.Heartbeat:Connect(function()
	local dist = getClosestTsunami()

	if dist <= 500 then
		frame.BackgroundColor3 = Color3.fromRGB(160, 40, 40)
		text.Text = "⚠️ تسونامي قريب أوي\n" .. math.floor(dist) .. " متر"
	elseif dist <= 1000 then
		frame.BackgroundColor3 = Color3.fromRGB(190, 130, 40)
		text.Text = "⚠️ تسونامي قريب\n" .. math.floor(dist) .. " متر"
	elseif dist < math.huge then
		frame.BackgroundColor3 = Color3.fromRGB(40, 130, 70)
		text.Text = "✔️ الدنيا أمان\n" .. math.floor(dist) .. " متر"
	else
		frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
		text.Text = "مفيش تسونامي"
	end
end)



-- الحاجه النادره فشخ هتترسبن بعد XX: XX

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")


local originalTextLabel =
    workspace.Model:GetChildren()[16]
    .SurfaceGui.Frame.TextLabel




local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RespawnTextTranslator"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui


local frame = Instance.new("Frame")
-- INCREASED THE HEIGHT SCALE FROM 0.1 to 0.15
frame.Size = UDim2.new(0.8, 0, 0.15, 0) -- 80% width, 15% height
frame.Position = UDim2.new(0.5, 0, 0.2, 0)
frame.AnchorPoint = Vector2.new(0.5, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BackgroundTransparency = 0.1
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui


-- Let's adjust it slightly to better fit the new height. Original was ~380/80=4.75. New is ~380/120=3.1
local aspectRatio = Instance.new("UIAspectRatioConstraint")
aspectRatio.AspectRatio = 3.5 -- Adjusted ratio for the new height
aspectRatio.DominantAxis = Enum.DominantAxis.Width
aspectRatio.Parent = frame

local sizeConstraint = Instance.new("UISizeConstraint")
sizeConstraint.MaxSize = Vector2.new(450, math.huge) -- Slightly increased max size as well
sizeConstraint.Parent = frame


local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(1, -10, 0.5, -5)
textLabel.Position = UDim2.new(0, 5, 0, 5)
textLabel.BackgroundTransparency = 1
textLabel.TextWrapped = true
textLabel.TextScaled = true
textLabel.Font = Enum.Font.GothamBold
textLabel.TextColor3 = Color3.fromRGB(255, 105, 180) -- Pink
textLabel.Parent = frame


local translationLabel = Instance.new("TextLabel")
translationLabel.Size = UDim2.new(1, -10, 0.5, -5)
translationLabel.Position = UDim2.new(0, 5, 0.5, 0)
translationLabel.BackgroundTransparency = 1
translationLabel.TextWrapped = true
translationLabel.TextScaled = true
translationLabel.Font = Enum.Font.GothamBold
translationLabel.TextColor3 = Color3.fromRGB(0, 255, 255) -- Cyan
translationLabel.Parent = frame



local function translateTimer(text)
    local time = text:match("(%d%d:%d%d)")
    if time then
        return "الحاجه النادرة فشخ هتترسبن بعد " .. time
    else
        return ""
    end
end

local function updateText()
    local original = originalTextLabel.Text
    textLabel.Text = original
    translationLabel.Text = translateTimer(original)
end

originalTextLabel:GetPropertyChangedSignal("Text"):Connect(updateText)
updateText()




local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ContextActionService = game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera


task.spawn(function()
	StarterGui:SetCore("SendNotification", {
		Title = "Shiftlock",
		Text = "Shiftlock Enabled | By عباس",
		Duration = 4
	})
end)

local ShiftlockStarterGui
local ImageButton

local character
local humanoid
local rootPos = Vector3.new(0,0,0)

local MAX_LENGTH = 900000
local ENABLED_OFFSET = CFrame.new(1.5, 0.75, 0)
local DISABLED_OFFSET = CFrame.new(-1.5, 0, 0)

local active = nil

local states = {
	OFF = "rbxasset://textures/ui/mouseLock_off@2x.png",
	ON  = "rbxasset://textures/ui/mouseLock_on@2x.png"
}

local function UpdatePos()
	if humanoid and humanoid.RootPart then
		rootPos = humanoid.RootPart.Position
	end
end

local function UpdateImage(state)
	if ImageButton then
		ImageButton.Image = states[state]
	end
end

local function UpdateAutoRotate(state)
	if humanoid then
		humanoid.AutoRotate = state
	end
end

local function GetUpdatedCameraCFrame()
	return CFrame.new(
		rootPos,
		Vector3.new(
			camera.CFrame.LookVector.X * MAX_LENGTH,
			rootPos.Y,
			camera.CFrame.LookVector.Z * MAX_LENGTH
		)
	)
end

local function EnableShiftlock()
	UpdatePos()
	UpdateAutoRotate(false)
	UpdateImage("ON")

	if humanoid and humanoid.RootPart then
		humanoid.RootPart.CFrame = GetUpdatedCameraCFrame()
	end

	camera.CFrame = camera.CFrame * ENABLED_OFFSET
end

local function DisableShiftlock()
	UpdateAutoRotate(true)
	UpdateImage("OFF")

	camera.CFrame = camera.CFrame * DISABLED_OFFSET

	if active then
		active:Disconnect()
		active = nil
	end
end

local function ToggleShiftlock()
	if not active then
		active = RunService.RenderStepped:Connect(EnableShiftlock)
	else
		DisableShiftlock()
	end
end

local function createGUI()
	if player.PlayerGui:FindFirstChild("Shiftlock (StarterGui)") then
		player.PlayerGui["Shiftlock (StarterGui)"]:Destroy()
	end

	ShiftlockStarterGui = Instance.new("ScreenGui")
	ShiftlockStarterGui.Name = "Shiftlock (StarterGui)"
	ShiftlockStarterGui.ResetOnSpawn = false
	ShiftlockStarterGui.Parent = player.PlayerGui

	ImageButton = Instance.new("ImageButton")
	ImageButton.Parent = ShiftlockStarterGui
	ImageButton.Active = true
	ImageButton.Draggable = true
	ImageButton.BackgroundTransparency = 1
	ImageButton.Position = UDim2.new(0.921914339, 0, 0.552375436, 0)
	ImageButton.Size = UDim2.new(0.0636147112, 0, 0.0661305636, 0)
	ImageButton.SizeConstraint = Enum.SizeConstraint.RelativeXX

	
	ImageButton.Image = "http://www.roblox.com/asset/?id=182223762"
	ImageButton.Visible = UserInputService.TouchEnabled

	UpdateImage("OFF")
	ImageButton.MouseButton1Click:Connect(ToggleShiftlock)

	ContextActionService:BindAction(
		"ShiftLOCK",
		function(_, state)
			if state == Enum.UserInputState.Begin then
				ToggleShiftlock()
			end
		end,
		false,
		Enum.KeyCode.LeftShift
	)
end

local function onCharacterAdded(char)
	character = char
	humanoid = character:WaitForChild("Humanoid")
	task.wait(0.05)
	createGUI()
end

if player.Character then
	onCharacterAdded(player.Character)
end

player.CharacterAdded:Connect(onCharacterAdded)
