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
		print("Running Hero Selection script")
		HeroSelection:HeroListPreLoad()
	end

	if NewState == DOTA_GAMERULES_STATE_PRE_GAME then
		self.NewState_spawn = 0
		local numberOfPlayers = PlayerResource:GetPlayerCount()
		if numberOfPlayers > 7 then -- Plus de 7 
			self.TEAM_POINT_TO_WIN = 300
		elseif numberOfPlayers > 4 and numberOfPlayers <= 7 then -- 7 ou plus de 4
			self.TEAM_POINT_TO_WIN = 250
		elseif numberOfPlayers == 2 then -- 2
			self.TEAM_POINT_TO_WIN = 125
		else -- 4 ou moins 
			self.TEAM_POINT_TO_WIN = 200
		end
	end

	if NewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		print( "OnGameRulesStateChange: Game In Progress" )
		print("CUSTOM EVENT")
		print("PTW : " .. self.TEAM_POINT_TO_WIN)
		local battle_begiin =
			{
				Teampointtowin = self.TEAM_POINT_TO_WIN
			}
			local Teampointtowin = self.TEAM_POINT_TO_WIN
			CustomGameEventManager:Send_ServerToAllClients( "battle_begiin", {Teampointtowin=Teampointtowin})

		self.NewState_spawn = 1
		print("[SupremeHeroesWars] Unlock All Players")

		for _, hero in pairs(HeroList:GetAllHeroes()) do
			if hero:GetUnitName() == "npc_dota_hero_wisp" then return end
			hero:RemoveModifierByName("modifier_prevent_game_start")
			PlayerResource:SetCameraTarget(hero:GetPlayerID(), nil)
		end

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
			npc.score = 0
			-- Le code pour appliqué le modifier qui stun tout le monde
		else
			if not npc.score then npc.score = 0 end
			RespawnAtSpawnPoint(npc)
			npc:AddNewModifier(npc, npc, "modifier_respawn_immu", {duration = 5})
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
	if SPAWN_POINT[random] == 1 then
		SPAWN_POINT[random] = 0 
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

-- Objets Ramasé au sol
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

ScoreTeam = {} -- Spawn Point activé? 1 = oui
ScoreTeam[2] = 0 -- radiant
ScoreTeam[3] = 0 -- dire 
ScoreTeam[4] = 0 -- NEUTRE
ScoreTeam[5] = 0 -- 3
ScoreTeam[6] = 0 -- 4 
ScoreTeam[7] = 0 -- 5
ScoreTeam[8] = 0 -- 6
ScoreTeam[9] = 0 -- 7
ScoreTeam[10] = 0 -- 8
ScoreTeam[11] = 0 -- 9
ScoreTeam[12] = 0 -- 10
ScoreTeam[13] = 0 -- 10

-- value
function GameMode:Addscore(TeamID, value)
		ScoreTeam[TeamID] = ScoreTeam[TeamID] + value
		print("SCORE TEAM " .. TeamID .. " = " ..ScoreTeam[TeamID])
		CustomGameEventManager:Send_ServerToAllClients("SetTopBarScoreValue", { teamId = TeamID, teamScore = ScoreTeam[TeamID] } )

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
	Timers:CreateTimer(FrameTime(), function()

	print(ScoreTeam[TeamID])
	local KillsRemaining = self.TEAM_POINT_TO_WIN - ScoreTeam[TeamID] -- par score maintenant PTW = 250

	local broadcast_kill_event =
	{
		killer_id = event.killer_userid,
		team_id = event.teamnumber,
		team_kills = TeamKills,
		team_score = ScoreTeam[TeamID],
		kills_remaining = KillsRemaining,
		victory = 0,
		close_to_victory = 0,
		very_close_to_victory = 0,
	}

	if KillsRemaining <= 0 then
		--GameRules:SetCustomVictoryMessage( self.m_VictoryMessages[TeamID] )
		GameRules:SetGameWinner( TeamID )
		KILLSREMAINING_ITEM = 0
		broadcast_kill_event.victory = 1
	elseif KillsRemaining == 10 then
		EmitGlobalSound( "ui.npe_objective_complete" )
		broadcast_kill_event.very_close_to_victory = 1
	elseif KillsRemaining <= 30 then
		EmitGlobalSound( "ui.npe_objective_given" )
		broadcast_kill_event.close_to_victory = 1
	elseif KillsRemaining <= 100 then
			if itemspawn == nil then
			itemspawn = 1
			print("Item Gem")
			-- POTION
			local newItem = CreateItem( "item_crow_trow", nil, nil )
			-- newItem:SetPurchaseTime( 0 )
			local milieudelamap = Vector(0,0,0)
			local drop = CreateItemOnPositionSync( milieudelamap, newItem )
			--drop.Holdout_IsLootDrop = true
			local dropTarget = milieudelamap + RandomVector( RandomFloat( 50, 350 ) )
			newItem:LaunchLoot( false, 350, 2.0, dropTarget )
			end
	end
	end)

end

function GameMode:pointwin_sanskill(hero, teamid)

	local KillerID = hero
	local TeamID = teamid

	Timers:CreateTimer(FrameTime(), function()

	print("SCORE TEAM PWSK : " .. ScoreTeam[TeamID])
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
		--GameRules:SetCustomVictoryMessage( self.m_VictoryMessages[TeamID] )
		GameRules:SetGameWinner( TeamID )
		KILLSREMAINING_ITEM = 0
		broadcast_kill_event.victory = 1
	elseif KillsRemaining == 1 then
		EmitGlobalSound( "ui.npe_objective_complete" )
		broadcast_kill_event.very_close_to_victory = 1
	elseif KillsRemaining <= 5 then
		EmitGlobalSound( "ui.npe_objective_given" )
		broadcast_kill_event.close_to_victory = 1
	end
	end)

end

-- Unité meurt
function GameMode:OnEntityKilled( event )
	local killedUnit = EntIndexToHScript( event.entindex_killed )
	local killedTeam = killedUnit:GetTeam()
	local hero = EntIndexToHScript( event.entindex_attacker )
	local heroTeam = hero:GetTeam()
	local extraTime = 0

	local hero_playerID = hero:GetPlayerOwnerID()

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

			print("Item Potion")
			-- POTION
			local newItem = CreateItem( "item_health_potion", nil, nil )
			newItem:SetPurchaseTime( 0 )
			if newItem:IsPermanent() and newItem:GetShareability() == ITEM_FULLY_SHAREABLE then
				item:SetStacksWithOtherOwners( false )
			end
			local drop = CreateItemOnPositionSync( killedUnit:GetAbsOrigin(), newItem )
			drop.Holdout_IsLootDrop = true
			local dropTarget = killedUnit:GetAbsOrigin() + RandomVector( RandomFloat( 50, 350 ) )
			newItem:LaunchLoot( true, 150, 1.0, dropTarget )

			print("Item Mana")
			-- MANA
			local newItem_mana = CreateItem( "item_mana_potion", nil, nil )
			newItem_mana:SetPurchaseTime( 0 )
			if newItem_mana:IsPermanent() and newItem_mana:GetShareability() == ITEM_FULLY_SHAREABLE then
				item:SetStacksWithOtherOwners( false )
			end
			local drop = CreateItemOnPositionSync( killedUnit:GetAbsOrigin(), newItem_mana )
			drop.Holdout_IsLootDrop = true
			
			local dropTarget = killedUnit:GetAbsOrigin() + RandomVector( RandomFloat( 50, 100 ) )
			newItem_mana:LaunchLoot( true, 200, 1.0, dropTarget )
	end

	if killedUnit:GetUnitName() == "npc_dota_crystal_stone_golden" then
		print("-- Kill Crystal Golden--")
			local particleName = "particles/crystal/destroy_goldenwinter_destroy.vpcf"
			local particle_effect = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, killedUnit)
			ParticleManager:SetParticleControl(particle_effect, 0, killedUnit:GetAbsOrigin())

			if killedUnit.particle_name then
				-- local numberIndex = ParticleManager:CreateParticle("particles/crystal/aura.vpcf", PATTACH_POINT_FOLLOW, killedUnit)
				ParticleManager:DestroyParticle( killedUnit.particle_name, false )
				ParticleManager:ReleaseParticleIndex( killedUnit.particle_name )
			end

			GameMode:ScorekillUnit( "Golden_kill", hero )
			local memberID = hero:GetPlayerID()

			GameMode:pointwin_sanskill(hero, hero:GetTeamNumber())
			PlayerResource:ModifyGold( memberID, 300, true, 0 )
	end


	-- abilité utilisé pour le tué, or nil if not killed by an item/ability
	local killerAbility = nil
	if event.entindex_inflictor ~= nil then
			killerAbility = EntIndexToHScript( event.entindex_inflictor )
	end

	if killedUnit:IsRealHero() then
		self.allSpawned = true -- ??
		if hero:IsRealHero() and heroTeam ~= killedTeam then
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
						GameMode:ScorekillUnit( "assist", attacker )
						GameMode:pointwin_sanskill(attacker, attacker:GetTeamNumber()) 
					end
				end
			end

			if killedUnit:GetRespawnTime() > 5 then
				--print("Hero has long respawn time")
				if killedUnit:IsReincarnating() == true then
					--print("Set time for Wraith King respawn disabled")
					return nil
				else
				 
					GameMode:ScorekillUnit( killedTeam, hero )
					GameMode:SetRespawnTime( killedTeam, killedUnit, extraTime )
				end
			else
					GameMode:ScorekillUnit( killedTeam, hero )
					GameMode:SetRespawnTime( killedTeam, killedUnit, extraTime )
			end
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
	--DebugPrint('[BAREBONES] OnConnectFull')
	--DebugPrintTable(keys)
	
	local entIndex = keys.index+1
	-- entité player de l'user  
	local ply = EntIndexToHScript(entIndex)
	
	-- ID du Player qui a rejoing
	local playerID = ply:GetPlayerID()
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

function GameMode:ScorekillUnit( killedTeam, hero )
	if killedTeam == "Golden_kill" then
		TeamID = hero:GetTeamNumber()
		hero.score = hero.score + 5
		GameMode:Addscore(TeamID, 5)
	elseif killedTeam == "Item_crow" then
		TeamID = hero:GetTeamNumber()
		if self.TEAM_POINT_TO_WIN == 300 then
			hero.score = hero.score + 4
			GameMode:Addscore(TeamID, 4)
		elseif self.TEAM_POINT_TO_WIN == 125 then
			hero.score = hero.score + 2
			GameMode:Addscore(TeamID, 2)
		else
			hero.score = hero.score + 3
			GameMode:Addscore(TeamID, 3)
		end
	elseif killedTeam == "assist" then
		hero.score = hero.score + 1
		GameMode:Addscore(TeamID, 1)
	else
		TeamID = hero:GetTeamNumber()
		hero.score = hero.score + 10
		GameMode:Addscore(TeamID, 10)
			if killedTeam == self.leadingTeam and self.isGameTied == false then
				hero.score = hero.score + 5
				GameMode:Addscore(TeamID, 5)
			end
	end
	print("SCORE :" .. hero.score)
end



 