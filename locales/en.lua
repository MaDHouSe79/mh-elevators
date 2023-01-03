--[[ ===================================================== ]]--
--[[            MH Elevators Script by MaDHouSe            ]]--
--[[ ===================================================== ]]--

local Translations = {
    error = {
        ['no_access'] = "You are not authorized to use this elevator.",
    },
    menu = {
        ['popup']        = "[E] - Elevator",
        ['elevator']     = "%{label}",
        ['use_elevator'] = "Use the elevator on the floor %{level}",
        ['close_menu']   = "Close menu",
        ['floor']        = "Floor %{level} %{name}",
    },
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
