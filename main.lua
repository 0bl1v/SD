-- dosya: ReplicatedStorage.uilib (module script)
local uilib = {}
local ts = game:GetService("TweenService")
local uis = game:GetService("UserInputService")
local players = game:GetService("Players")

uilib.screen = Instance.new("ScreenGui")
uilib.screen.Name = "uilibScreen"
uilib.screen.Parent = players.LocalPlayer:WaitForChild("PlayerGui")

function uilib:createwindow(title, size)
	local frame = Instance.new("Frame")
	frame.Name = (title or "window"):gsub("%s","")
	frame.Size = UDim2.new(0,0,0,0)
	frame.Position = UDim2.new(0.5,0,0.5,0)
	frame.AnchorPoint = Vector2.new(0.5,0.5)
	frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
	frame.Parent = self.screen
	frame.ClipsDescendants = true

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(128,128,128)
	stroke.Thickness = 2
	stroke.Parent = frame

	local titlebar = Instance.new("Frame")
	titlebar.Size = UDim2.new(1,0,0,36)
	titlebar.Position = UDim2.new(0,0,0,0)
	titlebar.BackgroundTransparency = 1
	titlebar.Parent = frame

	local titlelbl = Instance.new("TextLabel")
	titlelbl.Size = UDim2.new(1,-44,1,0)
	titlelbl.Position = UDim2.new(0,8,0,0)
	titlelbl.BackgroundTransparency = 1
	titlelbl.Text = title or "window"
	titlelbl.TextColor3 = Color3.fromRGB(255,255,255)
	titlelbl.Font = Enum.Font.Code
	titlelbl.TextSize = 18
	titlelbl.TextXAlignment = Enum.TextXAlignment.Left
	titlelbl.Parent = titlebar

	local close = Instance.new("ImageButton")
	close.Size = UDim2.new(0,28,0,28)
	close.Position = UDim2.new(1,-32,0,4)
	close.BackgroundColor3 = Color3.fromRGB(30,30,30)
	close.Image = "rbxassetid://7072727365"
	close.ScaleType = Enum.ScaleType.Fit
	close.Parent = titlebar

	local closeStroke = Instance.new("UIStroke")
	closeStroke.Color = Color3.fromRGB(128,128,128)
	closeStroke.Thickness = 1
	closeStroke.Parent = close

	close.MouseEnter:Connect(function()
		close.BackgroundColor3 = Color3.fromRGB(50,50,50)
	end)
	close.MouseLeave:Connect(function()
		close.BackgroundColor3 = Color3.fromRGB(30,30,30)
	end)
	close.MouseButton1Click:Connect(function()
		frame:Destroy()
	end)

	local content = Instance.new("ScrollingFrame")
	content.Size = UDim2.new(1,-16,1,-46)
	content.Position = UDim2.new(0,8,0,38)
	content.CanvasSize = UDim2.new(0,0,0,0)
	content.AutomaticCanvasSize = Enum.AutomaticSize.Y
	content.ScrollBarThickness = 6
	content.BackgroundTransparency = 1
	content.Parent = frame

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0,6)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = content

	local pad = Instance.new("UIPadding")
	pad.PaddingTop = UDim.new(0,6)
	pad.PaddingLeft = UDim.new(0,6)
	pad.PaddingRight = UDim.new(0,6)
	pad.Parent = content

	local tweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	ts:Create(frame,tweenInfo,{Size = size or UDim2.new(0,300,0,520)}):Play()

	local dragging = false
	local dragInput, dragStart, startPos
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
			frame.Position = UDim2.new(startPos.X.Scale,startPos.X.Offset + delta.X,startPos.Y.Scale,startPos.Y.Offset + delta.Y)
		end
	end)

	local win = {}
	win.frame = frame
	win.content = content

	function win:addlabel(text)
		local lbl = Instance.new("TextLabel")
		lbl.Size = UDim2.new(1,0,0,24)
		lbl.BackgroundTransparency = 1
		lbl.Text = text or ""
		lbl.TextColor3 = Color3.fromRGB(220,220,220)
		lbl.Font = Enum.Font.Code
		lbl.TextSize = 16
		lbl.TextXAlignment = Enum.TextXAlignment.Left
		lbl.Parent = content
		return lbl
	end

	function win:addbutton(text,callback)
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1,0,0,28)
		btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
		btn.BorderSizePixel = 0
		btn.Text = text or ""
		btn.TextColor3 = Color3.fromRGB(255,255,255)
		btn.Font = Enum.Font.Code
		btn.TextSize = 16
		btn.Parent = content
		btn.MouseButton1Click:Connect(function()
			if callback then callback() end
		end)
		return btn
	end

	function win:addtab(name)
		local tab = Instance.new("Frame")
		tab.Size = UDim2.new(1,0,0,0)
		tab.BackgroundColor3 = Color3.fromRGB(35,35,35)
		tab.BorderSizePixel = 0
		tab.Parent = content

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1,0,0,28)
		label.BackgroundTransparency = 1
		label.Text = name or "tab"
		label.TextColor3 = Color3.fromRGB(255,255,255)
		label.Font = Enum.Font.Code
		label.TextSize = 16
		label.Parent = tab

		local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		ts:Create(tab,tweenInfo,{Size=UDim2.new(1,0,0,80)}):Play()

		return tab
	end

	return win
end

return uilib
