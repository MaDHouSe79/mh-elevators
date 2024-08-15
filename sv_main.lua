lib.addCommand('elevador', {
    help = 'Criar elevadores (somente Admin)',
    restricted = 'group.admin'
}, function(source, args, raw)
    TriggerClientEvent('mri_Q:client:startLiftCreator', source)
end)

local function processData(data)
    local merged = {}

    -- Copiar dados existentes
    for k, v in pairs(Lift.Data) do
        local liftData = {}
        for l, j in ipairs(v) do
            liftData[#liftData + 1] = {
                label = j.label,
                coords = j.coords,
                size = j.size,
                rot = j.rot or 0,
                car = j.car or false,
                job = j.job or ''
            }
        end
        merged[k] = liftData
    end

    -- Adicionar novos dados sem sobrescrever os existentes
    for k, v in pairs(data) do
        if not merged[k] then
            merged[k] = {}
        end
        for l, j in ipairs(v) do
            table.insert(merged[k], {
                label = j.label,
                coords = j.coords,
                size = j.size,
                rot = j.rot or 0,
                car = j.car or false,
                job = j.job or ''
            })
        end
    end

    return merged
end

RegisterNetEvent('mri_Q:server:liftCreatorSave', function(data)
    local mergedData = processData(data)

    local Model = [[
        {
            label = '%s',
            coords = vec3(%f, %f, %f),
            size = vec3(%f, %f, %f),
            rot = %f,
            car = %s,
            job = '%s',
        },
    ]]

    local Models = [[
        %s = {
            %s
        },
    ]]

    local result = {}

    for k, v in pairs(mergedData) do
        local datas = {}
        for _, j in ipairs(v) do
            datas[#datas + 1] = Model:format(j.label, j.coords.x, j.coords.y, j.coords.z, j.size.x, j.size.y, j.size.z, j.rot, tostring(j.car), j.job)
        end
        result[#result + 1] = Models:format(k, table.concat(datas, '\n\t\t\t\t'))
    end
    GlobalState.mri_Q_lift_zone = mergedData

    local serializedData = ('return { \n%s}'):format(table.concat(result, '\n'))

    SaveResourceFile(GetCurrentResourceName(), 'data/lift.lua', serializedData, -1)
    Lift.Data = mergedData
end)

local function removeLiftZone(elevatorName)
    for k, v in pairs(Lift.Data) do
        if k == elevatorName then
            for _, j in ipairs(v) do
                lib.zones.remove(k .. 'lift_zone')
            end
            Lift.Data[k] = nil
            break
        end
    end
end

local function processDataDelete(data, elevatorToDelete)
    local merged = {}
    for k, v in pairs(Lift.Data) do
        local liftData = {}
        for l, j in ipairs(v) do
            liftData[#liftData + 1] = {
                label = j.label,
                coords = j.coords,
                size = j.size,
                rot = j.rot or 0,
                car = j.car or false,
                job = j.job or ''
            }
        end
        merged[k] = liftData
    end

    for k, v in pairs(data) do
        if k ~= elevatorToDelete then
            local liftData = {}
            for l, j in ipairs(v) do
                liftData[#liftData + 1] = {
                    label = j.label,
                    coords = j.coords,
                    size = j.size,
                    rot = j.rot or 0,
                    car = j.car or false,
                    job = j.job or ''
                }
            end
            merged[k] = liftData
        end
    end

    removeLiftZone(elevatorToDelete) -- Chamar a função para remover a zona do elevador

    return merged
end

RegisterNetEvent('mri_Q:server:liftDeleteAndSave', function(data)
    local mergedData = processDataDelete(data)

    local Model = [[
        {
            label = "%s",
            coords = %s,
            size = %s,
            rot = %s,
            car = %s,
            job = '%s',
        },
    ]]

    local Models = [[
        %s = {
            %s
        },
    ]]

    local result = {}

    for k, v in pairs(mergedData) do
        local datas = {}
        for _, j in ipairs(v) do
            datas[#datas + 1] = Model:format(j.label, ('vec3(%s, %s, %s)'):format(j.coords.x, j.coords.y, j.coords.z),
                ('vec3(%s, %s, %s)'):format(j.size.x, j.size.y, j.size.z), j.rot, j.car, j.job)
        end
        result[#result + 1] = Models:format(k, table.concat(datas, '\n\t\t\t\t'))
        datas = {}
    end
    GlobalState.mri_Q_lift_zone = mergedData

    local serializedData = ('return { \n%s}'):format(table.concat(result, '\n'))

    SaveResourceFile(GetCurrentResourceName(), 'data/lift.lua', serializedData, -1)
    Lift.Data = mergedData
end)

function processDataDelete(data, elevatorToDelete)
    local result = {}
    for k, v in pairs(data) do
        if k ~= elevatorToDelete then
            result[k] = v
        end
    end
    return result
end

local function sendUpdatedElevatorsToClients()
    local liftData = LoadResourceFile(GetCurrentResourceName(), 'data/lift.lua')
    local elevators = assert(load(liftData))()
    TriggerClientEvent('mri_Q:client:updateElevators', -1, elevators)
end

RegisterNetEvent('mri_Q:server:liftDeleteAndSave', function(data, elevatorToDelete)
    local mergedData = processDataDelete(data, elevatorToDelete)

    local Model = [[
        {
            label = "%s",
            coords = %s,
            size = %s,
            rot = %s,
            car = %s,
            job = '%s',
        },
    ]]

    local Models = [[
        %s = {
            %s
        },
    ]]

    local result = {}

    for k, v in pairs(mergedData) do
        local datas = {}
        for _, j in ipairs(v) do
            datas[#datas + 1] = Model:format(j.label, ('vec3(%s, %s, %s)'):format(j.coords.x, j.coords.y, j.coords.z),
                ('vec3(%s, %s, %s)'):format(j.size.x, j.size.y, j.size.z), j.rot, j.car, j.job)
        end
        result[#result + 1] = Models:format(k, table.concat(datas, '\n\t\t\t\t'))
        datas = {}
    end
    GlobalState.mri_Q_lift_zone = mergedData

    local serializedData = ('return { \n%s}'):format(table.concat(result, '\n'))

    SaveResourceFile(GetCurrentResourceName(), 'data/lift.lua', serializedData, -1)

    -- Enviar dados atualizados para os clientes
    sendUpdatedElevatorsToClients()
end)

RegisterNetEvent('mri_Q:server:updateElevator', function(data)
    local mergedData = processData(data)

    -- Função para remover duplicações
    local function removeDuplicates(elevatorData)
        local seen = {}
        local uniqueData = {}
        for _, floor in ipairs(elevatorData) do
            local key = floor.label .. floor.coords.x .. floor.coords.y .. floor.coords.z
            if not seen[key] then
                seen[key] = true
                table.insert(uniqueData, floor)
            end
        end
        return uniqueData
    end

    -- Remover duplicações de cada elevador
    for k, v in pairs(mergedData) do
        mergedData[k] = removeDuplicates(v)
    end

    local Model = [[
        {
            label = '%s',
            coords = vec3(%f, %f, %f),
            size = vec3(%f, %f, %f),
            rot = %f,
            car = %s,
            job = '%s',
        },
    ]]

    local Models = [[
        %s = {
            %s
        },
    ]]

    local result = {}

    for k, v in pairs(mergedData) do
        local datas = {}
        for _, j in ipairs(v) do
            datas[#datas + 1] = Model:format(j.label, j.coords.x, j.coords.y, j.coords.z, j.size.x, j.size.y, j.size.z, j.rot, tostring(j.car), j.job)
        end
        result[#result + 1] = Models:format(k, table.concat(datas, '\n\t\t\t\t'))
    end
    GlobalState.mri_Q_lift_zone = mergedData

    local serializedData = ('return { \n%s}'):format(table.concat(result, '\n'))

    SaveResourceFile(GetCurrentResourceName(), 'data/lift.lua', serializedData, -1)    

    -- Enviar dados atualizados para os clientes
    TriggerClientEvent('mri_Q:client:updateElevators', -1, mergedData)
    Lift.Data = mergedData
end)