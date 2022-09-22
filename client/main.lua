--[[ ===================================================== ]]--
--[[          QBCore Elevators Script by MaDHouSe          ]]--
--[[ ===================================================== ]]--

local QBCore = exports['qb-core']:GetCoreObject()

local function ElevatorMenu(data)
    local categoryMenu = {
        {
            header = Lang:t('menu.elevator', {level = data.level}),
            isMenuHeader = true
        }
    }

    for key, floor in pairs(Config.Elevators[data.elevator]['floors']) do        
        if data.level ~= key then
            categoryMenu[#categoryMenu + 1] = {
                header = Lang:t('menu.floor', {level = key}),
                params = {
                    event = 'qb-elevators:client:useElevator',
                    args = {
                        level = key,
                        location = data.elevator,
                        coords = floor.coords,
                        heading = floor.heading,
                        tpVehicle = floor.tpVehicle,
                    }
                },
            }
        end
    end
    
    if Config.UseTableSort then
        table.sort(categoryMenu, function (a, b)
            if a.params and b.params then
                return a.params.args.level < b.params.args.level
            end
        end)
    else
        table.sort(categoryMenu, function (a, b)
            if a.params and b.params then
                return b.params.args.level < a.params.args.level
            end
        end)
    end

    categoryMenu[#categoryMenu + 1] = {
        header = Lang:t('menu.close_menu'),
        params = {event = ''}
    }
    exports['qb-menu']:openMenu(categoryMenu)
end

local function UseElevator(data)
    local ped = PlayerPedId()
    local vehicle = nil
    if data.tpVehicle and IsPedInAnyVehicle(ped) then vehicle = GetVehiclePedIsIn(ped) end
    DoScreenFadeOut(500)
	while not IsScreenFadedOut() do Wait(10) end
    RequestCollisionAtCoord(data.coords.x, data.coords.y, data.coords.z)
    while not HasCollisionLoadedAroundEntity(ped) do Wait(0) end
    if data.tpVehicle and vehicle ~= nil then
        SetEntityCoords(vehicle, data.coords.x, data.coords.y, data.coords.z, false, false, false, true)
        SetEntityHeading(vehicle, data.heading)
    else
        SetEntityCoords(ped, data.coords.x, data.coords.y, data.coords.z, false, false, false, false)
        SetEntityHeading(ped, data.heading)
    end
    Wait(1500)
	DoScreenFadeIn(500)
end

RegisterNetEvent('qb-elevators:client:useElevator', function(data)
    UseElevator(data)
end)

RegisterNetEvent('qb-elevators:client:elevatorMenu', function(data)
    ElevatorMenu(data)
end)

CreateThread(function()
    if Config.ShowBlips then
        for key, lift in pairs(Config.Elevators) do
            if lift.blip.show then
                local blip = AddBlipForCoord(lift.blip.coords.x, lift.blip.coords.y, lift.blip.coords.z)
                SetBlipSprite(blip, lift.blip.sprite)
                SetBlipAsShortRange(blip, true)
                SetBlipScale(blip, lift.blip.scale)
                SetBlipColour(blip, lift.blip.colour)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(lift.blip.label)
                EndTextCommandSetBlipName(blip)
            end
        end
    end
end)

CreateThread(function()
    for key, floors in pairs(Config.Elevators) do
        for index, floor in pairs(floors['floors']) do
            exports["qb-target"]:AddBoxZone(index..key, floor.coords, 5, 4, {
                name = index,
                heading = floor.heading,
                debugPoly = false,
                minZ = floor.coords.z - 1.5,
                maxZ = floor.coords.z + 1.5
            },
            {
                options = {
                    {
                        event = "qb-elevators:client:elevatorMenu",
                        icon = "fas fa-hand-point-up",
                        label = Lang:t('menu.use_elevator', {level = index}),
                        elevator = key,
                        level = index
                    },
                },
                distance = 2.0
            })
        end
    end
end)
