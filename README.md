## load library
```lua
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/0bl1v/SD/refs/heads/main/main.lua"))()
```
create hub
```lua
local hub = library:CreateHub("example hub")
```
create tabs
```lua
local maintab = hub:CreateTab("main")
local combattab = hub:CreateTab("combat")
local visualtab = hub:CreateTab("visual")
local misctab = hub:CreateTab("misc")
```
add section
```lua
maintab:AddSection("player controls")
```
add button
```lua
maintab:AddButton("button example", function()
    print("button clicked!")
    library:Notify("success", "button was clicked!", 2)
end)
```
add toggle
```lua
local toggle1 = maintab:AddToggle("toggle example", false, function(state)
    print("toggle state:", state)
    if state then
        library:Notify("enabled", "feature enabled!", 2)
    else
        library:Notify("disabled", "feature disabled!", 2)
    end
end)
```
add slider
```lua
local slider1 = maintab:AddSlider("slider example", 0, 100, 50, function(value)
    print("slider value:", value)
end)
```
add label
```lua
maintab:AddLabel("this is a label example")
```
add dropdown
```lua
local dropdown1 = maintab:AddDropdown("dropdown example", {"option1", "option2", "option3", "option4"}, "option1", function(value)
    print("selected:", value)
    library:Notify("dropdown", "selected: " .. value, 2)
end)
```
add keybind
```lua
local flykeybind = misctab:AddKeybind("fly", Enum.KeyCode.F, function()
    print("fly toggled!")
end)
```
add color picker
```lua
local playercolor = visualtab:AddColorPicker("player color", Color3.fromRGB(255, 0, 0), function(color)
    print("player color:", color)
end)
```
add radio buttons
```lua
local radio1 = misctab:AddRadioButtons("select mode", {"mode1", "mode2", "mode3"}, "mode1", function(value)
    print("selected mode:", value)
end)
```
notify
```lua
library:Notify("welcome", "script loaded successfully!", 5)
```
getters and setters
```lua
toggle1.SetValue(true)
print("toggle value:", toggle1.GetValue())

slider1.SetValue(75)
print("slider value:", slider1.GetValue())

dropdown1.SetValue("option3")
print("dropdown value:", dropdown1.GetValue())

flykeybind.SetKey(Enum.KeyCode.G)
print("fly key:", flykeybind.GetKey().Name)

playercolor.SetColor(Color3.fromRGB(0, 255, 0))
print("player color:", playercolor.GetColor())

radio1.SetValue("mode3")
print("radio value:", radio1.GetValue())
```
