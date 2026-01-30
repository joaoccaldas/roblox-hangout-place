-- Setup Script for Hangout Place
-- This script sets up the initial configuration for the game

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")

-- Create required folders and modules
local function setupFolders()
    print("Setting up required folders...")
    
    -- Create Modules folder for custom modules
    local modules = Instance.new("Folder")
    modules.Name = "Modules"
    modules.Parent = ReplicatedStorage
    
    -- Create Remotes folder for communication
    local remotes = Instance.new("Folder")
    remotes.Name = "Remotes"
    remotes.Parent = ReplicatedStorage
    
    -- Create Assets folder
    local assets = Instance.new("Folder")
    assets.Name = "Assets"
    assets.Parent = ReplicatedStorage
    
    print("Folders created successfully")
end

-- Create remote events and functions
local function setupRemotes()
    print("Setting up remote events...")
    
    local remotes = ReplicatedStorage:WaitForChild("Remotes")
    
    -- Chat message remote
    local chatMessage = Instance.new("RemoteEvent")
    chatMessage.Name = "ChatMessage"
    chatMessage.Parent = remotes
    
    -- Customize request remote
    local customizeRequest = Instance.new("RemoteEvent")
    customizeRequest.Name = "CustomizeRequest"
    customizeRequest.Parent = remotes
    
    -- Game action remote
    local gameAction = Instance.new("RemoteEvent")
    gameAction.Name = "GameAction"
    gameAction.Parent = remotes
    
    print("Remote events created successfully")
end

-- Configure lighting
local function setupLighting()
    print("Setting up lighting...")
    
    -- Configure ambient light
    Lighting.Ambient = Color3.fromRGB(130, 130, 140)
    Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    
    -- Set up default lighting
    Lighting.TimeOfDay = 14 -- Midday for bright atmosphere
    
    print("Lighting configured")
end

-- Create server-side scripts
local function setupServerScripts()
    print("Setting up server scripts...")
    
    -- Main script
    local mainScript = Instance.new("Script")
    mainScript.Name = "MainScript"
    mainScript.Source = game:GetService("ServerStorage"):FindFirstChild("MainScriptSource") and 
                       game:GetService("ServerStorage"):FindFirstChild("MainScriptSource").Value or ""
    mainScript.Parent = ServerScriptService
    
    -- Social hub script
    local socialHubScript = Instance.new("Script")
    socialHubScript.Name = "SocialHubScript"
    socialHubScript.Source = game:GetService("ServerStorage"):FindFirstChild("SocialHubScriptSource") and 
                            game:GetService("ServerStorage"):FindFirstChild("SocialHubScriptSource").Value or ""
    socialHubScript.Parent = ServerScriptService
    
    -- Activities script
    local activitiesScript = Instance.new("Script")
    activitiesScript.Name = "ActivitiesScript"
    activitiesScript.Source = game:GetService("ServerStorage"):FindFirstChild("ActivitiesScriptSource") and 
                            game:GetService("ServerStorage"):FindFirstChild("ActivitiesScriptSource").Value or ""
    activitiesScript.Parent = ServerScriptService
    
    print("Server scripts created")
end

-- Initialize the hangout place
local function initializeHangoutPlace()
    print("Initializing Hangout Place...")
    
    -- Setup all components
    setupFolders()
    setupRemotes()
    setupLighting()
    setupServerScripts()
    
    print("Hangout Place initialized successfully!")
    
    -- Fire an event to notify clients
    game.ReplicatedStorage.Remotes.ChatMessage:FireAllClients({
        player = nil,
        message = "Welcome to the amazing Hangout Place!",
        color = Color3.fromRGB(255, 215, 0), -- Gold color
        timestamp = tick()
    })
end

-- Run initialization
initializeHangoutPlace()

print("Setup script completed!")