Items = {}

Items.CanCarryItem = function(playerId, itemName, itemCount, metaData)
    return exports.ox_inventory:CanCarryItem(playerId, itemName, itemCount, metaData)
end

Items.AddItem = function(playerId, itemName, itemCount, metaData)
    exports.ox_inventory:AddItem(playerId, itemName, itemCount, metaData)
end

return Items