local Translations = {
    error = {
        ['no_access'] = "Je hebt geen toegang tot deze lift",
    },
    menu = {
        ['elevator']     = "Lift",
        ['use_elevator'] = "Gebruik de lift op %{level}",
        ['close_menu']   = "Sluit menu",
        ['floor']        = "Verdieping %{level}",
    },
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})