loadstring([[
print("✅")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Remove existing GUI
local existing = playerGui:FindFirstChild("DevMenuGui")
if existing then existing:Destroy() end

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DevMenuGui"
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 180)
frame.Position = UDim2.new(0.5, -150, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local uic = Instance.new("UICorner", frame)
uic.CornerRadius = UDim.new(0,10)

-- Dragging
local dragging = false
local dragInput, mousePos, framePos
local function update(input)
    local delta = input.Position - mousePos
    frame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X,
                               framePos.Y.Scale, framePos.Y.Offset + delta.Y)
end
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
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

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 30)
title.Position = UDim2.new(0,10,0,10)
title.BackgroundTransparency = 1
title.Text = "Dev Menu"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Parent = frame

-- WalkSpeed Input
local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(0,160,0,32)
speedInput.Position = UDim2.new(0,10,0,50)
speedInput.PlaceholderText = "Speed (8-200)"
speedInput.ClearTextOnFocus = false
speedInput.Font = Enum.Font.Gotham
speedInput.TextSize = 20
speedInput.Text = ""
speedInput.Parent = frame

local applySpeed = Instance.new("TextButton")
applySpeed.Size = UDim2.new(0,100,0,32)
applySpeed.Position = UDim2.new(0,180,0,50)
applySpeed.Text = "Set Speed"
applySpeed.Font = Enum.Font.GothamBold
applySpeed.TextSize = 18
applySpeed.BackgroundColor3 = Color3.fromRGB(70,130,180)
applySpeed.TextColor3 = Color3.fromRGB(255,255,255)
applySpeed.Parent = frame

-- ESP Toggle
local espEnabled = false
local espToggle = Instance.new("TextButton")
espToggle.Size = UDim2.new(0, 120, 0, 32)
espToggle.Position = UDim2.new(0,10,0,95)
espToggle.Text = "ESP: OFF"
espToggle.Font = Enum.Font.GothamBold
espToggle.TextSize = 18
espToggle.BackgroundColor3 = Color3.fromRGB(100,50,180)
espToggle.TextColor3 = Color3.fromRGB(255,255,255)
espToggle.Parent = frame

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,26,0,26)
closeBtn.Position = UDim2.new(1,-36,0,8)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.BackgroundColor3 = Color3.fromRGB(180,60,60)
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.Parent = frame
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- WalkSpeed logic
applySpeed.MouseButton1Click:Connect(function()
    local val = tonumber(speedInput.Text)
    if val then
        val = math.clamp(val, 8, 200)
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.WalkSpeed = val end
    end
end)

-- Full-body ESP logic
local espBoxes = {}
espToggle.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espToggle.Text = "ESP: "..(espEnabled and "ON" or "OFF")
    if not espEnabled then
        for _, boxes in pairs(espBoxes) do
            for _, box in pairs(boxes) do
                box:Destroy()
            end
        end
        espBoxes = {}
    end
end)

RunService.RenderStepped:Connect(function()
    if espEnabled then
        for _, other in pairs(Players:GetPlayers()) do
            if other ~= player and other.Character then
                local boxes = espBoxes[other] or {}
                local parts = other.Character:GetChildren()
                local newBoxes = {}
                for _, part in pairs(parts) do
                    if part:IsA("BasePart") then
                        local box = boxes[part]
                        if not box then
                            box = Instance.new("BoxHandleAdornment")
                            box.Adornee = part
                            box.AlwaysOnTop = true
                            box.ZIndex = 10
                            box.Size = part.Size
                            box.Transparency = 0.5
                            box.Color3 = Color3.fromRGB(255,0,0)
                            box.Parent = part
                        end
                        newBoxes[part] = box
                    end
                end
                -- Destroy old boxes no longer needed
                for p, b in pairs(boxes) do
                    if not newBoxes[p] then b:Destroy() end
                end
                espBoxes[other] = newBoxes
            end
        end
    end
end)
]])()
