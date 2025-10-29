local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/0bl1v/SD/refs/heads/main/main.lua"))()

local Hub = Library:CreateHub("Example Hub")

local MainTab = Hub:CreateTab("Main")
local CombatTab = Hub:CreateTab("Combat")
local VisualTab = Hub:CreateTab("Visual")
local MiscTab = Hub:CreateTab("Misc")

MainTab:AddSection("Player Controls")

MainTab:AddButton("Button Example", function()
    print("Button clicked!")
    Library:Notify("Success", "Button was clicked!", 2)
end)

local Toggle1 = MainTab:AddToggle("Toggle Example", false, function(state)
    print("Toggle state:", state)
    if state then
        Library:Notify("Enabled", "Feature enabled!", 2)
    else
        Library:Notify("Disabled", "Feature disabled!", 2)
    end
end)

local Slider1 = MainTab:AddSlider("Slider Example", 0, 100, 50, function(value)
    print("Slider value:", value)
end)

MainTab:AddLabel("This is a label example")

MainTab:AddSection("Dropdown Section")

local Dropdown1 = MainTab:AddDropdown("Dropdown Example", {"Option1", "Option2", "Option3", "Option4"}, "Option1", function(value)
    print("Selected:", value)
    Library:Notify("Dropdown", "Selected: " .. value, 2)
end)

CombatTab:AddSection("Combat Settings")

local AimbotToggle = CombatTab:AddToggle("Aimbot", false, function(state)
    print("Aimbot:", state)
end)

local AimbotFov = CombatTab:AddSlider("FOV", 50, 500, 150, function(value)
    print("FOV:", value)
end)

CombatTab:AddSection("Weapon Selection")

local WeaponDropdown = CombatTab:AddDropdown("Weapon", {"Sword", "Gun", "Bow", "Magic"}, "Sword", function(value)
    print("Weapon:", value)
end)

local DamageSlider = CombatTab:AddSlider("Damage", 1, 10, 1, function(value)
    print("Damage multiplier:", value)
end)

VisualTab:AddSection("ESP Settings")

local EspToggle = VisualTab:AddToggle("ESP", false, function(state)
    print("ESP:", state)
end)

local EspKeybind = VisualTab:AddKeybind("ESP Toggle Key", Enum.KeyCode.E, function()
    print("ESP key pressed!")
    Library:Notify("Keybind", "ESP toggled!", 2)
end)

VisualTab:AddSection("Color Settings")

local PlayerColor = VisualTab:AddColorPicker("Player Color", Color3.fromRGB(255, 0, 0), function(color)
    print("Player color:", color)
end)

local EnemyColor = VisualTab:AddColorPicker("Enemy Color", Color3.fromRGB(255, 255, 0), function(color)
    print("Enemy color:", color)
end)

local TeamColor = VisualTab:AddColorPicker("Team Color", Color3.fromRGB(0, 255, 0), function(color)
    print("Team color:", color)
end)

VisualTab:AddSection("Environment")

VisualTab:AddToggle("Fullbright", false, function(state)
    print("Fullbright:", state)
end)

VisualTab:AddSlider("FOV", 70, 120, 70, function(value)
    workspace.CurrentCamera.FieldOfView = value
end)

MiscTab:AddSection("Radio Buttons")

local Radio1 = MiscTab:AddRadioButtons("Select Mode", {"Mode1", "Mode2", "Mode3"}, "Mode1", function(value)
    print("Selected mode:", value)
end)

local Radio2 = MiscTab:AddRadioButtons("Difficulty", {"Easy", "Normal", "Hard"}, "Normal", function(value)
    print("Difficulty:", value)
end)

MiscTab:AddSection("Keybinds")

local FlyKeybind = MiscTab:AddKeybind("Fly", Enum.KeyCode.F, function()
    print("Fly toggled!")
end)

local NoclipKeybind = MiscTab:AddKeybind("Noclip", Enum.KeyCode.N, function()
    print("Noclip toggled!")
end)

MiscTab:AddSection("Information")

MiscTab:AddLabel("Script Version: 1.0.0")
MiscTab:AddLabel("Made by: YourName")
MiscTab:AddLabel("Last Updated: 2024")

MiscTab:AddButton("Save Config", function()
    Library:Notify("Config", "Configuration saved!", 3)
end)

MiscTab:AddButton("Load Config", function()
    Library:Notify("Config", "Configuration loaded!", 3)
end)

Toggle1.SetValue(true)
print("Toggle value:", Toggle1.GetValue())

Slider1.SetValue(75)
print("Slider value:", Slider1.GetValue())

Dropdown1.SetValue("Option3")
print("Dropdown value:", Dropdown1.GetValue())

FlyKeybind.SetKey(Enum.KeyCode.G)
print("Fly key:", FlyKeybind.GetKey().Name)

PlayerColor.SetColor(Color3.fromRGB(0, 255, 0))
print("Player color:", PlayerColor.GetColor())

Radio1.SetValue("Mode3")
print("Radio value:", Radio1.GetValue())

Library:Notify("Welcome", "Script loaded successfully!", 5)
