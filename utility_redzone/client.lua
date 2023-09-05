DevMode(false)

local options = {
    rgb = {255, 0, 0},
    slice = "ignore"
}

local ped = PlayerPedId()
local respawnTimers = {}
local playerWeapons = {}

Citizen.CreateThread(function()
    for marker_id, v in pairs(Config.RedZone) do 
        options.scale = vector3(v.Size, v.Size, 150.0)

        CreateMarker(marker_id, v.Coords, v.Size + 50.0, 0.0, options)

        if v.Blip.Active then
            CreateBlip(marker_id, v.Coords, v.Blip.Sprite, v.Blip.Colour, v.Blip.Scale)
        end

        if v.Weapon ~= "" then
            v.Weapon = GetHashKey(v.Weapon)
        end
    end
end)

CreateLoop(function()
    local founded = false

    for marker_id, v in pairs(Config.RedZone) do 
        if GetDistanceFrom("marker", marker_id) < v.Size/2 then
            ped = PlayerPedId()

            if not v.CanUseVehicle then
                local veh = GetVehiclePedIsIn(ped)

                if veh ~= 0 then
                    DeleteEntity(veh)
                    ShowNotification(Config.Notify["no_vehicle"])
                end
            end
    
            if v.NoHs then
                SetPedSuffersCriticalHits(PlayerPedId(), false)
            else
                SetPedSuffersCriticalHits(PlayerPedId(), true)
            end

            if v.Weapon ~= "" then
                if v.UnlimitedAmmo then
                    SetPedInfiniteAmmoClip(ped, true)
                else
                    SetPedInfiniteAmmoClip(ped, false)
                end
            
                local weaponHash = GetHashKey(v.Weapon)
            
                if GetSelectedPedWeapon(ped) ~= weaponHash then
                    if HasPedGotWeapon(ped, weaponHash, false) then
                        ShowNotification(Config.Notify["on_weapon_change"])
                        SetCurrentPedWeapon(ped, weaponHash, true)
                    else
                       -- ShowNotification(Config.Notify["no_weapon"])
                        GiveWeaponToPed(ped, weaponHash, 250, false, true)
                    end
                end
            end
    
            if v.OnlyHS then
                local _, entity = GetEntityPlayerIsFreeAimingAt(PlayerId())
    
                if entity ~= 0 then
                    if HasEntityBeenDamagedByWeapon(entity, GetSelectedPedWeapon(ped), 0) then
                        if GetEntityHealth(entity) ~= 0 then
                            if GetEntityHealth(entity) ~= 200 and GetEntityHealth(entity) ~= 150 then
                                TriggerSyncedEvent("utility_redzone:Heal", GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity)))
                            end
                        end
                    end
                end
            end

            -- Check if the player is dead and start the respawn timer
            if IsEntityDead(PlayerPedId()) and not respawnTimers[PlayerId()] then
                local respawnCoords = v.RespawnPoints[math.random(1, #v.RespawnPoints)]
                respawnTimers[PlayerId()] = { timer = v.RespawnTimer, spawnCoords = respawnCoords }
            end

            -- Player is inside the RedZone, remove the weapon tracking entry
            playerWeapons[PlayerId()] = nil

            founded = true
            break
        end
    end

    if not founded then
        -- Player is outside the RedZone
        local playerId = PlayerId()
        local ped = PlayerPedId()

        -- Check if the player has a weapon inside the RedZone
        if playerWeapons[playerId] then
            local weaponHash = playerWeapons[playerId]

            -- Remove the player's weapon
            RemoveWeaponFromPed(ped, weaponHash)

            -- Clear the entry in the table
            playerWeapons[playerId] = nil
        end

        -- Reset infinite ammo when leaving the RedZone
        SetPedInfiniteAmmoClip(ped, false)

        Citizen.Wait(500)
    end
end)

Citizen.CreateThread(function()
    while true do
        for playerId, respawnData in pairs(respawnTimers) do
            if respawnData.timer > 0 then
                respawnData.timer = respawnData.timer - 1000 
            else
                local playerPed = GetPlayerPed(-1)
                local respawnCoords = respawnData.spawnCoords

                TriggerEvent('hospital:client:Revive', true) 
                Citizen.Wait(0) 

                SetEntityCoordsNoOffset(playerPed, respawnCoords.x, respawnCoords.y, respawnCoords.z, true, true, true)
                SetEntityInvincible(playerPed, false)

                -- Clear the respawn timer entry
                respawnTimers[playerId] = nil 
            end
        end

        Citizen.Wait(1000) 
    end
end)

RegisterNetEvent("utility_redzone:Heal", function()
    SetEntityHealth(PlayerPedId(), 200)
end)
