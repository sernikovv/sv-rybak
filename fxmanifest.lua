fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Sernikov'

shared_script '@ox_lib/init.lua'
shared_script 'config.lua'

client_script 'client/client.lua'
server_script 'server/server.lua'

ui_page 'ui/index.html'

files {
    'ui/index.html',
    'ui/style.css',
    'ui/script.js',
    'ui/fish.png',
}