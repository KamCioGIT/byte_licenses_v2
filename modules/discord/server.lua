DiscordLogger = {}

DiscordLogger.generateDate = function (months)
    local osDate = os.date('*t')
    local date = osDate.day .. '. ' .. months[tonumber(osDate.month)] .. ' ' .. osDate.year
    return date
end

DiscordLogger.log = function(webhook, title, color, message, pfp, date)
    local Embed = {
        {
            ['color'] = color,
            ['title'] = title,
            ['description'] = '' .. message .. '',
            ['footer'] = {
                ['text'] = date,
            },
        }
    }
    PerformHttpRequest(webhook, function(err, text, headers)
        if Shared.debug == 1 then
            warn('DiscordLogger: ' .. err)
        end
    end, 'POST', json.encode({ username = title, avatar_url = pfp, embeds = Embed }),
        { ['Content-Type'] = 'application/json' })
end

return DiscordLogger
