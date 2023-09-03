Utils = {}

Utils.isPlayerAllowed = function (xPlayer, jobs)
    for _, job in pairs(jobs) do
        if xPlayer.getJob().name == job.name and xPlayer.getJob().grade >= job.grade then
            return true
        end
    end
    return false
end

Utils.getJobsTogether = function (elements, key)
    local jobs, num = {}, 0
    for _, element in pairs(elements) do
        local element_jobs = type(element[key]) == 'table' and element[key] or json.decode(element[key])
        for _, value in pairs(element_jobs) do
            num += 1
            jobs[num] = {
                name = value.name,
                grade = value.grade
            }
        end
    end
    return jobs
end

Utils.findPlayerWithName = function (targetName)
    local xPlayers = ESX.GetExtendedPlayers('name', targetName)
    return xPlayers[1] or nil
end

Utils.getPlayerCoordinates = function (xPlayer)
    return GetEntityCoords(GetPlayerPed(xPlayer.source))
end

Utils.getDistanceBetween = function (origin, destination)
    return #(origin - destination)
end

Utils.formatNearby = function (Other, Trim)
    local string = ''
    for _, value in pairs(Other) do
        string = string == '' and value.label or string.. ' ' ..Trim.. ' ' ..value.label
    end
    return string
end

return Utils