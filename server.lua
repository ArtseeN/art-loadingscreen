local playerCount = 0
local serverInfo = {}

-- Server bilgilerini al
function GetServerInfo()
    local info = {
        name = GetConvar("sv_hostname", "Unknown"),
        maxPlayers = GetConvarInt("sv_maxclients", 32),
        currentPlayers = playerCount,
        ip = GetConvar("sv_endpoint", "Unknown"),
        uptime = os.time() - serverInfo.startTime
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