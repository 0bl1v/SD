-- UI Library v1.1
-- DarkLua Compatible - Obfuscated Version Ready
-- Modern Roblox UI Library

local Library = {}
Library.__index = Library

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Configuration
local CONFIG = {
	AnimationSpeed = 0.3,
	Colors = {
		Background = Color3.fromRGB(0, 0, 0),
		ElementBg = Color3.fromRGB(0, 0, 0),
		ElementBgHover = Color3.fromRGB(20, 20, 20),
		Separator = Color3.fromRGB(67, 67, 67),
		Text = Color3.fromRGB(255, 255, 255),
		TabActive = Color3.fromRGB(100, 100, 255),
		TabInactive = Color3.fromRGB(255, 255, 255),
		ToggleOn = Color3.fromRGB(100, 200, 100),
		ToggleOff = Color3.fromRGB(200, 100, 100)
	}
}

-- Utility Functions
local function createCorner(parent, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius or 8)
	corner.Parent = parent
	return corner
end

local function createTween(object, goal, duration)
	return TweenService:Create(
		object,
		TweenInfo.new(duration or CONFIG.AnimationSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		goal
	)
end

-- Main Hub Creation
function Library:CreateHub(hubName)
	local Hub = {}
	Hub.Tabs = {}
	Hub.CurrentTab = nil
	
	-- Create ScreenGui
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "UILibrary_" .. tostring(math.random(1000, 9999))
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
	
	-- Main Frame
	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.BackgroundColor3 = CONFIG.Colors.Background
	MainFrame.BorderSizePixel = 0
	MainFrame.Position = UDim2.new(0.265, 0, 0.245, 0)
	MainFrame.Size = UDim2.new(0, 514, 0, 328)
	MainFrame.Parent = ScreenGui
	MainFrame.ClipsDescendants = true
	createCorner(MainFrame)
	
	-- Title
	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Name = "Title"
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Position = UDim2.new(0, 0, 0.027, 0)
	TitleLabel.Size = UDim2.new(0, 513, 0, 28)
	TitleLabel.Font = Enum.Font.Code
	TitleLabel.Text = "- " .. hubName .. " -"
	TitleLabel.TextColor3 = CONFIG.Colors.Text
	TitleLabel.TextSize = 16
	TitleLabel.Parent = MainFrame
	
	-- Tab Container (Left side)
	local TabContainer = Instance.new("Frame")
	TabContainer.Name = "TabContainer"
	TabContainer.BackgroundTransparency = 1
	TabContainer.Position = UDim2.new(0.025, 0, 0.137, 0)
	TabContainer.Size = UDim2.new(0, 75, 0, 260)
	TabContainer.Parent = MainFrame
	
	local TabLayout = Instance.new("UIListLayout")
	TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
	TabLayout.Padding = UDim.new(0, 8)
	TabLayout.Parent = TabContainer
	
	-- Left Separator
	local LeftSeparator = Instance.new("Frame")
	LeftSeparator.BackgroundColor3 = CONFIG.Colors.Separator
	LeftSeparator.BorderSizePixel = 0
	LeftSeparator.Position = UDim2.new(0, 0, 0.113, 0)
	LeftSeparator.Size = UDim2.new(0, 1, 0, 291)
	LeftSeparator.Parent = MainFrame
	
	-- Right Separator
	local RightSeparator = Instance.new("Frame")
	RightSeparator.BackgroundColor3 = CONFIG.Colors.Separator
	RightSeparator.BorderSizePixel = 0
	RightSeparator.Position = UDim2.new(0.177, 0, 0.113, 0)
	RightSeparator.Size = UDim2.new(0, 1, 0, 291)
	RightSeparator.Parent = MainFrame
	
	-- Content Container (Right side)
	local ContentContainer = Instance.new("Frame")
	ContentContainer.Name = "ContentContainer"
	ContentContainer.BackgroundTransparency = 1
	ContentContainer.Position = UDim2.new(0.204, 0, 0.137, 0)
	ContentContainer.Size = UDim2.new(0, 399, 0, 260)
	ContentContainer.Parent = MainFrame
	
	-- Make Draggable
	local dragging, dragInput, dragStart, startPos
	
	MainFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = MainFrame.Position
			
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)
	
	RunService.Heartbeat:Connect(function()
		if dragging and dragInput then
			local delta = dragInput.Position - dragStart
			MainFrame.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)
	
	Hub.ScreenGui = ScreenGui
	Hub.MainFrame = MainFrame
	Hub.TabContainer = TabContainer
	Hub.ContentContainer = ContentContainer
	
	return setmetatable(Hub, {__index = Library})
end

-- Create Tab
function Library:CreateTab(tabName)
	local Tab = {}
	Tab.Elements = {}
	
	-- Tab Button
	local TabButton = Instance.new("TextButton")
	TabButton.Name = tabName
	TabButton.BackgroundTransparency = 1
	TabButton.Size = UDim2.new(1, 0, 0, 20)
	TabButton.Font = Enum.Font.Code
	TabButton.Text = tabName
	TabButton.TextColor3 = CONFIG.Colors.TabInactive
	TabButton.TextSize = 14
	TabButton.TextXAlignment = Enum.TextXAlignment.Left
	TabButton.Parent = self.TabContainer
	
	-- Tab Content Frame
	local TabContent = Instance.new("ScrollingFrame")
	TabContent.Name = tabName .. "_Content"
	TabContent.BackgroundTransparency = 1
	TabContent.Size = UDim2.new(1, 0, 1, 0)
	TabContent.ScrollBarThickness = 4
	TabContent.ScrollBarImageColor3 = CONFIG.Colors.Separator
	TabContent.BorderSizePixel = 0
	TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
	TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
	TabContent.Visible = false
	TabContent.Parent = self.ContentContainer
	
	local ContentLayout = Instance.new("UIListLayout")
	ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
	ContentLayout.Padding = UDim.new(0, 8)
	ContentLayout.Parent = TabContent
	
	-- Tab Activation
	TabButton.MouseButton1Click:Connect(function()
		for _, tab in pairs(self.Tabs) do
			tab.Button.TextColor3 = CONFIG.Colors.TabInactive
			tab.Content.Visible = false
		end
		
		TabButton.TextColor3 = CONFIG.Colors.TabActive
		TabContent.Visible = true
		self.CurrentTab = Tab
	end)
	
	-- Auto-open first tab
	if #self.Tabs == 0 then
		TabButton.TextColor3 = CONFIG.Colors.TabActive
		TabContent.Visible = true
		self.CurrentTab = Tab
	end
	
	Tab.Button = TabButton
	Tab.Content = TabContent
	table.insert(self.Tabs, Tab)
	
	return setmetatable(Tab, {__index = Library})
end

-- Add Button Element
function Library:AddButton(text, callback)
	local ButtonFrame = Instance.new("Frame")
	ButtonFrame.Name = "ButtonElement"
	ButtonFrame.BackgroundColor3 = CONFIG.Colors.ElementBg
	ButtonFrame.BorderSizePixel = 0
	ButtonFrame.Size = UDim2.new(1, -10, 0, 34)
	ButtonFrame.Parent = self.Content
	createCorner(ButtonFrame, 6)
	
	local ButtonLabel = Instance.new("TextLabel")
	ButtonLabel.Name = "Label"
	ButtonLabel.BackgroundTransparency = 1
	ButtonLabel.Position = UDim2.new(0.0226, 0, 0.0863, 0)
	ButtonLabel.Size = UDim2.new(0, 382, 0, 28)
	ButtonLabel.Font = Enum.Font.Code
	ButtonLabel.Text = text
	ButtonLabel.TextColor3 = CONFIG.Colors.Text
	ButtonLabel.TextSize = 14
	ButtonLabel.TextXAlignment = Enum.TextXAlignment.Left
	ButtonLabel.Parent = ButtonFrame
	
	local ClickDetector = Instance.new("TextButton")
	ClickDetector.Name = "ClickDetector"
	ClickDetector.BackgroundTransparency = 1
	ClickDetector.Size = UDim2.new(1, 0, 1, 0)
	ClickDetector.Text = ""
	ClickDetector.Parent = ButtonFrame
	
	-- Hover Effect
	ClickDetector.MouseEnter:Connect(function()
		createTween(ButtonFrame, {BackgroundColor3 = CONFIG.Colors.ElementBgHover}, 0.2):Play()
	end)
	
	ClickDetector.MouseLeave:Connect(function()
		createTween(ButtonFrame, {BackgroundColor3 = CONFIG.Colors.ElementBg}, 0.2):Play()
	end)
	
	-- Click Handler
	ClickDetector.MouseButton1Click:Connect(function()
		-- Click animation
		createTween(ButtonFrame, {Size = UDim2.new(1, -15, 0, 32)}, 0.1):Play()
		wait(0.1)
		createTween(ButtonFrame, {Size = UDim2.new(1, -10, 0, 34)}, 0.1):Play()
		
		-- Execute callback
		pcall(callback)
	end)
	
	table.insert(self.Elements, ButtonFrame)
	return ButtonFrame
end

-- Add Toggle Element
function Library:AddToggle(text, default, callback)
	local toggled = default or false
	
	local ToggleFrame = Instance.new("Frame")
	ToggleFrame.Size = UDim2.new(1, -10, 0, 34)
	ToggleFrame.BackgroundColor3 = CONFIG.Colors.ElementBg
	ToggleFrame.BorderSizePixel = 0
	ToggleFrame.Parent = self.Content
	createCorner(ToggleFrame, 6)
	
	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(0.75, 0, 1, 0)
	Label.BackgroundTransparency = 1
	Label.Font = Enum.Font.Code
	Label.Text = text
	Label.TextColor3 = CONFIG.Colors.Text
	Label.TextSize = 14
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Position = UDim2.new(0.0226, 0, 0, 0)
	Label.Parent = ToggleFrame
	
	local ToggleButton = Instance.new("TextButton")
	ToggleButton.Size = UDim2.new(0, 40, 0, 20)
	ToggleButton.Position = UDim2.new(0.88, 0, 0.5, -10)
	ToggleButton.BackgroundColor3 = toggled and CONFIG.Colors.ToggleOn or CONFIG.Colors.ToggleOff
	ToggleButton.BorderSizePixel = 0
	ToggleButton.Text = ""
	ToggleButton.Parent = ToggleFrame
	createCorner(ToggleButton, 10)
	
	-- Hover Effect
	ToggleButton.MouseEnter:Connect(function()
		createTween(ToggleFrame, {BackgroundColor3 = CONFIG.Colors.ElementBgHover}, 0.2):Play()
	end)
	
	ToggleButton.MouseLeave:Connect(function()
		createTween(ToggleFrame, {BackgroundColor3 = CONFIG.Colors.ElementBg}, 0.2):Play()
	end)
	
	-- Toggle Handler
	ToggleButton.MouseButton1Click:Connect(function()
		toggled = not toggled
		createTween(ToggleButton, {
			BackgroundColor3 = toggled and CONFIG.Colors.ToggleOn or CONFIG.Colors.ToggleOff
		}, 0.2):Play()
		pcall(callback, toggled)
	end)
	
	table.insert(self.Elements, ToggleFrame)
	return ToggleFrame
end

-- Add Label Element
function Library:AddLabel(text)
	local LabelFrame = Instance.new("Frame")
	LabelFrame.Size = UDim2.new(1, -10, 0, 25)
	LabelFrame.BackgroundTransparency = 1
	LabelFrame.Parent = self.Content
	
	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(1, 0, 1, 0)
	Label.BackgroundTransparency = 1
	Label.Font = Enum.Font.Code
	Label.Text = text
	Label.TextColor3 = CONFIG.Colors.Text
	Label.TextSize = 13
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.TextWrapped = true
	Label.Parent = LabelFrame
	
	table.insert(self.Elements, LabelFrame)
	return LabelFrame
end

return Library
