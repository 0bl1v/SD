local Library = {}
Library.__index = Library

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local CONFIG = {
	AnimationSpeed = 0.25,
	Colors = {
		Background = Color3.fromRGB(15, 15, 15),
		TopBar = Color3.fromRGB(20, 20, 20),
		ElementBg = Color3.fromRGB(25, 25, 25),
		ElementBgHover = Color3.fromRGB(35, 35, 35),
		Separator = Color3.fromRGB(45, 45, 45),
		Stroke = Color3.fromRGB(40, 40, 40),
		Text = Color3.fromRGB(240, 240, 240),
		TextDim = Color3.fromRGB(180, 180, 180),
		TabActive = Color3.fromRGB(120, 120, 255),
		TabInactive = Color3.fromRGB(160, 160, 160),
		ToggleOn = Color3.fromRGB(100, 220, 100),
		ToggleOff = Color3.fromRGB(220, 100, 100),
		CloseButton = Color3.fromRGB(220, 60, 60),
		CloseButtonHover = Color3.fromRGB(255, 80, 80)
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
		TweenInfo.new(duration or CONFIG.AnimationSpeed, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
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
	MainFrame.Position = UDim2.new(0.2, 0, 0.15, 0)
	MainFrame.Size = UDim2.new(0, 680, 0, 480)
	MainFrame.Parent = ScreenGui
	MainFrame.ClipsDescendants = true
	createStroke(MainFrame, CONFIG.Colors.Stroke, 2)
	
	local TopBar = Instance.new("Frame")
	TopBar.Name = "TopBar"
	TopBar.BackgroundColor3 = CONFIG.Colors.TopBar
	TopBar.BorderSizePixel = 0
	TopBar.Size = UDim2.new(1, 0, 0, 40)
	TopBar.Parent = MainFrame
	
	local TopBarLine = Instance.new("Frame")
	TopBarLine.BackgroundColor3 = CONFIG.Colors.Separator
	TopBarLine.BorderSizePixel = 0
	TopBarLine.Position = UDim2.new(0, 0, 1, -1)
	TopBarLine.Size = UDim2.new(1, 0, 0, 1)
	TopBarLine.Parent = TopBar
	
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
	
	local CloseButton = Instance.new("TextButton")
	CloseButton.Name = "CloseButton"
	CloseButton.BackgroundColor3 = CONFIG.Colors.CloseButton
	CloseButton.BorderSizePixel = 0
	CloseButton.Position = UDim2.new(1, -32, 0.5, -12)
	CloseButton.Size = UDim2.new(0, 24, 0, 24)
	CloseButton.Font = Enum.Font.GothamBold
	CloseButton.Text = "×"
	CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	CloseButton.TextSize = 18
	CloseButton.Parent = TopBar
	
	CloseButton.MouseEnter:Connect(function()
		createTween(CloseButton, {BackgroundColor3 = CONFIG.Colors.CloseButtonHover}, 0.2):Play()
	end)
	
	CloseButton.MouseLeave:Connect(function()
		createTween(CloseButton, {BackgroundColor3 = CONFIG.Colors.CloseButton}, 0.2):Play()
	end)
	
	CloseButton.MouseButton1Click:Connect(function()
		createTween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3):Play()
		wait(0.3)
		ScreenGui:Destroy()
	end)
	
	local TabContainer = Instance.new("Frame")
	TabContainer.Name = "TabContainer"
	TabContainer.BackgroundTransparency = 1
	TabContainer.Position = UDim2.new(0, 15, 0, 55)
	TabContainer.Size = UDim2.new(0, 140, 1, -70)
	TabContainer.Parent = MainFrame
	
	local TabLayout = Instance.new("UIListLayout")
	TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
	TabLayout.Padding = UDim.new(0, 6)
	TabLayout.Parent = TabContainer
	
	local VerticalSeparator = Instance.new("Frame")
	VerticalSeparator.BackgroundColor3 = CONFIG.Colors.Separator
	VerticalSeparator.BorderSizePixel = 0
	VerticalSeparator.Position = UDim2.new(0, 165, 0, 45)
	VerticalSeparator.Size = UDim2.new(0, 1, 1, -50)
	VerticalSeparator.Parent = MainFrame
	
	local ContentContainer = Instance.new("ScrollingFrame")
	ContentContainer.Name = "ContentContainer"
	ContentContainer.BackgroundTransparency = 1
	ContentContainer.Position = UDim2.new(0, 180, 0, 55)
	ContentContainer.Size = UDim2.new(1, -195, 1, -70)
	ContentContainer.ScrollBarThickness = 6
	ContentContainer.ScrollBarImageColor3 = CONFIG.Colors.Separator
	ContentContainer.BorderSizePixel = 0
	ContentContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
	ContentContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
	ContentContainer.Parent = MainFrame
	
	local dragging, dragInput, dragStart, startPos
	
	TopBar.InputBegan:Connect(function(input)
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
	TabButton.BackgroundColor3 = CONFIG.Colors.ElementBg
	TabButton.BorderSizePixel = 0
	TabButton.Size = UDim2.new(1, 0, 0, 32)
	TabButton.Font = Enum.Font.GothamSemibold
	TabButton.Text = tabName
	TabButton.TextColor3 = CONFIG.Colors.TabInactive
	TabButton.TextSize = 14
	TabButton.TextXAlignment = Enum.TextXAlignment.Left
	TabButton.Parent = self.TabContainer
	createStroke(TabButton, CONFIG.Colors.Stroke, 1)
	
	local TabPadding = Instance.new("UIPadding")
	TabPadding.PaddingLeft = UDim.new(0, 12)
	TabPadding.Parent = TabButton
	
	local TabContent = Instance.new("Frame")
	TabContent.Name = tabName .. "_Content"
	TabContent.BackgroundTransparency = 1
	TabContent.Size = UDim2.new(1, 0, 1, 0)
	TabContent.Visible = false
	TabContent.Parent = self.ContentContainer
	
	local ContentLayout = Instance.new("UIListLayout")
	ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
	ContentLayout.Padding = UDim.new(0, 10)
	ContentLayout.Parent = TabContent
	
	TabButton.MouseEnter:Connect(function()
		if self.CurrentTab ~= Tab then
			createTween(TabButton, {BackgroundColor3 = CONFIG.Colors.ElementBgHover}, 0.2):Play()
		end
	end)
	
	TabButton.MouseLeave:Connect(function()
		if self.CurrentTab ~= Tab then
			createTween(TabButton, {BackgroundColor3 = CONFIG.Colors.ElementBg}, 0.2):Play()
		end
	end)
	
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
	ButtonFrame.Size = UDim2.new(1, 0, 0, 38)
	ButtonFrame.Parent = self.Content
	createStroke(ButtonFrame, CONFIG.Colors.Stroke, 1)
	
	local ButtonLabel = Instance.new("TextLabel")
	ButtonLabel.Name = "Label"
	ButtonLabel.BackgroundTransparency = 1
	ButtonLabel.Size = UDim2.new(1, -20, 1, 0)
	ButtonLabel.Position = UDim2.new(0, 10, 0, 0)
	ButtonLabel.Font = Enum.Font.Gotham
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
		createTween(ButtonFrame, {BackgroundColor3 = CONFIG.Colors.Separator}, 0.1):Play()
		wait(0.1)
		createTween(ButtonFrame, {BackgroundColor3 = CONFIG.Colors.ElementBgHover}, 0.1):Play()
		pcall(callback)
	end)
	
	table.insert(self.Elements, ButtonFrame)
	return ButtonFrame
end

function Library:AddToggle(text, default, callback)
	local toggled = default or false
	
	local ToggleFrame = Instance.new("Frame")
	ToggleFrame.Size = UDim2.new(1, 0, 0, 38)
	ToggleFrame.BackgroundColor3 = CONFIG.Colors.ElementBg
	ToggleFrame.BorderSizePixel = 0
	ToggleFrame.Parent = self.Content
	createStroke(ToggleFrame, CONFIG.Colors.Stroke, 1)
	
	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(1, -60, 1, 0)
	Label.Position = UDim2.new(0, 10, 0, 0)
	Label.BackgroundTransparency = 1
	Label.Font = Enum.Font.Gotham
	Label.Text = text
	Label.TextColor3 = CONFIG.Colors.Text
	Label.TextSize = 14
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = ToggleFrame
	
	local ToggleTrack = Instance.new("Frame")
	ToggleTrack.Name = "ToggleTrack"
	ToggleTrack.Size = UDim2.new(0, 38, 0, 20)
	ToggleTrack.Position = UDim2.new(1, -48, 0.5, -10)
	ToggleTrack.BackgroundColor3 = toggled and CONFIG.Colors.ToggleOn or CONFIG.Colors.ToggleOff
	ToggleTrack.BorderSizePixel = 0
	ToggleTrack.Parent = ToggleFrame
	createStroke(ToggleTrack, CONFIG.Colors.Stroke, 1)
	
	local ToggleThumb = Instance.new("Frame")
	ToggleThumb.Name = "ToggleThumb"
	ToggleThumb.Size = UDim2.new(0, 16, 0, 16)
	ToggleThumb.Position = toggled and UDim2.new(0, 20, 0, 2) or UDim2.new(0, 2, 0, 2)
	ToggleThumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ToggleThumb.BorderSizePixel = 0
	ToggleThumb.Parent = ToggleTrack
	createStroke(ToggleThumb, CONFIG.Colors.Stroke, 1)
	
	local ClickDetector = Instance.new("TextButton")
	ClickDetector.Name = "ClickDetector"
	ClickDetector.BackgroundTransparency = 1
	ClickDetector.Size = UDim2.new(1, 0, 1, 0)
	ClickDetector.Text = ""
	ClickDetector.Parent = ToggleFrame
	
	ClickDetector.MouseEnter:Connect(function()
		createTween(ToggleFrame, {BackgroundColor3 = CONFIG.Colors.ElementBgHover}, 0.2):Play()
	end)
	
	ClickDetector.MouseLeave:Connect(function()
		createTween(ToggleFrame, {BackgroundColor3 = CONFIG.Colors.ElementBg}, 0.2):Play()
	end)
	
	ClickDetector.MouseButton1Click:Connect(function()
		toggled = not toggled
		
		createTween(ToggleTrack, {
			BackgroundColor3 = toggled and CONFIG.Colors.ToggleOn or CONFIG.Colors.ToggleOff
		}, 0.2):Play()
		
		createTween(ToggleThumb, {
			Position = toggled and UDim2.new(0, 20, 0, 2) or UDim2.new(0, 2, 0, 2)
		}, 0.2):Play()
		
		pcall(callback, toggled)
	end)
	
	table.insert(self.Elements, ToggleFrame)
	
	return {
		Frame = ToggleFrame,
		SetValue = function(value)
			toggled = value
			createTween(ToggleTrack, {
				BackgroundColor3 = toggled and CONFIG.Colors.ToggleOn or CONFIG.Colors.ToggleOff
			}, 0.2):Play()
			createTween(ToggleThumb, {
				Position = toggled and UDim2.new(0, 20, 0, 2) or UDim2.new(0, 2, 0, 2)
			}, 0.2):Play()
		end,
		GetValue = function()
			return toggled
		end
	}
end

function Library:AddLabel(text)
	local LabelFrame = Instance.new("Frame")
	LabelFrame.Size = UDim2.new(1, 0, 0, 28)
	LabelFrame.BackgroundTransparency = 1
	LabelFrame.Parent = self.Content
	
	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(1, -20, 1, 0)
	Label.Position = UDim2.new(0, 10, 0, 0)
	Label.BackgroundTransparency = 1
	Label.Font = Enum.Font.Gotham
	Label.Text = text
	Label.TextColor3 = CONFIG.Colors.TextDim
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
	SliderFrame.Size = UDim2.new(1, 0, 0, 50)
	SliderFrame.BackgroundColor3 = CONFIG.Colors.ElementBg
	SliderFrame.BorderSizePixel = 0
	SliderFrame.Parent = self.Content
	createStroke(SliderFrame, CONFIG.Colors.Stroke, 1)
	
	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(1, -80, 0, 20)
	Label.Position = UDim2.new(0, 10, 0, 5)
	Label.BackgroundTransparency = 1
	Label.Font = Enum.Font.Gotham
	Label.Text = text
	Label.TextColor3 = CONFIG.Colors.Text
	Label.TextSize = 14
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = SliderFrame
	
	local ValueLabel = Instance.new("TextLabel")
	ValueLabel.Size = UDim2.new(0, 60, 0, 20)
	ValueLabel.Position = UDim2.new(1, -70, 0, 5)
	ValueLabel.BackgroundTransparency = 1
	ValueLabel.Font = Enum.Font.GothamBold
	ValueLabel.Text = tostring(value)
	ValueLabel.TextColor3 = CONFIG.Colors.TabActive
	ValueLabel.TextSize = 14
	ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
	ValueLabel.Parent = SliderFrame
	
	local SliderBar = Instance.new("Frame")
	SliderBar.Size = UDim2.new(1, -20, 0, 6)
	SliderBar.Position = UDim2.new(0, 10, 1, -15)
	SliderBar.BackgroundColor3 = CONFIG.Colors.Separator
	SliderBar.BorderSizePixel = 0
	SliderBar.Parent = SliderFrame
	
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

return Library
