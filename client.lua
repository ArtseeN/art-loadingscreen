local function LoadResourceFile(resourceName, fileName)
    return LoadResourceFile(GetCurrentResourceName(), fileName)
end

local function SendToNUI(data)
    SendNUIMessage({
        type = "updateConfig",
        config = data
    })
end

-- Config'i yükle
local config = Config

-- NUI'ye veri gönderme fonksiyonu
function SendConfigToNUI(info)
    SendNUIMessage({
        type = "updateConfig",
        config = info.config
    })
end

-- Oyuncu oyuna girdiğinde
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if NetworkIsSessionStarted() then
            -- Config'i NUI'ye gönder
            SendConfigToNUI(config)
            
            -- Video ve müzik ayarlarını uygula
            SendNUIMessage({
                type = "updateVideoSettings",
                volume = config.Video.volume,
                filter = config.Video.filter
            })
            
            break
        end
    end
end)

-- Steam bilgilerini alma fonksiyonları
function GetSteamID(source)
    local identifiers = GetPlayerIdentifiers(source)
    for _, v in pairs(identifiers) do
        if string.find(v, "steam") then
            return v
        end
    end
    return nil
end

function GetSteamProfileInfo()
    local source = GetPlayerServerId(PlayerId())
    local steamid = GetSteamID(source)
    
    if steamid then
        -- Steam Web API kullanarak avatar ve diğer bilgileri al
        if config.steamAPI.enabled and config.steamAPI.key then
            local steamid64 = string.gsub(steamid, "steam:", "")
            local url = string.format("http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=%s&steamids=%s", config.steamAPI.key, steamid64)
            
            PerformHttpRequest(url, function(err, text, headers)
                if text then
                    local data = json.decode(text)
                    if data and data.response and data.response.players and data.response.players[1] then
                        local player = data.response.players[1]
                        SendNUIMessage({
                            eventName = "updateSteamProfile",
                            name = player.personaname,
                            steamId = steamid,
                            avatar = player.avatarfull
                        })
                    end
                end
            end)
        end
    end
end

-- Steam bilgilerini güncelle
Citizen.CreateThread(function()
    while true do
        if NetworkIsSessionStarted() then
            GetSteamProfileInfo()
            break
        end
        Citizen.Wait(100)
    end
end)

-- Server'dan gelen bilgileri al
RegisterNetEvent('loading:receiveServerInfo')
AddEventHandler('loading:receiveServerInfo', function(info)
    -- Config'i güncelle
    SendConfigToNUI(info)
    
    -- Server bilgilerini güncelle
    SendNUIMessage({
        type = "updateServerInfo",
        info = info
    })
end)

-- Ping güncellemesi
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        -- Server bilgilerini iste
        TriggerServerEvent('loading:requestServerInfo')
        
        -- Ping'i güncelle
        local ping = GetPlayerPing(PlayerId())
        SendNUIMessage({
            eventName = "updatePing",
            ping = ping
        })
    end
end)

-- NUI'den gelen mesajları dinle
RegisterNUICallback('ready', function(data, cb)
    -- NUI hazır olduğunda config'i tekrar gönder
    SendConfigToNUI(config)
    cb('ok')
end) 