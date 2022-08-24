--[[ ===================================================== ]]--
--[[          QBCore Elevators Script by MaDHouSe          ]]--
--[[ ===================================================== ]]--

Config = {}

Config.UseTableSort = true
Config.ShowBlips = true

Config.Elevators = {

    ['pillbox_hospital_elevator'] = {

        ['blip'] = {
            ['label'] = "Pillbox Hospital Elevator",
            ['show'] = false,
            ['coords'] = vector3(341.05, -580.84, 28.8),
            ['sprite'] = 728,
            ['colour'] = 44,
            ['scale'] = 0.8,
        },

        ['floors'] = {
            [0] = { -- basement
                coords = vector3(341.05, -580.84, 28.8), 
                heading = 86.6,
                tpVehicle = false,
            },

            [1] = { -- ground floor
                coords = vector3(332.17, -595.61, 43.28),
                heading = 68.44,
                tpVehicle = false,
            },

            [2] = { -- roof
                coords = vector3(339.7, -584.19, 74.16),
                heading = 242.64,
                tpVehicle = false,
            },
        }
    },


    ['red_garage_elevator'] = {

        ['blip'] = {
            ['label'] = "Red Garage Elevator",
            ['show'] = true,
            ['coords'] = vector3(-322.65, -774.91, 33.96),
            ['sprite'] = 728,
            ['colour'] = 44,
            ['scale'] = 0.8,
        },

        ['floors'] = {
            [1] = { -- ground floor
                coords = vector3(-322.65, -774.91, 33.96),
                heading = 48.92,
                tpVehicle = false,
            },

            [2] = { 
                coords = vector3(-322.5, -774.88, 38.78),
                heading = 48.83,
                tpVehicle = false,
            },

            [3] = {
                coords = vector3(-322.43, -774.9, 43.61),
                heading = 47.51,
                tpVehicle = false,
            },

            [4] = { -- roof
                coords = vector3(-322.37, -774.92, 53.25),
                heading = 41.19,
                tpVehicle = false,
            },
        }

    },
 
    ['maze_bank_vehicle_elevator'] = {

        ['blip'] = {
            ['label'] = "Maze Bank Vehicle Elevator",
            ['show'] = true,
            ['coords'] = vector3(-84.03, -820.96, 35.62),
            ['sprite'] = 728,
            ['colour'] = 44,
            ['scale'] = 0.8,
        },

        ['floors'] = {
            [0] = { -- basement
                coords = vector3(-84.03, -820.96, 35.62),
                heading = 349.74,
                tpVehicle = true,
            },

            [1] = { -- floor 
                coords = vector3(-72.34, -813.36, 284.59),
                heading = 160.96,
                tpVehicle = true,
            },
        }
    },
}