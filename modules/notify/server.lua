Notify = {}

Notify.send = function (src, data)
    TriggerClientEvent('ox_lib:notify', src, data)
end

Notify.sendToFaction = function(jobName, data)
    local xPlayers = ESX.GetExtendedPlayers('job', jobName)
    for _, xPlayer in pairs(xPlayers) do
        Notify.send(xPlayer.source, data)
    end
end

return Notify