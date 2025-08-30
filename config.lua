--[[ ===================================================== ]]--
--[[            MH Elevators Script by MaDHouSe            ]]--
--[[ ===================================================== ]]--

Config = {}

Config.UseTableSort = false
Config.ShowBlips = true

Config.DebugPoly = false

-- Use qb-target interactions (don't change this, go to your server.cfg and add: setr UseTarget true)
Config.UseTarget = false--GetConvar('UseTarget', 'false') == 'true'

Config.Elevators = {
    
    ['pillbox_hospital_elevator'] = {

        ['authorized'] = {"public"},

        ['blip'] = {
            ['label'] = "Pillbox Hospital Elevator",
            ['show'] = false,
            ['coords'] = vector3(341.05, -580.84, 28.8),
            ['sprite'] = 728,
            ['colour'] = 44,
            ['scale'] = 0.8,
        },

        ['floors'] = {
            [1] = { -- basement
                name = "floor 1",
                coords = vector3(341.05, -580.84, 28.8), 
                heading = 86.6,
                tpVehicle = false,
                authorized = {"police", "ambulance"},
            },

            [2] = { -- ground floor
                name = "floor 2",
                coords = vector3(332.0970, -595.5458, 43.2841),
                heading = 68.44,
                tpVehicle = false,
                authorized = {"police", "ambulance"},
            },

            [3] = { -- roof
                name = "floor 3",
                coords = vector3(339.7, -584.19, 74.16),
                heading = 242.64,
                tpVehicle = false,
                authorized = {"police", "ambulance"},
            },
        }
    },

    ['red_garage_elevator'] = {

        ['authorized'] = {"public"},

        ['blip'] = {
            ['label'] = "Red Garage Lift",
            ['show'] = false,
            ['coords'] = vector3(-322.65, -774.91, 33.96),
            ['sprite'] = 728,
            ['colour'] = 44,
            ['scale'] = 0.8,
        },

        ['floors'] = {
            [1] = { -- ground floor
                name = "floor 1",
                coords = vector3(-322.65, -774.91, 33.96),
                heading = 48.92,
                tpVehicle = false,
                authorized = {"public"},
            },

            [2] = { 
                name = "floor 2",
                coords = vector3(-322.5, -774.88, 38.78),
                heading = 48.83,
                tpVehicle = false,
                authorized = {"public"},
            },

            [3] = {
                name = "floor 3",
                coords = vector3(-322.43, -774.9, 43.61),
                heading = 47.51,
                tpVehicle = false,
                authorized = {"public"},
            },

            [4] = { -- roof
                name = "floor 4",
                coords = vector3(-322.37, -774.92, 53.25),
                heading = 41.19,
                tpVehicle = false,
                authorized = {"public"},
            },
        }

    },

    ['maze_bank_vehicle_elevator'] = {

        ['authorized'] = {"public"},

        ['blip'] = {
            ['label'] = "Maze Bank Vehicle Lift",
            ['show'] = false,
            ['coords'] = vector3(-84.03, -820.96, 35.62),
            ['sprite'] = 728,
            ['colour'] = 44,
            ['scale'] = 0.8,
        },

        ['floors'] = {
            [1] = { -- basement
                name = "floor 1",
                coords = vector3(-84.03, -820.96, 35.62),
                heading = 349.74,
                tpVehicle = true,
                authorized = {"public"},
            },

            [2] = { -- floor 
                name = "floor 2",
                coords = vector3(-72.34, -813.36, 284.59),
                heading = 160.96,
                tpVehicle = true,
                authorized = {"public"},
            },
        }
    },

    ['politieburo_elevator'] = {

        ['authorized'] = {"public"},

        ['blip'] = {
            ['label'] = "Politie Lift",
            ['show'] = false,
            ['coords'] = vector3(-1097.7673, -848.4358, 4.8841),
            ['sprite'] = 728,
            ['colour'] = 44,
            ['scale'] = 0.8,
        },

        ['floors'] = {
            [1] = { -- basement 
                name = "floor 0",
                coords = vector3(-1097.7673, -848.4358, 4.8841),
                heading = 39.1039,
                tpVehicle = false,
                authorized = {"public"},
            },

            [2] = { -- floor 
                name = "floor 1",
                coords = vector3(-1097.7006, -848.4302, 10.2769),
                heading = 39.2713,
                tpVehicle = false,
                authorized = {"public"},
            },

            [3] = { -- floor 
                name = "floor 2",
                coords = vector3(-1097.6643, -848.4446, 13.6870),
                heading = 45.6027,
                tpVehicle = false,
                authorized = {"public"},
            },

            [4] = { -- floor 
                name = "floor 3",
                coords = vector3(-1097.5712, -848.4559, 19.0014),
                heading = 39.5547,
                tpVehicle = false,
                authorized = {"public"},
            },

            [5] = { -- floor 
                name = "floor 4",
                coords = vector3(-1097.6392, -848.3046, 26.8274),
                heading = 46.6716,
                tpVehicle = false,
                authorized = {"public"},
            },

            [6] = { -- floor 
                name = "floor 5",
                coords = vector3(-1097.5714, -848.4492, 30.7570),
                heading = 41.9310,
                tpVehicle = false,
                authorized = {"public"},
            },

            [7] = { -- floor 
                name = "floor 6",
                coords = vector3(-1097.6560, -848.3918, 34.3609),
                heading = 55.6209,
                tpVehicle = false,
                authorized = {"public"},
            },

            [8] = { -- floor 
                name = "floor 7",
                coords = vector3(-1098.0344, -847.9330, 37.7000),
                heading = 45.8382,
                tpVehicle = false,
                authorized = {"public"},
            },
        }
    },

    ['diamond_casino'] = {

        ['authorized'] = {"public"},

        ['blip'] = {
            ['label'] = "Diamond Casino Lift",
            ['show'] = false,
            ['coords'] = vector3(960.5756, 43.4318, 71.7007),
            ['sprite'] = 728,
            ['colour'] = 44,
            ['scale'] = 0.8,
        },

        ['floors'] = {
            [1] = { -- basement
                name = "floor 1",
                coords = vector3(960.5756, 43.4318, 71.7007), 
                heading = 284.6085,
                tpVehicle = false,
                authorized = {"public"},
            },

            [2] = { -- ground floor
                name = "floor 2",
                coords = vector3(964.9559, 58.6617, 112.5531),
                heading = 80.0243,
                tpVehicle = false,
                authorized = {"public"},
            },
            [3] = { -- ground floor
                name = "floor 3",
                coords = vector3(971.8812, 51.9888, 120.2407),
                heading = 327.7185,
                tpVehicle = false,
                authorized = {"public"},
            },
        }
    },
}
