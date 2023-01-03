--[[ ===================================================== ]]--
--[[            MH Elevators Script by MaDHouSe            ]]--
--[[ ===================================================== ]]--

local Translations = {
    error = {
        ['no_access'] = "No está autorizado a utilizar este ascensor.",
    },
    menu = {
        ['popup']        = "[E] - Ascensor",
        ['elevator']     = "%{label}",
        ['use_elevator'] = "Utilice el ascensor desde el piso %{level}",
        ['close_menu']   = "Cerrar menú",
        ['floor']        = "Piso %{level} %{name}",
    },
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
