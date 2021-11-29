RegisterCommand("coord", function ()
    print(GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId()))
end)