--[[ ===================================================== ]] --
--[[            MH Elevators Script by MaDHouSe            ]] --
--[[ ===================================================== ]] --
local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = {}
local inElevatorZone = false

local function isAuthorizedToFloor(authorizedList)
    for _, job in pairs(authorizedList) do
        if job == "public" then
            return true
        elseif job == PlayerData.job.name then
            return true
        elseif job == PlayerData.gang.name then
            return true
        end
    end
    return false
end

local function isAuthorized(authorizedList)
    for _, job in pairs(authorizedList) do
        if job == "public" then
            return true
        elseif job == PlayerData.job.name then
            return true
        elseif job == PlayerData.gang.name then
            return true
        end
    end
    return false
end

local function ElevatorMenu(data)
    local authorized = isAuthorized(data.authorized)
    if authorized then
        local categoryMenu = {{
            header = Lang:t('menu.elevator', {
                label = data.menu
            }),
            isMenuHeader = true
        }}
        for key, floor in pairs(Config.Elevators[data.elevator]['floors']) do
            if data.level ~= key then
                local authorizedToFloor = isAuthorizedToFloor(floor.authorized)
                if authorizedToFloor then
                    categoryMenu[#categoryMenu + 1] = {
                        header = Lang:t('menu.floor', {
                            level = key,
                            name = floor.name
                        }),
                        params = {
                            event = 'qb-elevators:client:useElevator',
                            args = {
                                level = key,
                                location = data.elevator,
                                coords = floor.coords,
                                heading = floor.heading,
                                tpVehicle = floor.tpVehicle
                            }
                        }
                    }
                end
            end
        end
        if Config.UseTableSort then
            table.sort(categoryMenu, function(a, b)
                if a.params and b.params then
                    return a.params.args.level < b.params.args.level
                end
            end)
        else
            table.sort(categoryMenu, function(a, b)
                if a.params and b.params then
                    return b.params.args.level < a.params.args.level
                end
            end)
        end
        categoryMenu[#categoryMenu + 1] = {
            header = Lang:t('menu.close_menu'),
            params = {
                event = ''
            }
        }
        exports['qb-menu']:openMenu(categoryMenu)
    else
        QBCore.Functions.Notify(Lang:t('error.no_access'))
    end
end

local function UseElevator(data)
    local ped = PlayerPedId()
    local vehicle = nil
    if data.tpVehicle and IsPedInAnyVehicle(ped) then
        vehicle = GetVehiclePedIsIn(ped)
    end
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Wait(10)
    end
    RequestCollisionAtCoord(data.coords.x, data.coords.y, data.coords.z)
    while not HasCollisionLoadedAroundEntity(ped) do
        Wait(0)
    end
    if data.tpVehicle and vehicle ~= nil then
        SetEntityCoords(vehicle, data.coords.x, data.coords.y, data.coords.z, false, false, false, true)
        SetEntityHeading(vehicle, data.heading)
    else
        SetEntityCoords(ped, data.coords.x, data.coords.y, data.coords.z, false, false, false, false)
        SetEntityHeading(ped, data.heading)
    end
    Wait(1000)
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "elevator-ding", 0.5)
    Wait(1500)
    DoScreenFadeIn(500)
end

local listen = false
local function Listen4Control(data)
    CreateThread(function()
        if LocalPlayer.state.isLoggedIn then
            listen = true
            while listen do
                if IsControlJustPressed(0, 38) and inElevatorZone then -- E
                    ElevatorMenu(data)
                    listen = false
                    break
                end
                Wait(1)
            end
        end
    end)
end

function PrepareElevatorMenu()
    if Config.UseTarget then
        for key, floors in pairs(Config.Elevators) do
            for index, floor in pairs(floors['floors']) do
                exports["qb-target"]:RemoveZone(index .. key)
                exports["qb-target"]:AddBoxZone(index .. key, floor.coords, 5, 4, {
                    name = index,
                    heading = floor.heading,
                    debugPoly = false,
                    minZ = floor.coords.z - 1.0,
                    maxZ = floor.coords.z + 1.0
                }, {
                    options = {{
                        event = "qb-elevators:client:elevatorMenu",
                        icon = "fas fa-hand-point-up",
                        label = Lang:t('menu.use_elevator', {
                            level = index
                        }),
                        elevator = key,
                        level = index,
                        menu = floors.blip.label,
                        authorized = floors.authorized
                    }},
                    distance = 2.5
                })
            end
        end
    else
        for i, floors in pairs(Config.Elevators) do
            for index, floor in pairs(floors['floors']) do
                LiftZone = BoxZone:Create(floor.coords, 2.0, 2.0, {
                    heading = floor.heading,
                    minZ = floor.coords.z - 1.0,
                    maxZ = floor.coords.z + 1.0,
                    debugPoly = false,
                    name = index .. i
                })
                LiftZone:onPlayerInOut(function(isPointInside)
                    if isPointInside then
                        exports['qb-core']:DrawText(Lang:t('menu.popup'))
                        local data = {
                            elevator = i,
                            level = index,
                            menu = floors.blip.label,
                            authorized = floors.authorized
                        }
                        inElevatorZone = true
                        Listen4Control(data)
                    else
                        if inElevatorZone then
                            exports['qb-core']:HideText()
                        end
                        inElevatorZone = false
                        listen = false
                    end
                end)
            end
        end
    end
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
    PrepareElevatorMenu()
end)

RegisterNetEvent('QBCore:Player:SetPlayerData', function(data)
    PlayerData = data
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
    PlayerData.job = job
    PrepareElevatorMenu()
end)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        PlayerData = QBCore.Functions.GetPlayerData()
        PrepareElevatorMenu()
    end
end)

RegisterNetEvent('qb-elevators:client:useElevator', function(data)
    UseElevator(data)
    exports['qb-core']:HideText()
end)

RegisterNetEvent('qb-elevators:client:elevatorMenu', function(data)
    ElevatorMenu(data)
    exports['qb-core']:HideText()
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
