-- Transportation System Script
-- Handles teleportation and movement between areas

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local TRANSPORT = {}

-- Location definitions
TRANSPORT.LOCATIONS = {
    {
        name = "Main Hub",
        position = Vector3.new(0, 0, 0),
        description = "Central meeting area",
        teleportCost = 0
    },
    {
        name = "Beach Area",
        position = Vector3.new(50, 5, 30),
        description = "Relaxing beach with water activities",
        teleportCost = 10
    },
    {
        name = "Mountain Top",
        position = Vector3.new(-40, 50, -20),
        description = "Scenic mountain view",
        teleportCost = 15
    },
    {
        name = "Space Station",
        position = Vector3.new(20, 100, 60),
        description = "Zero-gravity adventure",
        teleportCost = 25
    },
    {
        name = "Underwater Cave",
        position = Vector3.new(-30, -20, 40),
        description = "Mysterious underwater exploration",
        teleportCost = 20
    },
    {
        name = "Arcade Zone",
        position = Vector3.new(35, 5, -45),
        description = "Classic arcade games",
        teleportCost = 10
    }
}

-- Initialize transport system
function TRANSPORT.Initialize()
    print("Transportation system initialized")
    print("Available locations:")
    
    for i, location in ipairs(TRANSPORT.LOCATIONS) do
        print(string.format("%d. %s (%s) - Cost: %d", 
            i, location.name, location.description, location.teleportCost))
    end
end

-- Teleport player to location
function TRANSPORT.TeleportPlayer(player, locationName)
    local targetLocation = nil
    
    -- Find the location
    for _, location in ipairs(TRANSPORT.LOCATIONS) do
        if location.name:lower() == locationName:lower() then
            targetLocation = location
            break
        end
    end
    
    if not targetLocation then
        warn("Location not found: " .. locationName)
        return false
    end
    
    -- Check if player has enough resources (simplified)
    -- In actual game: Check player's currency
    local hasResources = true -- Simplified for now
    
    if not hasResources then
        print(player.Name .. ", you don't have enough resources to teleport to " .. targetLocation.name)
        return false
    end
    
    -- Perform teleportation
    local character = player.Character
    if not character then
        warn("Player character not found for " .. player.Name)
        return false
    end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then
        warn("HumanoidRootPart not found for " .. player.Name)
        return false
    end
    
    -- Create teleportation effect
    TRANSPORT.CreateTeleportEffect(humanoidRootPart, targetLocation.position)
    
    -- Actually teleport the player
    humanoidRootPart.CFrame = CFrame.new(targetLocation.position)
    
    print(player.Name .. " teleported to " .. targetLocation.name)
    return true
end

-- Create teleportation visual effect
function TRANSPORT.CreateTeleportEffect(part, targetPosition)
    -- In actual game: Create particle effects, sound, animation
    print("Creating teleportation effect...")
    
    -- Simulate effect with TweenService
    local tweenInfo = TweenInfo.new(
        1, -- Duration
        Enum.EasingStyle.Quad, -- Easing style
        Enum.EasingDirection.Out, -- Easing direction
        0, -- Repeat count
        false, -- Reverses
        0 -- Delay time
    )
    
    local goal = {}
    goal.CFrame = CFrame.new(targetPosition)
    
    local tween = TweenService:Create(part, tweenInfo, goal)
    tween:Play()
end

-- Get player's current location
function TRANSPORT.GetCurrentLocation(player)
    local character = player.Character
    if not character then return nil end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return nil end
    
    local currentPosition = humanoidRootPart.Position
    
    -- Find the closest location
    local closestLocation = nil
    local minDistance = math.huge
    
    for _, location in ipairs(TRANSPORT.LOCATIONS) do
        local distance = (currentPosition - location.position).Magnitude
        if distance < minDistance then
            minDistance = distance
            closestLocation = location
        end
    end
    
    return closestLocation, minDistance
end

-- List nearby locations
function TRANSPORT.GetNearbyLocations(player, radius)
    local currentLocation, _ = TRANSPORT.GetCurrentLocation(player)
    if not currentLocation then return {} end
    
    local nearby = {}
    for _, location in ipairs(TRANSPORT.LOCATIONS) do
        local distance = (currentLocation.position - location.position).Magnitude
        if distance <= radius and location.name ~= currentLocation.name then
            table.insert(nearby, {location = location, distance = distance})
        end
    end
    
    -- Sort by distance
    table.sort(nearby, function(a, b)
        return a.distance < b.distance
    end)
    
    return nearby
end

-- Get all locations
function TRANSPORT.GetAllLocations()
    return TRANSPORT.LOCATIONS
end

-- Initialize the transport system
TRANSPORT.Initialize()

return TRANSPORT