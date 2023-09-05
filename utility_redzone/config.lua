Config = {}

-- https://wiki.gtanet.work/index.php?title=Blips
Config.RedZone = {
    ["Nuketown"] = {
        Blip = {
            Sprite = 84,
            Colour = 1,
            Scale  = 1.0,
            Active = true
        },
        Coords        = vector3(1381.7900, -745.3795, 65.2007),
        Size          = 100.0,

        Weapon        = 'WEAPON_PISTOL', -- Set it to "" to disable it 
        CanUseVehicle = false,                                --^  
        OnlyHS        = false,                                --^  
        NoHs          = false,                                --^  
        UnlimitedAmmo = true,     
        RespawnPoints = {
            vector3(1368.29, -788.46, 68.78),
            vector3(1387.54, -785.25, 67.43),
            vector3(1417.4, -740.89, 67.06),
            vector3(1411.13, -727.37, 67.6),
            vector3(1416.51, -717.4, 67.14),
            vector3(1400.38, -702.67, 67.44),
            
        },
        RespawnTimer = 8000, -- This is in milliseconds (8 seconds == 8000ms)  / recommend 5 secs or more
    },  

  -------------------------------    THIS IS FOR EXTRA ZONES ------------------------------

   --[[ ["Vill"] = {
        Blip = {
            Sprite = 84,
            Colour = 1,
            Scale  = 1.0,
            Active = true
        },
        Coords        = vector3(0, 0, 0),
        Size          = 100.0,

        Weapon        = 'WEAPON_PISTOL', -- Set it to "" to disable giving a weapon
        CanUseVehicle = false,                                --^  
        OnlyHS        = false,                                --^  
        NoHs          = false,                                --^  
        UnlimitedAmmo = true,     
        RespawnPoints = {
            vector3(15.5, -15.5, 15.5),
            vector3(10.5, -12.5, 18.5),
            
        },
        RespawnTimer = 8000, -- This is in milliseconds (8 seconds == 8000ms)  / recommend 5 secs or more
    },  ]]
}

Config.Notify = {
    ["no_vehicle"]       = "~r~You cannot use vehicles in this RedZone!",
    ["on_weapon_change"] = "~r~You can't use other weapons!",
   -- ["no_weapon"]        = "~r~You don't have the weapon to be able to play in this RedZone, so you won't be able to shoot!",
}
