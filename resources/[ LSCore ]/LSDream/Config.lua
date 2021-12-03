Config = {
    PrefixEvent = "LSDream",
    FirstSpawnPoint = {x = 203.0913, y = -923.7607, z = 30.69202},
    DefaultMoney = {bank = 2000, black_money = 0, money = 1000},
    DefaultInventory = {["bread"] = 1, ["water"] = 1}
}

Config.ResourceList = {
    ["chat"] = true,
    ["LSDream"] = true,
    ["loadscreen"] = true,
    ["webpack"] = true,
    ["yarn"] = true
}

Config.AdminGroups = {
    {
        group = "fondator", 
        label = "Fondateur"
    },
    {
        group = "superadmin", 
        label = "Super Admin"
    },
    {
        group = "moderator", 
        label = "Modérateur"
    }
}

Config.BlacklistEvent = {
    "esx_ambulancejob:revive",
}

Config.PropsBlacklist = {
    "prop_quelquechose"
}

Config.VehiclesBlacklist = {
    "rhino"
}

Config.Items = {
    ["bread"] = {
        label = "Pain",
        prop = "prop_bread",
        usable = true
    },
    ["water"] = {
        label = "Eau",
        prop = "prop_water",
        usable = true
    },
}