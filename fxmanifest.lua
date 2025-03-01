fx_version 'cerulean'
game 'gta5'

author 'ArtseeN'
description 'Modern FiveM Loading Screen'
version '1.0.0'

loadscreen 'index.html'

files {
    'index.html',
    'style.css',
    'script.js',
    -- Medya dosyaları
    'background.mp4',
    'logo.png',
    'music/*.mp3',
}

client_scripts {
    'config.lua',
    'client.lua'
}

server_script 'server.lua' 