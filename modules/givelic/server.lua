local GiveLic = require 'modules.givelic.shared'
local Notify = require 'modules.notify.server'
local Items = require 'modules.items.server'
local Utils = require 'modules.utils.shared'

local Logger, DiscordLogger = require 'modules.discord.config', require 'modules.discord.server'


Citizen.CreateThreadNow(function ()
    local jobs = Utils.getJobsTogether(GiveLic.Licenses, 'AllowedJobs')
    Server.jobs = jobs
end)

lib.addCommand(GiveLic.Command, {
    help = GiveLic.CommandHelp,
    params = {
        {
            type = 'string',
            name = 'player',
            help = GiveLic.ParamHelp
        }
    }
}, function (source, args, raw)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then
        return Notify.send(src, {
            title = GiveLic.Notify.Title,
            type = 'error',
            description = GiveLic.Notify.UnkownError
        })
    end

    if not Utils.isPlayerAllowed(xPlayer, Server.jobs) then
        return Notify.send(src, {
            title = GiveLic.Notify.Title,
            type = 'error',
            description = GiveLic.Notify.NoPermission
        })
    end

    if not args.player then
        return Notify.send(src, {
            title = GiveLic.Notify.Title,
            type = 'error',
            description = GiveLic.Notify.TargetNotFound
        })
    end

    local targetName = string.gsub(args.player, '_', ' ')
    if not GiveLic.AllowSelfGive and xPlayer.getName() == targetName then
        return Notify.send(src, {
            title = GiveLic.Notify.Title,
            type = 'error',
            description = GiveLic.Notify.NoSelfGive
        })
    end

    local xTarget = Utils.findPlayerWithName(targetName)
    if not xTarget then
        return Notify.send(src, {
            title = GiveLic.Notify.Title,
            type = 'error',
            description = GiveLic.Notify.TargetNotFound
        })
    end

    if GiveLic.Distance.BetweenPlayers ~= 0.0 and Utils.getDistanceBetween(Utils.getPlayerCoordinates(xPlayer), Utils.getPlayerCoordinates(xTarget)) > GiveLic.Distance.BetweenPlayers then
        return Notify.send(src, {
            title = GiveLic.Notify.Title,
            type = 'error',
            description = GiveLic.Notify.PlayerNotNearby
        })
    end

    if #GiveLic.Distance.Other ~= 0 then
        local isInRange = false
        for _, value in pairs(GiveLic.Distance.Other) do
            if Utils.getDistanceBetween(Utils.getPlayerCoordinates(xPlayer), value.position) <= value.distance then
                isInRange = true
                break
            end
        end

        if not isInRange then
            return Notify.send(src, {
                title = GiveLic.Notify.Title,
                type = 'error',
                description = (GiveLic.Notify.Distance.Nearby):format(Utils.formatNearby(GiveLic.Distance.Other, GiveLic.Notify.Distance.NearbyTrim))
            })
        end
    end

    local options, num = {}, 0
    for _, value in pairs(GiveLic.Licenses) do
        if Utils.isPlayerAllowed(xPlayer, value.AllowedJobs) then
            num += 1
            options[num] = {
                title = value.Label,
                description = (GiveLic.Notify.Menu.Give):format(value.Price),
                icon = value.Icon,
                serverEvent = 'licenses:tryGiveLic',
                args = {xTarget.source, value}
            }
        end
    end

    TriggerClientEvent('licenses:openMenu', xPlayer.source, xTarget.getName(), options)
end)

RegisterServerEvent('licenses:tryGiveLic', function (object)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if not xPlayer then
        return Notify.send(src, {
            title = GiveLic.Notify.Title,
            type = 'error',
            description = GiveLic.Notify.UnkownError
        })
    end

    local xTargetId, license = object[1], object[2]
    if not xTargetId or not license then
        return Notify.send(src, {
            title = GiveLic.Notify.Title,
            type = 'error',
            description = GiveLic.Notify.UnkownError
        })
    end

    local xTarget = ESX.GetPlayerFromId(xTargetId)
    if not xTarget then
        return Notify.send(src, {
            title = GiveLic.Notify.Title,
            type = 'error',
            description = GiveLic.Notify.TargetNotFound
        })
    end

    local issuerName = xPlayer.getName()
    local itemMetaData = {
        holder = xTarget.getName(),
        issuer = issuerName,
        type = license.Type,
        description = (GiveLic.Notify.Item.Description):format(xTarget.getName(), license.Label)
    }

    if not Items.CanCarryItem(xPlayer.source, object[2].ItemName, 1, itemMetaData) then
        return Notify.send(src, {
            title = GiveLic.Notify.Title,
            type = 'error',
            description = GiveLic.Notify.Item.NoPlace
        })
    end

    if object[2].Price ~= 0 and xPlayer.getAccount(GiveLic.AccountName).money < object[2].Price then
        return Notify.send(src, {
            title = GiveLic.Notify.Title,
            type = 'error',
            description = GiveLic.Notify.NotEnoughMoney
        })
    end

    Items.AddItem(xPlayer.source, object[2].ItemName, 1, itemMetaData)

    Notify.sendToFaction(xPlayer.getJob().name, {
        title = xPlayer.getJob().label,
        description = (GiveLic.Notify.Issued.FactionNotify):format(
            xPlayer.getJob().grade,
            xPlayer.getName(),
            xTarget.getName(),
            object[2].Label
        ),
        type = 'info'
    })

    Notify.send(xPlayer.source, {
        title = GiveLic.Notify.Title,
        description = (GiveLic.Notify.Issued.GaveLicense):format(xTarget.getName(), object[2].Label),
        type = 'success'
    })

    Notify.send(xTarget.source, {
        title = GiveLic.Notify.Title,
        description = (GiveLic.Notify.Issued.GotLicense):format(xPlayer.getName(), object[2].Label),
        type = 'success'
    })

    if Logger.UseLogger then
        DiscordLogger.log(Logger.Url, Logger.Title, Logger.Color, (GiveLic.Notify.Issued.FactionNotify):format(
            xPlayer.getJob().grade,
            xPlayer.getName(),
            xTarget.getName(),
            object[2].Label
        ), Logger.Pfp, DiscordLogger.generateDate(Logger.Months))
    end


end)