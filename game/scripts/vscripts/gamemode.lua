-- This is the primary SupremeHeroesWars gamemode script and should be used to assist in initializing your game mode
SupremeHeroesWars_VERSION = "0.1"

-- Set this to true if you want to see a complete debug output of all events/processes done by SupremeHeroesWars
-- You can also change the cvar 'SupremeHeroesWars_spew' at any time to 1 or 0 for output/no output
SupremeHeroesWars_DEBUG_SPEW = false 

_G.nNEUTRAL_TEAM = 4
_G.nCOUNTDOWNTIMER = 901

if GameMode == nil then
    DebugPrint( '[SupremeHeroesWars] creating SupremeHeroesWars game mode' )
    _G.GameMode = class({})
end

-- This library allow for easily delayed/timed actions
require('libraries/timers')
-- This library can be used for advancted physics/motion/collision of units.  See PhysicsReadme.txt for more information.
require('libraries/physics')
-- This library can be used for advanced 3D projectile systems.
require('libraries/projectiles')
-- This library can be used for sending panorama notifications to the UIs of players/teams/everyone
require('libraries/notifications')
-- This library can be used for starting customized animations on units from lua
require('libraries/animations')
-- This library can be used for performing "Frankenstein" attachments on units
-- require('libraries/attachments')
-- This library can be used to synchronize client-server data via player/client-specific nettables
require('libraries/playertables')
-- This library can be used to create container inventories or container shops
require('libraries/containers')
-- This library provides a searchable, automatically updating lua API in the tools-mode via "modmaker_api" console command
-- require('libraries/modmaker')
-- This library provides an automatic graph construction of path_corner entities within the map
require('libraries/pathgraph')
-- This library (by Noya) provides player selection inspection and management from server lua
require('libraries/selection')

-- These internal libraries set up SupremeHeroesWars's events and processes.  Feel free to inspect them/change them if you need to.
require('internal/gamemode')
require('internal/events')

-- settings.lua is where you can specify many different properties for your game mode and is one of the core SupremeHeroesWars files.
require('settings')
-- events.lua is where you can specify the actions to be taken when any event occurs and is one of the core SupremeHeroesWars files.
require('events')

-- custom ajouté
require('utility_functions/utility_time_message')
require('utility_functions/utility_functions')
--[[
  This function should be used to set up Async precache calls at the beginning of the gameplay.

  In this function, place all of your PrecacheItemByNameAsync and PrecacheUnitByNameAsync.  These calls will be made
  after all players have loaded in, but before they have selected their heroes. PrecacheItemByNameAsync can also
  be used to precache dynamically-added datadriven abilities instead of items.  PrecacheUnitByNameAsync will 
  precache the precache{} block statement of the unit and all precache{} block statements for every Ability# 
  defined on the unit.

  This function should only be called once.  If you want to/need to precache more items/abilities/units at a later
  time, you can call the functions individually (for example if you want to precache units in a new wave of
  holdout).

  This function should generally only be used if the Precache() function in addon_game_mode.lua is not working.
]]
function GameMode:PostLoadPrecache()
  DebugPrint("[SupremeHeroesWars] Performing Post-Load precache")    
  --PrecacheItemByNameAsync("item_example_item", function(...) end)
  --PrecacheItemByNameAsync("example_ability", function(...) end)

  --PrecacheUnitByNameAsync("npc_dota_hero_viper", function(...) end)
  --PrecacheUnitByNameAsync("npc_dota_hero_enigma", function(...) end)
end

--[[
  This function is called once and only once as soon as the first player (almost certain to be the server in local lobbies) loads in.
  It can be used to initialize state that isn't initializeable in InitGameMode() but needs to be done before everyone loads in.
]]
function GameMode:OnFirstPlayerLoaded()
  DebugPrint("[SupremeHeroesWars] First Player has loaded")
end

--[[
  This function is called once and only once after all players have loaded into the game, right as the hero selection time begins.
  It can be used to initialize non-hero player state or adjust the hero selection (i.e. force random etc)
]]
function GameMode:OnAllPlayersLoaded()
  DebugPrint("[SupremeHeroesWars] All Players have loaded into the game")
end

--[[
  This function is called once and only once for every player when they spawn into the game for the first time.  It is also called
  if the player's hero is replaced with a new hero for any reason.  This function is useful for initializing heroes, such as adding
  levels, changing the starting gold, removing/adding abilities, adding physics, etc.

  The hero parameter is the hero entity that just spawned in
]]
function GameMode:OnHeroInGame(hero)
  DebugPrint("[SupremeHeroesWars] Hero spawned in game for first time -- " .. hero:GetUnitName())


end

function GameMode:OnGameInProgress()
  DebugPrint("[SupremeHeroesWars] The game has officially begun")

  Timers:CreateTimer(30, -- Start this timer 30 game-time seconds later
    function()
      DebugPrint("This function is called 30 seconds after the game begins, and every 30 seconds thereafter")
      return 30.0 -- Rerun this timer every 30 game-time seconds 
    end)
end



-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later
function GameMode:InitGameMode()
  GameMode = self
  DebugPrint('[SupremeHeroesWars] Starting to load SupremeHeroesWars gamemode...')

  self.TEAM_POINT_TO_WIN = 250
  self.countdownEnabled = false
  self.isGameTied = true -- Si 2 team sont égalité
  self.leadingTeam = -1 -- Team leader
  self.NewState_spawn = 0 -- check le states et le spawn
  self.m_GatheredShuffledTeams = {} -- Team
  self:GatherAndRegisterValidTeams()

  GameRules:GetGameModeEntity():SetThink( "OnThink", self, 1 ) 
  ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(GameMode, 'OnGameRulesStateChange'), self)
  ListenToGameEvent( "npc_spawned" , Dynamic_Wrap(GameMode, 'OnNPCSpawned'), self)
  ListenToGameEvent( "entity_killed", Dynamic_Wrap( GameMode, 'OnEntityKilled' ), self )
  ListenToGameEvent("dota_team_kill_credit", Dynamic_Wrap(GameMode, 'OnTeamKillCredit'), self)

  DebugPrint('[SupremeHeroesWars] Done loading SupremeHeroesWars gamemode!\n\n')
end

---------------------------------------------------------------------------
-- Simple scoreboard using debug text
---------------------------------------------------------------------------
function GameMode:UpdateScoreboard()
  local sortedTeams = {}
  for _, team in pairs( self.m_GatheredShuffledTeams ) do
    table.insert( sortedTeams, { teamID = team, teamScore = ScoreTeam[team] } )
  end

  -- reverse-sort by score
  table.sort( sortedTeams, function(a,b) return ( a.teamScore > b.teamScore ) end )

  for _, t in pairs( sortedTeams ) do
    -- local clr = self:ColorForTeam( t.teamID )

    -- Scaleform UI Scoreboard
    local score = 
    {
      team_id = t.teamID,
      team_score = t.teamScore
    }
    FireGameEvent( "score_board", score )
  end
  -- Leader effects (moved from OnTeamKillCredit)
  local leader = sortedTeams[1].teamID
  print("Leader = " .. leader)
  self.leadingTeam = leader
  self.runnerupTeam = sortedTeams[2].teamID
  self.leadingTeamScore = sortedTeams[1].teamScore
  self.runnerupTeamScore = sortedTeams[2].teamScore
  if sortedTeams[1].teamScore == sortedTeams[2].teamScore then
    self.isGameTied = true
  else
    self.isGameTied = false
  end
  local allHeroes = HeroList:GetAllHeroes()
  for _,entity in pairs( allHeroes) do
    if entity:GetTeamNumber() == leader and sortedTeams[1].teamScore ~= sortedTeams[2].teamScore then
      if entity:IsAlive() == true then
        -- Attaching a particle to the leading team heroes
        local existingParticle = entity:Attribute_GetIntValue( "particleID", -1 )
            if existingParticle == -1 then
              local particleLeader = ParticleManager:CreateParticle( "particles/leader/leader_overhead.vpcf", PATTACH_OVERHEAD_FOLLOW, entity )
          ParticleManager:SetParticleControlEnt( particleLeader, PATTACH_OVERHEAD_FOLLOW, entity, PATTACH_OVERHEAD_FOLLOW, "follow_overhead", entity:GetAbsOrigin(), true )
          entity:Attribute_SetIntValue( "particleID", particleLeader )
        end
      else
        local particleLeader = entity:Attribute_GetIntValue( "particleID", -1 )
        if particleLeader ~= -1 then
          ParticleManager:DestroyParticle( particleLeader, true )
          entity:DeleteAttribute( "particleID" )
        end
      end
    else
      local particleLeader = entity:Attribute_GetIntValue( "particleID", -1 )
      if particleLeader ~= -1 then
        ParticleManager:DestroyParticle( particleLeader, true )
        entity:DeleteAttribute( "particleID" )
      end
    end
  end
end

---------------------------------------------------------------------------
-- Scan the map to see which teams have spawn points
---------------------------------------------------------------------------
function GameMode:GatherAndRegisterValidTeams()
  print( "GatherValidTeams:" )

  local foundTeams = {}
  for _, playerStart in pairs( Entities:FindAllByClassname( "info_player_start_dota" ) ) do
    print(playerStart:GetTeam())
    foundTeams[  playerStart:GetTeam() ] = true
  end

  local numTeams = TableCount(foundTeams)
  print( "GatherValidTeams - Found spawns for a total of " .. numTeams .. " teams" )
  
  local foundTeamsList = {}
  for t, _ in pairs( foundTeams ) do
    table.insert( foundTeamsList, t )
  end

  if numTeams == 0 then
    print( "GatherValidTeams - NO team spawns detected, defaulting to GOOD/BAD" )
    table.insert( foundTeamsList, DOTA_TEAM_GOODGUYS )
    table.insert( foundTeamsList, DOTA_TEAM_BADGUYS )
    numTeams = 2
  end

  local maxPlayersPerValidTeam = math.floor( 10 / numTeams )

  self.m_GatheredShuffledTeams = ShuffledList( foundTeamsList )

  print( "Final shuffled team list:" )
  for _, team in pairs( self.m_GatheredShuffledTeams ) do
    print( " - " .. team .. " ( " .. GetTeamName( team ) .. " )" )
  end

  print( "Setting up teams:" )
  for team = 0, (DOTA_TEAM_COUNT-1) do
    local maxPlayers = 0
    if ( nil ~= TableFindKey( foundTeamsList, team ) ) then
      maxPlayers = maxPlayersPerValidTeam
    end
    print( " - " .. team .. " ( " .. GetTeamName( team ) .. " ) -> max players = " .. tostring(maxPlayers) )
    GameRules:SetCustomGameTeamMaxPlayers( team, maxPlayers )
  end
end


function GameMode:OnThink()
  --DebugPrint('[SupremeHeroesWars] On Think')

  for nPlayerID = 0, (DOTA_MAX_TEAM_PLAYERS-1) do
    --self:UpdatePlayerColor( nPlayerID )
  end
  
  GameMode:UpdateScoreboard()

  -- Stop thinking if game is paused
  if GameRules:IsGamePaused() == true then
    return 1
  end

  if self.countdownEnabled == true then
    CountdownTimer()
    if nCOUNTDOWNTIMER == 30 then -- si le temps arrive a moins de 30 = 30 secondes 
      -- CustomGameEventManager:Send_ServerToAllClients( "timer_alert", {} )
    end
    if nCOUNTDOWNTIMER <= 0 then -- si le temps arrive a 0
      -- Check si egalité ou non
      --if self.isGameTied == false then
        --GameRules:SetCustomVictoryMessage( self.m_VictoryMessages[self.leadingTeam] )
        --COverthrowGameMode:EndGame( self.leadingTeam )
        --self.countdownEnabled = false
      --else
        --self.TEAM_KILLS_TO_WIN = self.leadingTeamScore + 1
        --local broadcast_killcount = 
        --{
        --  killcount = self.TEAM_KILLS_TO_WIN
        --}
        -- CustomGameEventManager:Send_ServerToAllClients( "overtime_alert", broadcast_killcount )
      --end
    end
  end

  return 1
end