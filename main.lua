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

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(128,128,128)
    stroke.Thickness = 2
    stroke.Parent = frame

    local titlelbl = Instance.new("TextLabel")
    titlelbl.Size = UDim2.new(1,-40,0,30)
    titlelbl.Position = UDim2.new(0,0,0,0)
    titlelbl.BackgroundTransparency = 1
    titlelbl.Text = title or "window"
    titlelbl.TextColor3 = Color3.fromRGB(255,255,255)
    titlelbl.Font = Enum.Font.Code
    titlelbl.TextSize = 18
    titlelbl.Parent = frame

    local close = Instance.new("ImageButton")
    close.Size = UDim2.new(0,30,0,30)
    close.Position = UDim2.new(1,-30,0,0)
    close.BackgroundColor3 = Color3.fromRGB(30,30,30)
    close.Image = "rbxassetid://7072727365"
    close.ScaleType = Enum.ScaleType.Fit
    close.Parent = frame

    local closeStroke = Instance.new("UIStroke")
    closeStroke.Color = Color3.fromRGB(128,128,128)
    closeStroke.Thickness = 1
    closeStroke.Parent = close

    close.MouseButton1Click:Connect(function()
        frame:Destroy()
    end)

    local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    ts:Create(frame, tweenInfo, {Size = size or UDim2.new(0,250,0,500)}):Play()

    local dragging = false
    local dragInput, dragStart, startPos
    titlelbl.InputBegan:Connect(function(input)
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
    titlelbl.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    uis.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    return frame
end

return uilib
