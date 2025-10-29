local Library = {}
Library.__index = Library
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CONFIG = {
	AnimationSpeed = 0.3,
	Colors = {
		Background = Color3.fromRGB(0, 0, 0),
		ElementBg = Color3.fromRGB(0, 0, 0),
		ElementBgHover = Color3.fromRGB(20, 20, 20),
		Separator = Color3.fromRGB(67, 67, 67),
		Stroke = Color3.fromRGB(31, 31, 31),
		Text = Color3.fromRGB(255, 255, 255),
		TabActive = Color3.fromRGB(100, 100, 255),
		TabInactive = Color3.fromRGB(255, 255, 255),
		ToggleOn = Color3.fromRGB(100, 200, 100),
		ToggleOff = Color3.fromRGB(200, 100, 100),
		CloseButton = Color3.fromRGB(200, 50, 50),
		CloseButtonHover = Color3.fromRGB(255, 70, 70)
	}
}

local function createStroke(parent, color, thickness)
	local stroke = Instance.new("UIStroke")
	stroke.Color = color or CONFIG.Colors.Stroke
	stroke.Thickness = thickness or 1
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
	ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
	
	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.BackgroundColor3 = CONFIG.Colors.Background
	MainFrame.BorderSizePixel = 0
	MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	MainFrame.Size = UDim2.new(0, 520, 0, 340)
	MainFrame.Parent = ScreenGui
	MainFrame.ClipsDescendants = true
	createStroke(MainFrame, CONFIG.Colors.Stroke, 1)
	
	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Name = "Title"
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Position = UDim2.new(0, 0, 0, 8)
	TitleLabel.Size = UDim2.new(1, 0, 0, 28)
	TitleLabel.Font = Enum.Font.Code
	TitleLabel.Text = "- " .. hubName .. " -"
	TitleLabel.TextColor3 = CONFIG.Colors.Text
	TitleLabel.TextSize = 16
	TitleLabel.Parent = MainFrame
	
	local MinimizeButton = Instance.new("TextLabel")
	MinimizeButton.Name = "MinimizeButton"
	MinimizeButton.BackgroundTransparency = 1
	MinimizeButton.Position = UDim2.new(1, -50, 0, 8)
	MinimizeButton.Size = UDim2.new(0, 20, 0, 20)
	MinimizeButton.Font = Enum.Font.Code
	MinimizeButton.Text = "-"
	MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	MinimizeButton.TextSize = 16
	MinimizeButton.Parent = MainFrame
	
	local MinimizeDetector = Instance.new("TextButton")
	MinimizeDetector.Name = "MinimizeDetector"
	MinimizeDetector.BackgroundTransparency = 1
	MinimizeDetector.Size = UDim2.new(1, 0, 1, 0)
	MinimizeDetector.Text = ""
	MinimizeDetector.Parent = MinimizeButton
	
	local isMinimized = false
	local originalSize = MainFrame.Size
	
	MinimizeDetector.MouseEnter:Connect(function()
		createTween(MinimizeButton, {TextColor3 = Color3.fromRGB(100, 200, 100)}, 0.2):Play()
	end)
	
	MinimizeDetector.MouseLeave:Connect(function()
		createTween(MinimizeButton, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.2):Play()
	end)
	
	MinimizeDetector.MouseButton1Click:Connect(function()
		isMinimized = not isMinimized
		
		if isMinimized then
			MainFrame.Size = UDim2.new(0, 520, 0, 40)
			MinimizeButton.Text = "+"
			TabContainer.Visible = false
			LeftSeparator.Visible = false
			RightSeparator.Visible = false
			ContentContainer.Visible = false
		else
			MainFrame.Size = originalSize
			MinimizeButton.Text = "-"
			TabContainer.Visible = true
			LeftSeparator.Visible = true
			RightSeparator.Visible = true
			ContentContainer.Visible = true
		end
	end)
	
	local CloseButton = Instance.new("TextLabel")
	CloseButton.Name = "CloseButton"
	CloseButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	CloseButton.BackgroundTransparency = 1
	CloseButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	CloseButton.BorderSizePixel = 0
	CloseButton.Position = UDim2.new(1, -28, 0, 8)
	CloseButton.Size = UDim2.new(0, 20, 0, 20)
	CloseButton.Font = Enum.Font.Code
	CloseButton.Text = "x"
	CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	CloseButton.TextSize = 16
	CloseButton.Parent = MainFrame
	
	local CloseDetector = Instance.new("TextButton")
	CloseDetector.Name = "CloseDetector"
	CloseDetector.BackgroundTransparency = 1
	CloseDetector.Size = UDim2.new(1, 0, 1, 0)
	CloseDetector.Text = ""
	CloseDetector.Parent = CloseButton
	
	CloseDetector.MouseEnter:Connect(function()
		createTween(CloseButton, {TextColor3 = Color3.fromRGB(200, 100, 100)}, 0.2):Play()
	end)
	
	CloseDetector.MouseLeave:Connect(function()
		createTween(CloseButton, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.2):Play()
	end)
	
	CloseDetector.MouseButton1Click:Connect(function()
		ScreenGui:Destroy()
	end)
	
	local TabContainer = Instance.new("Frame")
	TabContainer.Name = "TabContainer"
	TabContainer.BackgroundTransparency = 1
	TabContainer.Position = UDim2.new(0, 12, 0, 45)
	TabContainer.Size = UDim2.new(0, 80, 1, -60)
	TabContainer.Parent = MainFrame
	
	local TabLayout = Instance.new("UIListLayout")
	TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
	TabLayout.Padding = UDim.new(0, 8)
	TabLayout.Parent = TabContainer
	
	local LeftSeparator = Instance.new("Frame")
	LeftSeparator.BackgroundColor3 = CONFIG.Colors.Separator
	LeftSeparator.BorderSizePixel = 0
	LeftSeparator.Position = UDim2.new(0, 100, 0, 40)
	LeftSeparator.Size = UDim2.new(0, 1, 1, -45)
	LeftSeparator.Parent = MainFrame
	
	local RightSeparator = Instance.new("Frame")
	RightSeparator.BackgroundColor3 = CONFIG.Colors.Separator
	RightSeparator.BorderSizePixel = 0
	RightSeparator.Position = UDim2.new(0, 100, 0, 40)
	RightSeparator.Size = UDim2.new(0, 1, 1, -45)
	RightSeparator.Parent = MainFrame
	
	local ContentContainer = Instance.new("Frame")
	ContentContainer.Name = "ContentContainer"
	ContentContainer.BackgroundTransparency = 1
	ContentContainer.Position = UDim2.new(0, 110, 0, 45)
	ContentContainer.Size = UDim2.new(1, -120, 1, -55)
	ContentContainer.Parent = MainFrame
	
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

function Library:CreateTab(tabName)
	local Tab = {}
	Tab.Elements = {}
	
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
	
	TabButton.MouseButton1Click:Connect(function()
		for _, tab in pairs(self.Tabs) do
			tab.Button.TextColor3 = CONFIG.Colors.TabInactive
			tab.Content.Visible = false
		end
		
		TabButton.TextColor3 = CONFIG.Colors.TabActive
		TabContent.Visible = true
		self.CurrentTab = Tab
	end)
	
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

function Library:AddButton(text, callback)
	local ButtonFrame = Instance.new("Frame")
	ButtonFrame.Name = "ButtonElement"
	ButtonFrame.BackgroundColor3 = CONFIG.Colors.ElementBg
	ButtonFrame.BorderSizePixel = 0
	ButtonFrame.Size = UDim2.new(1, -5, 0, 36)
	ButtonFrame.Parent = self.Content
	createStroke(ButtonFrame, CONFIG.Colors.Stroke, 1)
	
	local ButtonLabel = Instance.new("TextLabel")
	ButtonLabel.Name = "Label"
	ButtonLabel.BackgroundTransparency = 1
	ButtonLabel.Position = UDim2.new(0, 10, 0, 0)
	ButtonLabel.Size = UDim2.new(1, -20, 1, 0)
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
	
	ClickDetector.MouseEnter:Connect(function()
		createTween(ButtonFrame, {BackgroundColor3 = CONFIG.Colors.ElementBgHover}, 0.2):Play()
	end)
	
	ClickDetector.MouseLeave:Connect(function()
		createTween(ButtonFrame, {BackgroundColor3 = CONFIG.Colors.ElementBg}, 0.2):Play()
	end)
	
	ClickDetector.MouseButton1Click:Connect(function()
		createTween(ButtonFrame, {Size = UDim2.new(1, -8, 0, 34)}, 0.1):Play()
		wait(0.1)
		createTween(ButtonFrame, {Size = UDim2.new(1, -5, 0, 36)}, 0.1):Play()
		pcall(callback)
	end)
	
	table.insert(self.Elements, ButtonFrame)
	return ButtonFrame
end

function Library:AddToggle(text, default, callback)
	local toggled = default or false
	
	local ToggleFrame = Instance.new("Frame")
	ToggleFrame.Size = UDim2.new(1, -5, 0, 36)
	ToggleFrame.BackgroundColor3 = CONFIG.Colors.ElementBg
	ToggleFrame.BorderSizePixel = 0
	ToggleFrame.Parent = self.Content
	createStroke(ToggleFrame, CONFIG.Colors.Stroke, 1)
	
	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(1, -60, 1, 0)
	Label.Position = UDim2.new(0, 10, 0, 0)
	Label.BackgroundTransparency = 1
	Label.Font = Enum.Font.Code
	Label.Text = text
	Label.TextColor3 = CONFIG.Colors.Text
	Label.TextSize = 14
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = ToggleFrame
	
	local ToggleButton = Instance.new("TextButton")
	ToggleButton.Size = UDim2.new(0, 40, 0, 20)
	ToggleButton.Position = UDim2.new(1, -48, 0.5, -10)
	ToggleButton.BackgroundColor3 = toggled and CONFIG.Colors.ToggleOn or CONFIG.Colors.ToggleOff
	ToggleButton.BorderSizePixel = 0
	ToggleButton.Text = ""
	ToggleButton.Parent = ToggleFrame
	createStroke(ToggleButton, CONFIG.Colors.Stroke, 1)
	
	ToggleButton.MouseEnter:Connect(function()
		createTween(ToggleFrame, {BackgroundColor3 = CONFIG.Colors.ElementBgHover}, 0.2):Play()
	end)
	
	ToggleButton.MouseLeave:Connect(function()
		createTween(ToggleFrame, {BackgroundColor3 = CONFIG.Colors.ElementBg}, 0.2):Play()
	end)
	
	ToggleButton.MouseButton1Click:Connect(function()
		toggled = not toggled
		createTween(ToggleButton, {
			BackgroundColor3 = toggled and CONFIG.Colors.ToggleOn or CONFIG.Colors.ToggleOff
		}, 0.2):Play()
		pcall(callback, toggled)
	end)
	
	table.insert(self.Elements, ToggleFrame)
	return {
		Frame = ToggleFrame,
		SetValue = function(value)
			toggled = value
			createTween(ToggleButton, {
				BackgroundColor3 = toggled and CONFIG.Colors.ToggleOn or CONFIG.Colors.ToggleOff
			}, 0.2):Play()
		end,
		GetValue = function()
			return toggled
		end
	}
end

function Library:AddLabel(text)
	local LabelFrame = Instance.new("Frame")
	LabelFrame.Size = UDim2.new(1, -5, 0, 25)
	LabelFrame.BackgroundTransparency = 1
	LabelFrame.Parent = self.Content
	
	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(1, -10, 1, 0)
	Label.Position = UDim2.new(0, 5, 0, 0)
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

function Library:AddSlider(text, min, max, default, callback)
	local value = default or min
	
	local SliderFrame = Instance.new("Frame")
	SliderFrame.Size = UDim2.new(1, -5, 0, 52)
	SliderFrame.BackgroundColor3 = CONFIG.Colors.ElementBg
	SliderFrame.BorderSizePixel = 0
	SliderFrame.Parent = self.Content
	createStroke(SliderFrame, CONFIG.Colors.Stroke, 1)
	
	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(1, -70, 0, 22)
	Label.Position = UDim2.new(0, 10, 0, 5)
	Label.BackgroundTransparency = 1
	Label.Font = Enum.Font.Code
	Label.Text = text
	Label.TextColor3 = CONFIG.Colors.Text
	Label.TextSize = 14
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = SliderFrame
	
	local ValueLabel = Instance.new("TextLabel")
	ValueLabel.Size = UDim2.new(0, 50, 0, 22)
	ValueLabel.Position = UDim2.new(1, -60, 0, 5)
	ValueLabel.BackgroundTransparency = 1
	ValueLabel.Font = Enum.Font.Code
	ValueLabel.Text = tostring(value)
	ValueLabel.TextColor3 = CONFIG.Colors.Text
	ValueLabel.TextSize = 14
	ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
	ValueLabel.Parent = SliderFrame
	
	local SliderBar = Instance.new("Frame")
	SliderBar.Size = UDim2.new(1, -20, 0, 6)
	SliderBar.Position = UDim2.new(0, 10, 1, -16)
	SliderBar.BackgroundColor3 = CONFIG.Colors.Separator
	SliderBar.BorderSizePixel = 0
	SliderBar.Parent = SliderFrame
	createStroke(SliderBar, CONFIG.Colors.Stroke, 1)
	
	local SliderFill = Instance.new("Frame")
	SliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
	SliderFill.BackgroundColor3 = CONFIG.Colors.TabActive
	SliderFill.BorderSizePixel = 0
	SliderFill.Parent = SliderBar
	
	local SliderButton = Instance.new("TextButton")
	SliderButton.Size = UDim2.new(1, 0, 1, 0)
	SliderButton.BackgroundTransparency = 1
	SliderButton.Text = ""
	SliderButton.Parent = SliderBar
	
	local dragging = false
	
	SliderButton.MouseButton1Down:Connect(function()
		dragging = true
	end)
	
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
	
	SliderButton.MouseMoved:Connect(function(x)
		if dragging then
			local percentage = math.clamp((x - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
			value = math.floor(min + (max - min) * percentage)
			
			createTween(SliderFill, {Size = UDim2.new(percentage, 0, 1, 0)}, 0.1):Play()
			ValueLabel.Text = tostring(value)
			pcall(callback, value)
		end
	end)
	
	SliderFrame.MouseEnter:Connect(function()
		createTween(SliderFrame, {BackgroundColor3 = CONFIG.Colors.ElementBgHover}, 0.2):Play()
	end)
	
	SliderFrame.MouseLeave:Connect(function()
		createTween(SliderFrame, {BackgroundColor3 = CONFIG.Colors.ElementBg}, 0.2):Play()
	end)
	
	table.insert(self.Elements, SliderFrame)
	
	return {
		Frame = SliderFrame,
		SetValue = function(newValue)
			value = math.clamp(newValue, min, max)
			local percentage = (value - min) / (max - min)
			createTween(SliderFill, {Size = UDim2.new(percentage, 0, 1, 0)}, 0.2):Play()
			ValueLabel.Text = tostring(value)
		end,
		GetValue = function()
			return value
		end
	}
end

function Library:AddDropdown(text, options, default, callback)
	local selected = default or options[1]
	local isOpen = false
	
	local DropdownFrame = Instance.new("Frame")
	DropdownFrame.Size = UDim2.new(1, -5, 0, 36)
	DropdownFrame.BackgroundColor3 = CONFIG.Colors.ElementBg
	DropdownFrame.BorderSizePixel = 0
	DropdownFrame.Parent = self.Content
	DropdownFrame.ClipsDescendants = true
	createStroke(DropdownFrame, CONFIG.Colors.Stroke, 1)
	
	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(0.45, 0, 0, 36)
	Label.Position = UDim2.new(0, 10, 0, 0)
	Label.BackgroundTransparency = 1
	Label.Font = Enum.Font.Code
	Label.Text = text
	Label.TextColor3 = CONFIG.Colors.Text
	Label.TextSize = 14
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = DropdownFrame
	
	local SelectedLabel = Instance.new("TextLabel")
	SelectedLabel.Size = UDim2.new(0.45, 0, 0, 36)
	SelectedLabel.Position = UDim2.new(0.5, 0, 0, 0)
	SelectedLabel.BackgroundTransparency = 1
	SelectedLabel.Font = Enum.Font.Code
	SelectedLabel.Text = selected
	SelectedLabel.TextColor3 = CONFIG.Colors.TabActive
	SelectedLabel.TextSize = 13
	SelectedLabel.TextXAlignment = Enum.TextXAlignment.Right
	SelectedLabel.Parent = DropdownFrame
	
	local Arrow = Instance.new("TextLabel")
	Arrow.Size = UDim2.new(0, 20, 0, 36)
	Arrow.Position = UDim2.new(1, -25, 0, 0)
	Arrow.BackgroundTransparency = 1
	Arrow.Font = Enum.Font.Code
	Arrow.Text = "v"
	Arrow.TextColor3 = CONFIG.Colors.Text
	Arrow.TextSize = 14
	Arrow.Parent = DropdownFrame
	
	local OptionsContainer = Instance.new("Frame")
	OptionsContainer.Size = UDim2.new(1, 0, 0, 0)
	OptionsContainer.Position = UDim2.new(0, 0, 0, 36)
	OptionsContainer.BackgroundTransparency = 1
	OptionsContainer.Parent = DropdownFrame
	
	local OptionsLayout = Instance.new("UIListLayout")
	OptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
	OptionsLayout.Parent = OptionsContainer
	
	local ClickDetector = Instance.new("TextButton")
	ClickDetector.Size = UDim2.new(1, 0, 0, 36)
	ClickDetector.BackgroundTransparency = 1
	ClickDetector.Text = ""
	ClickDetector.Parent = DropdownFrame
	
	ClickDetector.MouseEnter:Connect(function()
		createTween(DropdownFrame, {BackgroundColor3 = CONFIG.Colors.ElementBgHover}, 0.2):Play()
	end)
	
	ClickDetector.MouseLeave:Connect(function()
		if not isOpen then
			createTween(DropdownFrame, {BackgroundColor3 = CONFIG.Colors.ElementBg}, 0.2):Play()
		end
	end)
	
	for i, option in ipairs(options) do
		local OptionButton = Instance.new("TextButton")
		OptionButton.Size = UDim2.new(1, 0, 0, 28)
		OptionButton.BackgroundColor3 = CONFIG.Colors.ElementBg
		OptionButton.BorderSizePixel = 0
		OptionButton.Font = Enum.Font.Code
		OptionButton.Text = option
		OptionButton.TextColor3 = CONFIG.Colors.Text
		OptionButton.TextSize = 13
		OptionButton.TextXAlignment = Enum.TextXAlignment.Left
		OptionButton.Parent = OptionsContainer
		createStroke(OptionButton, CONFIG.Colors.Stroke, 1)
		
		local Padding = Instance.new("UIPadding")
		Padding.PaddingLeft = UDim.new(0, 10)
		Padding.Parent = OptionButton
		
		OptionButton.MouseEnter:Connect(function()
			createTween(OptionButton, {BackgroundColor3 = CONFIG.Colors.ElementBgHover}, 0.2):Play()
		end)
		
		OptionButton.MouseLeave:Connect(function()
			createTween(OptionButton, {BackgroundColor3 = CONFIG.Colors.ElementBg}, 0.2):Play()
		end)
		
		OptionButton.MouseButton1Click:Connect(function()
			selected = option
			SelectedLabel.Text = selected
			isOpen = false
			createTween(Arrow, {Rotation = 0}, 0.2):Play()
			createTween(DropdownFrame, {Size = UDim2.new(1, -5, 0, 36)}, 0.3):Play()
			createTween(DropdownFrame, {BackgroundColor3 = CONFIG.Colors.ElementBg}, 0.2):Play()
			pcall(callback, selected)
		end)
	end
	
	ClickDetector.MouseButton1Click:Connect(function()
		isOpen = not isOpen
		
		if isOpen then
			local targetHeight = 36 + (#options * 28)
			createTween(Arrow, {Rotation = 180}, 0.2):Play()
			createTween(DropdownFrame, {Size = UDim2.new(1, -5, 0, targetHeight)}, 0.3):Play()
		else
			createTween(Arrow, {Rotation = 0}, 0.2):Play()
			createTween(DropdownFrame, {Size = UDim2.new(1, -5, 0, 36)}, 0.3):Play()
			createTween(DropdownFrame, {BackgroundColor3 = CONFIG.Colors.ElementBg}, 0.2):Play()
		end
	end)
	
	table.insert(self.Elements, DropdownFrame)
	
	return {
		Frame = DropdownFrame,
		SetValue = function(value)
			selected = value
			SelectedLabel.Text = selected
		end,
		GetValue = function()
			return selected
		end
	}
end

function Library:AddSection(text)
	local SectionFrame = Instance.new("Frame")
	SectionFrame.Size = UDim2.new(1, -10, 0, 30)
	SectionFrame.BackgroundTransparency = 1
	SectionFrame.Parent = self.Content
	
	local SectionLabel = Instance.new("TextLabel")
	SectionLabel.Size = UDim2.new(1, 0, 0, 20)
	SectionLabel.BackgroundTransparency = 1
	SectionLabel.Font = Enum.Font.Code
	SectionLabel.Text = text
	SectionLabel.TextColor3 = CONFIG.Colors.TabActive
	SectionLabel.TextSize = 15
	SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
	SectionLabel.Parent = SectionFrame
	
	local SectionLine = Instance.new("Frame")
	SectionLine.Size = UDim2.new(1, 0, 0, 1)
	SectionLine.Position = UDim2.new(0, 0, 1, -5)
	SectionLine.BackgroundColor3 = CONFIG.Colors.Separator
	SectionLine.BorderSizePixel = 0
	SectionLine.Parent = SectionFrame
	
	table.insert(self.Elements, SectionFrame)
	return SectionFrame
end

function Library:Notify(title, text, duration)
	duration = duration or 3
	
	local NotificationGui = Instance.new("ScreenGui")
	NotificationGui.Name = "Notification"
	NotificationGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	NotificationGui.ResetOnSpawn = false
	NotificationGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
	
	local NotificationFrame = Instance.new("Frame")
	NotificationFrame.Size = UDim2.new(0, 300, 0, 80)
	NotificationFrame.Position = UDim2.new(1, -320, 0, 20)
	NotificationFrame.BackgroundColor3 = CONFIG.Colors.ElementBg
	NotificationFrame.BorderSizePixel = 0
	NotificationFrame.Parent = NotificationGui
	createStroke(NotificationFrame, CONFIG.Colors.Stroke, 1)
	
	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Size = UDim2.new(1, -20, 0, 25)
	TitleLabel.Position = UDim2.new(0, 10, 0, 5)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Font = Enum.Font.Code
	TitleLabel.Text = title
	TitleLabel.TextColor3 = CONFIG.Colors.TabActive
	TitleLabel.TextSize = 15
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.Parent = NotificationFrame
	
	local TextLabel = Instance.new("TextLabel")
	TextLabel.Size = UDim2.new(1, -20, 0, 40)
	TextLabel.Position = UDim2.new(0, 10, 0, 30)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Font = Enum.Font.Code
	TextLabel.Text = text
	TextLabel.TextColor3 = CONFIG.Colors.Text
	TextLabel.TextSize = 13
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel.TextWrapped = true
	TextLabel.Parent = NotificationFrame
	
	NotificationFrame.Position = UDim2.new(1, 0, 0, 20)
	createTween(NotificationFrame, {Position = UDim2.new(1, -320, 0, 20)}, 0.5):Play()
	
	wait(duration)
	
	createTween(NotificationFrame, {Position = UDim2.new(1, 0, 0, 20)}, 0.5):Play()
	wait(0.5)
	NotificationGui:Destroy()
end

function Library:AddKeybind(text, defaultKey, callback)
	local currentKey = defaultKey or Enum.KeyCode.E
	local waitingForKey = false
	
	local KeybindFrame = Instance.new("Frame")
	KeybindFrame.Size = UDim2.new(1, -10, 0, 34)
	KeybindFrame.BackgroundColor3 = CONFIG.Colors.ElementBg
	KeybindFrame.BorderSizePixel = 0
	KeybindFrame.Parent = self.Content or self.ContentContainer
	createStroke(KeybindFrame, CONFIG.Colors.Stroke, 1)
	
	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(0.65, 0, 1, 0)
	Label.Position = UDim2.new(0.0226, 0, 0, 0)
	Label.BackgroundTransparency = 1
	Label.Font = Enum.Font.Code
	Label.Text = text
	Label.TextColor3 = CONFIG.Colors.Text
	Label.TextSize = 14
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = KeybindFrame
	
	local KeyButton = Instance.new("TextButton")
	KeyButton.Size = UDim2.new(0, 60, 0, 24)
	KeyButton.Position = UDim2.new(0.88, -40, 0.5, -12)
	KeyButton.BackgroundColor3 = CONFIG.Colors.Separator
	KeyButton.BorderSizePixel = 0
	KeyButton.Font = Enum.Font.Code
	KeyButton.Text = currentKey.Name
	KeyButton.TextColor3 = CONFIG.Colors.Text
	KeyButton.TextSize = 13
	KeyButton.Parent = KeybindFrame
	createStroke(KeyButton, CONFIG.Colors.Stroke, 1)
	
	KeyButton.MouseEnter:Connect(function()
		createTween(KeybindFrame, {BackgroundColor3 = CONFIG.Colors.ElementBgHover}, 0.2):Play()
	end)
	
	KeyButton.MouseLeave:Connect(function()
		createTween(KeybindFrame, {BackgroundColor3 = CONFIG.Colors.ElementBg}, 0.2):Play()
	end)
	
	KeyButton.MouseButton1Click:Connect(function()
		waitingForKey = true
		KeyButton.Text = "..."
	end)
	
	UserInputService.InputBegan:Connect(function(input)
		if waitingForKey and input.UserInputType == Enum.UserInputType.Keyboard then
			currentKey = input.KeyCode
			KeyButton.Text = currentKey.Name
			waitingForKey = false
		end
		
		if input.KeyCode == currentKey and not waitingForKey then
			pcall(callback)
		end
	end)
	
	table.insert(self.Elements, KeybindFrame)
	
	return {
		Frame = KeybindFrame,
		SetKey = function(newKey)
			currentKey = newKey
			KeyButton.Text = currentKey.Name
		end,
		GetKey = function()
			return currentKey
		end
	}
end

function Library:AddColorPicker(text, defaultColor, callback)
	local selectedColor = defaultColor or Color3.fromRGB(255, 255, 255)
	local isOpen = false
	
	local ColorFrame = Instance.new("Frame")
	ColorFrame.Size = UDim2.new(1, -10, 0, 34)
	ColorFrame.BackgroundColor3 = CONFIG.Colors.ElementBg
	ColorFrame.BorderSizePixel = 0
	ColorFrame.Parent = self.Content or self.ContentContainer
	ColorFrame.ClipsDescendants = true
	createStroke(ColorFrame, CONFIG.Colors.Stroke, 1)
	
	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(0.7, 0, 0, 34)
	Label.Position = UDim2.new(0.0226, 0, 0, 0)
	Label.BackgroundTransparency = 1
	Label.Font = Enum.Font.Code
	Label.Text = text
	Label.TextColor3 = CONFIG.Colors.Text
	Label.TextSize = 14
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = ColorFrame
	
	local ColorDisplay = Instance.new("Frame")
	ColorDisplay.Size = UDim2.new(0, 40, 0, 20)
	ColorDisplay.Position = UDim2.new(0.88, 0, 0.5, -10)
	ColorDisplay.BackgroundColor3 = selectedColor
	ColorDisplay.BorderSizePixel = 0
	ColorDisplay.Parent = ColorFrame
	createStroke(ColorDisplay, CONFIG.Colors.Stroke, 1)
	
	local ColorButton = Instance.new("TextButton")
	ColorButton.Size = UDim2.new(1, 0, 0, 34)
	ColorButton.BackgroundTransparency = 1
	ColorButton.Text = ""
	ColorButton.Parent = ColorFrame
	
	local ColorPicker = Instance.new("Frame")
	ColorPicker.Size = UDim2.new(1, 0, 0, 120)
	ColorPicker.Position = UDim2.new(0, 0, 0, 34)
	ColorPicker.BackgroundColor3 = CONFIG.Colors.ElementBgHover
	ColorPicker.BorderSizePixel = 0
	ColorPicker.Parent = ColorFrame
	
	local ColorLayout = Instance.new("UIGridLayout")
	ColorLayout.CellSize = UDim2.new(0, 30, 0, 30)
	ColorLayout.CellPadding = UDim2.new(0, 5, 0, 5)
	ColorLayout.SortOrder = Enum.SortOrder.LayoutOrder
	ColorLayout.Parent = ColorPicker
	
	local ColorPadding = Instance.new("UIPadding")
	ColorPadding.PaddingLeft = UDim.new(0, 10)
	ColorPadding.PaddingTop = UDim.new(0, 10)
	ColorPadding.Parent = ColorPicker
	
	local colors = {
		Color3.fromRGB(255, 0, 0), Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 0, 255),
		Color3.fromRGB(255, 255, 0), Color3.fromRGB(255, 0, 255), Color3.fromRGB(0, 255, 255),
		Color3.fromRGB(255, 128, 0), Color3.fromRGB(128, 0, 255), Color3.fromRGB(255, 255, 255),
		Color3.fromRGB(0, 0, 0), Color3.fromRGB(128, 128, 128), Color3.fromRGB(100, 100, 255)
	}
	
	for i, color in ipairs(colors) do
		local ColorBox = Instance.new("TextButton")
		ColorBox.Size = UDim2.new(0, 30, 0, 30)
		ColorBox.BackgroundColor3 = color
		ColorBox.BorderSizePixel = 0
		ColorBox.Text = ""
		ColorBox.Parent = ColorPicker
		createStroke(ColorBox, CONFIG.Colors.Stroke, 1)
		
		ColorBox.MouseButton1Click:Connect(function()
			selectedColor = color
			ColorDisplay.BackgroundColor3 = selectedColor
			isOpen = false
			ColorFrame.Size = UDim2.new(1, -10, 0, 34)
			pcall(callback, selectedColor)
		end)
		
		ColorBox.MouseEnter:Connect(function()
			createTween(ColorBox, {Size = UDim2.new(0, 35, 0, 35)}, 0.1):Play()
		end)
		
		ColorBox.MouseLeave:Connect(function()
			createTween(ColorBox, {Size = UDim2.new(0, 30, 0, 30)}, 0.1):Play()
		end)
	end
	
	ColorButton.MouseEnter:Connect(function()
		createTween(ColorFrame, {BackgroundColor3 = CONFIG.Colors.ElementBgHover}, 0.2):Play()
	end)
	
	ColorButton.MouseLeave:Connect(function()
		if not isOpen then
			createTween(ColorFrame, {BackgroundColor3 = CONFIG.Colors.ElementBg}, 0.2):Play()
		end
	end)
	
	ColorButton.MouseButton1Click:Connect(function()
		isOpen = not isOpen
		
		if isOpen then
			ColorFrame.Size = UDim2.new(1, -10, 0, 154)
		else
			ColorFrame.Size = UDim2.new(1, -10, 0, 34)
			createTween(ColorFrame, {BackgroundColor3 = CONFIG.Colors.ElementBg}, 0.2):Play()
		end
	end)
	
	table.insert(self.Elements, ColorFrame)
	
	return {
		Frame = ColorFrame,
		SetColor = function(color)
			selectedColor = color
			ColorDisplay.BackgroundColor3 = selectedColor
		end,
		GetColor = function()
			return selectedColor
		end
	}
end

function Library:AddCheckbox(text, default, callback)
	local checked = default or false
	
	local CheckboxFrame = Instance.new("Frame")
	CheckboxFrame.Size = UDim2.new(1, -10, 0, 34)
	CheckboxFrame.BackgroundColor3 = CONFIG.Colors.ElementBg
	CheckboxFrame.BorderSizePixel = 0
	CheckboxFrame.Parent = self.Content or self.ContentContainer
	createStroke(CheckboxFrame, CONFIG.Colors.Stroke, 1)
	
	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(0.75, 0, 1, 0)
	Label.BackgroundTransparency = 1
	Label.Font = Enum.Font.Code
	Label.Text = text
	Label.TextColor3 = CONFIG.Colors.Text
	Label.TextSize = 14
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Position = UDim2.new(0.0226, 0, 0, 0)
	Label.Parent = CheckboxFrame
	
	local CheckboxBox = Instance.new("Frame")
	CheckboxBox.Size = UDim2.new(0, 20, 0, 20)
	CheckboxBox.Position = UDim2.new(0.88, 0, 0.5, -10)
	CheckboxBox.BackgroundColor3 = CONFIG.Colors.ElementBg
	CheckboxBox.BorderSizePixel = 0
	CheckboxBox.Parent = CheckboxFrame
	createStroke(CheckboxBox, CONFIG.Colors.Stroke, 1)
	
	local CheckMark = Instance.new("TextLabel")
	CheckMark.Size = UDim2.new(1, 0, 1, 0)
	CheckMark.BackgroundTransparency = 1
	CheckMark.Font = Enum.Font.Code
	CheckMark.Text = checked and "✓" or ""
	CheckMark.TextColor3 = CONFIG.Colors.ToggleOn
	CheckMark.TextSize = 18
	CheckMark.Parent = CheckboxBox
	
	local ClickDetector = Instance.new("TextButton")
	ClickDetector.Size = UDim2.new(1, 0, 1, 0)
	ClickDetector.BackgroundTransparency = 1
	ClickDetector.Text = ""
	ClickDetector.Parent = CheckboxFrame
	
	ClickDetector.MouseEnter:Connect(function()
		createTween(CheckboxFrame, {BackgroundColor3 = CONFIG.Colors.ElementBgHover}, 0.2):Play()
	end)
	
	ClickDetector.MouseLeave:Connect(function()
		createTween(CheckboxFrame, {BackgroundColor3 = CONFIG.Colors.ElementBg}, 0.2):Play()
	end)
	
	ClickDetector.MouseButton1Click:Connect(function()
		checked = not checked
		CheckMark.Text = checked and "✓" or ""
		createTween(CheckMark, {TextColor3 = checked and CONFIG.Colors.ToggleOn or CONFIG.Colors.ToggleOff}, 0.2):Play()
		pcall(callback, checked)
	end)
	
	table.insert(self.Elements, CheckboxFrame)
	
	return {
		Frame = CheckboxFrame,
		SetValue = function(value)
			checked = value
			CheckMark.Text = checked and "✓" or ""
			CheckMark.TextColor3 = checked and CONFIG.Colors.ToggleOn or CONFIG.Colors.ToggleOff
		end,
		GetValue = function()
			return checked
		end
	}
end

function Library:AddRadioButtons(text, options, default, callback)
	local selected = default or options[1]
	
	local RadioFrame = Instance.new("Frame")
	RadioFrame.Size = UDim2.new(1, -10, 0, 34 + (#options * 30))
	RadioFrame.BackgroundColor3 = CONFIG.Colors.ElementBg
	RadioFrame.BorderSizePixel = 0
	RadioFrame.Parent = self.Content or self.ContentContainer
	createStroke(RadioFrame, CONFIG.Colors.Stroke, 1)
	
	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(1, -10, 0, 28)
	Label.Position = UDim2.new(0.0226, 0, 0, 3)
	Label.BackgroundTransparency = 1
	Label.Font = Enum.Font.Code
	Label.Text = text
	Label.TextColor3 = CONFIG.Colors.Text
	Label.TextSize = 14
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = RadioFrame
	
	local OptionsContainer = Instance.new("Frame")
	OptionsContainer.Size = UDim2.new(1, 0, 0, #options * 30)
	OptionsContainer.Position = UDim2.new(0, 0, 0, 34)
	OptionsContainer.BackgroundTransparency = 1
	OptionsContainer.Parent = RadioFrame
	
	local radioButtons = {}
	
	for i, option in ipairs(options) do
		local OptionFrame = Instance.new("Frame")
		OptionFrame.Size = UDim2.new(1, 0, 0, 28)
		OptionFrame.Position = UDim2.new(0, 0, 0, (i - 1) * 30)
		OptionFrame.BackgroundTransparency = 1
		OptionFrame.Parent = OptionsContainer
		
		local RadioCircle = Instance.new("Frame")
		RadioCircle.Size = UDim2.new(0, 18, 0, 18)
		RadioCircle.Position = UDim2.new(0.05, 0, 0.5, -9)
		RadioCircle.BackgroundColor3 = CONFIG.Colors.ElementBg
		RadioCircle.BorderSizePixel = 0
		RadioCircle.Parent = OptionFrame
		createStroke(RadioCircle, CONFIG.Colors.Stroke, 1)
		
		local RadioDot = Instance.new("Frame")
		RadioDot.Size = UDim2.new(0, 10, 0, 10)
		RadioDot.Position = UDim2.new(0.5, -5, 0.5, -5)
		RadioDot.BackgroundColor3 = option == selected and CONFIG.Colors.ToggleOn or CONFIG.Colors.ElementBg
		RadioDot.BorderSizePixel = 0
		RadioDot.Parent = RadioCircle
		
		local OptionLabel = Instance.new("TextLabel")
		OptionLabel.Size = UDim2.new(0.8, 0, 1, 0)
		OptionLabel.Position = UDim2.new(0.15, 0, 0, 0)
		OptionLabel.BackgroundTransparency = 1
		OptionLabel.Font = Enum.Font.Code
		OptionLabel.Text = option
		OptionLabel.TextColor3 = CONFIG.Colors.Text
		OptionLabel.TextSize = 13
		OptionLabel.TextXAlignment = Enum.TextXAlignment.Left
		OptionLabel.Parent = OptionFrame
		
		local OptionButton = Instance.new("TextButton")
		OptionButton.Size = UDim2.new(1, 0, 1, 0)
		OptionButton.BackgroundTransparency = 1
		OptionButton.Text = ""
		OptionButton.Parent = OptionFrame
		
		OptionButton.MouseEnter:Connect(function()
			createTween(OptionFrame, {BackgroundColor3 = CONFIG.Colors.ElementBgHover}, 0.2):Play()
		end)
		
		OptionButton.MouseLeave:Connect(function()
			createTween(OptionFrame, {BackgroundTransparency = 1}, 0.2):Play()
		end)
		
		OptionButton.MouseButton1Click:Connect(function()
			selected = option
			
			for _, btn in pairs(radioButtons) do
				createTween(btn.Dot, {BackgroundColor3 = CONFIG.Colors.ElementBg}, 0.2):Play()
			end
			
			createTween(RadioDot, {BackgroundColor3 = CONFIG.Colors.ToggleOn}, 0.2):Play()
			pcall(callback, selected)
		end)
		
		table.insert(radioButtons, {Dot = RadioDot, Option = option})
	end
	
	table.insert(self.Elements, RadioFrame)
	
	return {
		Frame = RadioFrame,
		SetValue = function(value)
			selected = value
			for _, btn in pairs(radioButtons) do
				btn.Dot.BackgroundColor3 = btn.Option == selected and CONFIG.Colors.ToggleOn or CONFIG.Colors.ElementBg
			end
		end,
		GetValue = function()
			return selected
		end
	}
end

return Library
