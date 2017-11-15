require('internal/util')
require('gamemode')

function Precache( context )
	DebugPrint("[Frostivus] Performing pre-load precache")
	PrecacheResource("sound", "sounds/weapons/hero/skywrath/taunt_chicken.vsnd", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_custom.vsndevts", context)

	PrecacheItemByNameSync("item_crow_trow", context)
	PrecacheItemByNameSync("item_health_potion", context)
	PrecacheItemByNameSync("item_mana_potion", context)
end

-- Create the game mode when we activate
function Activate()
	GameRules.GameMode = GameMode()
	GameRules.GameMode:_InitGameMode()
end
