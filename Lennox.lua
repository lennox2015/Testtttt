print("bruhhhhhhhhhhhhhhhhhhhhhhh")
local code = [[
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Entferne vorhandene Kopie, falls vorhanden
local existing = playerGui:FindFirstChild("LolGui")
if existing then existing:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LolGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 140)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BackgroundTransparency = 0
frame.BorderSizePixel = 0
frame.Parent = screenGui
frame.ZIndex = 2
frame.ClipsDescendants = true

local uICorner = Instance.new("UICorner", frame)
uICorner.CornerRadius = UDim.new(0, 12)

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, -20, 1, -20)
label.Position = UDim2.new(0, 10, 0, 10)
label.BackgroundTransparency = 1
label.Text = "lol"
label.Font = Enum.Font.GothamBold
label.TextSize = 56
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.TextXAlignment = Enum.TextXAlignment.Center
label.TextYAlignment = Enum.TextYAlignment.Center
label.Parent = frame
label.ZIndex = 3
]]

local fn = loadstring(code)
if type(fn) == "function" then
    fn()
else
    warn("loadstring nicht verfügbar oder Rückgabewert ist kein Function.")
end
