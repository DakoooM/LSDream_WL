LSDream = {}
LSDream.UI = {}
LSDream.Player = {}
LSDream.Game = {}
LSDream.Util = {}

LSDream.Var = {
	playerLoaded = false;
}

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

LSDream.Util.IsPlayerAdmin = function()
	if LSDream.Player.group ~= nil then
		for _, value in pairs(Config.AdminGroups) do
			if LSDream.Player.group == value.group then
				return value
			end
		end
	end
	return false
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
		showStatus = show
	})
end

LSDream.Game.Notif = function(msg)
	SetNotificationTextEntry('STRING')
	AddTextComponentSubstringPlayerName(msg or "NULL")
	DrawNotification(0, 1)
end

LSDream.Game.helpNotif = function(msg, sound, time)
	BeginTextCommandDisplayHelp('STRING')
	AddTextComponentSubstringPlayerName(msg or "NULL")
	EndTextCommandDisplayHelp(0, false, sound or true, time or -1)
end

LSDream.Game.advancedNotif = function(title, subject, msg, icon, iconType)
	SetNotificationTextEntry('STRING')
	AddTextComponentSubstringPlayerName(msg or "NULL")
	SetNotificationMessage(icon or "CHAR_ARTHUR", icon or "CHAR_ARTHUR", false, iconType or 1, title, subject or "NULL")
	DrawNotification(false, false)
end

LSDream.Game.simpleText = function(msg, time)
	ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(msg or "null")
	DrawSubtitleTimed(time and math.ceil(time) or 0, true)
end

LSDream.Game.advancedText = function(args) 
	SetTextFont(args.font) 
	SetTextProportional(0) 
	SetTextScale(args.size, args.size) 
	if args.Ombres == true then
		SetTextDropShadow(0, 0, 0, 0,255) 
		SetTextEdge(1, 0, 0, 0, 255) 
	end
	SetTextEntry("STRING") 
	AddTextComponentString(args.msg) 
	DrawText(args.posx, args.posy) 
end

LSDream.Game.floatingHelp = function(msg, coords)
	AddTextEntry('FloatingHelpNotif', msg or "∑ NULL ~BLIP_40~")
	SetFloatingHelpTextWorldPosition(1, coords or GetEntityCoords(PlayerPedId()))
	SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
	BeginTextCommandDisplayHelp('FloatingHelpNotif')
	EndTextCommandDisplayHelp(2, false, false, -1)
end

LSDream.Game.advanced3DText = function(args)
	local camCoords = GetGameplayCamCoords()
	local distance = #(args.coords - camCoords)

	args.size = args.size or 1.0
	args.font = args.font or 0
	args.Shadow = args.Shadow or false
	args.text = args.text or "text null"

	local scale = (args.size / distance) * 2
	local fov = (1 / GetGameplayCamFov()) * 100
	scale = scale * fov

	SetTextScale(0.0 * scale, 0.55 * scale)
	SetTextFont(args.font)
	SetTextColour(255, 255, 255, 255)
	if (args.Shadow) then
		SetTextDropShadow(0, 0, 0, 0,180) 
		SetTextEdge(1, 0, 0, 0, 180) 
	end
	SetTextCentre(true)

	SetDrawOrigin(args.coords, 0)
	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(args.text)
	EndTextCommandDisplayText(0.0, 0.0)
	ClearDrawOrigin()
end

-- LSDream.Util.BoardInput("JOB_HELLO", "coucou je suis moi", "", 8)
LSDream.Util.BoardInput = function(title, text, textInBox, maxCaracters)
	AddTextEntry(title, text)
	DisplayOnscreenKeyboard(1, tostring(title), "", textInBox or "", "", "", "", tonumber(maxCaracters))
	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do Wait(0) end
	if (UpdateOnscreenKeyboard() ~= 2) then
		local result = GetOnscreenKeyboardResult()
		Wait(100)
		return result
	else
		Wait(100)
		return nil
	end
end

-- LSDream.Game.CreateCamera({20.0, 20.0, 110.0, rotY = -40.0, heading = 10.0, fov = 50.0, AnimTime = 4500})
LSDream.Game.CreateCamera = function(var)
	local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)
	SetCamActive(cam, true)
	SetCamParams(cam, var[1] or 10.0, var[2] or 10.0, var[3] or 10.0, var.rotY or 1.0, 0.0, var.heading or 200.0, 42.24, 0, 1, 1, 2)
	SetCamCoord(cam, var[1], var[2], var[3])
	SetCamFov(cam, var.fov or 40.0)
	RenderScriptCams(true, var.Anim or true, var.AnimTime or 0, true, true)
	return cam
end

-- LSDream.Game.DeleteCam(varcaméra, {Anim = true, AnimTime = 2000})
LSDream.Game.DeleteCam = function(name, var)
	if DoesCamExist(name) then
		SetCamActive(name, false)
		DestroyCam(name, false, false)
		RenderScriptCams(false, var.Anim or true, var.AnimTime or 0, false, false)
	end
end

LSDream.Util.RequestModel = function(entity)
	if not IsModelInCdimage(entity) then return print("l'entity", entity, "ne fait partie de votre jeu (RequestModel)") end
	RequestModel(entity)
	while not HasModelLoaded(entity) do Wait(5) end
end

LSDream.Game.spawnVehicle = function(model, localveh, coords, heading)
	local model = (type(model) == 'number' and model or GetHashKey(model))
	CreateThread(function()
		LSDream.Util.RequestModel(model)
		local thisVehicle = CreateVehicle(model, coords, coords, coords, heading or 0.0, Locales or false, false)
		local networkId = NetworkGetNetworkIdFromEntity(thisVehicle)
		SetEntityHeading(thisVehicle, heading or 0.0)
		-- SetNetworkIdCanMigrate(networkId, true)
		SetEntityAsMissionEntity(thisVehicle, true, false)
		SetVehicleHasBeenOwnedByPlayer(thisVehicle, true)
		SetVehicleNeedsToBeHotwired(thisVehicle, false)
		RequestCollisionAtCoord(coords, coords, coords)
		SetVehRadioStation(thisVehicle, 'OFF')
		SetModelAsNoLongerNeeded(thisVehicle)
		return thisVehicle
	end)
end

LSDream.Game.spawnObject = function(model, localobj, coords)
	local model = (type(model) == 'number' and model or GetHashKey(model))
	CreateThread(function()
		LSDream.Util.RequestModel(model)
		local object = CreateObject(model, coords.x, coords.y, coords.z, localobj or true, false, true)
		SetModelAsNoLongerNeeded(model)
		return object
	end)
end

LSDream.Game.spawnPed = function(model, localped, coords, heading, pedType)
	local model = (type(model) == 'number' and model or GetHashKey(model))
	CreateThread(function()
		Sigma.RequestModel(model)
		local SigmaPeds = CreatePed(pedType or 4, model, coords, coords, coords-1, heading, localped, true)
		return SigmaPeds
	end)
end