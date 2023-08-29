fx_version 'bodacious'
game 'gta5'
lua54 'yes'

ui_page 'html/index.html'

client_scripts {
	"@vrp/lib/utils.lua",
	'client/main.lua',
}

shared_scripts {
    'config.lua',
}

files {
	'html/index.html',
	'html/images/*.png',
	'html/sounds/*.mp3',
	'html/sounds/*.wav',
}