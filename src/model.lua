-- Roblox Place Model Definition
-- This file represents the basic structure of the hangout place

local Model = {}

-- Define the main areas of the hangout place
Model.Areas = {
    MainHub = {
        Name = "Main Hub",
        Position = Vector3.new(0, 0, 0),
        Size = Vector3.new(100, 50, 100),
        Description = "Central meeting area with social features"
    },
    BeachArea = {
        Name = "Beach Area",
        Position = Vector3.new(50, 5, 30),
        Size = Vector3.new(80, 30, 80),
        Description = "Relaxing beach with water activities"
    },
    MountainTop = {
        Name = "Mountain Top",
        Position = Vector3.new(-40, 50, -20),
        Size = Vector3.new(60, 40, 60),
        Description = "Scenic mountain view"
    },
    SpaceStation = {
        Name = "Space Station",
        Position = Vector3.new(20, 100, 60),
        Size = Vector3.new(70, 60, 70),
        Description = "Zero-gravity adventure"
    },
    UnderwaterCave = {
        Name = "Underwater Cave",
        Position = Vector3.new(-30, -20, 40),
        Size = Vector3.new(50, 40, 50),
        Description = "Mysterious underwater exploration"
    },
    ArcadeZone = {
        Name = "Arcade Zone",
        Position = Vector3.new(35, 5, -45),
        Size = Vector3.new(60, 30, 60),
        Description = "Classic arcade games"
    }
}

-- Define interactive objects in each area
Model.InteractiveObjects = {
    MainHub = {
        {
            Type = "Seating",
            Name = "Comfortable Sofa",
            Position = Vector3.new(-5, 0, -5),
            Properties = {Color = Color3.fromRGB(255, 200, 150)}
        },
        {
            Type = "Table",
            Name = "Coffee Table",
            Position = Vector3.new(0, 0, -5),
            Properties = {Color = Color3.fromRGB(150, 100, 50)}
        },
        {
            Type = "Decoration",
            Name = "Welcome Sign",
            Position = Vector3.new(0, 5, 0),
            Properties = {Color = Color3.fromRGB(255, 255, 0)}
        }
    },
    BeachArea = {
        {
            Type = "WaterFeature",
            Name = "Swimming Pool",
            Position = Vector3.new(55, 0, 35),
            Properties = {Color = Color3.fromRGB(0, 150, 255)}
        },
        {
            Type = "Seating",
            Name = "Beach Chair",
            Position = Vector3.new(45, 0, 25),
            Properties = {Color = Color3.fromRGB(255, 255, 200)}
        },
        {
            Type = "Decoration",
            Name = "Palm Tree",
            Position = Vector3.new(60, 5, 40),
            Properties = {Height = 20}
        }
    },
    MountainTop = {
        {
            Type = "ViewPoint",
            Name = "Scenic Lookout",
            Position = Vector3.new(-45, 55, -25),
            Properties = {ViewDistance = 1000}
        },
        {
            Type = "Seating",
            Name = "Rock Bench",
            Position = Vector3.new(-35, 50, -15),
            Properties = {Color = Color3.fromRGB(150, 150, 150)}
        }
    }
}

-- Define spawn points
Model.SpawnPoints = {
    {
        Name = "Main Spawn",
        Position = Vector3.new(0, 5, 0),
        Area = "MainHub"
    },
    {
        Name = "Beach Spawn",
        Position = Vector3.new(50, 5, 30),
        Area = "BeachArea"
    },
    {
        Name = "Mountain Spawn",
        Position = Vector3.new(-40, 55, -20),
        Area = "MountainTop"
    }
}

-- Define teleport locations
Model.Teleports = {
    {
        From = "MainHub",
        To = "BeachArea",
        Position = Vector3.new(20, 0, 20),
        Cost = 10
    },
    {
        From = "MainHub", 
        To = "MountainTop",
        Position = Vector3.new(-20, 0, -20),
        Cost = 15
    },
    {
        From = "MainHub",
        To = "SpaceStation", 
        Position = Vector3.new(0, 20, 20),
        Cost = 25
    },
    {
        From = "MainHub",
        To = "UnderwaterCave",
        Position = Vector3.new(20, 0, -20),
        Cost = 20
    },
    {
        From = "MainHub",
        To = "ArcadeZone",
        Position = Vector3.new(-20, 0, 20),
        Cost = 10
    }
}

-- Initialize the model
function Model.Initialize()
    print("Hangout Place Model Initialized")
    print("Areas:", #Model.Areas)
    print("Spawn Points:", #Model.SpawnPoints)
    print("Teleport Locations:", #Model.Teleports)
end

-- Get area by name
function Model.GetAreaByName(name)
    for areaName, areaData in pairs(Model.Areas) do
        if areaData.Name == name then
            return areaData
        end
    end
    return nil
end

-- Get spawn point by area
function Model.GetSpawnPointByArea(areaName)
    for _, spawnPoint in ipairs(Model.SpawnPoints) do
        if spawnPoint.Area == areaName then
            return spawnPoint
        end
    end
    return nil
end

Model.Initialize()

return Model