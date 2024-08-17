local utils = require 'modules.utils'
local liftZone
local QBCore
if Lift.QB then
    QBCore = exports['qb-core']:GetCoreObject()
end

local inZone = nil

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
    -- print(json.encode(data))
    for _, v in ipairs(data) do
        if playerJob == v.job then
            liftOptions[#liftOptions + 1] = {
                title = v.label,
                icon = 'elevator',
                disabled = v.label == inZone,
                onSelect = function()
                    -- SetEntityCoords(cache.ped, v.coords.x, v.coords.y, v.coords.z)
                    UseElevator(v.coords.x, v.coords.y, v.coords.z, v.rot, v.car)
                end
            }
        elseif v.job == '' or nil then
            liftOptions[#liftOptions + 1] = {
                title = v.label,
                icon = 'elevator',
                disabled = v.label == inZone,
                onSelect = function()
                    -- SetEntityCoords(cache.ped, v.coords.x, v.coords.y, v.coords.z)
                    UseElevator(v.coords.x, v.coords.y, v.coords.z, v.rot, v.car)
                end
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
    if car and IsPedInAnyVehicle(cache.ped) then
        vehicle = GetVehiclePedIsIn(cache.ped)
    end
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Wait(10)
    end

    local int = GetInteriorAtCoords(vec3(x, y, z))
    PinInteriorInMemory(int)
    RequestCollisionAtCoord(x, y, z)
    while not HasCollisionLoadedAroundEntity(cache.ped) do
        Wait(0)
    end

    -- while not IsInteriorReady(int) do Wait(0) end
    if car and vehicle ~= nil then
        SetEntityCoords(vehicle, x, y, z, false, false, false, true)
        SetEntityHeading(vehicle, rot)
    else
        SetEntityCoords(cache.ped, x, y, z, false, false, false, false)
        SetEntityHeading(cache.ped, rot)
    end
    Wait(1000)
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "liftSoundBellRing", 0.1)
    Wait(1500)
    DoScreenFadeIn(500)
end

function createLiftZone()
    local liftData = {}
    if type(Lift.Data) ~= "table" then
        -- print("Error: Lift.Data is not a table")
        return
    end

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
                        inZone = j.label
                        lib.showTextUI('[E] ' .. j.label .. ' (' .. string.gsub(k, '_', ' ') .. ')', {
                            icon = 'elevator',
                            iconAnimation = 'bounce'
                        })
                    end
                end,
                onExit = function()
                    inZone = nil
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
    if liftZone ~= nil then
        liftZone = nil
    end

    createLiftZone()
end

local helpText = {('Criador de Elevador  \n'), ('[F] Para adicionar  \n'), ('[Enter] Para salvar  \n'),
                  ('[Backspace] Para cancelar')}

local addedFloor = {}

local function createLiftOptions()
    local playerpos = GetEntityCoords(cache.ped)
    local playerhead = GetEntityHeading(cache.ped)
    local input = lib.inputDialog('Criador de Elevador', {{
        type = 'input',
        label = 'Nome',
        placeholder = '1st Floor',
        required = true
    }, {
        type = 'number',
        label = 'Tamanho',
        placeholder = '2',
        required = false
    }, {
        type = 'select',
        label = 'Veículo (Opcional)',
        placeholder = 'Não',
        required = false,
        options = {{
            value = true,
            label = "Sim"
        }, {
            value = false,
            label = "Não"
        }}
    }, {
        type = 'input',
        label = 'Job (Opcional)',
        placeholder = 'police'
    }})

    if not input then
        return
    end

    local size = {
        x = input[2] or 2,
        y = input[2] or 2,
        z = input[2] or 2
    }

    addedFloor[#addedFloor + 1] = {
        label = input[1],
        coords = playerpos,
        rot = playerhead,
        size = size,
        car = input[3] or false,
        job = input[4] or ''
    }
end

local function onFinishAction()
    local input = lib.inputDialog('Lift Creator', {{
        type = 'input',
        label = 'Nome do Elevador',
        placeholder = 'Delegacia',
        required = true
    }})

    if not input then
        return
    end
    local label = input[1]:gsub(' ', '_')

    local finalLift = {
        [label] = addedFloor
    }

    -- print(json.encode(finalLift, {
    --     indent = true
    -- }))

    TriggerServerEvent('mri_Q:server:liftCreatorSave', finalLift)
    finalLift = {}
    addedFloor = {}
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
        -- isCreatingLift = true
        -- lib.showTextUI(table.concat(helpText))
        lib.registerContext({
            id = 'elevator menu',
            title = 'Elevadores',
            menu = 'menu_gerencial',
            options = {{
                title = 'Listar Elevadores',
                description = 'Lista elevadores existentes',
                icon = 'bars',
                onSelect = function()
                    liftList()
                end
            }, {
                title = 'Criar novo Elevador',
                description = 'Cria um elevador',
                icon = 'hand',
                onSelect = function()
                    liftCreation()
                end
            }}
        })
        lib.showContext('elevator menu')
        -- createLiftThread()
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

function liftCreation()
    -- print('liftCreation function')
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
end

function liftList()
    local liftData = {}
    local elevatorsList = {}
    for location, elevators in pairs(Lift.Data) do
        table.insert(elevatorsList, {
            title = location,
            icon = 'hand',
            onSelect = function()
                liftOptions(location)
            end
        })
    end

    table.insert(elevatorsList, {
        title = 'Criar novo Elevador',
        description = 'Cria um elevador',
        icon = 'hand',
        onSelect = function()
            liftCreation()
        end
    })

    lib.registerContext({
        id = 'elevator_list',
        title = 'Lista de Elevadores',
        menu = 'elevator menu',
        options = elevatorsList
    })

    lib.showContext('elevator_list')
end

function liftOptions(name)
    local liftData = {}

    lib.registerContext({
        id = 'elevator_opts',
        title = 'Editando Elevador',
        description = name,
        menu = 'elevator_list',
        options = {{
            title = 'Mudar Nome',
            description = 'Altera nome do elevador',
            icon = 'signature',
            onSelect = function()
                changeNameElevator(name)
            end
        }, -- {
        --     title = 'Adicionar Andar',
        --     description = 'Adiciona andar ao elevador',
        --     icon = 'plus',
        --     onSelect = function()
        --         addFloorToElevator(name)
        --     end
        -- }, {
        --     title = 'Remover Andar',
        --     description = 'Remove andar do elevador',
        --     icon = 'x',
        --     onSelect = function()
        --         removeFloorFromElevator(name)
        --     end
        -- }, 
        {
            title = 'Teleportar',
            description = 'Teleporta ao elevador',
            icon = 'location-dot',
            onSelect = function()
                teleportElevator(name)
            end
        }, {
            title = 'Excluir Elevador',
            description = 'Exclui elevador',
            icon = 'trash',
            iconColor = 'red',
            onSelect = function()
                deleteElevator(name)
            end
        }}
    })

    lib.showContext('elevator_opts')
end

-- parei aqui
function changeNameElevator(location)
    -- print('change function ' .. location)

    -- Exibe o diálogo para alterar o nome do elevador
    local input = lib.inputDialog('Lift teste', {{
        type = 'input',
        label = 'Nome do Elevador',
        placeholder = 'Delegacia',
        required = true
    }})

    if not input then
        -- print('Input cancelado')
        return
    end

    local result = input[1]

    if result then
        -- Atualiza o nome do elevador
        local newLocation = result

        -- Verifica se o novo nome já existe
        if Lift.Data[newLocation] then
            -- print('O nome do elevador já existe')
            lib.notify({
                title = "Erro",
                description = "O nome do elevador já existe",
                type = "error"
            })
            return
        end

        -- Atualiza o nome do elevador no Lift.Data
        Lift.Data[newLocation] = Lift.Data[location]
        Lift.Data[location] = nil

        -- Log para depuração
        -- print("Nome do elevador alterado de " .. location .. " para " .. newLocation)
        -- print("Dados atualizados: " .. json.encode(Lift.Data))

        -- Chama o evento para salvar as mudanças no servidor
        TriggerServerEvent('mri_Q:server:liftDeleteAndSave', Lift.Data)

        -- Notifica o usuário que o nome do elevador foi alterado
        lib.notify({
            title = "Nome Alterado",
            description = "O nome do elevador em " .. location .. " foi alterado para " .. newLocation,
            type = "success"
        })
    else
        -- print('Nenhum resultado recebido')
    end
end

function teleportElevator(location)
    -- Teleporta o jogador para o elevador selecionado
    -- print("Teleportando para o elevador em: " .. location)
    local elevator = Lift.Data[location][1]
    -- print(json.encode(Lift.Data[location][1], {
    --     indent = true
    -- }))
    SetEntityCoords(cache.ped, elevator.coords.x, elevator.coords.y, elevator.coords.z)
    SetEntityHeading(cache.ped, elevator.rot)
    lib.notify({
        title = "Teleportado",
        description = "Você foi teleportado para o elevador em " .. location,
        type = "success"
    })
end

function deleteElevator(location)
    -- Exibe o diálogo de confirmação antes de excluir
    local result = lib.alertDialog({
        header = "Excluir Elevador",
        content = "Você tem certeza que deseja excluir o elevador em: " .. location .. "?",
        centered = true,
        cancel = true
    })

    if result == 'confirm' then
        -- Cria uma nova tabela sem o local do elevador que está sendo excluído
        local newLiftData = {}

        for loc, elevators in pairs(Lift.Data) do
            if loc ~= location then
                newLiftData[loc] = elevators
            end
        end

        -- print(json.encode(newLiftData, { indent = true }))

        -- Atualiza Lift.Data com a nova tabela que não contém o elevador excluído
        Lift.Data = newLiftData

        -- Log para depuração
        -- print("Elevador excluído: " .. location)
        -- print("Dados atualizados: " .. json.encode(Lift.Data))

        -- Chama o evento para salvar as mudanças no servidor
        TriggerServerEvent('mri_Q:server:liftDeleteAndSave', newLiftData)

        -- Notifica o usuário que o elevador foi excluído
        lib.notify({
            title = "Elevador Excluído",
            description = "O elevador em " .. location .. " foi excluído com sucesso.",
            type = "success"
        })
    else
        -- print("Exclusão cancelada.")
        lib.notify({
            title = 'Cancelado',
            description = 'Exclusão de ' .. location .. ' cancelada.',
            type = 'error'
        })
    end
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    init()
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    init()
end)

AddEventHandler('onResourceStart', function(resource)
    if resource ~= cache.resource then
        return
    end
    init()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    -- if liftZone ~= nil then return end
    if liftZone ~= nil then
        liftZone = nil
    end
    -- for k, v in pairs(liftZone) do
    --     liftZone[k]:remove()
    -- end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= cache.resource then
        return
    end
    if liftZone ~= nil then
        liftZone = nil
    end
    -- for k, v in pairs(liftZone) do
    --     liftZone[k]:remove()
    -- end
end)

RegisterNetEvent('mri_Q:client:updateElevators', function(elevators)
    --print(json.encode(elevators, {
    --    ident = true
    --}))
    --print(json.encode(liftZone, {
    --    ident = true
    --}))
    if type(elevators) ~= "table" then
        --print("Error: elevators is not a table")
        return
    end
    Lift.Data = elevators
    init() -- Recriar as zonas dos elevadores com os dados atualizados
end)

AddStateBagChangeHandler('mri_Q_lift_zone', 'global', function(bagname, key, value)
    if value then
        if type(value) ~= "table" then
            -- print("Error: value is not a table")
            return
        end
        Lift.Data = value
        init()
    end
end)
