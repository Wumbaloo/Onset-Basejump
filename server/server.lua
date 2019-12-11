local basejumpers = {}

function StartBaseJump(player)
    if (IsPlayerDead(player)) then
        return AddPlayerChat(player, "You can't base jump because you're dead.")
    end
    local select = basejumpPositions[math.random(1, #basejumpPositions)]
    local height = 50000
    local x, y = select[1], select[2]
    local bounds = 34000
    local targetX = math.random(math.floor(x - bounds), math.floor(x + bounds))
    local targetY = math.random(math.floor(y - bounds), math.floor(y + bounds))

    AttachPlayerParachute(player, true)
    basejumpers[player] = CreateObject(496, x, y, height - 200)
    SetPlayerLocation(player, x, y, height)
    AddPlayerChat(player, "Welcome to basejump, you're at " .. math.floor(height) / 100 .. " meters. Good luck.")
    SetPlayerHeadSize(player, 3)
    CallRemoteEvent(player, "OnBaseJumpStart", targetX, targetY)
end
AddCommand("basejump", StartBaseJump)

function OnBaseJumpFinish(player)
    if (basejumpers[player]) then
        DestroyObject(basejumpers[player])
        basejumpers[player] = false
        SetPlayerHeadSize(player, 1)
        AttachPlayerParachute(player, false)
        SetPlayerAnimation(player, "FLEXX")
        Delay(5000, function(player)
            SetPlayerAnimation(player, "STOP")
        end, player)
    end
end
AddEvent("OnPlayerQuit", OnBaseJumpFinish)
AddEvent("OnPlayerSpawn", OnBaseJumpFinish)
AddEvent("OnPlayerEnterVehicle", OnBaseJumpFinish)
AddRemoteEvent("OnBaseJumpFinish", OnBaseJumpFinish)