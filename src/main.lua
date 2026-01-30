-- Main Script for Hangout Place
-- This script handles core functionality

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

-- Configuration
local CONFIG = {
    SPAWN_DELAY = 2,
    MAX_PLAYERS = 50,
    ARENA_NAME = "Hangout Paradise"
}

-- Modules and Remote Events
local Modules = ReplicatedStorage:WaitForChild("Modules")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

-- Player joined handler
local function onPlayerAdded(player)
    print(player.Name .. " joined " .. CONFIG.ARENA_NAME)
    
    -- Wait for player character
    local character = player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Optional: Teleport player to spawn location after delay
    wait(CONFIG.SPAWN_DELAY)
    
    -- Initialize player-specific features
    -- Add to player's backpack, give special items, etc.
end

-- Player left handler
local function onPlayerRemoving(player)
    print(player.Name .. " left " .. CONFIG.ARENA_NAME)
    -- Clean up player-specific items or data
end

-- Connect event handlers
Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

print(CONFIG.ARENA_NAME .. " initialized successfully!")