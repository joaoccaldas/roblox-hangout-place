-- Customization System Script
-- Handles avatar and environment customization

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local CustomizeRemote = Remotes:WaitForChild("CustomizeRequest")

local CUSTOMIZATION = {}

-- Available customization options
CUSTOMIZATION.OPTIONS = {
    AVATAR = {
        accessories = {
            {id = 1, name = "Sun Glasses", cost = 50},
            {id = 2, name = "Top Hat", cost = 100},
            {id = 3, name = "Crown", cost = 200},
            {id = 4, name = "Party Hat", cost = 75},
            {id = 5, name = "Visor", cost = 60},
            {id = 6, name = "Earmuffs", cost = 80}
        },
        clothing = {
            {id = 1, name = "Hawaiian Shirt", cost = 120},
            {id = 2, name = "Tuxedo", cost = 250},
            {id = 3, name = "Superhero Costume", cost = 300},
            {id = 4, name = "Space Suit", cost = 400},
            {id = 5, name = "Cowboy Outfit", cost = 180}
        },
        animations = {
            {id = 1, name = "Wave Dance", cost = 100},
            {id = 2, name = "Robot Dance", cost = 150},
            {id = 3, name = "Floss Dance", cost = 75},
            {id = 4, name = "Celebration Dance", cost = 200}
        }
    },
    ENVIRONMENT = {
        furniture = {
            {id = 1, name = "Cozy Sofa", cost = 300},
            {id = 2, name = "Coffee Table", cost = 150},
            {id = 3, name = "Lamp", cost = 100},
            {id = 4, name = "Bookshelf", cost = 250},
            {id = 5, name = "Plant Pot", cost = 80}
        },
        decorations = {
            {id = 1, name = "Balloon", cost = 20},
            {id = 2, name = "Banner", cost = 50},
            {id = 3, name = "Confetti Cannon", cost = 150},
            {id = 4, name = "Disco Ball", cost = 300},
            {id = 5, name = "Fireworks", cost = 200}
        }
    }
}

-- Player customization data
CUSTOMIZATION.PlayerData = {}

-- Initialize customization system
function CUSTOMIZATION.Initialize()
    print("Customization system initialized")
    
    -- Setup remote event connections
    CustomizeRemote.OnServerEvent:Connect(function(player, action, ...)
        CUSTOMIZATION.HandleRequest(player, action, ...)
    end)
    
    -- Initialize player data
    Players.PlayerAdded:Connect(function(player)
        CUSTOMIZATION.InitializePlayerData(player)
    end)
    
    -- Cleanup when player leaves
    Players.PlayerRemoving:Connect(function(player)
        CUSTOMIZATION.CleanupPlayerData(player)
    end)
    
    print("Customization system ready!")
end

-- Initialize player data
function CUSTOMIZATION.InitializePlayerData(player)
    CUSTOMIZATION.PlayerData[player.UserId] = {
        ownedItems = {
            accessories = {},
            clothing = {},
            animations = {},
            furniture = {},
            decorations = {}
        },
        equippedItems = {
            accessories = {},
            clothing = {}
        },
        currency = 1000 -- Starting currency
    }
    
    print("Initialized customization data for " .. player.Name)
end

-- Cleanup player data
function CUSTOMIZATION.CleanupPlayerData(player)
    CUSTOMIZATION.PlayerData[player.UserId] = nil
    print("Cleaned up customization data for " .. player.Name)
end

-- Handle customization requests
function CUSTOMIZATION.HandleRequest(player, action, ...)
    local args = {...}
    
    if action == "buy" then
        local category, itemId = args[1], args[2]
        CUSTOMIZATION.BuyItem(player, category, itemId)
    elseif action == "equip" then
        local category, itemId = args[1], args[2]
        CUSTOMIZATION.EquipItem(player, category, itemId)
    elseif action == "unequip" then
        local category, itemId = args[1], args[2]
        CUSTOMIZATION.UnequipItem(player, category, itemId)
    elseif action == "getCatalog" then
        CUSTOMIZATION.SendCatalog(player)
    elseif action == "getPlayerData" then
        CUSTOMIZATION.SendPlayerData(player)
    end
end

-- Buy an item
function CUSTOMIZATION.BuyItem(player, category, itemId)
    local playerData = CUSTOMIZATION.PlayerData[player.UserId]
    if not playerData then
        warn("No player data found for " .. player.Name)
        return
    end
    
    local item = nil
    local itemCategory = nil
    
    -- Find the item in the catalog
    if category == "accessory" then
        for _, accessory in ipairs(CUSTOMIZATION.OPTIONS.AVATAR.accessories) do
            if accessory.id == itemId then
                item = accessory
                itemCategory = "accessories"
                break
            end
        end
    elseif category == "clothing" then
        for _, cloth in ipairs(CUSTOMIZATION.OPTIONS.AVATAR.clothing) do
            if cloth.id == itemId then
                item = cloth
                itemCategory = "clothing"
                break
            end
        end
    elseif category == "animation" then
        for _, anim in ipairs(CUSTOMIZATION.OPTIONS.AVATAR.animations) do
            if anim.id == itemId then
                item = anim
                itemCategory = "animations"
                break
            end
        end
    elseif category == "furniture" then
        for _, furn in ipairs(CUSTOMIZATION.OPTIONS.ENVIRONMENT.furniture) do
            if furn.id == itemId then
                item = furn
                itemCategory = "furniture"
                break
            end
        end
    elseif category == "decoration" then
        for _, decor in ipairs(CUSTOMIZATION.OPTIONS.ENVIRONMENT.decorations) do
            if decor.id == itemId then
                item = decor
                itemCategory = "decorations"
                break
            end
        end
    end
    
    if not item then
        print(player.Name .. " tried to buy invalid item: " .. tostring(itemId))
        return
    end
    
    -- Check if player can afford the item
    if playerData.currency >= item.cost then
        -- Deduct cost
        playerData.currency = playerData.currency - item.cost
        
        -- Add to owned items
        table.insert(playerData.ownedItems[itemCategory], item.id)
        
        print(player.Name .. " bought " .. item.name .. " for " .. item.cost .. " currency")
        
        -- Send confirmation to player
        CustomizeRemote:FireClient(player, "purchaseSuccess", item, playerData.currency)
    else
        print(player.Name .. " cannot afford " .. item.name)
        CustomizeRemote:FireClient(player, "purchaseFailed", item, "Not enough currency")
    end
end

-- Equip an item
function CUSTOMIZATION.EquipItem(player, category, itemId)
    local playerData = CUSTOMIZATION.PlayerData[player.UserId]
    if not playerData then
        warn("No player data found for " .. player.Name)
        return
    end
    
    local categoryMap = {
        accessory = "accessories",
        clothing = "clothing"
    }
    
    local equipCategory = categoryMap[category]
    if not equipCategory then
        print(player.Name .. " tried to equip invalid category: " .. category)
        return
    end
    
    -- Check if player owns the item
    local ownsItem = false
    for _, ownedId in ipairs(playerData.ownedItems[equipCategory]) do
        if ownedId == itemId then
            ownsItem = true
            break
        end
    end
    
    if not ownsItem then
        print(player.Name .. " doesn't own item " .. itemId)
        CustomizeRemote:FireClient(player, "equipFailed", "You don't own this item")
        return
    end
    
    -- Equip the item
    table.insert(playerData.equippedItems[equipCategory], itemId)
    
    print(player.Name .. " equipped item " .. itemId)
    CustomizeRemote:FireClient(player, "equipSuccess", category, itemId)
end

-- Unequip an item
function CUSTOMIZATION.UnequipItem(player, category, itemId)
    local playerData = CUSTOMIZATION.PlayerData[player.UserId]
    if not playerData then
        warn("No player data found for " .. player.Name)
        return
    end
    
    local categoryMap = {
        accessory = "accessories",
        clothing = "clothing"
    }
    
    local equipCategory = categoryMap[category]
    if not equipCategory then
        print(player.Name .. " tried to unequip invalid category: " .. category)
        return
    end
    
    -- Find and remove the item from equipped items
    for i, equippedId in ipairs(playerData.equippedItems[equipCategory]) do
        if equippedId == itemId then
            table.remove(playerData.equippedItems[equipCategory], i)
            break
        end
    end
    
    print(player.Name .. " unequipped item " .. itemId)
    CustomizeRemote:FireClient(player, "unequipSuccess", category, itemId)
end

-- Send catalog to player
function CUSTOMIZATION.SendCatalog(player)
    CustomizeRemote:FireClient(player, "catalog", CUSTOMIZATION.OPTIONS)
end

-- Send player data to player
function CUSTOMIZATION.SendPlayerData(player)
    local playerData = CUSTOMIZATION.PlayerData[player.UserId]
    if playerData then
        CustomizeRemote:FireClient(player, "playerData", playerData)
    end
end

-- Get player's equipped items
function CUSTOMIZATION.GetEquippedItems(player)
    local playerData = CUSTOMIZATION.PlayerData[player.UserId]
    if playerData then
        return playerData.equippedItems
    end
    return nil
end

-- Initialize the customization system
CUSTOMIZATION.Initialize()

return CUSTOMIZATION