local ESX = exports['es_extended']:getSharedObject()

local blacklistedJobs = {
    unemployed = true
}

local function GetTrackedPlayersForJob(jobName, excludeId)
    local tracked = {}
    for _, playerId in pairs(ESX.GetPlayers()) do
        if playerId ~= excludeId then
            local xPlayer = ESX.GetPlayerFromId(playerId)
            if xPlayer and xPlayer.job.name == jobName and not blacklistedJobs[jobName] then
                local gpsItem = xPlayer.getInventoryItem('gps_tracker')
                if gpsItem and gpsItem.count > 0 then
                    table.insert(tracked, {
                        id = playerId,
                        coords = GetEntityCoords(GetPlayerPed(playerId)),
                        name = xPlayer.getName(),
                        job = jobName
                    })
                end
            end
        end
    end
    return tracked
end

ESX.RegisterServerCallback('simeon-gps:getPlayers', function(src, cb)
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return cb({}) end

    local jobName = xPlayer.job.name
    local gpsItem = xPlayer.getInventoryItem('gps_tracker')

    if gpsItem and gpsItem.count > 0 then
        local players = GetTrackedPlayersForJob(jobName, src)
        cb(players)
    else
        cb({})
    end
end)
