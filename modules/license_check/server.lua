local GiveLic = require 'modules.givelic.shared'
local Notify = require 'modules.notify.server'
Check = {}

Check.getItemName = function(type)
    for _, license in pairs(GiveLic.Licenses) do
        if license.Type == type then
            return license.ItemName
        end
    end
    return false
end

Check.hasLicense = function(xPlayer, type, own)
    if own == nil then
        own = false
    end
    if not xPlayer or not type then return false end

    local itemName = Check.getItemName(type)
    if not itemName then return false end
    local items = exports.ox_inventory:Search(xPlayer.source, 1, itemName)
    if items then
        for key, value in pairs(items) do
            if value.metadata.type == type then
                if value.metadata.holder == xPlayer.getName() and own then
                    return true
                elseif not own then
                    return true
                end
            end
        end
    end


    return false
end

lib.callback.register('licenses:hasLicense', function (source, type, own)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local hasLicense = Check.hasLicense(xPlayer, type, own)
    return hasLicense
end)

if Shared.debug == 1 then
    warn('Debug-Command: checklicense created')
    lib.addCommand('checklicense', {
        help = 'This is a Debug command',
        params = {
            {
                type = 'string',
                name = 'type'
            },
            {
                type = 'number',
                name = 'own'
            }
        },
        restricted = 'group.admin'
    }, function (source, args, raw)
        local src = source
        local xPlayer = ESX.GetPlayerFromId(src)
        local type = args.type
        local own = args.own == 1 and true or false
        
        Notify.send(xPlayer.source, {
            title = 'DEBUG',
            type = 'info',
            description = ('Player has license: ' ..tostring(Check.hasLicense(xPlayer, type, own)))
        })
    end)
end
