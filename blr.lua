
--[[ 
    سكربت Roblox معدل بواسطة Manus AI 
    الوظيفة: إضافة واجهة اختيار لجذب الكرة أو التحكم بها، مع زر "جيت" متحرك ونظام تحكم بالكرة.
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- متغيرات التحكم بالكرة
local isAttracting = false
local isControllingBall = false
local controlSpeed = 200 -- سرعة التحكم بالكرة

-- إنشاء واجهة المستخدم الرسومية الرئيسية (GUI)
local MainScreenGui = Instance.new("ScreenGui")
MainScreenGui.Name = "MainControlGui"
MainScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- إطار الاختيار الأولي
local ChoiceFrame = Instance.new("Frame")
ChoiceFrame.Name = "ChoiceFrame"
ChoiceFrame.Size = UDim2.new(0, 300, 0, 200)
ChoiceFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
ChoiceFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ChoiceFrame.BorderSizePixel = 0
ChoiceFrame.Active = true -- لجعلها قابلة للسحب
ChoiceFrame.Draggable = true -- لجعلها قابلة للسحب
ChoiceFrame.Parent = MainScreenGui

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, 0, 0, 30)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Text = "اختر وضع التحكم بالكرة"
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 20
TitleLabel.Parent = ChoiceFrame

-- زر جذب الكرة
local AttractButton = Instance.new("TextButton")
AttractButton.Name = "AttractButton"
AttractButton.Size = UDim2.new(0.8, 0, 0, 40)
AttractButton.Position = UDim2.new(0.1, 0, 0.25, 0)
AttractButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
AttractButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AttractButton.Text = "جذب الكرة بالزر"
AttractButton.Font = Enum.Font.SourceSansBold
AttractButton.TextSize = 18
AttractButton.Parent = ChoiceFrame

-- زر التحكم بالكرة
local ControlButton = Instance.new("TextButton")
ControlButton.Name = "ControlButton"
ControlButton.Size = UDim2.new(0.8, 0, 0, 40)
ControlButton.Position = UDim2.new(0.1, 0, 0.5, 0)
ControlButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
ControlButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ControlButton.Text = "تحكم بالكرة (تشغيل/إيقاف)"
ControlButton.Font = Enum.Font.SourceSansBold
ControlButton.TextSize = 18
ControlButton.Parent = ChoiceFrame

-- زر كلاهما
local BothButton = Instance.new("TextButton")
BothButton.Name = "BothButton"
BothButton.Size = UDim2.new(0.8, 0, 0, 40)
BothButton.Position = UDim2.new(0.1, 0, 0.75, 0)
BothButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
BothButton.TextColor3 = Color3.fromRGB(255, 255, 255)
BothButton.Text = "كلاهما"
BothButton.Font = Enum.Font.SourceSansBold
BothButton.TextSize = 18
BothButton.Parent = ChoiceFrame

-- دوال التحكم بالكرة
local function getBall()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        warn("اللاعب ليس لديه شخصية أو HumanoidRootPart.")
        return
    end

    local football = workspace:FindFirstChild("Football")
    if not football then
        warn("الكرة غير موجودة في مساحة العمل.")
        return
    end

    local playerRoot = LocalPlayer.Character.HumanoidRootPart
    local targetPosition = playerRoot.Position + Vector3.new(0, 2.5, 0) -- فوق اللاعب قليلاً

    local isBallControlled = false
    if football.AssemblyLinearVelocity.Magnitude > 5 then 
        isBallControlled = true
    end

    if not isBallControlled then
        football.CFrame = CFrame.new(targetPosition)
        warn("تم نقل الكرة مباشرة إلى اللاعب.")
    else
        warn("الكرة ليست حرة، محاولة جذبها...")
        isAttracting = true
        local attractionConnection
        attractionConnection = RunService.Heartbeat:Connect(function()
            if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                attractionConnection:Disconnect()
                isAttracting = false
                return
            end
            if not football or not football.Parent then
                attractionConnection:Disconnect()
                isAttracting = false
                return
            end

            local currentPlayerRoot = LocalPlayer.Character.HumanoidRootPart
            local direction = (currentPlayerRoot.Position - football.Position).Unit
            football:ApplyImpulse(direction * 50) 

            if (currentPlayerRoot.Position - football.Position).Magnitude < 5 or football.AssemblyLinearVelocity.Magnitude < 5 then
                football.CFrame = CFrame.new(currentPlayerRoot.Position + Vector3.new(0, 2.5, 0))
                attractionConnection:Disconnect()
                isAttracting = false
                warn("تم جذب الكرة ونقلها إلى اللاعب.")
            end
        end)
    end
end

local function setupAttractButton()
    local GetButton = Instance.new("TextButton")
    GetButton.Name = "GetButton"
    GetButton.Size = UDim2.new(0, 100, 0, 50) 
    GetButton.Position = UDim2.new(0.5, -50, 0.8, 0) 
    GetButton.BackgroundColor3 = Color3.fromRGB(0, 0, 255) 
    GetButton.TextColor3 = Color3.fromRGB(255, 255, 255) 
    GetButton.Text = "جيت"
    GetButton.Font = Enum.Font.SourceSansBold
    GetButton.TextSize = 24
    GetButton.Parent = MainScreenGui

    -- جعل الزر متحركًا
    local dragging
    local dragInput
    local dragStart
    local startPosition

    local function onDragStart(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPosition = GetButton.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end

    local function onDragMove(input)
        if dragging then
            local delta = input.Position - dragStart
            GetButton.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
        end
    end

    GetButton.InputBegan:Connect(onDragStart)
    UserInputService.InputChanged:Connect(onDragMove)

    GetButton.MouseButton1Click:Connect(function()
        if not isAttracting then
            getBall()
        else
            warn("جذب الكرة قيد التقدم بالفعل.")
        end
    end)
end

local function setupControlToggle()
    local ControlToggle = Instance.new("TextButton")
    ControlToggle.Name = "ControlToggle"
    ControlToggle.Size = UDim2.new(0, 150, 0, 50)
    ControlToggle.Position = UDim2.new(0.5, -75, 0.8, 0)
    ControlToggle.BackgroundColor3 = Color3.fromRGB(255, 165, 0) -- لون برتقالي
    ControlToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    ControlToggle.Text = "التحكم بالكرة: إيقاف"
    ControlToggle.Font = Enum.Font.SourceSansBold
    ControlToggle.TextSize = 18
    ControlToggle.Parent = MainScreenGui

    -- جعل الزر متحركًا
    local draggingControl
    local dragInputControl
    local dragStartControl
    local startPositionControl

    local function onDragStartControl(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingControl = true
            dragStartControl = input.Position
            startPositionControl = ControlToggle.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    draggingControl = false
                end
            end)
        end
    end

    local function onDragMoveControl(input)
        if draggingControl then
            local delta = input.Position - dragStartControl
            ControlToggle.Position = UDim2.new(startPositionControl.X.Scale, startPositionControl.X.Offset + delta.X, startPositionControl.Y.Scale, startPositionControl.Y.Offset + delta.Y)
        end
    end

    ControlToggle.InputBegan:Connect(onDragStartControl)
    UserInputService.InputChanged:Connect(onDragMoveControl)

    ControlToggle.MouseButton1Click:Connect(function()
        isControllingBall = not isControllingBall
        local camera = workspace.CurrentCamera
        if isControllingBall then
            ControlToggle.Text = "التحكم بالكرة: تشغيل"
            ControlToggle.BackgroundColor3 = Color3.fromRGB(0, 200, 0) -- أخضر
            
            -- تفعيل تتبع الكاميرا للكرة
            camera.CameraType = Enum.CameraType.Scriptable
            local cameraConnection = RunService.RenderStepped:Connect(function()
                local football = workspace:FindFirstChild("Football")
                if football and football.Parent then
                    camera.CFrame = CFrame.new(football.Position + Vector3.new(0, 10, 15)) * CFrame.Angles(math.rad(-20), 0, 0) -- الكاميرا فوق وخلف الكرة قليلاً
                end
            end)
            ControlToggle:SetAttribute("CameraConnection", cameraConnection) -- حفظ الاتصال لقطعه لاحقاً
        else
            ControlToggle.Text = "التحكم بالكرة: إيقاف"
            ControlToggle.BackgroundColor3 = Color3.fromRGB(255, 165, 0) -- برتقالي
            
            -- تعطيل تتبع الكاميرا للكرة واستعادة الكاميرا الافتراضية
            camera.CameraType = Enum.CameraType.Custom
            local cameraConnection = ControlToggle:GetAttribute("CameraConnection")
            if cameraConnection then
                cameraConnection:Disconnect()
                ControlToggle:SetAttribute("CameraConnection", nil)
            end
        end
    end)

    -- منطق التحكم بالكرة
    RunService.Heartbeat:Connect(function()
        if isControllingBall and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local football = workspace:FindFirstChild("Football")
            if football and football.AssemblyLinearVelocity.Magnitude < 5 then -- فقط إذا كانت الكرة حرة
                local playerRoot = LocalPlayer.Character.HumanoidRootPart
                local camera = workspace.CurrentCamera
                local moveVector = UserInputService:GetMoveVector()
                local moveDirection = Vector3.new(0,0,0)

                if moveVector.Magnitude > 0 then
                    local cameraCFrame = camera.CFrame
                    local relativeMove = cameraCFrame.RightVector * moveVector.X + cameraCFrame.LookVector * -moveVector.Z + cameraCFrame.UpVector * moveVector.Y -- Y for up/down
                    moveDirection = relativeMove.Unit
                end

                if moveDirection.Magnitude > 0 then
                    football:ApplyImpulse(moveDirection * controlSpeed * football:GetMass())
                end
            end
        end
    end)
end

-- معالجة اختيار المستخدم
AttractButton.MouseButton1Click:Connect(function()
    ChoiceFrame:Destroy()
    setupAttractButton()
end)

ControlButton.MouseButton1Click:Connect(function()
    ChoiceFrame:Destroy()
    setupControlToggle()
end)

BothButton.MouseButton1Click:Connect(function()
    ChoiceFrame:Destroy()
    setupAttractButton()
    setupControlToggle()
end)
