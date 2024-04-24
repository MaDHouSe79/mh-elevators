local utils = require 'modules.utils'
local liftZone
local QBCore
if Lift.QB then
    QBCore = exports['qb-core']:GetCoreObject()
end

local function addLiftOptions(data, liftName)
    local liftInfo
    for _, v in ipairs(data) do
        for _, j in ipairs(v.liftData) do
            liftInfo = {
                menuId = 'lift_for_' .. v.lift,
                icon = 'elevator',
                title = 'Elevator ' .. string.gsub(v.lift, '_', ' '),
                event = 'mri_Q:client:lift',
                args = v.liftData
            }
            if liftInfo.menuId == liftName then
                if Lift.UseRadial then
                    utils.radialAdd(liftInfo)
                else
                    TriggerEvent("mri_Q:client:lift", v.liftData)
                end
                break
            end
        end
    end
end

RegisterNetEvent('mri_Q:client:lift', function(data)
    local liftOptions = {}
    local playerJob = ''
    local playerCoords = GetEntityCoords(cache.ped)
    if Lift.QB then
        local Player = QBCore.Functions.GetPlayerData()
        playerJob = Player.job.name
    else
        playerJob = QBX.PlayerData.job.name
    end
    print(json.encode(data))
    for _, v in ipairs(data) do
        if playerJob == v.job then
            liftOptions[#liftOptions + 1] = {
                title = v.label,
                icon = 'elevator',
                disabled = GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, v.coords.x, v.coords.y, v.coords.z) <= v.size.x,
                onSelect = function()
                    -- SetEntityCoords(cache.ped, v.coords.x, v.coords.y, v.coords.z)
                    UseElevator(v.coords.x, v.coords.y, v.coords.z, v.rot, v.car)
                end,
            }
        elseif v.job == '' or nil then
            liftOptions[#liftOptions + 1] = {
                title = v.label,
                icon = 'elevator',
                disabled = GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, v.coords.x, v.coords.y, v.coords.z) <= v.size.x,
                onSelect = function()
                    -- SetEntityCoords(cache.ped, v.coords.x, v.coords.y, v.coords.z)
                    UseElevator(v.coords.x, v.coords.y, v.coords.z, v.rot, v.car)
                end,
            }
        end
    end
    lib.registerContext({
        id = 'mri_Q_lift',
        title = 'Escolha o andar',
        options = liftOptions
    })
    lib.showContext('mri_Q_lift')
end)

function UseElevator(x, y, z, rot, car)
    local vehicle = nil
    if car and IsPedInAnyVehicle(cache.ped) then vehicle = GetVehiclePedIsIn(cache.ped) end
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do Wait(10) end
    RequestCollisionAtCoord(x, y, z)
    while not HasCollisionLoadedAroundEntity(cache.ped) do Wait(0) end
    if car and vehicle ~= nil then
        SetEntityCoords(vehicle, x, y, z, false, false, false, true)
        SetEntityHeading(vehicle, rot)
    else
        SetEntityCoords(cache.ped, x, y, z, false, false, false, false)
        SetEntityHeading(cache.ped, rot)
    end
    Wait(1000)
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "liftSoundBellRing", 0.4)
    Wait(1500)
    DoScreenFadeIn(500)
end

local function createLiftZone()
    local liftData = {}
    for k, v in pairs(Lift.Data) do
        table.insert(liftData, {
            lift = k,
            liftData = v
        })
        for _, j in ipairs(v) do
            liftZone = lib.zones.box({
                name = k .. 'lift_zone',
                coords = j.coords,
                size = j.size,
                rotation = j.rot,
                debug = Lift.Debug,
                onEnter = function()
                    if Lift.UseRadial then
                        lib.showTextUI(string.gsub(k, '_', ' ') .. ' | Usar elevador')
                        addLiftOptions(liftData, 'lift_for_' .. k)
                    else
                        lib.showTextUI('[E] Elevador ' ..string.gsub(k, '_', ' '), {icon = 'elevator'})
                    end
                end,
                onExit = function()
                    lib.hideTextUI()
                    utils.radialRemove('lift_for_' .. k)
                end,
                inside = function()
                    if IsControlJustPressed(0, 51) then -- E
                        addLiftOptions(liftData, 'lift_for_' .. k)
                    end
                end
            })
        end
    end
end

local function init()
    -- if liftZone ~= nil then
    --     for i = 1, #liftZone do
    --         liftZone[i]:remove()
    --     end
    -- end
    if liftZone ~= nil then liftZone = nil end

    createLiftZone()
end

local helpText = {
    ('Criador de Elevador  \n'),
    ('[F] Para adicionar  \n'),
    ('[Enter] Para salvar  \n'),
    ('[Backspace] Para cancelar \n')
}

local addedFloor = {}

local function createLiftOptions()
    local playerpos = GetEntityCoords(cache.ped)
    local playerhead = GetEntityHeading(cache.ped)
    local input = lib.inputDialog('Criador de Elevador', {
        { type = 'input',  label = 'Nome',             placeholder = '1st Floor', required = true },
        { type = 'number', label = 'Tamanho',              placeholder = '2',         required = false },
        { type = 'select', label = 'Veículo (Opcional)',  placeholder = 'Não',     required = false, 
            options = {
                {
                    value = true,
                    label = "Sim"
                },
                {
                    value = false,
                    label = "Não"
                },
            },
        },
        { type = 'input',  label = 'Job (Opcional)',    placeholder = 'police' }
    })

    if not input then return end

    local size = {
        x = input[2] or 2,
        y = input[2] or 2,
        z = input[2] or 2,
    }

    addedFloor[#addedFloor + 1] = {
        label = input[1],
        coords = playerpos,
        rot = playerhead,
        size = size,
        car = input[3] or false,
        job = input[4] or '',
    }
end

local function onFinishAction()
    local input = lib.inputDialog('Lift Creator', {
        { type = 'input', label = 'Nome do Elevador', placeholder = 'Delegacia', required = true },
    })

    if not input then return end
    local label = input[1]:gsub(' ', '_')

    local finalLift = {
        [label] = addedFloor
    }

    TriggerServerEvent('mri_Q:server:liftCreatorSave', finalLift)
end

local isCreatingLift = false

local function createLiftThread()
    while isCreatingLift do
        if IsControlJustPressed(0, 23) then -- f
            createLiftOptions()
        end

        if IsControlJustPressed(0, 194) then -- backspace
            isCreatingLift = false
            lib.hideTextUI()
        end

        if IsControlJustPressed(0, 201) then -- enter
            isCreatingLift = false
            lib.hideTextUI()
            onFinishAction()
        end
        Wait(1)
    end
end

RegisterNetEvent('mri_Q:client:startLiftCreator', function()
    if not isCreatingLift then
        isCreatingLift = true
        lib.showTextUI(table.concat(helpText))
        createLiftThread()
    else
        local alert = lib.alertDialog({
            icon = 'warning',
            header = 'Aviso',
            content = 'Você ainda está criando um elevador, CONFIRME para DESATIVAR',
            centered = true,
            cancel = true
        })
        if alert == 'confirm' then
            isCreatingLift = false
            lib.hideTextUI()
        end
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    init()
end)

AddEventHandler('onResourceStart', function(resource)
    if resource ~= cache.resource then return end
    init()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    -- if liftZone ~= nil then return end
    if liftZone ~= nil then liftZone = nil end
    -- for k, v in pairs(liftZone) do
    --     liftZone[k]:remove()
    -- end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= cache.resource then return end
    if liftZone ~= nil then liftZone = nil end
    -- for k, v in pairs(liftZone) do
    --     liftZone[k]:remove()
    -- end
end)

AddStateBagChangeHandler('mri_Q_lift_zone', 'global', function(bagname, key, value)
    if value then
        Lift.Data = value
        init()
    end
end)
