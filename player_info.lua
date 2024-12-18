-- Gui to Lua
-- Version: 3.2

-- Instances:

local GUI_Info = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local PlayerUsername = Instance.new("TextLabel")
local UICorner_2 = Instance.new("UICorner")
local PlayerImage = Instance.new("ImageLabel")
local UICorner_3 = Instance.new("UICorner")
local Tools = Instance.new("ScrollingFrame")
local UICorner_4 = Instance.new("UICorner")
local UIListLayout = Instance.new("UIListLayout")
local ToolF = Instance.new("Frame")
local UICorner_5 = Instance.new("UICorner")
local ToolName = Instance.new("TextLabel")
local UICorner_6 = Instance.new("UICorner")
local ToolImage = Instance.new("ImageLabel")
local UICorner_7 = Instance.new("UICorner")

--Properties:

GUI_Info.Name = "GUI_Info"
GUI_Info.Parent = gethui()
GUI_Info.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
GUI_Info.ResetOnSpawn = false

Frame.Parent = GUI_Info
Frame.BackgroundColor3 = Color3.fromRGB(49, 49, 49)
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.699574471, 0, 0.269982249, 0)
Frame.Size = UDim2.new(0.193191484, 0, 0.460035533, 0)

UICorner.Parent = Frame

PlayerUsername.Name = "PlayerUsername"
PlayerUsername.Parent = Frame
PlayerUsername.BackgroundColor3 = Color3.fromRGB(179, 0, 255)
PlayerUsername.BorderColor3 = Color3.fromRGB(0, 0, 0)
PlayerUsername.BorderSizePixel = 0
PlayerUsername.Size = UDim2.new(1, 0, 0.0926640928, 0)
PlayerUsername.Font = Enum.Font.Unknown
PlayerUsername.TextColor3 = Color3.fromRGB(0, 0, 0)
PlayerUsername.TextScaled = true
PlayerUsername.TextSize = 14.000
PlayerUsername.TextWrapped = true
PlayerUsername.TextXAlignment = Enum.TextXAlignment.Right

UICorner_2.Parent = PlayerUsername

PlayerImage.Name = "PlayerImage"
PlayerImage.Parent = Frame
PlayerImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PlayerImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
PlayerImage.BorderSizePixel = 0
PlayerImage.Size = UDim2.new(0.105726875, 0, 0.0926640928, 0)
PlayerImage.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"

UICorner_3.Parent = PlayerImage

Tools.Name = "Tools"
Tools.Parent = Frame
Tools.Active = true
Tools.BackgroundColor3 = Color3.fromRGB(183, 0, 255)
Tools.BorderColor3 = Color3.fromRGB(0, 0, 0)
Tools.BorderSizePixel = 0
Tools.Position = UDim2.new(0.0572687238, 0, 0.67181468, 0)
Tools.Size = UDim2.new(0.867841423, 0, 0.289575279, 0)

UICorner_4.Parent = Tools

UIListLayout.Parent = Tools
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

ToolF.Name = "ToolF"
ToolF.Parent = Tools
ToolF.BackgroundColor3 = Color3.fromRGB(76, 76, 76)
ToolF.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToolF.BorderSizePixel = 0
ToolF.Size = UDim2.new(0, 184, 0, 23)

UICorner_5.Parent = ToolF

ToolName.Name = "ToolName"
ToolName.Parent = ToolF
ToolName.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
ToolName.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToolName.BorderSizePixel = 0
ToolName.Position = UDim2.new(0.125, 0, 0, 0)
ToolName.Size = UDim2.new(0.875, 0, 1, 0)
ToolName.Font = Enum.Font.SourceSans
ToolName.TextColor3 = Color3.fromRGB(255, 229, 152)
ToolName.TextScaled = true
ToolName.TextSize = 14.000
ToolName.TextWrapped = true

UICorner_6.Parent = ToolName

ToolImage.Name = "ToolImage"
ToolImage.Parent = ToolF
ToolImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToolImage.BackgroundTransparency = 1.000
ToolImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToolImage.BorderSizePixel = 0
ToolImage.Size = UDim2.new(0.125, 0, 1, 0)
ToolImage.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"

UICorner_7.Parent = ToolImage

return GUI_Info;
