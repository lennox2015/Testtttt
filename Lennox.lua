loadstring([[
print("✅")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Entferne vorhandene GUI
local existing = playerGui:FindFirstChild("SpeedGui")
if existing then existing:Destroy() end

-- GUI erstellen
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpeedGui"
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 140)
frame.Position = UDim2.new(0.5, -150, 0.5, -70)
frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local uic = Instance.new("UICorner", frame)
uic.CornerRadius = UDim.new(0,10)

-- Funktion für Drag
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
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Text und Eingabe
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 30)
title.Position = UDim2.new(0,10,0,10)
title.BackgroundTransparency = 1
title.Text = "WalkSpeed Controller"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Parent = frame

local input = Instance.new("TextBox")
input.Size = UDim2.new(0,160,0,32)
input.Position = UDim2.new(0,10,0,50)
input.PlaceholderText = "Speed (8-200)"
input.ClearTextOnFocus = false
input.Font = Enum.Font.Gotham
input.TextSize = 20
input.Text = ""
input.Parent = frame

local applyBtn = Instance.new("TextButton")
applyBtn.Size = UDim2.new(0,100,0,32)
applyBtn.Position = UDim2.new(0,180,0,50)
applyBtn.Text = "Set Speed"
applyBtn.Font = Enum.Font.GothamBold
applyBtn.TextSize = 18
applyBtn.BackgroundColor3 = Color3.fromRGB(70,130,180)
applyBtn.TextColor3 = Color3.fromRGB(255,255,255)
applyBtn.Parent = frame

local info = Instance.new("TextLabel")
info.Size = UDim2.new(1, -20, 0, 36)
info.Position = UDim2.new(0,10,0,92)
info.BackgroundTransparency = 1
info.Text = "Client-side only. Allowed: 8-200"
info.Font = Enum.Font.Gotham
info.TextSize = 14
info.TextColor3 = Color3.fromRGB(200,200,200)
info.TextXAlignment = Enum.TextXAlignment.Left
info.Parent = frame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,26,0,26)
closeBtn.Position = UDim2.new(1,-36,0,8)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.BackgroundColor3 = Color3.fromRGB(180,60,60)
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.Parent = frame

-- Button Events
applyBtn.MouseButton1Click:Connect(function()
    local val = tonumber(input.Text)
    if not val then
        info.Text = "Bitte Zahl eingeben."
        return
    end
    val = math.clamp(val,8,200)
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = val
        info.Text = "WalkSpeed gesetzt: "..val
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)
]])()
