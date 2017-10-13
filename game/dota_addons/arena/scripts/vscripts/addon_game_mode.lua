require('internal/util')
require('gamemode')


function Precache( context )
  DebugPrint("[SupremeHeroesWars] Performing pre-load precache")
end

-- Create the game mode when we activate
function Activate()
  GameRules.GameMode = GameMode()
  GameRules.GameMode:_InitGameMode()
end