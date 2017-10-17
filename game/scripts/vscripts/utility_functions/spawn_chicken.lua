SPAWN_CHICKEN_POINT = {} -- Spawn Point activé? 1 = oui
SPAWN_CHICKEN_POINT[1] = 1
SPAWN_CHICKEN_POINT[2] = 1
SPAWN_CHICKEN_POINT[3] = 1
SPAWN_CHICKEN_POINT[4] = 1
SPAWN_CHICKEN_POINT[5] = 1

SPAWN_CHICKEN_POINT_INTERRUPT = 1
SPAWN_CHICKEN_TIME_SPAWN = 0
SPAWN_CHICKEN_LIMIT = 0



function GameMode:Thinkcustomchicken()
		Timers:CreateTimer(0.0, function()
			GameMode:Spawnchicken()
			SPAWN_CHICKEN_TIME_SPAWN = SPAWN_CHICKEN_TIME_SPAWN + 1
			if SPAWN_CHICKEN_POINT_INTERRUPT == 1 then
				return 0.3 -- 30 secondes 
			else
				return nil
			end
		end)
end

function GameMode:Spawnchicken()
	local random = RandomInt(1, 5)
	local point = Entities:FindByName(nil, "point_unit_chiken_"..random)
	local summon_origin = point:GetAbsOrigin()
	SPAWN_CHICKEN_LIMIT = SPAWN_CHICKEN_LIMIT + 1
	if SPAWN_CHICKEN_LIMIT == 50 then
		print("----------------")
		print("STOP CHICKEN ?")
		print("----------------")
		SPAWN_CHICKEN_POINT_INTERRUPT = 0
	end
	local chicken = CreateUnitByName("npc_dota_creature_bonus_chicken", summon_origin, false, nil, nil, DOTA_TEAM_NEUTRALS)
	FindClearSpaceForUnit(chicken, summon_origin, true)
end