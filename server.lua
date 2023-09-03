if not lib then return end

local Utils = require 'modules.utils.shared'
require 'modules.givelic.server'
ESX = exports['es_extended']:getSharedObject()

if Shared.debug == 1 then
    local message = string.format("The resource %s was started with debug-mode enabled! If you want to turn it of add the following to your 'server.cfg': 'set licenses:debug 0'", GetCurrentResourceName())
    warn(message)
end



