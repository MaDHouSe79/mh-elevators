--[[ ===================================================== ]]--
--[[          QBCore Elevators Script by MaDHouSe          ]]--
--[[ ===================================================== ]]--

fx_version 'cerulean'
game 'gta5'

author 'MaDHouSe'
description 'QB Elevators'
version '1.0.0'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'locales/en.lua', -- change en to your language
    'config.lua',
}

client_scripts {
    'client/main.lua',
}


lua54 'yes'