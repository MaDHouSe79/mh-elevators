--[[ ===================================================== ]]--
--[[            MH Elevators Script by MaDHouSe            ]]--
--[[ ===================================================== ]]--

local Translations = {
    error = {
        no_access = "Você não está autorizado a usar este elevador.",
    },
    menu = {
        popup = "[E] - Elevador",
        elevator = "%{label}",
        use_elevator = "Usar o elevador",
        close_menu = "Fechar",
        floor = "%{name}",
    },
}

if GetConvar('qb_locale', 'en') == 'pt-br' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end