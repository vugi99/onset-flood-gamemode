local waterlvl = 0
local ingame = false

local timer = nil

local nbplayers = 0

function elevate_water()
   waterlvl=waterlvl+50
   SetOceanWaterLevel(waterlvl ,false)
end

AddRemoteEvent("GetWaterLvl",function(lvl)
    waterlvl=lvl
    if timer==nil then
    timer = CreateTimer(elevate_water,1000)
    end
end)

AddRemoteEvent("Ingamestate",function(game_state)
    ingame = game_state
end)

function OnKeyPress(key)
	if (key == "G" and ingame) then
		CallRemoteEvent("SpawnCarFlood")
	end
end
AddEvent("OnKeyPress", OnKeyPress)

AddEvent("OnRenderHUD", function()
    if not ingame then
        DrawText(0, 400, "Please wait the end of the round to play")
        DrawText(0, 425, "Water level : " .. waterlvl)
        DrawText(0, 450, "Players Alive : " .. nbplayers)
    else
        DrawText(0, 400, "Press G to spawn a car")
        DrawText(0, 425, "Water level : " .. waterlvl)
        DrawText(0, 450, "Players Alive : " .. nbplayers)
    end

end)

AddRemoteEvent("Syncalive",function(alive)
    nbplayers=alive
end)

