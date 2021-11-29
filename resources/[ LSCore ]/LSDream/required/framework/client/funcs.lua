LSDream = {}
LSDream.UI = {}
LSDream.Player = {}

LSDream.ServerCallbacks           = {};
LSDream.RequestId          = 0;
LSDream.TriggerServEvent = TriggerServerEvent

LSDream.TriggerCallback = function(name, cb, ...)
	LSDream.ServerCallbacks[LSDream.RequestId] = cb
    
	LSDream.TriggerServEvent(Config.PrefixEvent.. "CallbackTrigger", name, LSDream.RequestId, ...)

	if LSDream.RequestId < 65535 then
		LSDream.RequestId = LSDream.RequestId + 1
	else
		LSDream.RequestId = 0
	end
end

RegisterNetEvent(Config.PrefixEvent.. "serverCallback")
AddEventHandler(Config.PrefixEvent.. "serverCallback", function(requestId, ...)
	LSDream.ServerCallbacks[requestId](...)
	LSDream.ServerCallbacks[requestId] = nil
end)

LSDream.getItem = function(name)
	if type(name) ~= "string" then return print("please enter string in (getItem)") end
	if Config.Items[name] then
		return Config.Items[name]
	else
		return false
	end
end

LSDream.UI.loading = function(text, show)
	show = show or false
	text = text or "Chargement"
	SendNUIMessage({
		type = "loadBar", 
		showLoad = show, 
		loadText = text
	})
end

LSDream.UI.status = function(show)
	show = show or false
	SendNUIMessage({
		type = "statsBar", 
		showStatus = show, 
		loadText = text
	})
end