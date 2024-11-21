local announce = {}

local function setAnnounce()
    local query = MySQL.query.await("SELECT * FROM `lb-announce`")
    if query then
        for k,v in pairs(query) do
            v.date = os.date("%d/%m/%Y - %H:%M", v.date)
            announce[k] = v
        end
    end
end

MySQL.update(
        [[
        CREATE TABLE IF NOT EXISTS `lb-announce` (
            `id` int(11) NOT NULL AUTO_INCREMENT,
            `title` varchar(255) NOT NULL,
            `text` text NOT NULL,
            `date` longtext NOT NULL,
            PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ]], {}, function(success)
            if success then
                setAnnounce()
            else
                print("^3Error connecting to DB^0")
            end
        end)

lib.callback.register('lb-announcely:getAllAnnounce', function()
    return announce
end)

local function sendWebhook(data)
    if Config.webhook ~= '' then
        PerformHttpRequest(Config.webhook, function(err, text, headers) end, 'POST', json.encode({username = 'Annoncely', content = data}), { ['Content-Type'] = 'application/json' })
    end
end



RegisterNetEvent('lb-announcely:addAnnounce',function(data)
    data.date = os.date("%d/%m/%Y - %H:%M", os.time())
    MySQL.insert("INSERT INTO `lb-announce` (title,text,date) VALUES (?,?,?)",{
        data.title,
        data.text,
        os.time()
    })
    TriggerClientEvent('lb-announcely:Announce',-1,data)
    announce[#announce+1] = data
    sendWebhook(data.title .. '\n' .. data.text)
end)