require('internal/util')
require('gamemode')


function Precache( context )
  DebugPrint("[SupremeHeroesWars] Performing pre-load precache")
  PrecacheResource("sound", "sounds/weapons/hero/skywrath/taunt_chicken.vsnd", context)
  PrecacheResource("soundfile", "soundevents/game_sounds_custom.vsndevts", context)
end

-- Create the game mode when we activate
function Activate()
  GameRules.GameMode = GameMode()
  GameRules.GameMode:_InitGameMode()
end