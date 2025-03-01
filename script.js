// İpuçları dizisi
const tips = [
    "Sunucumuza hoş geldiniz! Keyifli oyunlar...",
    "Yeni güncellemeler ve etkinlikler için Discord sunucumuza katılın!",
    "Oyun içi destek için F8 tuşuna basabilirsiniz",
    "Sunucumuzda VIP paketleri aktif!",
    "Arkadaşlarınızı davet ederek ödüller kazanabilirsiniz!"
];

// Değişkenler
let currentTip = 0;
let loadingProgress = 0;
const progressBar = document.querySelector('.progress');
const tipText = document.getElementById('tip-text');
const currentPlayers = document.getElementById('current-players');
const maxPlayers = document.getElementById('max-players');
const pingElement = document.getElementById('ping');
const loadingPercentage = document.getElementById('loading-percentage');

// Gelişmiş loading bar animasyonu
function updateLoadingBar() {
    if (loadingProgress < 100) {
        const increment = Math.random() * (3 - 0.5) + 0.5;
        loadingProgress = Math.min(loadingProgress + increment, 100);
        progressBar.style.width = `${loadingProgress}%`;
        loadingPercentage.textContent = Math.round(loadingProgress);
        
        const delay = loadingProgress > 80 ? 150 : 100;
        setTimeout(updateLoadingBar, delay);
    }
}

// Gelişmiş ipucu değiştirme animasyonu
function changeTip() {
    tipText.style.opacity = 0;
    tipText.style.transform = 'translateY(20px)';
    
    setTimeout(() => {
        currentTip = (currentTip + 1) % tips.length;
        tipText.textContent = tips[currentTip];
        tipText.style.opacity = 1;
        tipText.style.transform = 'translateY(0)';
    }, 500);
}

// Glitch efekti için
function addGlitchEffect(element) {
    element.classList.add('glitch');
    setTimeout(() => {
        element.classList.remove('glitch');
    }, 1000);
}

// Mevcut JavaScript'e ekleyin
function updateSteamProfile(data) {
    // Bu fonksiyon FiveM'den gelen Steam verilerini güncelleyecek
    const steamAvatar = document.getElementById('steam-avatar');
    const steamName = document.getElementById('steam-name');
    const steamId = document.getElementById('steam-id');

    if (data.avatar) steamAvatar.src = data.avatar;
    if (data.name) steamName.textContent = data.name;
    if (data.steamId) steamId.textContent = data.steamId;
}

// Config güncelleme fonksiyonu
function updateConfig(config) {
    // Renkleri güncelle
    document.documentElement.style.setProperty('--primary', config.colors.primary);
    document.documentElement.style.setProperty('--secondary', config.colors.secondary);
    document.documentElement.style.setProperty('--text', config.colors.text);
    document.documentElement.style.setProperty('--text-secondary', config.colors.textSecondary);
    document.documentElement.style.setProperty('--bg', config.colors.background);
    document.documentElement.style.setProperty('--bg-secondary', config.colors.backgroundSecondary);

    // Müzik listesini güncelle
    if (config.music.enabled) {
        playlist = config.music.playlist;
        audio.volume = config.music.defaultVolume;
        loadTrack(currentTrack);
    }

    // İpuçlarını güncelle
    tips = config.tips;

    // Kuralları güncelle
    updateRules(config.rules);

    // Sosyal medya linklerini güncelle
    updateSocialLinks(config.socialMedia);

    // Animasyon sürelerini güncelle
    document.documentElement.style.setProperty('--fade-duration', `${config.animations.fadeInDuration}ms`);
}

// Server bilgilerini güncelleme fonksiyonu
function updateServerInfo(info) {
    // Oyuncu sayısını güncelle
    document.getElementById('current-players').textContent = info.currentPlayers;
    document.getElementById('max-players').textContent = info.maxPlayers;
    
    // Uptime'ı güncelle
    const days = Math.floor(info.uptime / (24 * 60 * 60));
    document.getElementById('server-uptime').textContent = `${days} gün`;
    
    // Server adını güncelle (isteğe bağlı)
    if (document.querySelector('.server-info h1')) {
        document.querySelector('.server-info h1').textContent = info.name;
    }
}

// Event listener'ı güncelle
window.addEventListener('message', function(event) {
    const data = event.data;

    switch(data.type) {
        case 'updateConfig':
            updateConfig(data.config);
            break;
        case 'updateVideoSettings':
            const video = document.getElementById('background-video');
            video.volume = data.volume;
            video.style.filter = `brightness(${data.filter.brightness}) contrast(${data.filter.contrast})`;
            break;
        case 'updateServerInfo':
            updateServerInfo(data.info);
            break;
    }

    // Mevcut eventleri koru
    if (data.eventName === 'updatePlayerCount') {
        currentPlayers.textContent = data.currentPlayers;
        maxPlayers.textContent = data.maxPlayers;
    }
    if (data.eventName === 'updatePing') {
        pingElement.textContent = data.ping;
    }
    if (data.eventName === 'updateSteamProfile') {
        updateSteamProfile(data);
    }
});

// NUI hazır olduğunda FiveM'e bildir
document.addEventListener('DOMContentLoaded', function() {
    fetch(`https://${GetParentResourceName()}/ready`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({})
    });
});

// Kurallar Slider
const rules = document.querySelectorAll('.rule');
const rulesContainer = document.querySelector('.rules-container');
const dotsContainer = document.querySelector('.rules-dots');
let currentRule = 0;

// Nokta göstergelerini oluştur
rules.forEach((_, index) => {
    const dot = document.createElement('div');
    dot.classList.add('dot');
    if (index === 0) dot.classList.add('active');
    dot.addEventListener('click', () => showRule(index));
    dotsContainer.appendChild(dot);
});

function showRule(index) {
    rules.forEach(rule => {
        rule.classList.remove('active');
    });
    document.querySelectorAll('.dot').forEach(dot => {
        dot.classList.remove('active');
    });
    
    rules[index].classList.add('active');
    document.querySelectorAll('.dot')[index].classList.add('active');
    currentRule = index;
}

// Otomatik kural değiştirme
setInterval(() => {
    currentRule = (currentRule + 1) % rules.length;
    showRule(currentRule);
}, 5000);

// Müzik Player
const playlist = [
    { name: "Ambient Music", artist: "Artist 1", url: "music1.mp3" },
    { name: "Loading Theme", artist: "Artist 2", url: "music2.mp3" },
    { name: "Background Music", artist: "Artist 3", url: "music3.mp3" }
];

let currentTrack = 0;
let isPlaying = false;
const audio = new Audio();
audio.volume = 0.5;

const playBtn = document.querySelector('.play-btn');
const prevBtn = document.querySelector('.prev-btn');
const nextBtn = document.querySelector('.next-btn');
const volumeSlider = document.querySelector('.volume-slider');
const songName = document.querySelector('.song-name');
const artistName = document.querySelector('.artist-name');

function loadTrack(track) {
    audio.src = playlist[track].url;
    songName.textContent = playlist[track].name;
    artistName.textContent = playlist[track].artist;
}

function playTrack() {
    isPlaying = true;
    audio.play();
    playBtn.innerHTML = '<i class="fas fa-pause"></i>';
}

function pauseTrack() {
    isPlaying = false;
    audio.pause();
    playBtn.innerHTML = '<i class="fas fa-play"></i>';
}

playBtn.addEventListener('click', () => {
    if (isPlaying) {
        pauseTrack();
    } else {
        playTrack();
    }
});

prevBtn.addEventListener('click', () => {
    currentTrack = (currentTrack - 1 + playlist.length) % playlist.length;
    loadTrack(currentTrack);
    if (isPlaying) playTrack();
});

nextBtn.addEventListener('click', () => {
    currentTrack = (currentTrack + 1) % playlist.length;
    loadTrack(currentTrack);
    if (isPlaying) playTrack();
});

volumeSlider.addEventListener('input', (e) => {
    audio.volume = e.target.value / 100;
});

// Server uptime güncelleme
function updateServerUptime() {
    const uptimeElement = document.getElementById('server-uptime');
    let days = 0;
    setInterval(() => {
        days++;
        uptimeElement.textContent = `${days} gün`;
    }, 86400000); // Her 24 saatte bir
}

// Sayfa yüklendiğinde
document.addEventListener('DOMContentLoaded', () => {
    // İpuçlarını değiştirmeye başla
    setInterval(changeTip, 5000);
    
    // Loading bar'ı başlat
    setTimeout(updateLoadingBar, 1000);
    
    // Arka plan video ayarları
    const video = document.getElementById('background-video');
    video.volume = 0.1;
    
    // Başlangıç animasyonları
    document.querySelector('.container').style.opacity = 0;
    setTimeout(() => {
        document.querySelector('.container').style.opacity = 1;
        document.querySelector('.container').style.transition = 'opacity 1s ease';
    }, 100);
    
    loadTrack(currentTrack); // İlk şarkıyı yükle
    updateServerUptime(); // Uptime sayacını başlat
});

// Ses kontrolü için
const video = document.getElementById('background-video');
video.volume = 0.2; // Ses seviyesini %20'ye ayarla 

function updateRules(rules) {
    const container = document.querySelector('.rules-container');
    container.innerHTML = rules.map((rule, index) => `
        <div class="rule ${index === 0 ? 'active' : ''}">
            <i class="fas ${rule.icon}"></i>
            <h3>${rule.title}</h3>
            <p>${rule.description}</p>
        </div>
    `).join('');
}

function updateSocialLinks(social) {
    const socialMedia = document.querySelector('.social-media');
    // Sosyal medya butonlarını güncelle
} 