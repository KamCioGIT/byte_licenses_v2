Shared = {
    debug = GetConvarInt('licenses:debug', 1),
}

if IsDuplicityVersion() then
    Server = {}
else
    Client = {}
end

if lib.context == 'server' then
    return require 'server'
end

require 'client'