fx_version 'adamant'
game 'gta5'

ui_page 'html/index.html'

client_scripts {
    "client.lua",
}

server_scripts {
    "@vrp/lib/utils.lua",
    "server.lua"
}

files {
    "html/*",
    "html/imgs/*"
}