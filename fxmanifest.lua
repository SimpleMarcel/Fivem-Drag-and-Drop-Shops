fx_version 'adamant'
game 'gta5'

author 'MarcelSimple'
description 'Simple Shops'
version '1.0.0'

client_scripts {
  'Einstellungen/Simple_Einstellungen.lua',
	'Client/Simple_Client.lua'
}

server_scripts {
  '@mysql-async/lib/MySQL.lua',
  'Einstellungen/Simple_Einstellungen.lua',
  'Einstellungen/Simple_Security.lua',
  'Server/Simple_Server.lua'
}

escrow_ignore {
  'Einstellungen/Simple_Security.lua',
  'Einstellungen/Simple_Einstellungen.lua'
}

ui_page 'UI/SimpleScripts.html'
files {
    'UI/*.*',
    'UI/**/*.*',
    'UI/**/**/*.*'
}

