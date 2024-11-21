local PlayerData

if Config.Framework == 'auto' then
    if GetResourceState("es_extended") == 'started' then
        Config.Framework = 'esx'
    elseif GetResourceState("qb-core") == 'started' then
        Config.Framework = 'qb'
    end
end

if Config.Framework == 'esx' then
    RegisterNetEvent("esx:playerLoaded",function(xPlayer)
        PlayerData = xPlayer
    end)

     RegisterNetEvent("esx:setJob",function(job)
         PlayerData.job = job
     end)

elseif Config.Framework == 'qb' then

    RegisterNetEvent("QBCore:Client:OnPlayerLoaded",function(Player)
        PlayerData = Player
    end)

    RegisterNetEvent("QBCore:Client:OnJobUpdate",function(JobInfo)
        PlayerData.job = JobInfo
    end)
end



local identifier = "lb-announcely"

while GetResourceState("lb-phone") ~= "started" do
    Wait(500)
end

local function addApp()
    local added, errorMessage = exports["lb-phone"]:AddCustomApp({
        identifier = identifier, -- unique app identifier

        name = "Annoncely",
        description = "Annoncely permet de voir les annonces et en creer.",
        developer = "Enzo2991",

        defaultApp = false, --  set to true, the app will automatically be added to the player's phone
        size = 59812, -- the app size in kb
        -- price = 0, -- OPTIONAL make players pay with in-game money to download the app

        images = { -- OPTIONAL array of screenshots of the app, used for showcasing the app
            "https://cfx-nui-" .. GetCurrentResourceName() .. "/ui/dist/screenshot-light.png",
            "https://cfx-nui-" .. GetCurrentResourceName() .. "/ui/dist/screenshot-dark.png"
        },

        -- ui = "http://localhost:3000",
        ui = GetCurrentResourceName() .. "/ui/dist/index.html",

        icon = "https://cfx-nui-" .. GetCurrentResourceName() .. "/ui/dist/icon.png",

        fixBlur = true -- set to true if you use em, rem etc instead of px in your css
    })

    if not added then
        print("Could not add app:", errorMessage)
    end
end

addApp()

local function drawNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

AddEventHandler("onResourceStart", function(resource)
    if resource == "lb-phone" then
        addApp()
    end
end)

RegisterNUICallback('getJob',function(_,cb)
    local job = {
        name = PlayerData.job.name,
        gradeName = PlayerData.job.grade_name
    }
    cb(job)
end)

RegisterNUICallback('getAllAnnounce',function(_,cb)
    local announce = lib.callback.await('lb-announcely:getAllAnnounce',false)
    cb(announce)
end)

RegisterNUICallback("sendAnnounce", function(data, cb)
    TriggerServerEvent("lb-announcely:addAnnounce", data)
    cb(true)
end)

RegisterNetEvent('lb-announcely:Announce',function(data)
    drawNotification(data.title..'\n'..data.text)
end)