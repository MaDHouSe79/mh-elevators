--[[ ===================================================== ]]--
--[[          QBCore Elevators Script by MaDHouSe          ]]--
--[[ ===================================================== ]]--

Config = {}

Config.CheckForUpdates  = true

Config.UseTableSort = false
Config.ShowBlips = true

Config.UseTarget = false 

Config.Elevators = {

    ['pillbox_hospital_elevator'] = {

        ['authorized'] = {"police", "ambulance"}, -- job or gang or public

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
                coords = vector3(332.0970, -595.5458, 43.2841),
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

        ['authorized'] = {"public"}, -- job or gang or public

        ['blip'] = {
            ['label'] = "Red Garage Elevator",
            ['show'] = false,
            ['coords'] = vector3(-322.65, -774.91, 33.96),
            ['sprite'] = 728,
            ['colour'] = 44,
            ['scale'] = 0.8,
        },

        ['floors'] = {
            [0] = { -- ground floor
                coords = vector3(-322.65, -774.91, 33.96),
                heading = 48.92,
                tpVehicle = false,
            },

            [1] = { 
                coords = vector3(-322.5, -774.88, 38.78),
                heading = 48.83,
                tpVehicle = false,
            },

            [2] = {
                coords = vector3(-322.43, -774.9, 43.61),
                heading = 47.51,
                tpVehicle = false,
            },

            [3] = { -- roof
                coords = vector3(-322.37, -774.92, 53.25),
                heading = 41.19,
                tpVehicle = false,
            },
        }

    },

    ['maze_bank_vehicle_elevator'] = {

        ['authorized'] = {"public"}, -- job or gang or public

        ['blip'] = {
            ['label'] = "Maze Bank Vehicle Lift",
            ['show'] = false,
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

    ['politieburo_elevator'] = {

        ['authorized'] = {"police", "ambulance"}, -- job or gang or public

        ['blip'] = {
            ['label'] = "Politie Elevator",
            ['show'] = false,
            ['coords'] = vector3(-1097.7673, -848.4358, 4.8841),
            ['sprite'] = 728,
            ['colour'] = 44,
            ['scale'] = 0.8,
        },

        ['floors'] = {
            [0] = { -- basement
                coords = vector3(-1097.7673, -848.4358, 4.8841),
                heading = 39.1039,
                tpVehicle = false,
            },

            [1] = { -- floor 
                coords = vector3(-1097.7006, -848.4302, 10.2769),
                heading = 39.2713,
                tpVehicle = false,
            },

            [2] = { -- floor 
                coords = vector3(-1097.6643, -848.4446, 13.6870),
                heading = 45.6027,
                tpVehicle = false,
            },

            [3] = { -- floor 
                coords = vector3(-1097.5712, -848.4559, 19.0014),
                heading = 39.5547,
                tpVehicle = false,
            },

            [4] = { -- floor 
                coords = vector3(-1097.6392, -848.3046, 26.8274),
                heading = 46.6716,
                tpVehicle = false,
            },

            [5] = { -- floor 
                coords = vector3(-1097.5714, -848.4492, 30.7570),
                heading = 41.9310,
                tpVehicle = false,
            },

            [6] = { -- floor 
                coords = vector3(-1097.6560, -848.3918, 34.3609),
                heading = 55.6209,
                tpVehicle = false,
            },

            [7] = { -- floor 
                coords = vector3(-1098.0344, -847.9330, 37.7000),
                heading = 45.8382,
                tpVehicle = false,
            },
        }
    },

    ['diamond_casino'] = {

        ['authorized'] = {"public"}, -- job or gang or public

        ['blip'] = {
            ['label'] = "Diamond Casino Elevator",
            ['show'] = false,
            ['coords'] = vector3(960.5756, 43.4318, 71.7007),
            ['sprite'] = 728,
            ['colour'] = 44,
            ['scale'] = 0.8,
        },

        ['floors'] = {
            [0] = { -- basement
                coords = vector3(960.5756, 43.4318, 71.7007), 
                heading = 284.6085,
                tpVehicle = false,
            },

            [1] = { -- ground floor
                coords = vector3(964.9559, 58.6617, 112.5531),
                heading = 80.0243,
                tpVehicle = false,
            },
            [2] = { -- ground floor
                coords = vector3(971.8812, 51.9888, 120.2407),
                heading = 327.7185,
                tpVehicle = false,
            },
        }
    },

}
