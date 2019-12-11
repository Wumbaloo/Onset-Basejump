local targetX, targetY, targetZ = nil, nil, nil
local waypoint = nil

function BaseJumpStart(tx, ty)
    local x, y, z = GetPlayerLocation()
    targetX = tx
    targetY = ty
    targetZ = GetTerrainHeight(tonumber(tx), tonumber(ty), z) or 0
    waypoint = CreateWaypoint(tx, ty, targetZ, "Target - Base Jump")
    ResetEffects()
end
AddRemoteEvent("OnBaseJumpStart", BaseJumpStart)

function OnSkydive()
    local x, y, z = GetPlayerLocation()

    CreateFireworks(2, x, y, z, 90, 0, 0)
    SetPostEffect("ImageEffects", "VignetteIntensity", 1.0)
    SetPostEffect("Chromatic", "Intensity", 5.0)
    SetPostEffect("Chromatic", "StartOffset", 0.1)
    SetPostEffect("DepthOfField", "Distance", targetZ)
    SetPostEffect("MotionWhiteBalanceBlur", "Temp", 7000)
end
AddEvent("OnPlayerSkydive", OnSkydive)

function ResetEffects()
    SetPostEffect("ImageEffects", "VignetteIntensity", 0.25)
    SetPostEffect("Chromatic", "Intensity", 0.0)
    SetPostEffect("Chromatic", "StartOffset", 0.0)
    SetPostEffect("MotionBlur", "Amount", 0.0)
    SetPostEffect("DepthOfField", "Distance", 0)
    SetPostEffect("MotionWhiteBalanceBlur", "Temp", 0)
end

function PlayerParachuteLand()
    local x, y, z = GetPlayerLocation()
    -- Distance in meters
    local distance = math.floor(GetDistance3D(x, y, z, targetX, targetY, targetZ)) / 100

    AddPlayerChat("You're " .. distance .. " meters far away from your target.")
    if (distance < 4) then
        AddPlayerChat("Congratulations! It's almost perfect.")
    end
    InvokeDamageFX(500)
    CreateFireworks(3, x, y, z, 90, 0, 0)
    ResetEffects()
    CallRemoteEvent("OnBaseJumpFinish")
end
AddEvent("OnPlayerParachuteClose", PlayerParachuteLand)
AddEvent("OnPlayerParachuteLand", PlayerParachuteLand)

function CrashBaseJump()
    if (waypoint) then
        DestroyWaypoint(waypoint)
        waypoint = nil
    end
    CallRemoteEvent("OnBaseJumpFinish")
end
AddEvent("OnPlayerCancelSkydive", PlayerParachuteLand)
AddEvent("OnPlayerSkydiveCrash", CrashBaseJump)