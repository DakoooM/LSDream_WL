SetRoutingBucketPopulationEnabled(0, false)

LSDream = {}
LSDream.Player = {}
LSDream.ServerCallbacks = {}
LSDream.allSourcePlayers = {}

LSDream.selectPlayersTable = function(license, cb)
    MySQL.Async.fetchAll("SELECT discord, name, inventory, money, status, skin, admin FROM players WHERE discord=@discord", {
        ["@discord"] = license;
    }, function(result)
        if (cb) then
            cb(result)
        else
            return result
        end
    end)
end

RegisterServerEvent(Config.PrefixEvent.. "characterAdd")
AddEventHandler(Config.PrefixEvent.. "characterAdd", function()
    local source = tonumber(source);
    local discord = LSDream.getLicense(source, "discord");
    local playerName = GetPlayerName(source) or "none";
    LSDream.selectPlayersTable(discord, function(result)
        if (not result[1]) then
            MySQL.Async.execute("INSERT INTO `players` (discord, name, inventory, admin, money) VALUES (@discord, @name, @inventory, @group, @money)", {
                ["@discord"] = discord,
                ["@name"] = playerName,
                ["@inventory"] = json.encode(Config.DefaultInventory),
                ["@money"] = json.encode(Config.DefaultMoney),
                ["@group"] = "user"
            }, function()
                local firstData = MySQL.Async.fetchAll("SELECT discord, name, inventory, money, status, skin, admin FROM players WHERE discord=" ..discord:sub(7))
                LSDream.Player[tostring(source)] = firstData[1];
                LSDream.Player[tostring(source)].money = json.decode(firstData[1].money);
                LSDream.Player[tostring(source)].inventory = json.decode(firstData[1].inventory);
                LSDream.Player[tostring(source)].playerId = source;
            end)
        else
            LSDream.Player[tostring(source)] = result[1];
            LSDream.Player[tostring(source)].money = json.decode(result[1].money);
            LSDream.Player[tostring(source)].inventory = json.decode(result[1].inventory);
            LSDream.Player[tostring(source)].playerId = source;
            table.insert(LSDream.allSourcePlayers, source)
        end
    end)
end)

LSDream.RegisterCallback = function(name, cb)
	LSDream.ServerCallbacks[name] = cb
end

LSDream.TriggerCallback = function(name, requestId, source, cb, ...)
	if LSDream.ServerCallbacks[name] then
		LSDream.ServerCallbacks[name](source, cb, ...)
	else
		print(('[^3Server Callback^7] "%s" n\'existe pas'):format(name))
	end
end

RegisterServerEvent(Config.PrefixEvent.. "CallbackTrigger")
AddEventHandler(Config.PrefixEvent.. "CallbackTrigger", function(name, requestId, ...)
	local playerId = source;
	LSDream.TriggerCallback(name, requestId, playerId, function(...)
		TriggerClientEvent(Config.PrefixEvent.. "serverCallback", playerId, requestId, ...)
	end, ...)
end)

LSDream.getLicense = function(_src, licenseType)
    local source = _src;
    for index, identifier in pairs(GetPlayerIdentifiers(source)) do
        if string.sub(identifier, 1, string.len(licenseType..":")) == licenseType..":" then
            return identifier
        end
    end
    return false
end

LSDream.getLocalTime = function()
    return os.date("%d/%m/%Y", os.time()), os.date("%H:%M:%S", os.time())
end

LSDream.IsPropsBlacklist = function(props)
    for no, model in pairs(Config.PropsBlacklist) do
        if GetEntityModel(props) == GetHashKey(model) then 
            return true
        end
    end
    return false
end

LSDream.IsVehicleBlacklist = function(vehicle)
    for no, model in pairs(Config.VehiclesBlacklist) do
        if GetEntityModel(vehicle) == GetHashKey(model) then 
            return true
        end
    end
    return false
end

AddEventHandler("playerConnecting", function(name, kick, def)
    local player = source
    def.defer()
    Wait(0)
    def.update(string.format("Bonjour %s. Nous récupérons votre discord", name))
    local steamIdentifier = LSDream.getLicense(player, "discord");
    Wait(4000)
    if not steamIdentifier then
        def.done("Vous n'êtes pas connecter a discord")
    else
        def.done()
    end
end)

AddEventHandler("onResourceStarting", function(resource)
    if not Config.ResourceList[resource] then
        CancelEvent()
        print("CANCEL RESOURCE STARTING", resource)
    end
end)

LSDream.RegisterCallback(Config.PrefixEvent.. "getPersonalData", function(source, cb)
    local player = LSDream.getPlayersById(source)
    cb(player)
end)