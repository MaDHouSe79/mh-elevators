local Translations = {
    error = {
        ['no_access'] = "You do not have access to this elevator",
    },
    menu = {
        ['elevator']     = "Lift",
        ['use_elevator'] = "Use the elevator from %{level}",
        ['close_menu']   = "Close menu",
        ['floor']        = "Floor %{level}",
    },
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})