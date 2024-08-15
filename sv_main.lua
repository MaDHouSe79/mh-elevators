lib.addCommand('elevador', {
    help = 'Criar elevadores (somente Admin)',
    restricted = 'group.admin'
}, function(source, args, raw)
    TriggerClientEvent('mri_Q:client:startLiftCreator', source)
end)

local processData = function(data)
    local merged = {}
    for k, v in pairs(Lift.Data) do
        local data = {}
        for l, j in ipairs(v) do
            data[#data + 1] = {
                label = j.label,
                coords = j.coords,
                size = j.size,
                rot = j.rot or 0,
                car = j.car or false,
                job = j.job or ''
            }
        end
        merged[k] = data
        data = {}
    end

    for k, v in pairs(data) do
        local data = {}
        for l, j in ipairs(v) do
            data[#data + 1] = {
                label = j.label,
                coords = j.coords,
                size = j.size,
                rot = j.rot or 0,
                car = j.car or false,
                job = j.job or ''
            }
        end
        merged[k] = data
        data = {}
    end
    return merged
end

RegisterNetEvent('mri_Q:server:liftCreatorSave', function(data)
    local mergedData = processData(data)

    print(json.encode(mergedData, { indent = true }))

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
            datas[#datas + 1] = Model:format(
                j.label,
                ('vec3(%s, %s, %s)'):format(j.coords.x, j.coords.y, j.coords.z),
                ('vec3(%s, %s, %s)'):format(j.size.x, j.size.y, j.size.z),
                j.rot,
                j.car,
                j.job
            )
        end
        result[#result + 1] = Models:format(k, table.concat(datas, '\n\t\t\t\t'))
        datas = {}
    end
    GlobalState.mri_Q_lift_zone = mergedData

    local serializedData = ('return { \n%s}'):format(table.concat(result), '\n')

    SaveResourceFile(cache.resource, 'data/lift.lua', serializedData, -1)
end)
