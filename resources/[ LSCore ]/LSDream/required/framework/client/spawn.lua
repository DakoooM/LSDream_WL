LSDream.loadCharacter = function()
    CreateThread(function()
        -- LSDream.UI.status(false)
        LSDream.UI.loading("Chargement", true)
        -- DisplayRadar(false)
        SetPlayerControl(PlayerId(), false, 12)
        TriggerServerEvent(Config.PrefixEvent.. "characterAdd")
        TriggerScreenblurFadeIn(200)
        Wait(5000)
        TriggerScreenblurFadeOut(200)
        LSDream.TriggerCallback(Config.PrefixEvent.. "getPersonalData", function(thisPlayer)
            LSDream.Player.name = thisPlayer.name;
            LSDream.Player.discord = thisPlayer.discord;
            LSDream.Player.group = thisPlayer.admin;
            LSDream.Player.inventory = thisPlayer.inventory;
            LSDream.Player.money = thisPlayer.money;
            LSDream.Player.status = thisPlayer.status;
            LSDream.Player.skin = thisPlayer.skin;
        end)
        DisplayRadar(true)
        SetPlayerControl(PlayerId(), true, 12)
        LSDream.UI.loading("None", false)
        Visual.Popup({msg = "~g~Vous avez réussi le chargement de votre personnage"})
        LSDream.loadAntiCheat(true)
        LSDream.UI.status(true)
    end)
end

CreateThread(function()
    while not PlayerPedId() do Wait(5) end
    while true do
        Wait(200)
        if NetworkIsSessionStarted() then
            ShutdownLoadingScreenNui()
            ShutdownLoadingScreen()
            spawnPlayer({
                x = Config.FirstSpawnPoint.x, 
                y = Config.FirstSpawnPoint.y, 
                z = Config.FirstSpawnPoint.z, 
                model = GetHashKey("ig_g"), 
                heading = 215.0
            }, false, function()
                LSDream.loadCharacter()
            end)
        end
        break
    end
end)