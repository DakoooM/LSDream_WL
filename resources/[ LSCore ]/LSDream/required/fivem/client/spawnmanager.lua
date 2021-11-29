local function freezePlayer(id, freeze)
    local player = id
    SetPlayerControl(player, not freeze, false)

    local ped = GetPlayerPed(player)
    if not freeze then
        if not IsEntityVisible(ped) then
            SetEntityVisible(ped, true)
        end

        if not IsPedInAnyVehicle(ped) then
            SetEntityCollision(ped, true)
        end
        FreezeEntityPosition(ped, false)
        SetPlayerInvincible(player, false)
    else
        if IsEntityVisible(ped) then
            SetEntityVisible(ped, false)
        end
        SetEntityCollision(ped, false)
        FreezeEntityPosition(ped, true)
        SetPlayerInvincible(player, true)

        if not IsPedFatallyInjured(ped) then
            ClearPedTasksImmediately(ped)
        end
    end
end

function loadScene(x, y, z)
	if not NewLoadSceneStart then return end

    NewLoadSceneStart(x, y, z, 0.0, 0.0, 0.0, 20.0, 0)
    while IsNewLoadSceneActive() do
        networkTimer = GetNetworkTimer()
        NetworkUpdateLoadScene()
    end
end

local spawnLock = false
function spawnPlayer(spawnIdx, revive, call)
    if spawnLock then return end
    spawnLock = true
    CreateThread(function()
        local spawn

        if type(spawnIdx) == 'table' then
            spawn = spawnIdx

            spawn.x = spawn.x + 0.00
            spawn.y = spawn.y + 0.00
            spawn.z = spawn.z + 0.00

            spawn.heading = spawn.heading and (spawn.heading + 0.00) or 0
        end

        if not spawn then
            Citizen.Trace("tried to spawn at an invalid spawn index\n")
            spawnLock = false

            return
        end

        freezePlayer(PlayerId(), true)

        if spawn.model then
            if IsModelInCdimage(spawn.model) then
                RequestModel(spawn.model)
                while not HasModelLoaded(spawn.model) do
                    RequestModel(spawn.model)
                    Wait(5)
                end

                SetPlayerModel(PlayerId(), spawn.model)
                SetModelAsNoLongerNeeded(spawn.model)
                
                if N_0x283978a15512b2fe then
                    N_0x283978a15512b2fe(PlayerPedId(), true)
                end
            else
                error("Model its not in GTA 5 game assets")
            end
        end

        if IsScreenFadedOut() then
            DoScreenFadeIn(200)
        end

        RequestCollisionAtCoord(spawn.x, spawn.y, spawn.z)
        SetEntityCoordsNoOffset(PlayerPedId(), spawn.x, spawn.y, spawn.z, false, false, false, true)
        NetworkResurrectLocalPlayer(spawn.x, spawn.y, spawn.z, spawn.heading, true, true, false)
        ClearPedTasksImmediately(PlayerPedId())
        RemoveAllPedWeapons(PlayerPedId())
        ClearPlayerWantedLevel(PlayerId())


        local time = GetGameTimer();
        while (not HasCollisionLoadedAroundEntity(PlayerPedId()) and (GetGameTimer() - time) < 5000) do
            Wait(0)
        end

        ShutdownLoadingScreen()
        freezePlayer(PlayerId(), false)

        if (revive ~= nil and revive == true) then
            TriggerEvent("playerSpawned", spawn)
        end

        if (call) then call(spawn) end
        spawnLock = false
    end)
end

function forceRespawn()
    spawnLock = false
    respawnForced = true
end