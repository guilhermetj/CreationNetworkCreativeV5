--client_script "@vrp/lib/lib.lua" --Para remover esta pendencia de todos scripts, execute no console o comando "uninstall"

fx_version 'bodacious'
game 'gta5'

description 'Hospital animations & props @ AjnaMods - All rights reserved'
author 'Team AjnaMods'

client_scripts {
	'config.lua',
	'locale.lua',
	'client/*.lua'
}

server_scripts {
	'config.lua',
	'server/*.lua'
}

data_file 'DLC_ITYP_REQUEST' 'stream/ajnaprops_ems_01.ytyp'              