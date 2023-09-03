--[[ FX Information ]]--
fx_version 'cerulean'
games {'gta5'}
use_experimental_fxv2_oal 'yes'
lua54 'yes'

--[[ Resource ]]--
name 'byte_licenses'
author 'ByteScripts | https://bytescripts.tebex.io/ | discord.gg/6XwewsSk9W'
version '2.0'
description 'FiveM License-Script'

--[[ Manifest ]]--
dependencies {
    'es_extended',
    'ox_lib',
    'oxmysql',
    'ox_inventory'
}

shared_scripts {
    '@ox_lib/init.lua',
}

client_script 'init.lua'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'init.lua'
}

files {
    'client.lua',
    'server.lua',
    'modules/**/client.lua',
    'modules/**/shared.lua',
}