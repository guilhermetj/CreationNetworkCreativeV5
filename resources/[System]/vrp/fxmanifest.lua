fx_version "bodacious"
game "gta5"
lua54 "yes"

ui_page "gui/index.html"

client_scripts {
    "config/*",
    "lib/vehicles.lua",
    "lib/itemlist.lua",
    "lib/utils.lua",
    "client/*"
}

server_scripts {
    "config/*",
    "lib/vehicles.lua",
    "lib/itemlist.lua",
    "lib/utils.lua",
    "modules/*"
}

files {
    "lib/*",
    "gui/*"
}