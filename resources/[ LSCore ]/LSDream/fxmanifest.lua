fx_version "adamant"
game "gta5"

ui_page "required/nui/main.html"

files {
    "required/nui/main.html",
    "required/nui/main.css",
    "required/nui/main.js"
}

shared_scripts {
    "Config.lua",
    "required/fivem/shared/*.lua"
}

client_scripts {
    "RageUI/RMenu.lua",
    "RageUI/menu/RageUI.lua",
    "RageUI/menu/Menu.lua",
    "RageUI/menu/MenuController.lua",
    "RageUI/components/*.lua",
    "RageUI/menu/elements/*.lua",
    "RageUI/menu/items/*.lua",
    "RageUI/menu/panels/*.lua",
    "RageUI/menu/windows/*.lua",

    "required/fivem/client/*.lua",
    "required/nui/*",
    "required/framework/client/*.lua"
}

server_scripts {
    "required/fivem/mysql/oxmysql.js",
    "required/fivem/mysql/wrapper.lua",
    "required/fivem/mysql/MySQL.lua",

    "required/fivem/server/*.lua",
    "required/framework/server/*.lua"
}