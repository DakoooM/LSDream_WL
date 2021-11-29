CreateThread(function()
    while not LSDream do Wait(10) end
    LSDream.loadAntiCheat = function(loadThis)
        CreateThread(function()
            while loadThis do
                Wait(4000)
                if GetEntityMaxHealth(PlayerPedId()) > 200 then
                    -- trigger qui ban
                end
            end
        end)
    end
end)