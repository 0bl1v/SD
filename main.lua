-- Modern UI Library v2.0
-- ReplicatedStorage.uilib (ModuleScript)

local uilib = {}
local ts = game:GetService("TweenService")
local uis = game:GetService("UserInputService")
local players = game:GetService("Players")

-- UI Screen oluştur
uilib.screen = Instance.new("ScreenGui")
uilib.screen.Name = "ModernUILib"
uilib.screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
uilib.screen.ResetOnSpawn = false
uilib.screen.Parent = players.LocalPlayer:WaitForChild("PlayerGui")

-- Utility Functions
local function createCorner(parent, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius or 8)
	corner.Parent = parent
	return corner
end

local function rippleEffect(button, x, y)
	local circle = Instance.new("ImageLabel")
	circle.Image = "rbxassetid://2708891598"
	circle.ImageTransparency = 0.5
	circle.BackgroundTransparency = 1
	circle.ZIndex = 10
	circle.Size = UDim2.new(0, 0, 0, 0)
	circle.Position = UDim2.new(0, x, 0, y)
	circle.AnchorPoint = Vector2.new(0.5, 0.5)
	circle.Parent = button
	
	local size = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
	ts:Create(circle, TweenInfo.new(0.5), {Size = UDim2.new(0, size, 0, size), ImageTransparency = 1}):Play()
	
	task.delay(0.5, function()
		circle:Destroy()
	end)
end

-- Window Creation
function uilib:createwindow(config)
	config = config or {}
	local title = config.title or "Window"
	local size = config.size or UDim2.new(0, 480, 0, 560)
	local theme = config.theme or "dark"
	
	-- Theme colors
	local themes = {
		dark = {
			bg = Color3.fromRGB(18, 18, 22),
			secondary = Color3.fromRGB(28, 28, 35),
			accent = Color3.fromRGB(88, 101, 242),
			hover = Color3.fromRGB(98, 111, 252),
			text = Color3.fromRGB(255, 255, 255),
			subtext = Color3.fromRGB(160, 160, 170),
			border = Color3.fromRGB(45, 45, 55)
		},
		light = {
			bg = Color3.fromRGB(250, 250, 255),
			secondary = Color3.fromRGB(255, 255, 255),
			accent = Color3.fromRGB(88, 101, 242),
			hover = Color3.fromRGB(98, 111, 252),
			text = Color3.fromRGB(20, 20, 25),
			subtext = Color3.fromRGB(100, 100, 110),
			border = Color3.fromRGB(225, 225, 235)
		},
		nord = {
			bg = Color3.fromRGB(46, 52, 64),
			secondary = Color3.fromRGB(59, 66, 82),
			accent = Color3.fromRGB(136, 192, 208),
			hover = Color3.fromRGB(146, 202, 218),
			text = Color3.fromRGB(236, 239, 244),
			subtext = Color3.fromRGB(216, 222, 233),
			border = Color3.fromRGB(76, 86, 106)
		},
		purple = {
			bg = Color3.fromRGB(25, 15, 35),
			secondary = Color3.fromRGB(40, 25, 55),
			accent = Color3.fromRGB(147, 51, 234),
			hover = Color3.fromRGB(167, 71, 254),
			text = Color3.fromRGB(255, 255, 255),
			subtext = Color3.fromRGB(200, 180, 220),
			border = Color3.fromRGB(60, 40, 80)
		}
	}
	
	local c = themes[theme] or themes.dark
	
	-- Main Frame
	local frame = Instance.new("Frame")
	frame.Name = title:gsub("%s", "")
	frame.Size = UDim2.new(0, 0, 0, 0)
	frame.Position = UDim2.new(0.5, 0, 0.5, 0)
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.BackgroundColor3 = c.bg
	frame.BorderSizePixel = 0
	frame.ClipsDescendants = true
	frame.Parent = self.screen
	
	createCorner(frame, 12)
	
	-- Border stroke
	local stroke = Instance.new("UIStroke")
	stroke.Color = c.border
	stroke.Thickness = 1.5
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Parent = frame
	
	-- Shadow
	local shadow = Instance.new("ImageLabel")
	shadow.Name = "Shadow"
	shadow.BackgroundTransparency = 1
	shadow.Size = UDim2.new(1, 40, 1, 40)
	shadow.Position = UDim2.new(0, -20, 0, -20)
	shadow.Image = "rbxassetid://5554236805"
	shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	shadow.ImageTransparency = 0.5
	shadow.ScaleType = Enum.ScaleType.Slice
	shadow.SliceCenter = Rect.new(23, 23, 277, 277)
	shadow.ZIndex = 0
	shadow.Parent = frame
	
	frame.ZIndex = 1
	
	-- Title Bar
	local titlebar = Instance.new("Frame")
	titlebar.Name = "TitleBar"
	titlebar.Size = UDim2.new(1, 0, 0, 44)
	titlebar.BackgroundTransparency = 1
	titlebar.ZIndex = 2
	titlebar.Parent = frame
	
	local titlelbl = Instance.new("TextLabel")
	titlelbl.Size = UDim2.new(1, -100, 1, 0)
	titlelbl.Position = UDim2.new(0, 16, 0, 0)
	titlelbl.BackgroundTransparency = 1
	titlelbl.Text = title
	titlelbl.TextColor3 = c.text
	titlelbl.Font = Enum.Font.GothamBold
	titlelbl.TextSize = 15
	titlelbl.TextXAlignment = Enum.TextXAlignment.Left
	titlelbl.ZIndex = 3
	titlelbl.Parent = titlebar
	
	-- Close Button
	local closeBtn = Instance.new("TextButton")
	closeBtn.Name = "CloseButton"
	closeBtn.Size = UDim2.new(0, 32, 0, 32)
	closeBtn.Position = UDim2.new(1, -42, 0, 6)
	closeBtn.BackgroundColor3 = c.secondary
	closeBtn.BorderSizePixel = 0
	closeBtn.Text = "✕"
	closeBtn.TextColor3 = c.text
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.TextSize = 16
	closeBtn.AutoButtonColor = false
	closeBtn.ZIndex = 3
	closeBtn.Parent = titlebar
	
	createCorner(closeBtn, 6)
	
	closeBtn.MouseEnter:Connect(function()
		ts:Create(closeBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220, 50, 50)}):Play()
	end)
	
	closeBtn.MouseLeave:Connect(function()
		ts:Create(closeBtn, TweenInfo.new(0.2), {BackgroundColor3 = c.secondary}):Play()
	end)
	
	closeBtn.MouseButton1Click:Connect(function()
		local tweenOut = ts:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
			Size = UDim2.new(0, 0, 0, 0)
		})
		tweenOut:Play()
		tweenOut.Completed:Connect(function()
			frame:Destroy()
		end)
	end)
	
	-- Minimize Button
	local minBtn = Instance.new("TextButton")
	minBtn.Name = "MinimizeButton"
	minBtn.Size = UDim2.new(0, 32, 0, 32)
	minBtn.Position = UDim2.new(1, -78, 0, 6)
	minBtn.BackgroundColor3 = c.secondary
	minBtn.BorderSizePixel = 0
	minBtn.Text = "−"
	minBtn.TextColor3 = c.text
	minBtn.Font = Enum.Font.GothamBold
	minBtn.TextSize = 18
	minBtn.AutoButtonColor = false
	minBtn.ZIndex = 3
	minBtn.Parent = titlebar
	
	createCorner(minBtn, 6)
	
	local minimized = false
	local originalSize = size
	
	minBtn.MouseEnter:Connect(function()
		ts:Create(minBtn, TweenInfo.new(0.2), {BackgroundColor3 = c.border}):Play()
	end)
	
	minBtn.MouseLeave:Connect(function()
		ts:Create(minBtn, TweenInfo.new(0.2), {BackgroundColor3 = c.secondary}):Play()
	end)
	
	minBtn.MouseButton1Click:Connect(function()
		minimized = not minimized
		local targetSize = minimized and UDim2.new(0, originalSize.X.Offset, 0, 44) or originalSize
		ts:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = targetSize}):Play()
		minBtn.Text = minimized and "□" or "−"
	end)
	
	-- Divider
	local divider = Instance.new("Frame")
	divider.Size = UDim2.new(1, 0, 0, 1)
	divider.Position = UDim2.new(0, 0, 0, 44)
	divider.BackgroundColor3 = c.border
	divider.BorderSizePixel = 0
	divider.ZIndex = 2
	divider.Parent = frame
	
	-- Content Container
	local content = Instance.new("ScrollingFrame")
	content.Name = "Content"
	content.Size = UDim2.new(1, -20, 1, -56)
	content.Position = UDim2.new(0, 10, 0, 50)
	content.CanvasSize = UDim2.new(0, 0, 0, 0)
	content.AutomaticCanvasSize = Enum.AutomaticSize.Y
	content.ScrollBarThickness = 4
	content.ScrollBarImageColor3 = c.accent
	content.BackgroundTransparency = 1
	content.BorderSizePixel = 0
	content.ZIndex = 2
	content.Parent = frame
	
	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 8)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = content
	
	local pad = Instance.new("UIPadding")
	pad.PaddingTop = UDim.new(0, 6)
	pad.PaddingBottom = UDim.new(0, 6)
	pad.Parent = content
	
	-- Animate window opening
	ts:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = size}):Play()
	
	-- Dragging
	local dragging, dragInput, dragStart, startPos
	
	titlebar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
			
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	
	titlebar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)
	
	uis.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)
	
	-- Window Object
	local win = {}
	win.frame = frame
	win.content = content
	win.colors = c
	
	-- Toggle visibility (K tuşu)
	local visible = true
	uis.InputBegan:Connect(function(input, processed)
		if processed then return end
		if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.K then
			visible = not visible
			frame.Visible = visible
		end
	end)
	
	-- Add Label
	function win:addlabel(text, config)
		config = config or {}
		local lbl = Instance.new("TextLabel")
		lbl.Name = "Label"
		lbl.Size = UDim2.new(1, 0, 0, config.height or 26)
		lbl.BackgroundTransparency = 1
		lbl.Text = text or ""
		lbl.TextColor3 = config.color or c.subtext
		lbl.Font = config.bold and Enum.Font.GothamBold or Enum.Font.Gotham
		lbl.TextSize = config.size or 13
		lbl.TextXAlignment = Enum.TextXAlignment.Left
		lbl.TextWrapped = true
		lbl.ZIndex = 3
		lbl.Parent = content
		
		local obj = {element = lbl}
		function obj:update(newtext)
			lbl.Text = newtext
		end
		return obj
	end
	
	-- Add Button
	function win:addbutton(text, callback)
		local btn = Instance.new("TextButton")
		btn.Name = "Button"
		btn.Size = UDim2.new(1, 0, 0, 34)
		btn.BackgroundColor3 = c.secondary
		btn.BorderSizePixel = 0
		btn.AutoButtonColor = false
		btn.Text = text or "Button"
		btn.TextColor3 = c.text
		btn.Font = Enum.Font.GothamSemibold
		btn.TextSize = 13
		btn.ClipsDescendants = true
		btn.ZIndex = 3
		btn.Parent = content
		
		createCorner(btn, 7)
		
		btn.MouseEnter:Connect(function()
			ts:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = c.accent}):Play()
		end)
		
		btn.MouseLeave:Connect(function()
			ts:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = c.secondary}):Play()
		end)
		
		btn.MouseButton1Click:Connect(function()
			local x = uis:GetMouseLocation().X - btn.AbsolutePosition.X
			local y = uis:GetMouseLocation().Y - btn.AbsolutePosition.Y
			rippleEffect(btn, x, y)
			
			if callback then
				task.spawn(callback)
			end
		end)
		
		return {element = btn}
	end
	
	-- Add Toggle
	function win:addtoggle(text, default, callback)
		local container = Instance.new("Frame")
		container.Name = "Toggle"
		container.Size = UDim2.new(1, 0, 0, 34)
		container.BackgroundColor3 = c.secondary
		container.BorderSizePixel = 0
		container.ZIndex = 3
		container.Parent = content
		
		createCorner(container, 7)
		
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, -55, 1, 0)
		label.Position = UDim2.new(0, 10, 0, 0)
		label.BackgroundTransparency = 1
		label.Text = text or "Toggle"
		label.TextColor3 = c.text
		label.Font = Enum.Font.Gotham
		label.TextSize = 13
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.ZIndex = 4
		label.Parent = container
		
		local toggle = Instance.new("TextButton")
		toggle.Size = UDim2.new(0, 38, 0, 20)
		toggle.Position = UDim2.new(1, -45, 0.5, 0)
		toggle.AnchorPoint = Vector2.new(0, 0.5)
		toggle.BackgroundColor3 = default and c.accent or c.border
		toggle.BorderSizePixel = 0
		toggle.Text = ""
		toggle.AutoButtonColor = false
		toggle.ZIndex = 4
		toggle.Parent = container
		
		createCorner(toggle, 10)
		
		local knob = Instance.new("Frame")
		knob.Size = UDim2.new(0, 16, 0, 16)
		knob.Position = default and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
		knob.AnchorPoint = Vector2.new(0, 0.5)
		knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		knob.BorderSizePixel = 0
		knob.ZIndex = 5
		knob.Parent = toggle
		
		createCorner(knob, 8)
		
		local enabled = default or false
		
		toggle.MouseButton1Click:Connect(function()
			enabled = not enabled
			
			ts:Create(toggle, TweenInfo.new(0.2), {
				BackgroundColor3 = enabled and c.accent or c.border
			}):Play()
			
			ts:Create(knob, TweenInfo.new(0.2), {
				Position = enabled and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
			}):Play()
			
			if callback then
				task.spawn(callback, enabled)
			end
		end)
		
		local obj = {element = container, enabled = enabled}
		function obj:set(value)
			enabled = value
			ts:Create(toggle, TweenInfo.new(0.2), {
				BackgroundColor3 = enabled and c.accent or c.border
			}):Play()
			ts:Create(knob, TweenInfo.new(0.2), {
				Position = enabled and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
			}):Play()
		end
		return obj
	end
	
	-- Add Slider
	function win:addslider(text, min, max, default, callback)
		local container = Instance.new("Frame")
		container.Name = "Slider"
		container.Size = UDim2.new(1, 0, 0, 46)
		container.BackgroundColor3 = c.secondary
		container.BorderSizePixel = 0
		container.ZIndex = 3
		container.Parent = content
		
		createCorner(container, 7)
		
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, -55, 0, 18)
		label.Position = UDim2.new(0, 10, 0, 5)
		label.BackgroundTransparency = 1
		label.Text = text or "Slider"
		label.TextColor3 = c.text
		label.Font = Enum.Font.Gotham
		label.TextSize = 13
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.ZIndex = 4
		label.Parent = container
		
		local value = Instance.new("TextLabel")
		value.Size = UDim2.new(0, 45, 0, 18)
		value.Position = UDim2.new(1, -52, 0, 5)
		value.BackgroundTransparency = 1
		value.Text = tostring(default or min)
		value.TextColor3 = c.accent
		value.Font = Enum.Font.GothamBold
		value.TextSize = 13
		value.TextXAlignment = Enum.TextXAlignment.Right
		value.ZIndex = 4
		value.Parent = container
		
		local sliderBg = Instance.new("Frame")
		sliderBg.Size = UDim2.new(1, -20, 0, 5)
		sliderBg.Position = UDim2.new(0, 10, 1, -12)
		sliderBg.BackgroundColor3 = c.border
		sliderBg.BorderSizePixel = 0
		sliderBg.ZIndex = 4
		sliderBg.Parent = container
		
		createCorner(sliderBg, 2.5)
		
		local sliderFill = Instance.new("Frame")
		sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
		sliderFill.BackgroundColor3 = c.accent
		sliderFill.BorderSizePixel = 0
		sliderFill.ZIndex = 5
		sliderFill.Parent = sliderBg
		
		createCorner(sliderFill, 2.5)
		
		local dragging = false
		
		sliderBg.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = true
			end
		end)
		
		uis.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = false
			end
		end)
		
		uis.InputChanged:Connect(function(input)
			if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
				local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
				local val = math.floor(min + (max - min) * pos)
				
				sliderFill.Size = UDim2.new(pos, 0, 1, 0)
				value.Text = tostring(val)
				
				if callback then
					task.spawn(callback, val)
				end
			end
		end)
		
		return {element = container}
	end
	
	-- Add Textbox
	function win:addtextbox(placeholder, callback)
		local box = Instance.new("TextBox")
		box.Name = "Textbox"
		box.Size = UDim2.new(1, 0, 0, 34)
		box.BackgroundColor3 = c.secondary
		box.BorderSizePixel = 0
		box.PlaceholderText = placeholder or "Enter text..."
		box.PlaceholderColor3 = c.subtext
		box.Text = ""
		box.TextColor3 = c.text
		box.Font = Enum.Font.Gotham
		box.TextSize = 13
		box.TextXAlignment = Enum.TextXAlignment.Left
		box.ClearTextOnFocus = false
		box.ZIndex = 3
		box.Parent = content
		
		createCorner(box, 7)
		
		local padding = Instance.new("UIPadding")
		padding.PaddingLeft = UDim.new(0, 10)
		padding.PaddingRight = UDim.new(0, 10)
		padding.Parent = box
		
		box.FocusLost:Connect(function(enter)
			if enter and callback then
				task.spawn(callback, box.Text)
			end
		end)
		
		return {element = box}
	end
	
	-- Add Dropdown
	function win:adddropdown(text, options, callback)
		local container = Instance.new("Frame")
		container.Name = "Dropdown"
		container.Size = UDim2.new(1, 0, 0, 34)
		container.BackgroundColor3 = c.secondary
		container.BorderSizePixel = 0
		container.ClipsDescendants = true
		container.ZIndex = 3
		container.Parent = content
		
		createCorner(container, 7)
		
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, 0, 0, 34)
		btn.BackgroundTransparency = 1
		btn.Text = text or "Select..."
		btn.TextColor3 = c.text
		btn.Font = Enum.Font.Gotham
		btn.TextSize = 13
		btn.TextXAlignment = Enum.TextXAlignment.Left
		btn.ZIndex = 4
		btn.Parent = container
		
		local padding = Instance.new("UIPadding")
		padding.PaddingLeft = UDim.new(0, 10)
		padding.Parent = btn
		
		local arrow = Instance.new("TextLabel")
		arrow.Size = UDim2.new(0, 18, 1, 0)
		arrow.Position = UDim2.new(1, -25, 0, 0)
		arrow.BackgroundTransparency = 1
		arrow.Text = "▼"
		arrow.TextColor3 = c.subtext
		arrow.Font = Enum.Font.Gotham
		arrow.TextSize = 11
		arrow.ZIndex = 5
		arrow.Parent = btn
		
		local expanded = false
		
		btn.MouseButton1Click:Connect(function()
			expanded = not expanded
			local targetSize = expanded and UDim2.new(1, 0, 0, 34 + (#options * 30)) or UDim2.new(1, 0, 0, 34)
			ts:Create(container, TweenInfo.new(0.2), {Size = targetSize}):Play()
			ts:Create(arrow, TweenInfo.new(0.2), {Rotation = expanded and 180 or 0}):Play()
		end)
		
		for i, option in ipairs(options) do
			local optBtn = Instance.new("TextButton")
			optBtn.Size = UDim2.new(1, -8, 0, 26)
			optBtn.Position = UDim2.new(0, 4, 0, 34 + ((i - 1) * 30))
			optBtn.BackgroundColor3 = c.bg
			optBtn.BorderSizePixel = 0
			optBtn.Text = option
			optBtn.TextColor3 = c.text
			optBtn.Font = Enum.Font.Gotham
			optBtn.TextSize = 12
			optBtn.TextXAlignment = Enum.TextXAlignment.Left
			optBtn.ZIndex = 4
			optBtn.Parent = container
			
			createCorner(optBtn, 5)
			
			local optPadding = Instance.new("UIPadding")
			optPadding.PaddingLeft = UDim.new(0, 10)
			optPadding.Parent = optBtn
			
			optBtn.MouseEnter:Connect(function()
				ts:Create(optBtn, TweenInfo.new(0.15), {BackgroundColor3 = c.border}):Play()
			end)
			
			optBtn.MouseLeave:Connect(function()
				ts:Create(optBtn, TweenInfo.new(0.15), {BackgroundColor3 = c.bg}):Play()
			end)
			
			optBtn.MouseButton1Click:Connect(function()
				btn.Text = option
				expanded = false
				ts:Create(container, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 34)}):Play()
				ts:Create(arrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
				
				if callback then
					task.spawn(callback, option)
				end
			end)
		end
		
		return {element = container}
	end
	
	return win
end

return uilib
