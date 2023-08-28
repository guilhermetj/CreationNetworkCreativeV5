



fx_version "bodacious"
game "gta5"

shared_script {
	"@vrp/lib/utils.lua",
	"@vrp/lib/vehicles.lua",
	"shared/*.lua",
	"config/*.lua",
}

client_scripts {
	"src/client/cl_client.lua",
}

server_scripts {
	"src/server/*",
}