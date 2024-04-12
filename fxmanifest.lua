--[[ ===================================================== ]]--
--[[            MH Elevators Script by MaDHouSe            ]]--
--[[ ===================================================== ]]--

fx_version 'cerulean'
game 'gta5'

author 'MaDHouSe'
description 'QB Elevators'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    '@qbx_core/shared/locale.lua',
    'locales/pt-br.lua', -- change en to your language
    'config.lua',
}

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
    'client/main.lua',
}

server_scripts {
    'server/update.lua',
}

lua54 'yes'
