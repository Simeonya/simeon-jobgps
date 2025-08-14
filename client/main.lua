local blips = {}
local updateInterval = 3000

local jobColors = {
    police = 3,
    ambulance = 2,
    fire = 1
}

local function ClearBlips()
    for _, blip in pairs(blips) do
        if DoesBlipExist(blip) then
            RemoveBlip(blip)
        end
    end
    blips = {}
end

local function CreateJobBlip(coords, name, job)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 1)
    SetBlipScale(blip, 0.85)
    SetBlipColour(blip, jobColors[job] or 0)
    SetBlipAsShortRange(blip, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip)
    table.insert(blips, blip)
end

local function UpdateBlips()
    ESX.TriggerServerCallback('simeon-gps:getPlayers', function(players)
        ClearBlips()
        for _, data in pairs(players) do
            CreateJobBlip(data.coords, data.name, data.job)
        end
    end)
end

CreateThread(function()
    while true do
        UpdateBlips()
        Wait(updateInterval)
    end
end)
