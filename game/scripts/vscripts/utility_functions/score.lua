if not Score then
    Score = class({})
end

function Score:Init()
    Score.data = {}
    for playerID = 0, DOTA_MAX_TEAM_PLAYERS do
        if PlayerResource:IsValidPlayerID(playerID) then
            --print("PLAYER ID INIT : " .. playerID)
            self:InitPlayer(playerID)
        end
    end
end

function Score:InitPlayer(playerID)
    Score.data[playerID] = {}
    -- Score détailler
    Score.data[playerID].starobtenue = 0
    Score.data[playerID].kill = 0
    Score.data[playerID].kill_leader = 0
    Score.data[playerID].kill_golden_crystal = 0
    Score.data[playerID].gem = 0
    Score.data[playerID].chicken = 0
    Score.data[playerID].loup = 0
    Score.data[playerID].loup_golden = 0
    Score.data[playerID].chevre = 0
    Score.data[playerID].roshan = 0
    -- Total du score
    Score.data[playerID].total = 0
    --print("PLAYER ID FINAL INIT : " .. playerID)
end

function Score:ScoreKill( killedTeam, killedUnit, hero )
    -- Lorsque qu'un kill est effectué
    if IsValidEntity(hero:GetPlayerOwner()) then hero = hero:GetPlayerOwner():GetAssignedHero() end
    if hero:IsIllusion() then hero = PlayerResource:GetPlayer(hero:GetPlayerID()):GetAssignedHero() end
    hero = EntIndexToHScript(hero:entindex())
    playerid = hero:GetPlayerID()

    --print("Player id = " .. playerid)
    if killedUnit:GetTeam() == GameMode.leadingTeam and GameMode.isGameTied == false then
        Score.data[playerid].kill_leader = Score.data[playerid].kill_leader + 7
        Score.data[playerid].starobtenue = Score.data[playerid].starobtenue + 7
        Score:AddscoreTeam(hero, 7)
        --Score.data[playerID].total = Score.data[playerID].total + 15
    else
        Score.data[playerid].kill = Score.data[playerid].kill + 5
        Score.data[playerid].starobtenue = Score.data[playerid].starobtenue + 5
        Score:AddscoreTeam(hero, 5)
        --Score.data[playerID].total = Score.data[playerID].total + 10
    end
end

function Score:ScoreGolden( hero )
    -- Lorsque qu'un golden est tuée
    if IsValidEntity(hero:GetPlayerOwner()) then hero = hero:GetPlayerOwner():GetAssignedHero() end
    if hero:IsIllusion() then hero = PlayerResource:GetPlayer(hero:GetPlayerID()):GetAssignedHero() end
    hero = EntIndexToHScript(hero:entindex())
    playerid = hero:GetPlayerID()
    --print("Player id = " .. playerid)
    Score.data[playerid].kill_golden_crystal = Score.data[playerid].kill_golden_crystal + 3
    Score.data[playerid].starobtenue = Score.data[playerid].starobtenue + 3
    Score:AddscoreTeam(hero, 3)
    --Score.data[playerID].total = Score.data[playerID].total + 5
end

function Score:ScoreChicken( hero )
    -- Lorsque qu'un Chicken est touché
    if IsValidEntity(hero:GetPlayerOwner()) then hero = hero:GetPlayerOwner():GetAssignedHero() end
    if hero:IsIllusion() then hero = PlayerResource:GetPlayer(hero:GetPlayerID()):GetAssignedHero() end
    hero = EntIndexToHScript(hero:entindex())
    playerid = hero:GetPlayerID()
    --print("Player id = " .. playerid)
    Score.data[playerid].chicken = Score.data[playerid].chicken + 1
    Score.data[playerid].starobtenue = Score.data[playerid].starobtenue + 1
    Score:AddscoreTeam(hero, 1)
    --Score.data[playerID].total = Score.data[playerID].total + 1
end

function Score:ScoreGem( hero )
    -- Lorsque que la gem est porté
    if IsValidEntity(hero:GetPlayerOwner()) then hero = hero:GetPlayerOwner():GetAssignedHero() end
    if hero:IsIllusion() then hero = PlayerResource:GetPlayer(hero:GetPlayerID()):GetAssignedHero() end
    hero = EntIndexToHScript(hero:entindex())
    playerid = hero:GetPlayerID()
    --print("Player id = " .. playerid)
    Score.data[playerid].gem = Score.data[playerid].gem + 4
    Score.data[playerid].starobtenue = Score.data[playerid].starobtenue + 4
    Score:AddscoreTeam(hero, 4)
    --Score.data[playerID].total = Score.data[playerID].total + 5
end

function Score:ScoreLoup( hero )
    -- Lorsque qu'un Chicken est touché
    if IsValidEntity(hero:GetPlayerOwner()) then hero = hero:GetPlayerOwner():GetAssignedHero() end
    if hero:IsIllusion() then hero = PlayerResource:GetPlayer(hero:GetPlayerID()):GetAssignedHero() end
    hero = EntIndexToHScript(hero:entindex())
    playerid = hero:GetPlayerID()
    --print("Player id = " .. playerid)
    Score.data[playerid].loup = Score.data[playerid].loup + 2
    Score.data[playerid].starobtenue = Score.data[playerid].starobtenue + 2
    Score:AddscoreTeam(hero, 2)
    --Score.data[playerID].total = Score.data[playerID].total + 1
end

function Score:ScoreLoupGolden( hero )
    -- Lorsque qu'un Chicken est touché
    if IsValidEntity(hero:GetPlayerOwner()) then hero = hero:GetPlayerOwner():GetAssignedHero() end
    if hero:IsIllusion() then hero = PlayerResource:GetPlayer(hero:GetPlayerID()):GetAssignedHero() end
    hero = EntIndexToHScript(hero:entindex())
    playerid = hero:GetPlayerID()
    --print("Player id = " .. playerid)
    Score.data[playerid].loup_golden = Score.data[playerid].loup_golden + 3
    Score.data[playerid].starobtenue = Score.data[playerid].starobtenue + 3
    Score:AddscoreTeam(hero, 3)
    --Score.data[playerID].total = Score.data[playerID].total + 1
end

function Score:ScoreKillRoshan( hero )
    -- Lorsque qu'un Chicken est touché
    if IsValidEntity(hero:GetPlayerOwner()) then hero = hero:GetPlayerOwner():GetAssignedHero() end
    if hero:IsIllusion() then hero = PlayerResource:GetPlayer(hero:GetPlayerID()):GetAssignedHero() end
    hero = EntIndexToHScript(hero:entindex())
    playerid = hero:GetPlayerID()
    --print("Player id = " .. playerid)
    Score.data[playerid].roshan = Score.data[playerid].roshan + 25
    Score.data[playerid].starobtenue = Score.data[playerid].starobtenue + 25
    Score:AddscoreTeam(hero, 25)
    --Score.data[playerID].total = Score.data[playerID].total + 1
end

function Score:ScoreItemRamser( hero )
    -- Lorsque qu'un Chicken est touché
    if IsValidEntity(hero:GetPlayerOwner()) then hero = hero:GetPlayerOwner():GetAssignedHero() end
    if hero:IsIllusion() then hero = PlayerResource:GetPlayer(hero:GetPlayerID()):GetAssignedHero() end
    hero = EntIndexToHScript(hero:entindex())
    playerid = hero:GetPlayerID()
    --print("Player id = " .. playerid)
    Score.data[playerid].starobtenue = Score.data[playerid].starobtenue + 1
    Score:AddscoreTeam(hero, 1)
    --Score.data[playerID].total = Score.data[playerID].total + 1
end
---------------------------------------------------------------------------
-- Score par Team
---------------------------------------------------------------------------

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

function Score:AddscoreTeam(hero, value)
        -- SendOverheadEventMessage(hero, OVERHEAD_ALERT_GOLD, caster, goldgain, nil ) -- particles/particle_point_add.vpcf
        hero = EntIndexToHScript(hero:entindex())
        playerID = hero:GetPlayerID()
        PopupNumbers(hero, "particles/particle_point_add.vpcf", Vector(100, 255, 100), 1.0, value, POPUP_SYMBOL_PRE_PLUS, nil)
        local nombredetoile = Score.data[playerID].starobtenue 
        print("SCORE PLAYER : " .. nombredetoile )
        CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID), "stars_notification", { nombredetoile = nombredetoile } )
        -- CustomGameEventManager:Send_ServerToAllClients("SetTopBarScoreValue", { teamId = Teamid, teamScore = ScoreTeam[Teamid] } )
end

function Score:Startdeposer(hero)
		-- vérifier le hero
		hero = EntIndexToHScript(hero:entindex())
		playerID = hero:GetPlayerID()
		local nombredeposer = Score.data[playerID].starobtenue
		if nombredeposer > 0 then
			PopupNumbers(hero, "particles/particle_point_add.vpcf", Vector(100, 255, 100), 3.0, 1, POPUP_SYMBOL_PRE_PLUS, nil)
	        local Teamid = hero:GetTeamNumber()
	        -- ajout du score
	        ScoreTeam[Teamid] = ScoreTeam[Teamid] + 1
	        print("SCORE TEAM " .. Teamid .. " : " ..ScoreTeam[Teamid])
	        GameMode:pointwin_sanskill(hero, Teamid)
	        -- plus d'étoile sur le héro 
	        Score.data[playerID].starobtenue = Score.data[playerID].starobtenue - 1
	        CustomGameEventManager:Send_ServerToAllClients("SetTopBarScoreValue", { teamId = Teamid, teamScore = ScoreTeam[Teamid] } )
	        local nombredetoile = Score.data[playerID].starobtenue 
	        CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID), "stars_notification", { nombredetoile = nombredetoile } )
	    end
end


---------------------------------------------------------------------------
-- Game Phase 
-- GERE LES ROUNDS DE ROSHAN  ET LOUP 
---------------------------------------------------------------------------

---------------------------------------------------------------------------
-- Loup Phase
---------------------------------------------------------------------------

LinkLuaModifier("modifier_wolf", "modifier/modifier_wolf.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_mouton", "modifier/modifier_mouton.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_mouton_golden", "modifier/modifier_mouton_golden.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_creature_roshan", "abilities/creature_roshan.lua", LUA_MODIFIER_MOTION_NONE )

function Score:TrieScore()
    print( "VALID TEAM :" )

    local foundTeams = {}
    for _, playerStart in pairs( HeroList:GetAllHeroes() ) do
        print(playerStart:GetTeam())
        foundTeams[  playerStart:GetTeam() ] = true
    end

    local numTeams = TableCount(foundTeams)
    print( "VALID TEAM - Trouve un total de " .. numTeams .. " teams" )

    local foundTeamsList = {}
    for t, _ in pairs( foundTeams ) do
        table.insert( foundTeamsList, t )
    end

    -- Si egale a 0 .. on sais jamais
    if numTeams == 0 then
        print( "GatherValidTeams - NO team spawns detected, defaulting to GOOD/BAD" )
        table.insert( foundTeamsList, DOTA_TEAM_GOODGUYS )
        table.insert( foundTeamsList, DOTA_TEAM_BADGUYS )
        table.insert( foundTeamsList, DOTA_TEAM_CUSTOM_1 )
        numTeams = 3
    end

    local shuffleliste = ShuffledList( foundTeamsList )

    for _, team in pairs( shuffleliste ) do
        print( " TEAM - " .. team .. " ( " .. GetTeamName( team ) .. " )" )
    end

    local TeamPremier = {}
    local TeamDernier = {}

    for _, team in pairs( shuffleliste ) do
        if ScoreTeam[team] == nil then
            ScoreTeam[team] = 0 
        end
        table.insert( TeamPremier, { teamID = team, teamScore = ScoreTeam[team] } )
    end

    for _, team in pairs( shuffleliste ) do
        if ScoreTeam[team] == nil then
            ScoreTeam[team] = 0 
        end
        table.insert( TeamDernier, { teamID = team, teamScore = ScoreTeam[team] } )
    end

    table.sort( TeamPremier, function(a,b) return ( a.teamScore > b.teamScore ) end )
    table.sort( TeamDernier, function(a,b) return ( a.teamScore < b.teamScore ) end )

    PrintTable( TeamPremier )
    PrintTable( TeamDernier )

    if numTeams == 3 or numTeams == 2 or numTeams == 1 then
        print("STOP WOLF PAS ASSEZ DEQUIPE")
        return nil
    end

    local leader = TeamPremier[1].teamID
    local dernier = TeamDernier[1].teamID
    local avant_dernier = TeamDernier[2].teamID

    print("Leader : " .. leader)
    print("Dernier : " .. dernier)
    print("Avant Dernier : " .. avant_dernier)

    if TeamDernier[2].teamScore == TeamDernier[1].teamScore then
        -- Egalité des team derniere 
        print("Team Egalité")
    end

    local foundplayer = {}

    if TeamDernier[2].teamScore ~= TeamDernier[1].teamScore then
        print("Team Non Egalité")
        for _, playerStart in pairs( HeroList:GetAllHeroes() ) do
            playerStart = playerStart:GetPlayerOwner():GetAssignedHero()
            local player_ent = EntIndexToHScript(playerStart:entindex())
            table.insert( foundplayer, { player = player_ent, teamScore = ScoreTeam[playerStart:GetTeam()] } )
        end

        table.sort( foundplayer, function(a,b) return ( a.teamScore < b.teamScore ) end )
        if not foundplayer[1].player:IsAlive() then
            return nil
        end

        print("pret pour transformation")

        foundplayer[1].player:AddNewModifier(foundplayer[1].player, foundplayer[1].player, "modifier_wolf", {})

        for playermouton = 2, (numTeams-1) do
            print("SCORE DES MOUTON : " .. foundplayer[playermouton].teamScore)
            if foundplayer[playermouton].player:IsAlive() then
            foundplayer[playermouton].player:AddNewModifier(foundplayer[playermouton].player, foundplayer[playermouton].player, "modifier_mouton", {})
            else
                Timers:CreateTimer(1.0, function()
                    if foundplayer[playermouton].player:IsAlive() then
                        foundplayer[playermouton].player:AddNewModifier(foundplayer[playermouton].player, foundplayer[playermouton].player, "modifier_mouton", {})
                         print("Mouton ok")
                        return nil
                    else
                         print("Mouton PAS ok")
                        return 1
                    end
                end)
            end
        --self:UpdatePlayerColor( nPlayerID )
        end
        if foundplayer[numTeams].player:IsAlive() then
            foundplayer[numTeams].player:AddNewModifier(foundplayer[numTeams].player, foundplayer[numTeams].player, "modifier_mouton_golden", {})
        else 
            Timers:CreateTimer(1.0, function()
                    if foundplayer[numTeams].player:IsAlive() then
                        foundplayer[numTeams].player:AddNewModifier(foundplayer[numTeams].player, foundplayer[numTeams].player, "modifier_mouton_golden", {})
                        print("Mouton ok")
                        return nil
                    else
                        print("Mouton PAS ok")
                        return 1
                    end
                end)
            end

        local netTable = {}
        netTable["round_number"] = 5
        CustomGameEventManager:Send_ServerToAllClients( "round_started", netTable )

        GameMode.Roundwolf = 1
        EmitGlobalSound("General.Loup")

        Timers:CreateTimer(30, function()

            for _, hero in pairs(HeroList:GetAllHeroes()) do
                if hero:HasModifier("modifier_mouton") then
                    hero:RemoveModifierByName("modifier_mouton")
                end
                if hero:HasModifier("modifier_wolf") then
                    hero:RemoveModifierByName("modifier_wolf")
                end
                if hero:HasModifier("modifier_mouton_golden") then
                    hero:RemoveModifierByName("modifier_mouton_golden")
                end
                GameMode.Roundwolf = 2
            end
        end)
        -- foundplayer[1].player
        -- numTeams ( +1 )

    end
end

---------------------------------------------------------------------------
-- Roshan Phase
---------------------------------------------------------------------------

function Score:Roshan()

    EmitGlobalSound( "Music.Roshan" )

    -- Roshan Title
    print("spawn Roshan")
    local netTable = {}
    netTable["round_number"] = 6
    CustomGameEventManager:Send_ServerToAllClients( "round_started", netTable )

    local origin_point = Vector(0,0,0)
    local roshan = CreateUnitByName("npc_dota_creature_roshan_ice", origin_point, false, nil, nil, DOTA_TEAM_NEUTRALS)
    FindClearSpaceForUnit(roshan, origin_point, true)

    Timers:CreateTimer(0.5, function()
        EmitGlobalSound("Roshann.Tombe") -- Timer 0.6
    end)
    Timers:CreateTimer(1.0, function()
        roshan:StartGesture(ACT_DOTA_CAST_ABILITY_4)
        Timers:CreateTimer(0.6, function()
            EmitGlobalSound("Roshan.Cryy") -- Timer 0.6
            roshan:AddNewModifier(roshan, roshan, "modifier_creature_roshan", {})
        end)
    end)
    

end

---------------------------------------------------------------------------
-- Pluie D'étoile 
---------------------------------------------------------------------------

function Score:pluieetoile()

	if pluieetoile_start == nil then
		pluieetoile_start = 1 -- Pour annulé le 1er lancé
		print("start 1er lancé annulé")
		Timers:CreateTimer(300, function()
					Score:pluieetoile()
					return nil
				end)
	end

	local random_lieu = RandomInt(1, 4)
	-- 1 forest
	-- 2 Battlefield
	-- 3 Water
	-- 4 Cimetiere
	local random_etoile = RandomInt(1, 12)
	random_etoile = random_etoile + 7 -- maximun 30 étoile ... minimun 8 maxim 19
	print("lancé d'étoile")

	if random_lieu == 1 then -- point de lancement -2497 -2521 388
		PingMiniMapAtLocation(Vector(-2497, -2521, 385))
		Timers:CreateTimer(function()
			if random_etoile ~= 0 then
				local newItem = CreateItem( "item_stars_ground", nil, nil )
				newItem:SetPurchaseTime( 0 )
				if newItem:IsPermanent() and newItem:GetShareability() == ITEM_FULLY_SHAREABLE then
					item:SetStacksWithOtherOwners( false )
				end
				-- point dou sa sort 
				local point = Vector(-2497, -2521, 338)
				local drop = CreateItemOnPositionSync( point, newItem )
				drop.Holdout_IsLootDrop = true
				local dropTarget = point + RandomVector( RandomFloat( 150, 750 ) )
				newItem:LaunchLoot( true, 450, 1.8, dropTarget )
				random_etoile = random_etoile - 1 
				return 0.1
			elseif random_etoile == 0 then
				Timers:CreateTimer(240, function()
					Score:pluieetoile()
					return nil
				end)
				return nil
			end
		end)
	elseif random_lieu == 2 then -- point de lancement 2673 2674 385
		PingMiniMapAtLocation( Vector(2673, 2674, 385) )
		Timers:CreateTimer(function()
			if random_etoile ~= 0 then
				local newItem = CreateItem( "item_stars_ground", nil, nil )
				newItem:SetPurchaseTime( 0 )
				if newItem:IsPermanent() and newItem:GetShareability() == ITEM_FULLY_SHAREABLE then
					item:SetStacksWithOtherOwners( false )
				end
				-- point dou sa sort 
				local point = Vector(2673, 2674, 385)
				local drop = CreateItemOnPositionSync( point, newItem )
				drop.Holdout_IsLootDrop = true
				local dropTarget = point + RandomVector( RandomFloat( 150, 850 ) )
				newItem:LaunchLoot( true, 450, 1.8, dropTarget )
				random_etoile = random_etoile - 1 
				return 0.1
			elseif random_etoile == 0 then
				Timers:CreateTimer(240, function()
					Score:pluieetoile()
					return nil
				end)
				return nil
			end
		end)
	elseif random_lieu == 3 then -- point de lancement 2643 -2558 24
		PingMiniMapAtLocation( Vector(2673, -2558, 24) )
		Timers:CreateTimer(function()
			if random_etoile ~= 0 then
				local newItem = CreateItem( "item_stars_ground", nil, nil )
				newItem:SetPurchaseTime( 0 )
				if newItem:IsPermanent() and newItem:GetShareability() == ITEM_FULLY_SHAREABLE then
					item:SetStacksWithOtherOwners( false )
				end
				-- point dou sa sort 
				local point = Vector(2643, -2558, 24)
				local drop = CreateItemOnPositionSync( point, newItem )
				drop.Holdout_IsLootDrop = true
				local dropTarget = point + RandomVector( RandomFloat( 150, 750 ) )
				newItem:LaunchLoot( true, 450, 1.8, dropTarget )
				random_etoile = random_etoile - 1 
				return 0.1
			elseif random_etoile == 0 then
				Timers:CreateTimer(240, function()
					Score:pluieetoile()
					return nil
				end)
				return nil
			end
		end)
	elseif random_lieu == 4 then -- point de lancement -2497 2504 128
		PingMiniMapAtLocation( Vector(-2497, 2504, 128) )
		Timers:CreateTimer(function()
			if random_etoile ~= 0 then
				local newItem = CreateItem( "item_stars_ground", nil, nil )
				newItem:SetPurchaseTime( 0 )
				if newItem:IsPermanent() and newItem:GetShareability() == ITEM_FULLY_SHAREABLE then
					item:SetStacksWithOtherOwners( false )
				end
				-- point dou sa sort 
				local point = Vector(-2497, 2504, 128)
				local drop = CreateItemOnPositionSync( point, newItem )
				drop.Holdout_IsLootDrop = true
				local dropTarget = point + RandomVector( RandomFloat( 150, 750 ) )
				newItem:LaunchLoot( true, 450, 1.8, dropTarget )
				random_etoile = random_etoile - 1 
				return 0.1
			elseif random_etoile == 0 then
				Timers:CreateTimer(240, function()
					Score:pluieetoile()
					return nil
				end)
				return nil
			end
		end)
	end

end