fx_version "cerulean"
game "gta5"

title "LB Phone - APP announce"
author "Enzo2991"
lua54 'yes'

shared_script {'@ox_lib/init.lua', 'config.lua'}

client_script "client.lua"

server_scripts {'@oxmysql/lib/MySQL.lua', 'server.lua'}

files {
    "ui/dist/**/*",
    "ui/icon.png"
}

ui_page "ui/dist/index.html"
