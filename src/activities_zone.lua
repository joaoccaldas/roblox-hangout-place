-- Activities Zone Script
-- Handles various mini-games and interactive activities

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local ACTIVITIES = {}

-- Mini-game definitions
ACTIVITIES.GAMES = {
    {
        name = "Treasure Hunt",
        description = "Find hidden treasures around the map",
        minPlayers = 1,
        maxPlayers = 4,
        duration = 300 -- 5 minutes
    },
    {
        name = "Obstacle Course",
        description = "Race against others through challenging obstacles",
        minPlayers = 1,
        maxPlayers = 8,
        duration = 180 -- 3 minutes
    },
    {
        name = "Build Challenge",
        description = "Collaborate to build the best structure in limited time",
        minPlayers = 2,
        maxPlayers = 6,
        duration = 600 -- 10 minutes
    }
}

-- Start a specific game
function ACTIVITIES.StartGame(gameName, players)
    local gameDef = nil
    for _, game in pairs(ACTIVITIES.GAMES) do
        if game.name == gameName then
            gameDef = game
            break
        end
    end
    
    if not gameDef then
        warn("Game not found: " .. gameName)
        return false
    end
    
    if #players < gameDef.minPlayers or #players > gameDef.maxPlayers then
        warn("Invalid player count for " .. gameName)
        return false
    end
    
    print("Starting " .. gameName .. " with " .. #players .. " players")
    
    -- Initialize game-specific logic
    if gameName == "Treasure Hunt" then
        ACTIVITIES.StartTreasureHunt(players)
    elseif gameName == "Obstacle Course" then
        ACTIVITIES.StartObstacleCourse(players)
    elseif gameName == "Build Challenge" then
        ACTIVITIES.StartBuildChallenge(players)
    end
    
    return true
end

-- Treasure hunt game
function ACTIVITIES.StartTreasureHunt(players)
    print("Treasure Hunt started!")
    
    -- In actual game: Hide treasures throughout the map
    local treasures = {
        {position = Vector3.new(10, 5, 10), type = "gold_coin"},
        {position = Vector3.new(-15, 3, 8), type = "diamond"},
        {position = Vector3.new(7, 8, -12), type = "gemstone"},
        {position = Vector3.new(-8, 2, -15), type = "ring"},
        {position = Vector3.new(0, 10, 20), type = "crown"}
    }
    
    -- Assign random treasures to players
    for i, player in ipairs(players) do
        local treasure = treasures[i % #treasures + 1]
        print(player.Name .. " is searching for " .. treasure.type)
        
        -- In actual game: Send treasure location to player
    end
end

-- Obstacle course game
function ACTIVITIES.StartObstacleCourse(players)
    print("Obstacle Course started!")
    
    -- Reset player positions to start
    for _, player in ipairs(players) do
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0, 10, 0))
        end
    end
    
    -- Start timer and track winners
    local startTime = tick()
    print("Race begins now!")
    
    -- In actual game: Implement finish detection and timing
end

-- Build challenge game
function ACTIVITIES.StartBuildChallenge(players)
    print("Build Challenge started!")
    
    -- Give players building tools
    for _, player in ipairs(players) do
        -- In actual game: Give building tools or access
        print("Gave building tools to " .. player.Name)
    end
    
    -- Start timer for building phase
    print("Building phase starts now! You have " .. ACTIVITIES.GAMES[3].duration .. " seconds")
    
    -- In actual game: Implement voting system for best build
end

-- Join an activity
function ACTIVITIES.JoinActivity(player, activityName)
    print(player.Name .. " joined " .. activityName)
    
    -- In actual game: Add player to activity queue
    -- Return success or failure
    return true
end

-- Leave an activity
function ACTIVITIES.LeaveActivity(player, activityName)
    print(player.Name .. " left " .. activityName)
    
    -- In actual game: Remove player from activity
end

-- Get available activities
function ACTIVITIES.GetAvailableActivities()
    return ACTIVITIES.GAMES
end

-- Initialize activities system
function ACTIVITIES.Initialize()
    print("Activities system initialized")
    print("Available games: ")
    for _, game in pairs(ACTIVITIES.GAMES) do
        print("- " .. game.name .. ": " .. game.description)
    end
end

-- Start the activities system
ACTIVITIES.Initialize()

return ACTIVITIES