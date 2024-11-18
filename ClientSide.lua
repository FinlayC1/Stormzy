-- Client-Side Script: UI and Interaction

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Teams = game:GetService("Teams")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- GitHub link to the server-side script (raw URL)
local serverScriptUrl = "https://raw.githubusercontent.com/your-repo-name/server-side-script/main.lua"

-- Example: Fetch the server-side script content
local success, response = pcall(function()
    return HttpService:GetAsync(serverScriptUrl)
end)

if success then
    print("Server script content fetched successfully:")
    print(response)
else
    warn("Failed to fetch server script: " .. tostring(response))
end

-- Check if RemoteEvent exists or create one
local RemoteEvent = ReplicatedStorage:FindFirstChild("TrollRemoteEvent")
if not RemoteEvent then
    RemoteEvent = Instance.new("RemoteEvent")
    RemoteEvent.Name = "TrollRemoteEvent"
    RemoteEvent.Parent = ReplicatedStorage
end

-- Create and configure UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Panel Frame (rounded corners, gradient)
local PanelFrame = Instance.new("Frame")
PanelFrame.Size = UDim2.new(0, 450, 0, 750)
PanelFrame.Position = UDim2.new(0, 20, 0, 20)
PanelFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
PanelFrame.BorderSizePixel = 0
PanelFrame.BorderRadius = UDim.new(0, 10)
PanelFrame.BackgroundTransparency = 0.3
PanelFrame.Parent = ScreenGui

-- UI title
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Text = "Stormzy - Custom Trolling Panel"
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 24
TitleLabel.TextAlign = Enum.TextXAlignment.Center
TitleLabel.Parent = PanelFrame

-- Function to create player selection dropdowns
local function createPlayerSelectionDropdown(position, size, actionText)
    local Dropdown = Instance.new("Frame")
    Dropdown.Size = size
    Dropdown.Position = position
    Dropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Dropdown.BorderSizePixel = 0
    Dropdown.Parent = PanelFrame

    local actionButton = Instance.new("TextButton")
    actionButton.Size = UDim2.new(1, 0, 0, 40)
    actionButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    actionButton.Text = actionText
    actionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    actionButton.Font = Enum.Font.SourceSans
    actionButton.TextSize = 18
    actionButton.Parent = Dropdown

    actionButton.MouseButton1Click:Connect(function()
        -- Action button clicked, create a dropdown for player selection
        local actions = {"Select All", "Unselect All", "Execute"}
        local actionList = Instance.new("Frame")
        actionList.Size = UDim2.new(0, 380, 0, #actions * 40)
        actionList.Position = UDim2.new(0, 10, 0, 40)
        actionList.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        actionList.BorderSizePixel = 0
        actionList.Parent = Dropdown

        for i, action in ipairs(actions) do
            local actionButton = Instance.new("TextButton")
            actionButton.Size = UDim2.new(1, 0, 0, 40)
            actionButton.Text = action
            actionButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            actionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            actionButton.Font = Enum.Font.SourceSans
            actionButton.TextSize = 18
            actionButton.Parent = actionList

            actionButton.MouseButton1Click:Connect(function()
                RemoteEvent:FireServer(actionText, action)  -- Trigger the action on the server
                actionList:Destroy()  -- Close the dropdown after selecting an action
            end)
        end
    end)
end

-- Player Selection for Kill, Fling, Spaz actions
createPlayerSelectionDropdown(UDim2.new(0, 10, 0, 100), UDim2.new(0, 380, 0, 50), "Select Player for Kill")
createPlayerSelectionDropdown(UDim2.new(0, 10, 0, 150), UDim2.new(0, 380, 0, 50), "Select Player for Fling")
createPlayerSelectionDropdown(UDim2.new(0, 10, 0, 200), UDim2.new(0, 380, 0, 50), "Select Player for Spaz")

-- Dynamic Team Dropdown (gets teams dynamically)
local teamDropdown = Instance.new("Frame")
teamDropdown.Size = UDim2.new(0, 380, 0, 50)
teamDropdown.Position = UDim2.new(0, 10, 0, 300)
teamDropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
teamDropdown.BorderSizePixel = 0
teamDropdown.Parent = PanelFrame

local teamButton = Instance.new("TextButton")
teamButton.Size = UDim2.new(1, 0, 0, 40)
teamButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
teamButton.Text = "Change Team"
teamButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teamButton.Font = Enum.Font.SourceSans
teamButton.TextSize = 18
teamButton.Parent = teamDropdown

teamButton.MouseButton1Click:Connect(function()
    -- Get teams dynamically from the Teams service
    local teams = {}
    for _, team in ipairs(Teams:GetChildren()) do
        if team:IsA("Team") then
            table.insert(teams, team.Name)
        end
    end

    -- Create a dropdown list for team selection
    local teamSelectionList = Instance.new("Frame")
    teamSelectionList.Size = UDim2.new(0, 380, 0, #teams * 40)
    teamSelectionList.Position = UDim2.new(0, 10, 0, 40)
    teamSelectionList.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    teamSelectionList.BorderSizePixel = 0
    teamSelectionList.Parent = teamDropdown

    for _, team in ipairs(teams) do
        local teamButton = Instance.new("TextButton")
        teamButton.Size = UDim2.new(1, 0, 0, 40)
        teamButton.Text = "Change to " .. team
        teamButton.BackgroundColor3 = game:GetService("Teams")[team].TeamColor.Color  -- Dynamic background color
        teamButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        teamButton.Font = Enum.Font.SourceSans
        teamButton.TextSize = 18
        teamButton.Parent = teamSelectionList

        teamButton.MouseButton1Click:Connect(function()
            RemoteEvent:FireServer("ChangeTeam", team)
            teamSelectionList:Destroy()
        end)
    end
end)

-- Fly/No-Clip toggle and speed adjustment
local function toggleFlyNoClip(flySpeed)
    local character = Players.LocalPlayer.Character
    local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

    if humanoidRootPart then
        -- Fly/No-Clip logic for player only
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(5000, 5000, 5000)
        bodyVelocity.Velocity = Vector3.new(0, flySpeed, 0)
        bodyVelocity.Parent = humanoidRootPart
    end
end

-- Button for toggling Fly
local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0, 380, 0, 40)
flyButton.Position = UDim2.new(0, 10, 0, 350)
flyButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
flyButton.Text = "Toggle Fly"
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.Font = Enum.Font.SourceSans
flyButton.TextSize = 18
flyButton.Parent = PanelFrame

flyButton.MouseButton1Click:Connect(function()
    toggleFlyNoClip(50)  -- Adjust fly speed here
end)

-- Screen Flash Effect for Killing (Temporary effect)
local function screenFlash(targetPlayer)
    -- Flash the screen for the target player (black & white flash)
    local flashScreen = Instance.new("Frame")
    flashScreen.Size = UDim2.new(1, 0, 1, 0)
    flashScreen.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    flashScreen.BackgroundTransparency = 0.5
    flashScreen.Parent = targetPlayer.PlayerGui

    -- Flash text (red color, "You got fucked by Stormzy")
    local flashText = Instance.new("TextLabel")
    flashText.Text = "You got fucked by Stormzy"
    flashText.Size = UDim2.new(1, 0, 1, 0)
    flashText.Position = UDim2.new(0, 0, 0, 0)
    flashText.BackgroundTransparency = 1
    flashText.TextColor3 = Color3.fromRGB(255, 0, 0)
    flashText.Font = Enum.Font.Chiller
    flashText.TextSize = 50
    flashText.TextAlign = Enum.TextXAlignment.Center
    flashText.TextYAlignment = Enum.TextYAlignment.Center
    flashText.Parent = flashScreen

    -- Flash effect duration
    wait(0.3)
    flashScreen:Destroy()
end

-- Button for Kill Action
local killButton = Instance.new("TextButton")
killButton.Size = UDim2.new(0, 380, 0, 40)
killButton.Position = UDim2.new(0, 10, 0, 400)
killButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
killButton.Text = "Kill Target"
killButton.TextColor3 = Color3.fromRGB(255, 255, 255)
killButton.Font = Enum.Font.SourceSans
killButton.TextSize = 18
killButton.Parent = PanelFrame

killButton.MouseButton1Click:Connect(function()
    local targetPlayer = -- select your target player from the player list
    screenFlash(targetPlayer)  -- Trigger the screen flash on kill
end)
