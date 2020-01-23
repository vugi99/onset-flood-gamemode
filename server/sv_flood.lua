local curwater_lvl = 0

local game_launched = false

local playing_players = {}

function OnPlayerJoin(ply)
    SetPlayerSpawnLocation(ply, 125773.000000, 80246.000000, 1645.000000, 90.0)
    CallRemoteEvent(ply,"GetWaterLvl",curwater_lvl)
    SetPlayerRespawnTime(ply, 1000)
end
AddEvent("OnPlayerJoin", OnPlayerJoin)

function OnPlayerSpawn(ply)
    if game_launched then
        CallRemoteEvent(ply,"Ingamestate",false)
        local removedply = false
        for i,tblply in ipairs(playing_players) do
           if tblply==ply then
              table.remove(playing_players,i)
              removedply=true
           end
        end
        if removedply then
            for i,ply in ipairs(GetAllPlayers()) do
            CallRemoteEvent(ply,"Syncalive",#playing_players)
            end
        end
    else
        game_launched=true
        table.insert(playing_players,ply)
        for i,ply in ipairs(GetAllPlayers()) do
            CallRemoteEvent(ply,"Syncalive",#playing_players)
            end
        CallRemoteEvent(ply,"Ingamestate", game_launched)
    end
end
AddEvent("OnPlayerSpawn", OnPlayerSpawn)


function timer_flood()
    if game_launched then
    if #playing_players>0 then
        if (curwater_lvl+50 <= 10000) then
   curwater_lvl=curwater_lvl+50
   for i,ply in ipairs(playing_players) do
    if IsValidPlayer(ply) then
    local x, y, z = GetPlayerLocation(ply)
    if z<curwater_lvl then
        SetPlayerHealth(ply, GetPlayerHealth(ply)-50)
    end
else
    table.remove(playing_players,i)
    for i,ply in ipairs(GetAllPlayers()) do
        CallRemoteEvent(ply,"Syncalive",#playing_players)
        end
   end
end
else
    for i,ply in ipairs(playing_players) do
        SetPlayerHealth(ply, 0)
    end
    playing_players={}
    curwater_lvl=0
    for i,ply in ipairs(GetAllPlayers()) do
       table.insert(playing_players,ply)
       CallRemoteEvent(ply,"Ingamestate",true)
       CallRemoteEvent(ply,"GetWaterLvl",curwater_lvl)
    end
    for i,ply in ipairs(GetAllPlayers()) do
        CallRemoteEvent(ply,"Syncalive",#playing_players)
        end
        for i,veh in ipairs(GetAllVehicles()) do
            DestroyVehicle(veh)
            end
end
else
    playing_players={}
    curwater_lvl=0
    for i,ply in ipairs(GetAllPlayers()) do
       table.insert(playing_players,ply)
       CallRemoteEvent(ply,"Ingamestate",true)
       CallRemoteEvent(ply,"GetWaterLvl",curwater_lvl)
    end
    for i,ply in ipairs(GetAllPlayers()) do
        CallRemoteEvent(ply,"Syncalive",#playing_players)
        end
        for i,veh in ipairs(GetAllVehicles()) do
            DestroyVehicle(veh)
            end
end
end
end

AddEvent("OnPackageStart",function()
    CreateTimer(timer_flood,1000)
end)

AddRemoteEvent("SpawnCarFlood",function(ply)
    if (GetPlayerVehicle(ply) == 0 and GetPlayerMovementMode(ply)~=5) then
        local x, y, z = GetPlayerLocation(ply)
        local h = GetPlayerHeading(ply)
        local veh = CreateVehicle(4, x, y, z ,h)
        SetVehicleLicensePlate(veh, "FLOOD GAMEMODE")
        SetPlayerInVehicle(ply, veh)
        SetVehicleRespawnParams(veh, false)
    end
end)

function OnPlayerQuit(ply)
    if #GetAllPlayers() == 0 then
         game_launched=false
         curwater_lvl=0
    end
    for i,tblply in ipairs(playing_players) do
        if tblply==ply then
           table.remove(playing_players,i)
           removedply=true
        end
     end
     if removedply then
         for i,ply in ipairs(GetAllPlayers()) do
         CallRemoteEvent(ply,"Syncalive",#playing_players)
         end
     end
end
AddEvent("OnPlayerQuit", OnPlayerQuit)

