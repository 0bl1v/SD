local Library = {}
Library.__index = Library

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local CONFIG = {
	AnimationSpeed = 0.2,
	Colors = {
		Background = Color3.fromRGB(15, 15, 15),
		TopBar = Color3.fromRGB(20, 20, 20),
		ElementBg = Color3.fromRGB(25, 25, 25),
		ElementBgHover = Color3.fromRGB(35, 35, 35),
		Separator = Color3.fromRGB(45, 45, 45),
		Stroke = Color3.fromRGB(31, 31, 31),
		Text = Color3.fromRGB(255, 255, 255),
		TextDim = Color3.fromRGB(180, 180, 180),
		TabActive = Color3.fromRGB(100, 150, 255),
		TabInactive = Color3.fromRGB(150, 150, 150),
		ToggleOn = Color3.fromRGB(100, 200, 100),
		ToggleOff = Color3.fromRGB(60, 60, 60),
		SliderFill = Color3.fromRGB(100, 150, 255)
	}
}

local function createStroke(parent, color, thickness)
	local stroke = Instance.new("UIStroke")
	stroke.Color = color or CONFIG.Colors.Stroke
	stroke.Thickness = thickness or 1
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Parent = parent
	return stroke
end

local function createTween(object, goal, duration)
	return TweenService:Create(
		object,
		TweenInfo.new(duration or CONFIG.AnimationSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		goal
	)
end

function Library:CreateHub(hubName)
	local Hub = {}
	Hub.Tabs = {}
	Hub.CurrentTab = nil
	
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "UILibrary_" .. tostring(math.random(1000, 9999))
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = game:GetService("CoreGui")
	
	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.BackgroundColor3 = CONFIG.Colors.Background
	MainFrame.BorderSizePixel = 0
	MainFrame.Position = UDim2.new(0.5, -280, 0.5, -180)
	MainFrame.Size = UDim2.new(0, 560, 0, 360)
	MainFrame.Parent = ScreenGui
	MainFrame.ClipsDescendants = true
	createStroke(MainFrame, CONFIG.Colors.Stroke, 2)
	
	local TopBar = Instance.new("Frame")
	TopBar.Name = "TopBar"
	TopBar.BackgroundColor3 = CONFIG.Colors.TopBar
	TopBar.BorderSizePixel = 0
	TopBar.Size = UDim2.new(1, 0, 0, 40)
	TopBar.Parent = MainFrame
	
	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Name = "Title"
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Position = UDim2.new(0, 15, 0, 0)
	TitleLabel.Size = UDim2.new(1, -60, 1, 0)
	TitleLabel.Font = Enum.Font.GothamBold
	TitleLabel.Text = hubName
	TitleLabel.TextColor3 = CONFIG.Colors.Text
	TitleLabel.TextSize = 16
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.Parent = TopBar
	
	local CloseButton = Instance.new("TextLabel")
	CloseButton.Name = "CloseButton"
	CloseButton.BackgroundTransparency = 1
	CloseButton.Position = UDim2.new(1, -35, 0, 10)
	CloseButton.Size = UDim2.new(0, 20, 0, 20)
	CloseButton.Font = Enum.Font.GothamBold
	CloseButton.Text = "×"
	CloseButton.TextColor3 = CONFIG.Colors.TextDim
	CloseButton.TextSize = 20
	CloseButton.Parent = TopBar
	
	local CloseDetector = Instance.new("TextButton")
	CloseDetector.Name = "CloseDetector"
	CloseDetector.BackgroundTransparency = 1
	CloseDetector.Size = UDim2.new(1, 0, 1, 0)
	CloseDetector.Text = ""
	CloseDetector.Parent = CloseButton
	
	CloseDetector.MouseEnter:Connect(function()
		createTween(CloseButton, {TextColor3 = Color3.fromRGB(255, 100, 100)}, 0.15):Play()
	end)
	
	CloseDetector.MouseLeave:Connect(function()
		createTween(CloseButton, {TextColor3 = CONFIG.Colors.TextDim}, 0.15):Play()
	end)
	
	CloseDetector.MouseButton1Click:Connect(function()
		ScreenGui:Destroy()
	end)
	
	local TopBarSeparator = Instance.new("Frame")
	TopBarSeparator.BackgroundColor3 = CONFIG.Colors.Separator
	TopBarSeparator.BorderSizePixel = 0
	TopBarSeparator.Position = UDim2.new(0, 0, 1, 0)
	TopBarSeparator.Size = UDim2.new(1, 0, 0, 1)
	TopBarSeparator.Parent = TopBar
	
	local TabContainer = Instance.new("Frame")
	TabContainer.Name = "TabContainer"
	TabContainer.BackgroundTransparency = 1
	TabContainer.Position = UDim2.new(0, 10, 0, 50)
	TabContainer.Size = UDim2.new(0, 120, 1, -60)
	TabContainer.Parent = MainFrame
	
	local TabLayout = Instance.new("UIListLayout")
	TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
	TabLayout.Padding = UDim.new(0, 5)
	TabLayout.Parent = TabContainer
	
	local LeftSeparator = Instance.new("Frame")
	LeftSeparator.BackgroundColor3 = CONFIG.Colors.Separator
	LeftSeparator.BorderSizePixel = 0
	LeftSeparator.Position = UDim2.new(0, 140, 0, 40)
	LeftSeparator.Size = UDim2.new(0, 1, 1, -40)
	LeftSeparator.Parent = MainFrame
	
	local ContentContainer = Instance.new("Frame")
	ContentContainer.Name = "ContentContainer"
	ContentContainer.BackgroundTransparency = 1
	ContentContainer.Position = UDim2.new(0, 151, 0, 50)
	ContentContainer.Size = UDim2.new(1, -161, 1, -60)
	ContentContainer.Parent = MainFrame
	
	local dragging, dragInput, dragStart, startPos
	
	TopBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
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

function Library:CreateTab(tabName)
	local Tab = {}
	Tab.Elements = {}
	
	local TabButton = Instance.new("TextButton")
	TabButton.Name = tabName
	TabButton.BackgroundColor3 = CONFIG.Colors.ElementBg
	TabButton.BorderSizePixel = 0
	TabButton.Size = UDim2.new(1, 0, 0, 32)
	TabButton.Font = Enum.Font.Gotham
	TabButton.Text = tabName
	TabButton.TextColor3 = CONFIG.Colors.TabInactive
	TabButton.TextSize = 13
	TabButton.Parent = self.TabContainer
	createStroke(TabButton, CONFIG.Colors.Stroke, 1)
	
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
	
	local ContentPadding = Instance.new("UIPadding")
	ContentPadding.PaddingRight = UDim.new(0, 5)
	ContentPadding.Parent = TabContent
	
	TabButton.MouseButton1Click:Connect(function()
		for _, tab in pairs(self.Tabs) do
			tab.Button.TextColor3 = CONFIG.Colors.TabInactive
			tab.Button.BackgroundColor3 = CONFIG.Colors.ElementBg
			tab.Content.Visible = false
		end
		
		TabButton.TextColor3 = CONFIG.Colors.TabActive
		TabButton.BackgroundColor3 = CONFIG.Colors.ElementBgHover
		TabContent.Visible = true
		self.CurrentTab = Tab
	end)
	
	if #self.Tabs == 0 then
		TabButton.TextColor3 = CONFIG.Colors.TabActive
		TabButton.BackgroundColor3 = CONFIG.Colors.ElementBgHover
		TabContent.Visible = true
		self.CurrentTab = Tab
	end
	
	Tab.Button = TabButton
	Tab.Content = TabContent
	table.insert(self.Tabs, Tab)
	
	return setmetatable(Tab, {__index = Library})
end

function Library:AddButton(text, callback)
	local ButtonFrame = Instance.new("Frame")
	ButtonFrame.Name = "ButtonElement"
	ButtonFrame.BackgroundColor3 = CONFIG.Colors.ElementBg
	ButtonFrame.BorderSizePixel = 0
	ButtonFrame.Size = UDim2.new(1, 0, 0, 36)
	ButtonFrame.Parent = self.Content
	createStroke(ButtonFrame, CONFIG.Colors.Stroke, 1)
	
	local ButtonLabel = Instance.new("TextLabel")
	ButtonLabel.Name = "Label"
	ButtonLabel.BackgroundTransparency = 1
	ButtonLabel.Position = UDim2.new(0, 12, 0, 0)
	ButtonLabel.Size = UDim2.new(1, -24, 1, 0)
	ButtonLabel.Font = Enum.Font.Gotham
	ButtonLabel.Text = text
	ButtonLabel.TextColor3 = CONFIG.Colors.Text
	ButtonLabel.TextSize = 13
	ButtonLabel.TextXAlignment = Enum.TextXAlignment.Left
	ButtonLabel.Parent = ButtonFrame
	
	local ClickDetector = Instance.new("TextButton")
	ClickDetector.Name = "ClickDetector"
	ClickDetector.BackgroundTransparency = 1
	ClickDetector.Size = UDim2.new(1, 0, 1, 0)
	ClickDetector.Text = ""
	ClickDetector.Parent = ButtonFrame
	
	ClickDetector.MouseEnter:Connect(function()
		createTween(ButtonFrame, {BackgroundColor3 = CONFIG.Colors.ElementBgHover}, 0.15):Play()
	end)
	
	ClickDetector.MouseLeave:Connect(function()
		createTween(ButtonFrame, {BackgroundColor3 = CONFIG.Colors.ElementBg}, 0.15):Play()
	end)
	
	ClickDetector.MouseButton1Click:Connect(function()
		createTween(ButtonFrame, {BackgroundColor3 = CONFIG.Colors.Separator}, 0.05):Play()
		task.wait(0.05)
		createTween(ButtonFrame, {BackgroundColor3 = CONFIG.Colors.ElementBgHover}, 0.15):Play()
		pcall(callback)
	end)
	
	table.insert(self.Elements, ButtonFrame)
	return ButtonFrame
end

function Library:AddToggle(text, default, callback)
	local toggled = default or false
	
	local ToggleFrame = Instance.new("Frame")
	ToggleFrame.Size = UDim2.new(1, 0, 0, 36)
	ToggleFrame.BackgroundColor3 = CONFIG.Colors.ElementBg
	ToggleFrame.BorderSizePixel = 0
	ToggleFrame.Parent = self.Content
	createStroke(ToggleFrame, CONFIG.Colors.Stroke, 1)
	
	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(1, -70, 1, 0)
	Label.Position = UDim2.new(0, 12, 0, 0)
	Label.BackgroundTransparency = 1
	Label.Font = Enum.Font.Gotham
	Label.Text = text
	Label.TextColor3 = CONFIG.Colors.Text
	Label.TextSize = 13
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = ToggleFrame
	
	local ToggleButton = Instance.new("Frame")
	ToggleButton.Size = UDim2.new(0, 44, 0, 22)
	ToggleButton.Position = UDim2.new(1, -54, 0.5, -11)
	ToggleButton.BackgroundColor3 = toggled and CONFIG.Colors.ToggleOn or CONFIG.Colors.ToggleOff
	ToggleButton.BorderSizePixel = 0
	ToggleButton.Parent = ToggleFrame
	createStroke(ToggleButton, CONFIG.Colors.Stroke, 1)
	
	local ButtonCorner = Instance.new("UICorner")
	ButtonCorner.CornerRadius = UDim.new(1, 0)
	ButtonCorner.Parent = ToggleButton
	
	local ToggleCircle = Instance.new("Frame")
	ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
	ToggleCircle.Position = toggled and UDim2.new(0, 25, 0, 3) or UDim2.new(0, 3, 0, 3)
	ToggleCircle.BackgroundColor3 = CONFIG.Colors.Text
	ToggleCircle.BorderSizePixel = 0
	ToggleCircle.Parent = ToggleButton
	
	local CircleCorner = Instance.new("UICorner")
	CircleCorner.CornerRadius = UDim.new(1, 0)
	CircleCorner.Parent = ToggleCircle
	
	local ToggleDetector = Instance.new("TextButton")
	ToggleDetector.BackgroundTransparency = 1
	ToggleDetector.Size = UDim2.new(1, 0, 1, 0)
	ToggleDetector.Text = ""
	ToggleDetector.Parent = ToggleFrame
	
	ToggleDetector.MouseEnter:Connect(function()
		createTween(ToggleFrame, {BackgroundColor3 = CONFIG.Colors.ElementBgHover}, 0.15):Play()
	end)
	
	ToggleDetector.MouseLeave:Connect(function()
		createTween(ToggleFrame, {BackgroundColor3 = CONFIG.Colors.ElementBg}, 0.15):Play()
	end)
	
	ToggleDetector.MouseButton1Click:Connect(function()
		toggled = not toggled
		createTween(ToggleButton, {
			BackgroundColor3 = toggled and CONFIG.Colors.ToggleOn or CONFIG.Colors.ToggleOff
		}, 0.2):Play()
		createTween(ToggleCircle, {
			Position = toggled and UDim2.new(0, 25, 0, 3) or UDim2.new(0, 3, 0, 3)
		}, 0.2):Play()
		pcall(callback, toggled)
	end)
	
	table.insert(self.Elements, ToggleFrame)
	return ToggleFrame
end

function Library:AddSlider(text, min, max, default, callback)
	local value = default or min
	
	local SliderFrame = Instance.new("Frame")
	SliderFrame.Size = UDim2.new(1, 0, 0, 50)
	SliderFrame.BackgroundColor3 = CONFIG.Colors.ElementBg
	SliderFrame.BorderSizePixel = 0
	SliderFrame.Parent = self.Content
	createStroke(SliderFrame, CONFIG.Colors.Stroke, 1)
	
	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(0.6, 0, 0, 20)
	Label.Position = UDim2.new(0, 12, 0, 8)
	Label.BackgroundTransparency = 1
	Label.Font = Enum.Font.Gotham
	Label.Text = text
	Label.TextColor3 = CONFIG.Colors.Text
	Label.TextSize = 13
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = SliderFrame
	
	local ValueLabel = Instance.new("TextLabel")
	ValueLabel.Size = UDim2.new(0.35, 0, 0, 20)
	ValueLabel.Position = UDim2.new(0.65, 0, 0, 8)
	ValueLabel.BackgroundTransparency = 1
	ValueLabel.Font = Enum.Font.GothamBold
	ValueLabel.Text = tostring(value)
	ValueLabel.TextColor3 = CONFIG.Colors.TabActive
	ValueLabel.TextSize = 13
	ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
	ValueLabel.Parent = SliderFrame
	
	local SliderBar = Instance.new("Frame")
	SliderBar.Size = UDim2.new(1, -24, 0, 4)
	SliderBar.Position = UDim2.new(0, 12, 0, 34)
	SliderBar.BackgroundColor3 = CONFIG.Colors.Separator
	SliderBar.BorderSizePixel = 0
	SliderBar.Parent = SliderFrame
	
	local SliderFill = Instance.new("Frame")
	SliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
	SliderFill.BackgroundColor3 = CONFIG.Colors.SliderFill
	SliderFill.BorderSizePixel = 0
	SliderFill.Parent = SliderBar
	
	local SliderButton = Instance.new("Frame")
	SliderButton.Size = UDim2.new(0, 12, 0, 12)
	SliderButton.Position = UDim2.new((value - min) / (max - min), -6, 0.5, -6)
	SliderButton.BackgroundColor3 = CONFIG.Colors.Text
	SliderButton.BorderSizePixel = 0
	SliderButton.Parent = SliderBar
	
	local ButtonCorner = Instance.new("UICorner")
	ButtonCorner.CornerRadius = UDim.new(1, 0)
	ButtonCorner.Parent = SliderButton
	
	local dragging = false
	
	local function updateSlider(input)
		local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
		value = math.floor(min + (max - min) * pos)
		
		SliderFill.Size = UDim2.new(pos, 0, 1, 0)
		SliderButton.Position = UDim2.new(pos, -6, 0.5, -6)
		ValueLabel.Text = tostring(value)
		
		pcall(callback, value)
	end
	
	SliderBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			updateSlider(input)
		end
	end)
	
	SliderBar.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			updateSlider(input)
		end
	end)
	
	SliderFrame.MouseEnter:Connect(function()
		createTween(SliderFrame, {BackgroundColor3 = CONFIG.Colors.ElementBgHover}, 0.15):Play()
	end)
	
	SliderFrame.MouseLeave:Connect(function()
		createTween(SliderFrame, {BackgroundColor3 = CONFIG.Colors.ElementBg}, 0.15):Play()
	end)
	
	table.insert(self.Elements, SliderFrame)
	return SliderFrame
end

function Library:AddLabel(text)
	local LabelFrame = Instance.new("Frame")
	LabelFrame.Size = UDim2.new(1, 0, 0, 28)
	LabelFrame.BackgroundTransparency = 1
	LabelFrame.Parent = self.Content
	
	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(1, -12, 1, 0)
	Label.Position = UDim2.new(0, 12, 0, 0)
	Label.BackgroundTransparency = 1
	Label.Font = Enum.Font.Gotham
	Label.Text = text
	Label.TextColor3 = CONFIG.Colors.TextDim
	Label.TextSize = 12
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.TextWrapped = true
	Label.Parent = LabelFrame
	
	table.insert(self.Elements, LabelFrame)
	return LabelFrame
end

return Library
