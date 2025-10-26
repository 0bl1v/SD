local uiLib = {}
local ts = game:GetService("TweenService")
local uis = game:GetService("UserInputService")

uiLib.ScreenGui = Instance.new("ScreenGui")
uiLib.ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
uiLib.ScreenGui.Name = "myUiLib"

function uiLib:CreateWindow(titleText, size)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 0, 0, 0)
    frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.Parent = self.ScreenGui
    frame.Name = titleText or "Window"

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(128, 128, 128)
    stroke.Thickness = 2
    stroke.Parent = frame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 30)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = titleText or "Window"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.Code
    title.TextSize = 18
    title.Parent = frame

    local close = Instance.new("ImageButton")
    close.Size = UDim2.new(0, 30, 0, 30)
    close.Position = UDim2.new(1, -30, 0, 0)
    close.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    close.Image = "rbxassetid://7072727365"
    close.ScaleType = Enum.ScaleType.Fit
    close.Parent = frame

    local closeStroke = Instance.new("UIStroke")
    closeStroke.Color = Color3.fromRGB(128, 128, 128)
    closeStroke.Thickness = 1
    closeStroke.Parent = close

    close.MouseButton1Click:Connect(function()
        frame:Destroy()
    end)

    local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = ts:Create(frame, tweenInfo, {Size = size or UDim2.new(0, 250, 0, 600), Position = UDim2.new(0.5, 0, 0.5, 0)})
    tween:Play()

    local dragging = false
    local dragInput, mousePos, framePos

    title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    title.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    uis.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            frame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)

    return frame
end

return uiLib
