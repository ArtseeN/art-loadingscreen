Config = {}

-- Genel Ayarlar
Config.ServerName = "Sunucu İsmi"
Config.MaxPlayers = 32
Config.BackgroundVideo = "background.mp4"
Config.Logo = "logo.png"

-- Renk Ayarları
Config.Colors = {
    primary = "#ff1a1a", -- Ana renk (Örn: loading bar, butonlar)
    secondary = "#ff4d4d", -- İkincil renk
    text = "#ffffff", -- Yazı rengi
    textSecondary = "#666666", -- İkincil yazı rengi
    background = "rgba(0, 0, 0, 0.9)", -- Arkaplan rengi
    backgroundSecondary = "rgba(255, 255, 255, 0.05)" -- İkincil arkaplan rengi
}

-- Sosyal Medya Linkleri
Config.SocialMedia = {
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
}

-- Müzik Ayarları
Config.Music = {
    enabled = true,
    defaultVolume = 0.2,
    playlist = {
        {name = "Ambient Music", artist = "Artist 1", url = "music1.mp3"},
        {name = "Loading Theme", artist = "Artist 2", url = "music2.mp3"},
        {name = "Background Music", artist = "Artist 3", url = "music3.mp3"}
    }
}

-- Sunucu Kuralları
Config.Rules = {
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
}

-- İpuçları
Config.Tips = {
    "Sunucumuza hoş geldiniz! Keyifli oyunlar...",
    "Yeni güncellemeler ve etkinlikler için Discord sunucumuza katılın!",
    "Oyun içi destek için F8 tuşuna basabilirsiniz",
    "Sunucumuzda VIP paketleri aktif!",
    "Arkadaşlarınızı davet ederek ödüller kazanabilirsiniz!"
}

-- Animasyon Ayarları
Config.Animations = {
    loadingBarSpeed = 1.0, -- Loading bar hızı (1.0 = normal)
    tipsChangeInterval = 5000, -- İpuçları değişim süresi (ms)
    rulesChangeInterval = 5000, -- Kurallar değişim süresi (ms)
    fadeInDuration = 500 -- Fade in animasyon süresi (ms)
}

-- Video Ayarları
Config.Video = {
    volume = 0.1,
    filter = {
        brightness = 0.3,
        contrast = 1.2
    }
}

-- Steam API Ayarları
Config.SteamAPIKey = "YOUR_STEAM_API_KEY" -- Steam Web API key'inizi buraya ekleyin

return Config 