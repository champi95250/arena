---------------------------------
-- LUA MODIFIER 
---------------------------------

LinkLuaModifier("modifier_prevent_game_start", "modifier/modifier_prevent_game_start.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_respawn_immu", "modifier/modifier_respawn_immu.lua", LUA_MODIFIER_MOTION_NONE )

-- Quand Deconnecter
function GameMode:OnDisconnect(keys)
	--DebugPrint('[BAREBONES] Player Disconnected ' .. tostring(keys.userid))
	--DebugPrintTable(keys)
	local name = keys.name
	local networkid = keys.networkid
	local reason = keys.reason
	local userid = keys.userid
end

-- L'état du jeu a changer
function GameMode:OnGameRulesStateChange(keys)
	--DebugPrint("[BAREBONES] GameRules State Changed")
	--DebugPrintTable(keys)
	local NewState = GameRules:State_Get()

	-- Picking Screen init..
	if NewState == DOTA_GAMERULES_STATE_HERO_SELECTION then

		-- Pick Random hero if the player don't pick
		Timers:CreateTimer(HERO_SELECTION_TIME, function()
			for i = 0, DOTA_MAX_TEAM_PLAYERS do
				if PlayerResource:IsValidPlayer(i) then
					if PlayerResource:HasSelectedHero(i) == false then
						local player = PlayerResource:GetPlayer(i)
						player:MakeRandomHeroSelection()
					end
				end
			end
		end)
	end

	if NewState == DOTA_GAMERULES_STATE_PRE_GAME then
		self.NewState_spawn = 0
		local numberOfPlayers = PlayerResource:GetPlayerCount()
		if numberOfPlayers == 10 or numberOfPlayers == 9 then 
			self.TEAM_POINT_TO_WIN = 425
		elseif numberOfPlayers == 8 or numberOfPlayers == 7 then 
			self.TEAM_POINT_TO_WIN = 325
		elseif numberOfPlayers == 6 or numberOfPlayers == 5 then 
			self.TEAM_POINT_TO_WIN = 250
		elseif numberOfPlayers == 4 or numberOfPlayers == 3 then 
			self.TEAM_POINT_TO_WIN = 210
		elseif numberOfPlayers == 2 or numberOfPlayers == 1 then 
			self.TEAM_POINT_TO_WIN = 150
		end
		local battle_begiin =
		{
			Teampointtowin = self.TEAM_POINT_TO_WIN
		}
		local Teampointtowin = self.TEAM_POINT_TO_WIN
		CustomGameEventManager:Send_ServerToAllClients( "victory_condition", {Teampointtowin=Teampointtowin})
		for _, hero in pairs(HeroList:GetAllHeroes()) do
			-- if hero:GetUnitName() == "npc_dota_hero_wisp" then return end
			hero:RemoveModifierByName("modifier_prevent_game_start")
			PlayerResource:SetCameraTarget(hero:GetPlayerID(), nil)
		end

	end

	if NewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		print( "OnGameRulesStateChange: Game In Progress" )
		print("Point pour Win la game : " .. self.TEAM_POINT_TO_WIN)
		print("Initilisation des scores des joueurs présents")
		Score:Init()
		local battle_begiin =
			{
				Teampointtowin = self.TEAM_POINT_TO_WIN
			}
			local Teampointtowin = self.TEAM_POINT_TO_WIN
			CustomGameEventManager:Send_ServerToAllClients( "battle_begiin", {Teampointtowin=Teampointtowin})
			CustomGameEventManager:Send_ServerToAllClients( "victory_condition", {Teampointtowin=Teampointtowin})

		self.NewState_spawn = 1
		print("[SupremeHeroesWars] Unlock All Players")
		--PingMiniMapAtLocation(Vector(0, 0, 0) ) -- Ping a 0 0 0 
		EmitGlobalSound( "General.Begin" )

		Timers:CreateTimer(0.3, function()
			for _, hero in pairs(HeroList:GetAllHeroes()) do
				hero:RemoveModifierByName("modifier_prevent_game_start")
				PlayerResource:SetCameraTarget(hero:GetPlayerID(), nil)

				heroenti = EntIndexToHScript(hero:entindex())
				playerID = heroenti:GetPlayerID()
				local nombredetoile = 0
				CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID), "stars_notification", { nombredetoile = nombredetoile } )
				-- le score a t il etait crée pour le héro ? 1 = oui
				hero.score = 1
			end
		end)

		self.countdownEnabled = true
		--CustomGameEventManager:Send_ServerToAllClients( "show_timer", {} ) -- (montre le timer dans le panorama)
	end
end

SPAWN_POINT = {} -- Spawn Point activé? 1 = oui
SPAWN_POINT[1] = 1
SPAWN_POINT[2] = 1
SPAWN_POINT[3] = 1
SPAWN_POINT[4] = 1
SPAWN_POINT[5] = 1
SPAWN_POINT[6] = 1
SPAWN_POINT[7] = 1
SPAWN_POINT[8] = 1
SPAWN_POINT[9] = 1
SPAWN_POINT[10] = 1
KILLSREMAINING_ITEM = 1

-- NPC / HEROES SPAWN
function GameMode:OnNPCSpawned(keys)
	local npc = EntIndexToHScript(keys.entindex)

	if npc:IsRealHero() then -- Si héro
		if self.NewState_spawn == 0 then -- Si 1er fois
			print("[SupremeHeroesWars] 1st Spawn Hero")
			if GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME then
				npc:AddNewModifier(npc, npc, "modifier_prevent_game_start", {})
				PlayerResource:SetCameraTarget(npc:GetPlayerID(), npc)
			end
			-- Le code pour appliqué le modifier qui stun tout le monde
		else
			RespawnAtSpawnPoint(npc)
			local ply = npc:GetPlayerID()
			-- print("Player ID : " .. ply)
			if npc.score == nil then
				print("Nouveau player sans score")
				Score:InitPlayer(ply)
				npc.score = 1
			end
--			print("[SupremeHeroesWars] Spawn Check")
--			print("SPAWN 1 = " .. SPAWN_POINT[1]) -- radiant
--			print("SPAWN 2 = " .. SPAWN_POINT[2]) -- dire
--			print("SPAWN 3 = " .. SPAWN_POINT[3]) -- c8
--			print("SPAWN 4 = " .. SPAWN_POINT[4]) -- c1
--			print("SPAWN 5 = " .. SPAWN_POINT[5]) -- c2
--			print("SPAWN 6 = " .. SPAWN_POINT[6]) -- c3
--			print("SPAWN 7 = " .. SPAWN_POINT[7]) -- c4
--			print("SPAWN 8 = " .. SPAWN_POINT[8]) -- c5
--			print("SPAWN 9 = " .. SPAWN_POINT[9]) -- c7
--			print("SPAWN 10 = " .. SPAWN_POINT[10]) -- c    
		end
	end
end

function RespawnAtSpawnPoint(hero)
	local random = RandomInt(1, 10)
	local point = Entities:FindByName(nil, "spawn_point_"..random)

	if hero.reincarnationspawn == nil then
		hero.reincarnationspawn = 0
	end

	if hero.reincarnationspawn == 1 then
		hero.reincarnationspawn = 0
		return nil
	end

	if SPAWN_POINT[random] == 1 then
		SPAWN_POINT[random] = 0 
		hero:AddNewModifier(hero, hero, "modifier_respawn_immu", {duration = 5})
		FindClearSpaceForUnit(hero, point:GetAbsOrigin(), false)
		PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(), hero)
		Timers:CreateTimer(0.1, function()
			PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(), nil)
		end)
		Timers:CreateTimer(5.0, function()
			SPAWN_POINT[random] = 1
		end)
	else
		RespawnAtSpawnPoint(hero)
	end
end

-- Unité prend des damages ( Attention : Souvent executé )
function GameMode:OnEntityHurt(event)
	local damagebits = event.damagebits -- This might always be 0 and therefore useless
	if event.entindex_attacker ~= nil and event.entindex_killed ~= nil then
		local entCause = EntIndexToHScript(event.entindex_attacker)
		local entVictim = EntIndexToHScript(event.entindex_killed)
	end
end

-- Objets Ramassé au sol
function GameMode:OnItemPickedUp(keys)
	--DebugPrint( '[BAREBONES] OnItemPickedUp' )
	--DebugPrintTable(keys)

	local unitEntity = nil
	if keys.UnitEntitIndex then
		unitEntity = EntIndexToHScript(keys.UnitEntitIndex)
	elseif keys.HeroEntityIndex then
		unitEntity = EntIndexToHScript(keys.HeroEntityIndex)
	end

	local itemEntity = EntIndexToHScript(keys.ItemEntityIndex)
	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local itemname = keys.itemname
	print("X Rammase " .. itemname)
end

-- Player Reconnecter
function GameMode:OnPlayerReconnect(keys)
	--DebugPrint( '[BAREBONES] OnPlayerReconnect' )
	--DebugPrintTable(keys) 
end

-- Item Acheter par un player
function GameMode:OnItemPurchased( keys )
	--DebugPrint( '[BAREBONES] OnItemPurchased' )
	--DebugPrintTable(keys)
	-- The playerID of the hero who is buying something
	local plyID = keys.PlayerID
	if not plyID then return end
	-- The name of the item purchased
	local itemName = keys.itemname 
	-- The cost of the item purchased
	local itemcost = keys.itemcost
	
end

-- Ability Utilisé
function GameMode:OnAbilityUsed(keys)
	--DebugPrint('[BAREBONES] AbilityUsed')
	--DebugPrintTable(keys)
	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local abilityname = keys.abilityname
end

-- unit abilité (necro-book, chen creep, etc)
function GameMode:OnNonPlayerUsedAbility(keys)
	--DebugPrint('[BAREBONES] OnNonPlayerUsedAbility')
	--DebugPrintTable(keys)
	local abilityname=  keys.abilityname
end

-- Un Player change de nom
function GameMode:OnPlayerChangedName(keys)
	--DebugPrint('[BAREBONES] OnPlayerChangedName')
	--DebugPrintTable(keys)
	local newName = keys.newname
	local oldName = keys.oldName
end

-- Up une abilité
function GameMode:OnPlayerLearnedAbility( keys)
	--DebugPrint('[BAREBONES] OnPlayerLearnedAbility')
	--DebugPrintTable(keys)
	local player = EntIndexToHScript(keys.player)
	local abilityname = keys.abilityname
end

-- channel fait ou interrompu
function GameMode:OnAbilityChannelFinished(keys)
	--DebugPrint('[BAREBONES] OnAbilityChannelFinished')
	--DebugPrintTable(keys)
	local abilityname = keys.abilityname
	local interrupted = keys.interrupted == 1
end

-- player Lvl up
function GameMode:OnPlayerLevelUp(keys)
	local player = EntIndexToHScript(keys.player)
	local level = keys.level
end

-- last hit sur héro / tour / unité
function GameMode:OnLastHit(keys)
	local isFirstBlood = keys.FirstBlood == 1
	local isHeroKill = keys.HeroKill == 1
	local isTowerKill = keys.TowerKill == 1
	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local killedEnt = EntIndexToHScript(keys.EntKilled)
end

-- arbre coupé
function GameMode:OnTreeCut(keys)
	local treeX = keys.tree_x
	local treeY = keys.tree_y
end

-- rune activé par un héro
function GameMode:OnRuneActivated (keys)
	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local rune = keys.rune
end

-- Player Pick Hero
function GameMode:OnPlayerPickHero(keys)
	--DebugPrint('[BAREBONES] OnPlayerPickHero')
	--DebugPrintTable(keys)
	local heroClass = keys.hero
	local heroEntity = EntIndexToHScript(keys.heroindex)
	local player = EntIndexToHScript(keys.player)
end

function GameMode:OnHeroInGame(hero)
	Timers:CreateTimer(0.1, function()
		if hero:GetUnitName() ~= "npc_dota_hero_wisp" then
			print("Hero No Io")
			hero.picked = true
		end
	end)
end

-- A player killed another player in a multi-team context ?
function GameMode:OnTeamKillCredit(event)

	local KillerID = event.killer_userid
	local VictimID = event.victim_userid
	local TeamID = event.teamnumber
	local TeamKills = event.herokills

	--[[ for _,hero in pairs(HeroList:GetAllHeroes()) do
		if hero:GetTeamNumber() == TeamID then
			if oldscore == 0 then
				ScoreTeam[TeamID] = ScoreTeam + hero.score
				oldscore = hero.score
			else
				ScoreTeam[TeamID] = ScoreTeam - oldscore + hero.score
				oldscore = hero.score
			end

			print("TEAM " .. TeamID .. " = ".. ScoreTeam[TeamID])

		end
	end ]]
	--GameMode:pointwin_sanskill(KillerID, TeamID)

end

function GameMode:pointwin_sanskill(hero, teamid)

	local KillerID = hero
	local TeamID = teamid

	Timers:CreateTimer(FrameTime(), function()

	--print("SCORE TEAM PWSK : " .. ScoreTeam[TeamID])
	local KillsRemaining = self.TEAM_POINT_TO_WIN - ScoreTeam[TeamID] -- par score maintenant PTW = 250

	local broadcast_kill_event =
	{
		killer_id = hero,
		team_id = teamid,
		team_kills = TeamKills,
		team_score = ScoreTeam[TeamID],
		kills_remaining = KillsRemaining,
		victory = 0,
		close_to_victory = 0,
		very_close_to_victory = 0,
	}

	if KillsRemaining <= 0 then

		GameMode:tpendplayer()

		GameRules:SetCustomVictoryMessage( self.m_VictoryMessages[TeamID] )
		GameRules:SetGameWinner( TeamID )
		KILLSREMAINING_ITEM = 0
		broadcast_kill_event.victory = 1
	elseif KillsRemaining == 1 then
		EmitGlobalSound( "ui.npe_objective_complete" )
		broadcast_kill_event.very_close_to_victory = 1
	elseif KillsRemaining == 20 then
		EmitGlobalSound( "General.Player_Finish" )
		local netTable = {}
		netTable["round_number"] = 7
		CustomGameEventManager:Send_ServerToAllClients( "round_started", netTable )
		broadcast_kill_event.close_to_victory = 1
	elseif KillsRemaining == 10 then
		EmitGlobalSound( "General.Player_Finish" )
		local netTable = {}
		netTable["round_number"] = 7
		CustomGameEventManager:Send_ServerToAllClients( "round_started", netTable )
		broadcast_kill_event.close_to_victory = 1
	end

	if spawnchicken_start == nil then
		spawnchicken_start = 0
	end
	if spawngem_start == nil then
		spawngem_start = 0
	end

	-- Poulet Début de game
	if spawnchicken_start == 0 then
		local numberOfPlayers = PlayerResource:GetPlayerCount()
		if numberOfPlayers == 10 or numberOfPlayers == 9 then 
			if KillsRemaining <= 340 then
				EmitGlobalSound( "General.Chicken" )
				
				spawnchicken_start = 1
				print("spawn chicken")
				GameMode:Thinkcustomchicken()

				local netTable = {}
				netTable["round_number"] = 1
				CustomGameEventManager:Send_ServerToAllClients( "round_started", netTable )

			end
		elseif numberOfPlayers == 8 or numberOfPlayers == 7 then 
			if KillsRemaining <= 260 then
				EmitGlobalSound( "General.Chicken" )
				spawnchicken_start = 1
				print("spawn chicken")
				GameMode:Thinkcustomchicken()

				local netTable = {}
				netTable["round_number"] = 1
				CustomGameEventManager:Send_ServerToAllClients( "round_started", netTable )
				
			end
		elseif numberOfPlayers == 6 or numberOfPlayers == 5 then 
			if KillsRemaining <= 200 then
				EmitGlobalSound( "General.Chicken" )
				spawnchicken_start = 1
				print("spawn chicken")
				GameMode:Thinkcustomchicken()

				local netTable = {}
				netTable["round_number"] = 1
				CustomGameEventManager:Send_ServerToAllClients( "round_started", netTable )
				
			end
		elseif numberOfPlayers == 4 or numberOfPlayers == 3 then 
			if KillsRemaining <= 165 then
				EmitGlobalSound( "General.Chicken" )
				spawnchicken_start = 1
				print("spawn chicken")
				GameMode:Thinkcustomchicken()

				local netTable = {}
				netTable["round_number"] = 1
				CustomGameEventManager:Send_ServerToAllClients( "round_started", netTable )
				
			end
		elseif numberOfPlayers == 2 or numberOfPlayers == 1 then 
			if KillsRemaining <= 110 then
				EmitGlobalSound( "General.Chicken" )
				spawnchicken_start = 1
				print("spawn chicken")
				GameMode:Thinkcustomchicken()

				local netTable = {}
				netTable["round_number"] = 1
				CustomGameEventManager:Send_ServerToAllClients( "round_started", netTable )
				
			end
		end
	end

	if self.Roundwolf == 0 then
		local numberOfPlayers = PlayerResource:GetPlayerCount()
		if numberOfPlayers == 10 or numberOfPlayers == 9 then 
			if KillsRemaining <= 140 then
				print("Loup Mode")
				Score:TrieScore()
			end
		elseif numberOfPlayers == 8 or numberOfPlayers == 7 then 
			if KillsRemaining <= 110 then
				print("Loup Mode")
				Score:TrieScore()
			end
		elseif numberOfPlayers == 6 or numberOfPlayers == 5 then 
			if KillsRemaining <= 85 then
				print("Loup Mode")
				Score:TrieScore()
			end
		elseif numberOfPlayers == 4 then 
			if KillsRemaining <= 70 then
				print("Loup Mode")
				Score:TrieScore()
			end
		elseif numberOfPlayers == 2 or numberOfPlayers == 1 or numberOfPlayers == 3 then 
			if KillsRemaining <= 50 then
			print("Pas de loup mode en 1 / 2 / 3 players ")
			end
		end

	end

	if spawnroshan_start == nil then
		spawnroshan_start = 0
	end


	if spawnroshan_start == 0 then
		-- Wolf cancel if roshan start
		local numberOfPlayers = PlayerResource:GetPlayerCount()
		if numberOfPlayers == 10 or numberOfPlayers == 9 then 
			if KillsRemaining <= 90 then
				self.Roundwolf = 1
				spawnroshan_start = 1
				Score:Roshan()
			end
		elseif numberOfPlayers == 8 or numberOfPlayers == 7 then 
			if KillsRemaining <= 65 then
				self.Roundwolf = 1
				spawnroshan_start = 1
				Score:Roshan()
			end
		elseif numberOfPlayers == 6 or numberOfPlayers == 5 then 
			if KillsRemaining <= 50 then
				self.Roundwolf = 1
				spawnroshan_start = 1
				Score:Roshan()
			end
		elseif numberOfPlayers == 4 or numberOfPlayers == 3 then 
			if KillsRemaining <= 42 then
				self.Roundwolf = 1
				spawnroshan_start = 1
				Score:Roshan()
			end
		elseif numberOfPlayers == 2 or numberOfPlayers == 1 then 
			if KillsRemaining <= 30 then
				self.Roundwolf = 1
				spawnroshan_start = 1
				Score:Roshan()
			end
		end
	end

	-- Gem Apparait en milieu de game
	if spawngem_start == 0 then
		local numberOfPlayers = PlayerResource:GetPlayerCount()
		if numberOfPlayers == 10 or numberOfPlayers == 9 then 
			if KillsRemaining <= 280 then
				spawngem_start = 1
				print("spawn Gem")
				GameMode:SpawnGem()
			end
		elseif numberOfPlayers == 8 or numberOfPlayers == 7 then 
			if KillsRemaining <= 216 then
				spawngem_start = 1
				print("spawn Gem")
				GameMode:SpawnGem()
			end
		elseif numberOfPlayers == 6 or numberOfPlayers == 5 then 
			if KillsRemaining <= 166 then
				spawngem_start = 1
				print("spawn Gem")
				GameMode:SpawnGem()
			end
		elseif numberOfPlayers == 4 or numberOfPlayers == 3 then 
			if KillsRemaining <= 140 then
				spawngem_start = 1
				print("spawn Gem")
				GameMode:SpawnGem()
			end
		elseif numberOfPlayers == 2 or numberOfPlayers == 1 then 
			if KillsRemaining <= 100 then
				spawngem_start = 1
				print("spawn Gem")
				GameMode:SpawnGem()
			end
		end
	end

	-- Fin Timer
	end)

end

function GameMode:tpendplayer()

	local foundTeams = {}
    for _, playerStart in pairs( HeroList:GetAllHeroes() ) do
        print(playerStart:GetTeam())
        foundTeams[  playerStart:GetTeam() ] = true
    end

	local numTeams = TableCount(foundTeams)

	local foundplayer = {}

	for _, playerStart in pairs( HeroList:GetAllHeroes() ) do
        playerStart = playerStart:GetPlayerOwner():GetAssignedHero()
        local player_ent = EntIndexToHScript(playerStart:entindex())
        table.insert( foundplayer, { player = player_ent, teamScore = ScoreTeam[playerStart:GetTeam()] } )
    end

    table.sort( foundplayer, function(a,b) return ( a.teamScore > b.teamScore ) end )

	if numTeams == 0 then
		return nil
	end

	if numTeams >= 1 then -- Si 1 joueur ou plus
		FindClearSpaceForUnit(foundplayer[1].player, Vector(0,-600,0), false)
		foundplayer[1].player:SetAngles(0,-90,0)
		foundplayer[1].player:StartGesture(ACT_DOTA_VICTORY)

		local origin_point = Vector(-210,-580,-20)
	    local trophy = CreateUnitByName("npc_dota_trophy", origin_point, false, nil, nil, DOTA_TEAM_NEUTRALS)
	    -- FindClearSpaceForUnit(trophy, origin_point, true)

	    local origin_point2 = Vector(210,-580,-20)
	    local trophy2 = CreateUnitByName("npc_dota_trophy", origin_point2, false, nil, nil, DOTA_TEAM_NEUTRALS)
	    -- FindClearSpaceForUnit(trophy2, origin_point2, true)
	end

	if numTeams >= 2 then -- Si 2 joueur ou plus, si 1 il n'y as pas
		FindClearSpaceForUnit(foundplayer[2].player, Vector(-150,-400,0), false)
		foundplayer[2].player:SetAngles(0,-90,0)
	end

	if numTeams >= 3 then
		FindClearSpaceForUnit(foundplayer[3].player, Vector(150,-400,0), false)
		foundplayer[3].player:SetAngles(0,-90,0)
	end

	if numTeams >= 4 then
		FindClearSpaceForUnit(foundplayer[4].player, Vector(-420,-200,0), false)
		foundplayer[4].player:SetAngles(0,-90,0)
	end

	if numTeams >= 5 then
		FindClearSpaceForUnit(foundplayer[5].player, Vector(0,-180,0), false)
		foundplayer[5].player:SetAngles(0,-90,0)
	end

	if numTeams >= 6 then
		FindClearSpaceForUnit(foundplayer[6].player, Vector(420,-200,0), false)
		foundplayer[6].player:SetAngles(0,-90,0)
	end


	if numTeams >= 7 then
		FindClearSpaceForUnit(foundplayer[7].player, Vector(-440,100,0), false)
		foundplayer[7].player:SetAngles(0,-90,0)
	end

	if numTeams >= 8 then
		FindClearSpaceForUnit(foundplayer[8].player, Vector(-180,100,0), false)
		foundplayer[8].player:SetAngles(0,-90,0)
	end

	if numTeams >= 9 then
		FindClearSpaceForUnit(foundplayer[9].player, Vector(180,100,0), false)
		foundplayer[9].player:SetAngles(0,-90,0)
	end

	if numTeams >= 10 then
		FindClearSpaceForUnit(foundplayer[10].player, Vector(440,100,0), false)
		foundplayer[10].player:SetAngles(0,-90,0)
	end

end

function GameMode:SpawnGem()

	local netTable = {}
	netTable["round_number"] = 2
	CustomGameEventManager:Send_ServerToAllClients( "round_started", netTable )

	EmitGlobalSound("General.FemaleLevelUp")

	print("Item Gem")
	-- POTION
	local newItem = CreateItem( "item_crow_trow", nil, nil )
	-- newItem:SetPurchaseTime( 0 )
	local milieudelamap = Vector(0,0,0)
	local drop = CreateItemOnPositionSync( milieudelamap, newItem )
	--drop.Holdout_IsLootDrop = true
	local dropTarget = milieudelamap + RandomVector( RandomFloat( 200, 450 ) )
	newItem:LaunchLoot( false, 350, 2.0, dropTarget )
end

-- Unité meurt
function GameMode:OnEntityKilled( event )
	local killedUnit = EntIndexToHScript( event.entindex_killed )
	local killedTeam = killedUnit:GetTeam()
	local hero = EntIndexToHScript( event.entindex_attacker )
	local heroTeam = hero:GetTeam()
	local extraTime = 0

	local hero_playerID = hero:GetPlayerOwnerID()

	if killedUnit:GetUnitName() == "npc_dota_creature_roshan_ice" then
		-- StopSound("Music.Roshan")

		if not hero:IsHero() then
			local hero = hero:GetMainControllingPlayer()
		end

		Score:ScoreKillRoshan( hero, 25 )
	end

	if killedUnit:GetUnitName() == "npc_dota_crystal_stone" then
		print("-- Kill Crystal --")
			local particleName = "particles/crystal/destroywinter_destroy.vpcf"
			local particle_effect = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, killedUnit)
			ParticleManager:SetParticleControl(particle_effect, 0, killedUnit:GetAbsOrigin())

			if killedUnit.particle_name then
				-- local numberIndex = ParticleManager:CreateParticle("particles/crystal/aura.vpcf", PATTACH_POINT_FOLLOW, killedUnit)
				ParticleManager:DestroyParticle( killedUnit.particle_name, false )
				ParticleManager:ReleaseParticleIndex( killedUnit.particle_name )
			end

			-- REMOVE DU POINT
			local original = killedUnit.original
			print("Le point de ce Crystal est le " .. original)
			SPAWN_CRYSTAL_POINT[original] = 1

			-- POTION
			local newItem = CreateItem( "item_health_potion", nil, nil )
			newItem:SetPurchaseTime( 0 )
			if newItem:IsPermanent() and newItem:GetShareability() == ITEM_FULLY_SHAREABLE then
				item:SetStacksWithOtherOwners( false )
			end
			local drop = CreateItemOnPositionSync( killedUnit:GetAbsOrigin(), newItem )
			drop.Holdout_IsLootDrop = true
			local dropTarget = killedUnit:GetAbsOrigin() + RandomVector( RandomFloat( 50, 100 ) )
			newItem:LaunchLoot( true, 160, 0.7, dropTarget )

			-- MANA
			local newItem_mana = CreateItem( "item_mana_potion", nil, nil )
			newItem_mana:SetPurchaseTime( 0 )
			if newItem_mana:IsPermanent() and newItem_mana:GetShareability() == ITEM_FULLY_SHAREABLE then
				item:SetStacksWithOtherOwners( false )
			end
			local drop = CreateItemOnPositionSync( killedUnit:GetAbsOrigin(), newItem_mana )
			drop.Holdout_IsLootDrop = true
			
			local dropTarget = killedUnit:GetAbsOrigin() + RandomVector( RandomFloat( 50, 100 ) )
			newItem_mana:LaunchLoot( true, 160, 0.7, dropTarget )
	end

	if killedUnit:GetUnitName() == "npc_dota_crystal_stone_golden" then
		print("-- Kill Crystal Golden--")
			local particleName = "particles/crystal/destroy_goldenwinter_destroy.vpcf"
			local particle_effect = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, killedUnit)
			ParticleManager:SetParticleControl(particle_effect, 0, killedUnit:GetAbsOrigin())

			local original = killedUnit.original
			print("Le point de ce Crystal est le " .. original)
			SPAWN_CRYSTAL_GOLDEN_POINT[original] = 1

			if killedUnit.particle_name then
				-- local numberIndex = ParticleManager:CreateParticle("particles/crystal/aura.vpcf", PATTACH_POINT_FOLLOW, killedUnit)
				ParticleManager:DestroyParticle( killedUnit.particle_name, false )
				ParticleManager:ReleaseParticleIndex( killedUnit.particle_name )
			end
			if not hero:IsHero() then
				local hero = hero:GetMainControllingPlayer()
				-- local hero = GetPlayerData(playerID)
				PlayerResource:ModifyGold( hero, 300, true, 0 )
			else
				local memberID = hero:GetPlayerID()
				PlayerResource:ModifyGold( memberID, 300, true, 0 )
			end
			local etoiletomber = 3 

			Timers:CreateTimer(function()
				if etoiletomber ~= 0 then
					local newItem = CreateItem( "item_stars_ground", nil, nil )
					newItem:SetPurchaseTime( 0 )
					if newItem:IsPermanent() and newItem:GetShareability() == ITEM_FULLY_SHAREABLE then
						item:SetStacksWithOtherOwners( false )
					end
					local drop = CreateItemOnPositionSync( killedUnit:GetAbsOrigin(), newItem )
					drop.Holdout_IsLootDrop = true
					local dropTarget = killedUnit:GetAbsOrigin() + RandomVector( RandomFloat( 50, 100 ) )
					newItem:LaunchLoot( true, 125, 0.8, dropTarget )
					etoiletomber = etoiletomber - 1
					return 0.1
				else
					return nil
				end
			end)
				-- local memberID = hero:GetPlayerID()
	end


	-- abilité utilisé pour le tué, or nil if not killed by an item/ability
	local killerAbility = nil
	if event.entindex_inflictor ~= nil then
			killerAbility = EntIndexToHScript( event.entindex_inflictor )
	end

	if killedUnit:IsRealHero() then
		self.allSpawned = true -- ??
		if hero:IsHero() and heroTeam ~= killedTeam then
			if killedUnit:GetTeam() == self.leadingTeam and self.isGameTied == false then -- Team leader tuée
				local memberID = hero:GetPlayerID()
				PlayerResource:ModifyGold( memberID, 500, true, 0 )
				hero:AddExperience( 150, 0, false, false )
				local name = hero:GetClassname()
				local victim = killedUnit:GetClassname()
				local kill_alert =
					{
						hero_id = hero:GetClassname()
					}
				CustomGameEventManager:Send_ServerToAllClients( "kill_alert", kill_alert )
			else
				hero:AddExperience( 75, 0, false, false )
			end
			--Donne l'xp au héro qui ont assist
			local allHeroes = HeroList:GetAllHeroes()
			for _,attacker in pairs( allHeroes ) do
				--print(killedUnit:GetNumAttackers())
				for i = 0, killedUnit:GetNumAttackers() - 1 do
					if attacker == killedUnit:GetAttacker( i ) then
						--print("Granting assist xp")
						attacker:AddExperience( 30, 0, false, false )
					end
				end
			end

			if killedUnit:GetRespawnTime() > 5 then
				--print("Hero has long respawn time")
				if killedUnit:IsReincarnating() == true then
					killedUnit.reincarnationspawn = 1
					--print("Set time for Wraith King respawn disabled")
					return nil
				else
					----------------------
				 	-- score Unité Tué
				 	----------------------
				 	GameMode:Etoiletomber(killedUnit)
					Score:ScoreKill( killedTeam, killedUnit, hero, 5 )
					GameMode:SetRespawnTime( killedTeam, killedUnit, extraTime )
				end
			else
				if killedUnit:IsReincarnating() == true then
					killedUnit.reincarnationspawn = 1
					--print("Set time for Wraith King respawn disabled")
					return nil
				else
					----------------------
				 	-- score Unité Tué
				 	----------------------
				 	GameMode:Etoiletomber(killedUnit)
					Score:ScoreKill( killedTeam, killedUnit, hero, 5 )
					GameMode:SetRespawnTime( killedTeam, killedUnit, extraTime )
				end
			end
		elseif not hero:IsHero() and heroTeam ~= killedTeam then
			if killedUnit:IsReincarnating() == true then
				killedUnit.reincarnationspawn = 1
					--print("Set time for Wraith King respawn disabled")
					return nil
				else
			GameMode:SetRespawnTime( killedTeam, killedUnit, extraTime )
			if hero:GetUnitName() == "npc_dota_creature_roshan_ice" then
				return nil
			end
				if not hero:IsHero() then
					local hero = hero:GetMainControllingPlayer()
				end
				----------------------
				-- score Unité Tué
				----------------------
				GameMode:Etoiletomber(killedUnit)
				Score:ScoreKill( killedTeam, killedUnit, hero, 5 )
			end
		end
	end
end

function GameMode:Etoiletomber(killedUnit)
	print("ETOILE A TOMBER")
	if killedUnit:IsHero() then
 		herouniter = EntIndexToHScript(killedUnit:entindex())
		playerid = herouniter:GetPlayerID()
		print("SCORE DE L'UNITER TUER : " .. Score.data[playerid].starobtenue )
		if Score.data[playerid].starobtenue ~= 0 then 
			print("SPAWN ETOILE")
			local etoiletomber = math.floor(Score.data[playerid].starobtenue / 2)
			print(etoiletomber)
			math.floor(etoiletomber)
			if etoiletomber > 17 then
				etoiletomber = 17
			end
			Score.data[playerid].starobtenue = Score.data[playerid].starobtenue - etoiletomber
			local nombredetoile = Score.data[playerid].starobtenue 
	        CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerid), "stars_notification", { nombredetoile = nombredetoile } )
				Timers:CreateTimer(function()
					if etoiletomber ~= 0 then
						local newItem = CreateItem( "item_stars_ground", nil, nil )
						newItem:SetPurchaseTime( 0 )
						if newItem:IsPermanent() and newItem:GetShareability() == ITEM_FULLY_SHAREABLE then
							item:SetStacksWithOtherOwners( false )
						end
						local drop = CreateItemOnPositionSync( killedUnit:GetAbsOrigin(), newItem )
						drop.Holdout_IsLootDrop = true
						local dropTarget = killedUnit:GetAbsOrigin() + RandomVector( RandomFloat( 50, 350 ) )
						newItem:LaunchLoot( true, 150, 0.7, dropTarget )
						etoiletomber = etoiletomber - 1 
						return 0.07
					elseif etoiletomber == 0 then
						return nil
					end
				end)
		end
 	end
end

-- Player connect fonction 1 à 2 fois 
function GameMode:PlayerConnect(keys)
	--DebugPrint('[BAREBONES] PlayerConnect')
	--DebugPrintTable(keys)
end

-- tout le monde connecter
function GameMode:OnConnectFull(keys)
DebugPrint('[BAREBONES] OnConnectFull')
	DebugPrintTable(keys)
	-- Server_SendAndGetInfoForAll()
	
	local entIndex = keys.index+1
	local ply = EntIndexToHScript(entIndex)
	local player_id = ply:GetPlayerID()
end

-- illusion crée
function GameMode:OnIllusionsCreated(keys)
	--DebugPrint('[BAREBONES] OnIllusionsCreated')
	--DebugPrintTable(keys)
	local originalEntity = EntIndexToHScript(keys.original_entindex)
end

-- item combiné
function GameMode:OnItemCombined(keys)
	--DebugPrint('[BAREBONES] OnItemCombined')
	--DebugPrintTable(keys)

	-- The playerID of the hero who is buying something
	local plyID = keys.PlayerID
	if not plyID then return end
	local player = PlayerResource:GetPlayer(plyID)

	-- The name of the item purchased
	local itemName = keys.itemname 
	
	-- The cost of the item purchased
	local itemcost = keys.itemcost
end

-- début du cast ( avant diffusion )
function GameMode:OnAbilityCastBegins(keys)
	--DebugPrint('[BAREBONES] OnAbilityCastBegins')
	--DebugPrintTable(keys)

	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local abilityName = keys.abilityname
end

-- tour tuée
function GameMode:OnTowerKill(keys)
	--DebugPrint('[BAREBONES] OnTowerKill')
	--DebugPrintTable(keys)

	local gold = keys.gold
	local killerPlayer = PlayerResource:GetPlayer(keys.killer_userid)
	local team = keys.teamnumber
end

-- un joueur, changement d'équipe
function GameMode:OnPlayerSelectedCustomTeam(keys)
	--DebugPrint('[BAREBONES] OnPlayerSelectedCustomTeam')
	--DebugPrintTable(keys)

	local player = PlayerResource:GetPlayer(keys.player_id)
	local success = (keys.success == 1)
	local team = keys.team_id
end

-- PNJ atteint son but
function GameMode:OnNPCGoalReached(keys)
	--DebugPrint('[BAREBONES] OnNPCGoalReached')
	--DebugPrintTable(keys)

	local goalEntity = EntIndexToHScript(keys.goal_entindex)
	local nextGoalEntity = EntIndexToHScript(keys.next_goal_entindex)
	local npc = EntIndexToHScript(keys.npc_entindex)
end

-- fonction chat en team ou all 
function GameMode:OnPlayerChat(keys)
	local teamonly = keys.teamonly
	local userID = keys.userid
	local playerID = self.vUserIds[userID]:GetPlayerID()

	local text = keys.text
end

function GameMode:SetRespawnTime( killedTeam, killedUnit, extraTime )
	if killedTeam == self.leadingTeam and self.isGameTied == false then
		killedUnit:SetTimeUntilRespawn( 7 + extraTime )
	else
		killedUnit:SetTimeUntilRespawn( 5 + extraTime )
	end
end