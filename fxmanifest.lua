fx_version 'cerulean'
game 'gta5'

version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'cl_main.lua',
    '@qbx_core/modules/playerdata.lua',
}

server_scripts { 'sv_main.lua' }

files {
    'data/*.lua',
    'modules/*.lua'
}

dependencies {
    'ox_lib'
}

lua54 'yes'
use_experimental_fxv2_oal 'yes'
