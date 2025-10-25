loadstring([[
print("✅✅✅✅")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local isMobile = UserInputService.TouchEnabled

-- Settings
local flyEnabled = false
local flySpeed = 50
local menuVisible = true
local espEnabled = false
local espColor = Color3.fromRGB(255,0,0)
local espType = "FullBody"
local espTransparency = 0.5
local espAlwaysOnTop = true
local flyBV, flyBG
local keys = {}
local espBoxes = {}

-- Remove existing GUI
local existing = playerGui:FindFirstChild("DevMenuGui")
if existing then existing:Destroy() end

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DevMenuGui"
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,320,0,460)
frame.Position = UDim2.new(0.5,-160,0.5,-230)
frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
frame.BorderSizePixel = 0
frame.Parent = screenGui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)

-- Dragging
local dragging, dragInput, mousePos, framePos = false
local function update(input)
    local delta = input.Position - mousePos
    frame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X,
                               framePos.Y.Scale, framePos.Y.Offset + delta.Y)
end
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or isMobile then
        dragging = true
        mousePos = input.Position
        framePos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then update(input) end
end)

-- Labels
local function createLabel(text,posY)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1,-20,0,28)
    lbl.Position = UDim2.new(0,10,0,posY)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 18
    lbl.TextColor3 = Color3.fromRGB(255,255,255)
    lbl.Parent = frame
    return lbl
end
createLabel("Lennox Menu",10)

-- WalkSpeed
local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(0,160,0,30)
speedInput.Position = UDim2.new(0,10,0,45)
speedInput.PlaceholderText = "Speed (8-200)"
speedInput.ClearTextOnFocus = false
speedInput.Font = Enum.Font.Gotham
speedInput.TextSize = 18
speedInput.Parent = frame

local applySpeed = Instance.new("TextButton")
applySpeed.Size = UDim2.new(0,100,0,30)
applySpeed.Position = UDim2.new(0,180,0,45)
applySpeed.Text = "Set Speed"
applySpeed.Font = Enum.Font.GothamBold
applySpeed.TextSize = 16
applySpeed.BackgroundColor3 = Color3.fromRGB(70,130,180)
applySpeed.TextColor3 = Color3.fromRGB(255,255,255)
applySpeed.Parent = frame

applySpeed.MouseButton1Click:Connect(function()
    local val = tonumber(speedInput.Text)
    if val then
        val = math.clamp(val,8,200)
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.WalkSpeed = val end
    end
end)

-- ESP Toggle
local espToggle = Instance.new("TextButton")
espToggle.Size = UDim2.new(0,140,0,30)
espToggle.Position = UDim2.new(0,10,0,85)
espToggle.Text = "ESP: OFF"
espToggle.Font = Enum.Font.GothamBold
espToggle.TextSize = 16
espToggle.BackgroundColor3 = Color3.fromRGB(100,50,180)
espToggle.TextColor3 = Color3.fromRGB(255,255,255)
espToggle.Parent = frame

espToggle.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espToggle.Text = "ESP: "..(espEnabled and "ON" or "OFF")
    if not espEnabled then
        for _, boxes in pairs(espBoxes) do
            for _, box in pairs(boxes) do pcall(function() box:Destroy() end) end
        end
        espBoxes = {}
    end
end)

-- ESP Settings Section
local espLabel = createLabel("ESP Settings",120)

-- Color RGB
local rSlider = Instance.new("TextBox")
rSlider.Size = UDim2.new(0,50,0,25)
rSlider.Position = UDim2.new(0,10,0,150)
rSlider.PlaceholderText = "R"
rSlider.Font = Enum.Font.Gotham
rSlider.TextSize = 14
rSlider.Parent = frame

local gSlider = rSlider:Clone()
gSlider.Position = UDim2.new(0,70,0,150)
gSlider.PlaceholderText = "G"
gSlider.Parent = frame

local bSlider = rSlider:Clone()
bSlider.Position = UDim2.new(0,130,0,150)
bSlider.PlaceholderText = "B"
bSlider.Parent = frame

local function updateColor()
    local r = tonumber(rSlider.Text) or 255
    local g = tonumber(gSlider.Text) or 0
    local b = tonumber(bSlider.Text) or 0
    espColor = Color3.fromRGB(math.clamp(r,0,255),math.clamp(g,0,255),math.clamp(b,0,255))
end

rSlider.FocusLost:Connect(updateColor)
gSlider.FocusLost:Connect(updateColor)
bSlider.FocusLost:Connect(updateColor)

-- ESP Type Dropdown
local espTypeDropdown = Instance.new("TextButton")
espTypeDropdown.Size = UDim2.new(0,120,0,30)
espTypeDropdown.Position = UDim2.new(0,10,0,185)
espTypeDropdown.Text = "Type: FullBody"
espTypeDropdown.Font = Enum.Font.GothamBold
espTypeDropdown.TextSize = 16
espTypeDropdown.BackgroundColor3 = Color3.fromRGB(100,100,100)
espTypeDropdown.TextColor3 = Color3.fromRGB(255,255,255)
espTypeDropdown.Parent = frame

espTypeDropdown.MouseButton1Click:Connect(function()
    if espType == "FullBody" then espType = "HeadOnly"
    elseif espType == "HeadOnly" then espType = "Box"
    else espType = "FullBody" end
    espTypeDropdown.Text = "Type: "..espType
end)

-- Transparency Slider
local transparencySlider = Instance.new("TextBox")
transparencySlider.Size = UDim2.new(0,50,0,25)
transparencySlider.Position = UDim2.new(0,10,0,220)
transparencySlider.PlaceholderText = "0.5"
transparencySlider.Font = Enum.Font.Gotham
transparencySlider.TextSize = 14
transparencySlider.Parent = frame

transparencySlider.FocusLost:Connect(function()
    local val = tonumber(transparencySlider.Text)
    if val then espTransparency = math.clamp(val,0,1) end
end)

-- AlwaysOnTop Toggle
local alwaysTopBtn = Instance.new("TextButton")
alwaysTopBtn.Size = UDim2.new(0,150,0,30)
alwaysTopBtn.Position = UDim2.new(0,10,0,255)
alwaysTopBtn.Text = "Always On Top: ON"
alwaysTopBtn.Font = Enum.Font.GothamBold
alwaysTopBtn.TextSize = 16
alwaysTopBtn.BackgroundColor3 = Color3.fromRGB(50,150,50)
alwaysTopBtn.TextColor3 = Color3.fromRGB(255,255,255)
alwaysTopBtn.Parent = frame
alwaysTopBtn.MouseButton1Click:Connect(function()
    espAlwaysOnTop = not espAlwaysOnTop
    alwaysTopBtn.Text = "Always On Top: "..(espAlwaysOnTop and "ON" or "OFF")
end)

-- Fly Toggle
local flyToggle = Instance.new("TextButton")
flyToggle.Size = UDim2.new(0,140,0,30)
flyToggle.Position = UDim2.new(0,160,0,85)
flyToggle.Text = "Fly: OFF"
flyToggle.Font = Enum.Font.GothamBold
flyToggle.TextSize = 16
flyToggle.BackgroundColor3 = Color3.fromRGB(50,150,50)
flyToggle.TextColor3 = Color3.fromRGB(255,255,255)
flyToggle.Parent = frame

flyToggle.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    flyToggle.Text = "Fly: "..(flyEnabled and "ON" or "OFF")
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid and not flyEnabled then humanoid.PlatformStand = false end
end)

-- Fly Speed Slider
local flyLbl = createLabel("Fly Speed: 50",300)
local flyMinus = Instance.new("TextButton")
flyMinus.Size = UDim2.new(0,40,0,28)
flyMinus.Position = UDim2.new(0,10,0,330)
flyMinus.Text = "-"
flyMinus.Font = Enum.Font.GothamBold
flyMinus.TextSize = 18
flyMinus.Parent = frame
local flyPlus = Instance.new("TextButton")
flyPlus.Size = UDim2.new(0,40,0,28)
flyPlus.Position = UDim2.new(0,60,0,330)
flyPlus.Text = "+"
flyPlus.Font = Enum.Font.GothamBold
flyPlus.TextSize = 18
flyPlus.Parent = frame

flyMinus.MouseButton1Click:Connect(function()
    flySpeed = math.max(5,flySpeed-10)
    flyLbl.Text = "Fly Speed: "..flySpeed
end)
flyPlus.MouseButton1Click:Connect(function()
    flySpeed = math.min(500,flySpeed+10)
    flyLbl.Text = "Fly Speed: "..flySpeed
end)

-- Menu Toggle Button
local menuToggle = Instance.new("TextButton")
menuToggle.Size = UDim2.new(0,30,0,30)
menuToggle.Position = UDim2.new(0,10,0,10)
menuToggle.Text = isMobile and "☰" or "M"
menuToggle.Font = Enum.Font.GothamBold
menuToggle.TextSize = 18
menuToggle.BackgroundColor3 = Color3.fromRGB(150,150,150)
menuToggle.TextColor3 = Color3.fromRGB(0,0,0)
menuToggle.Parent = screenGui

local function toggleMenu()
    menuVisible = not menuVisible
    frame.Visible = menuVisible
end
menuToggle.MouseButton1Click:Connect(toggleMenu)
UserInputService.InputBegan:Connect(function(input,gp)
    if not gp and not isMobile and input.KeyCode == Enum.KeyCode.M then toggleMenu() end
end)

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,26,0,26)
closeBtn.Position = UDim2.new(1,-36,0,8)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.BackgroundColor3 = Color3.fromRGB(180,60,60)
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.Parent = frame
closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

-- Mobile Fly Buttons
local mobileButtons = {}
if isMobile then
    local directions = {"Forward","Back","Left","Right","Up","Down"}
    local offsets = {{120,350},{120,390},{80,370},{160,370},{240,370},{240,410}}
    for i,dir in ipairs(directions) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0,60,0,30)
        btn.Position = UDim2.new(0,offsets[i][1],0,offsets[i][2])
        btn.Text = dir
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 16
        btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.Parent = frame
        mobileButtons[dir] = btn
        btn.MouseButton1Down:Connect(function() keys[dir] = true end)
        btn.MouseButton1Up:Connect(function() keys[dir] = false end)
    end
end

-- Fly input for PC
UserInputService.InputBegan:Connect(function(input,gp)
    if not gp and not isMobile then keys[input.KeyCode] = true end
end)
UserInputService.InputEnded:Connect(function(input)
    if not isMobile then keys[input.KeyCode] = false end
end)

-- Main loop
RunService.RenderStepped:Connect(function()
    local char = player.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        -- ESP
        if espEnabled then
            for _, other in pairs(Players:GetPlayers()) do
                if other ~= player and other.Character then
                    local boxes = espBoxes[other] or {}
                    for _, part in pairs(other.Character:GetChildren()) do
                        if part:IsA("BasePart") then
                            if not boxes[part] then
                                local box = Instance.new("BoxHandleAdornment")
                                box.Adornee = part
                                box.AlwaysOnTop = espAlwaysOnTop
                                box.ZIndex = 10
                                box.Size = part.Size
                                box.Transparency = espTransparency
                                box.Color3 = espColor
                                box.Parent = part
                                boxes[part] = box
                            else
                                boxes[part].Color3 = espColor
                                boxes[part].Transparency = espTransparency
                                boxes[part].AlwaysOnTop = espAlwaysOnTop
                            end
                        end
                    end
                    espBoxes[other] = boxes
                end
            end
        end

        -- Fly
        if flyEnabled and hrp then
            humanoid.PlatformStand = true
            if not flyBV then
                flyBV = Instance.new("BodyVelocity")
                flyBV.MaxForce = Vector3.new(1e5,1e5,1e5)
                flyBV.Velocity = Vector3.new(0,0,0)
                flyBV.Parent = hrp

                flyBG = Instance.new("BodyGyro")
                flyBG.MaxTorque = Vector3.new(1e5,1e5,1e5)
                flyBG.CFrame = hrp.CFrame
                flyBG.Parent = hrp
            end

            local move = Vector3.new()
            local cam = workspace.CurrentCamera.CFrame
            if isMobile then
                if keys["Forward"] then move = move + cam.LookVector end
                if keys["Back"] then move = move - cam.LookVector end
                if keys["Left"] then move = move - cam.RightVector end
                if keys["Right"] then move = move + cam.RightVector end
                if keys["Up"] then move = move + Vector3.new(0,1,0) end
                if keys["Down"] then move = move - Vector3.new(0,1,0) end
            else
                if keys[Enum.KeyCode.W] then move = move + cam.LookVector end
                if keys[Enum.KeyCode.S] then move = move - cam.LookVector end
                if keys[Enum.KeyCode.A] then move = move - cam.RightVector end
                if keys[Enum.KeyCode.D] then move = move + cam.RightVector end
                if keys[Enum.KeyCode.Space] then move = move + Vector3.new(0,1,0) end
                if keys[Enum.KeyCode.LeftShift] then move = move - Vector3.new(0,1,0) end
            end

            if move.Magnitude > 0 then
                flyBV.Velocity = move.Unit * flySpeed
            else
                flyBV.Velocity = Vector3.new(0,0,0)
            end
            flyBG.CFrame = CFrame.new(hrp.Position, hrp.Position + cam.LookVector)
        elseif flyBV then
            flyBV:Destroy()
            flyBV = nil
            if flyBG then flyBG:Destroy() flyBG = nil end
            if humanoid then humanoid.PlatformStand = false end
        end
    end
end)
]])()
