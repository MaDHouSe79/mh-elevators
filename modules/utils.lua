local utils = {}
local QBRadial = {}

function utils.radialAdd(data)
    if Lift.Radial == 'OX' then
        lib.addRadialItem({
            id = data.menuId,
            icon = data.icon,
            label = data.title,
            onSelect = function()
                TriggerEvent(data.event, data.args)
            end
        })
    elseif Lift.Radial == 'QB' then
        QBRadial[data.menuId] = exports['qb-radialmenu']:AddOption({
            id = data.menuId,
            title = data.title,
            icon = data.icon,
            type = 'client',
            event = data.event,
            garage = data.garage,
            shouldClose = true
        }, QBRadial[data.menuId])
    end
end

function utils.radialRemove(menuId)
    if Lift.Radial == 'OX' then
        lib.removeRadialItem(menuId)
    elseif Lift.Radial == 'QB' then
        if QBRadial[id] then
            exports['qb-radialmenu']:RemoveOption(QBRadial[menuId])
        end
    end
end

return utils
