-- UI Library v1.0
-- Modern Roblox UI Library

local Library = {}
Library.__index = Library

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Ayarlar
local CONFIG = {
	AnimationSpeed = 0.3,
	Colors = {
		Background = Color3.fromRGB(0, 0, 0),
		Separator = Color3.fromRGB(67, 67, 67),
		Text = Color3.fromRGB(255, 255, 255),
		TabActive = Color3.fromRGB(100, 100, 255),
		TabInactive = Color3.fromRGB(255, 255, 255)
	}
}

-- Ana Hub oluştur
function Library:CreateHub(hubName)
	local Hub = {}
	Hub.Tabs = {}
	Hub.CurrentTab = nil
	
	-- ScreenGui oluştur
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "UILibrary"
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
	
	-- Ana Frame
	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.BackgroundColor3 = CONFIG.Colors.Background
	MainFrame.BorderSizePixel = 0
	MainFrame.Position = UDim2.new(0.265, 0, 0.245, 0)
	MainFrame.Size = UDim2.new(0, 514, 0, 328)
	MainFrame.Parent = ScreenGui
	
	-- Köşeleri yuvarla
	local UICorner = Instance.new("UICorner")
	UICorner.CornerRadius = UDim.new(0, 8)
	UICorner.Parent = MainFrame
	
	-- Başlık
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
	
	-- Tab Container (Sol taraf)
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
	
	-- Sol ayırıcı
	local LeftSeparator = Instance.new("Frame")
	LeftSeparator.BackgroundColor3 = CONFIG.Colors.Separator
	LeftSeparator.BorderSizePixel = 0
	LeftSeparator.Position = UDim2.new(0, 0, 0.113, 0)
	LeftSeparator.Size = UDim2.new(0, 1, 0, 291)
	LeftSeparator.Parent = MainFrame
	
	-- Sağ ayırıcı
	local RightSeparator = Instance.new("Frame")
	RightSeparator.BackgroundColor3 = CONFIG.Colors.Separator
	RightSeparator.BorderSizePixel = 0
	RightSeparator.Position = UDim2.new(0.177, 0, 0.113, 0)
	RightSeparator.Size = UDim2.new(0, 1, 0, 291)
	RightSeparator.Parent = MainFrame
	
	-- Content Container (Sağ taraf)
	local ContentContainer = Instance.new("Frame")
	ContentContainer.Name = "ContentContainer"
	ContentContainer.BackgroundTransparency = 1
	ContentContainer.Position = UDim2.new(0.19, 0, 0.137, 0)
	ContentContainer.Size = UDim2.new(0, 405, 0, 260)
	ContentContainer.Parent = MainFrame
	
	-- Draggable yapma
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
	
	game:GetService("RunService").Heartbeat:Connect(function()
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

-- Tab oluştur
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
	TabContent.Visible = false
	TabContent.Parent = self.ContentContainer
	
	local ContentLayout = Instance.new("UIListLayout")
	ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
	ContentLayout.Padding = UDim.new(0, 8)
	ContentLayout.Parent = TabContent
	
	-- Tab'ı aktif et
	TabButton.MouseButton1Click:Connect(function()
		-- Tüm tab'ları deaktif et
		for _, tab in pairs(self.Tabs) do
			tab.Button.TextColor3 = CONFIG.Colors.TabInactive
			tab.Content.Visible = false
		end
		
		-- Bu tab'ı aktif et
		TabButton.TextColor3 = CONFIG.Colors.TabActive
		TabContent.Visible = true
		self.CurrentTab = Tab
	end)
	
	-- İlk tab'ı otomatik aç
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

-- Button elementi ekle
function Library:AddButton(text, callback)
	local Button = Instance.new("TextButton")
	Button.Size = UDim2.new(1, -10, 0, 30)
	Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	Button.BorderSizePixel = 0
	Button.Font = Enum.Font.Code
	Button.Text = text
	Button.TextColor3 = CONFIG.Colors.Text
	Button.TextSize = 14
	Button.Parent = self.Content
	
	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 6)
	Corner.Parent = Button
	
	Button.MouseButton1Click:Connect(callback)
	
	-- Hover efekti
	Button.MouseEnter:Connect(function()
		TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
	end)
	
	Button.MouseLeave:Connect(function()
		TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
	end)
	
	return Button
end

-- Toggle elementi ekle
function Library:AddToggle(text, default, callback)
	local toggled = default or false
	
	local ToggleFrame = Instance.new("Frame")
	ToggleFrame.Size = UDim2.new(1, -10, 0, 30)
	ToggleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	ToggleFrame.BorderSizePixel = 0
	ToggleFrame.Parent = self.Content
	
	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 6)
	Corner.Parent = ToggleFrame
	
	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(0.8, 0, 1, 0)
	Label.BackgroundTransparency = 1
	Label.Font = Enum.Font.Code
	Label.Text = text
	Label.TextColor3 = CONFIG.Colors.Text
	Label.TextSize = 14
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Position = UDim2.new(0.05, 0, 0, 0)
	Label.Parent = ToggleFrame
	
	local ToggleButton = Instance.new("TextButton")
	ToggleButton.Size = UDim2.new(0, 40, 0, 20)
	ToggleButton.Position = UDim2.new(0.85, 0, 0.5, -10)
	ToggleButton.BackgroundColor3 = toggled and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(200, 100, 100)
	ToggleButton.BorderSizePixel = 0
	ToggleButton.Text = ""
	ToggleButton.Parent = ToggleFrame
	
	local ToggleCorner = Instance.new("UICorner")
	ToggleCorner.CornerRadius = UDim.new(1, 0)
	ToggleCorner.Parent = ToggleButton
	
	ToggleButton.MouseButton1Click:Connect(function()
		toggled = not toggled
		TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
			BackgroundColor3 = toggled and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(200, 100, 100)
		}):Play()
		callback(toggled)
	end)
	
	return ToggleFrame
end

return Library
