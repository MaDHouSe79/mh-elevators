local Translations = {
    error = {
        ['no_access'] = "No tienes acceso a este ascensor",
    },
    menu = {
        ['elevator']     = "Ascensor",
        ['use_elevator'] = "Utilice el ascensor desde el piso %{level}",
        ['close_menu']   = "Cerrar menú",
        ['floor']        = "Piso %{level}",
    },
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
