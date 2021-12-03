CreateThread(function()
    while LSDream.Var.playerLoaded == false do Wait(5) end
    if LSDream.Util.IsPlayerAdmin() then
        RegisterCommand("coord", function()
            print(GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId()))
        end)
        
        RegisterCommand("car", function(src, args, raw)
            local model = args[1];
            if (model and tostring(model)) then
                local thisVehicle = LSDream.Game.spawnVehicle(model, false, GetEntityCoords(PlayerPedId()))
                SetPedIntoVehicle(PlayerPedId(), thisVehicle, -1)
            else
                LSDream.Game.Notif("~r~<C>Attention</C>~s~\nVeuillez renseignez un véhicule a faire apparaitre")
            end
        end)
        
        RegisterCommand("dv", function()
            local inVehicle = GetVehiclePedIsIn(PlayerPedId(), false);
            local persoCoord = GetEntityCoords(PlayerPedId(), false);
            local closestVehicle = GetClosestVehicle(persoCoord, 5.0, 0, 70);
            if inVehicle ~= 0 then
                DeleteEntity(inVehicle)
                LSDream.Game.Notif("~g~<C>Succès</C>~s~\nLe véhicule dans lequel vous étiez a été supprimer")
            else
                if closestVehicle ~= 0 then
                    DeleteEntity(closestVehicle)
                    LSDream.Game.Notif("~g~<C>Succès</C>~s~\nLe véhicule le plus proche de votre position a été supprimer")
                else
                    LSDream.Game.Notif("~r~<C>Attention</C>~s~\nAucun véhicule aux alentours")
                end
            end
        end)
        print("^2You Have Registered 3 commands^0")
    end
end)