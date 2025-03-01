local playerCount = 0
local serverInfo = {}

-- Genel Ayarlar
local config = {
    steamAPI = {
        enabled = true,
        key = "YOUR_STEAM_API_KEY" -- Steam Web API anahtarınızı buraya ekleyin
    },
    colors = {
        primary = "#ff1a1a",
        secondary = "#ff4d4d",
        text = "#ffffff",
        textSecondary = "#666666",
        background = "rgba(0, 0, 0, 0.9)",
        backgroundSecondary = "rgba(255, 255, 255, 0.05)"
    },
    socialMedia = {
        discord = {
            link = "https://discord.gg/sunucu",
            show = true
        },
        instagram = {
            link = "https://instagram.com/sunucu",
            show = true
        },
        youtube = {
            link = "https://youtube.com/sunucu",
            show = true
        }
    },
    music = {
        enabled = true,
        defaultVolume = 0.2,
        playlist = {
            {name = "Ambient Music", artist = "Artist 1", url = "music1.mp3"},
            {name = "Loading Theme", artist = "Artist 2", url = "music2.mp3"},
            {name = "Background Music", artist = "Artist 3", url = "music3.mp3"}
        }
    },
    rules = {
        {
            icon = "fa-gavel",
            title = "Kural #1",
            description = "Sunucumuzda her türlü hack/hile kullanımı yasaktır!"
        },
        {
            icon = "fa-comment-slash",
            title = "Kural #2",
            description = "Küfür, hakaret ve argo kullanımı yasaktır!"
        },
        {
            icon = "fa-user-shield",
            title = "Kural #3",
            description = "Yetkililere saygılı davranınız!"
        }
    },
    tips = {
        "Sunucumuza hoş geldiniz! Keyifli oyunlar...",
        "Yeni güncellemeler ve etkinlikler için Discord sunucumuza katılın!",
        "Oyun içi destek için F8 tuşuna basabilirsiniz",
        "Arkadaşlarınızı davet ederek ödüller kazanabilirsiniz!"
    },
    animations = {
        loadingBarSpeed = 1.0,
        tipsChangeInterval = 5000,
        rulesChangeInterval = 5000,
        fadeInDuration = 500
    },
    video = {
        volume = 0.1,
        filter = {
            brightness = 0.3,
            contrast = 1.2
        }
    }
}

-- Server bilgilerini al
function GetServerInfo()
    local info = {
        name = GetConvar("sv_hostname", "Unknown"),
        maxPlayers = GetConvarInt("sv_maxclients", 32),
        currentPlayers = playerCount,
        ip = GetConvar("sv_endpoint", "Unknown"),
        uptime = os.time() - serverInfo.startTime,
        config = config -- Config'i de bilgilere ekle
    }
    return info
end

-- Server başlangıç zamanını kaydet
AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    serverInfo.startTime = os.time()
end)

-- Oyuncu sayısını güncelle
AddEventHandler('playerConnecting', function()
    playerCount = playerCount + 1
end)

AddEventHandler('playerDropped', function()
    playerCount = playerCount - 1
    if playerCount < 0 then playerCount = 0 end
end)

-- Client'a server bilgilerini gönder
RegisterServerEvent('loading:requestServerInfo')
AddEventHandler('loading:requestServerInfo', function()
    local source = source
    local info = GetServerInfo()
    TriggerClientEvent('loading:receiveServerInfo', source, info)
end)

-- Her 5 saniyede bir server bilgilerini güncelle
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        local info = GetServerInfo()
        TriggerClientEvent('loading:updateServerInfo', -1, info)
    end
end) 