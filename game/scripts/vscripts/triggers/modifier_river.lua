------------------------------------
-- TRIGGERS River
------------------------------------

function glace_modifier_for_hero(trigger)
	local activator = trigger.activator
	activator:AddNewModifier( activator, nil, "modifier_ice_slide", {} )
end


function glace_modifier_for_hero_remove(trigger)
	local activator = trigger.activator
	activator:RemoveModifierByName("modifier_ice_slide")
end

------------------------------------
-- TRIGGERS Cimetiere
------------------------------------
LinkLuaModifier("modifier_cimetiere", "modifier/modifier_cimetiere.lua", LUA_MODIFIER_MOTION_NONE )

function cimetiere_modifier_for_hero(trigger)
	local activator = trigger.activator
	activator:AddNewModifier( activator, nil, "modifier_cimetiere", {} )
end


function cimetiere_modifier_for_hero_remove(trigger)
	local activator = trigger.activator
	activator:RemoveModifierByName("modifier_cimetiere")
end

------------------------------------
-- TRIGGERS Battle
------------------------------------
LinkLuaModifier("modifier_battle", "modifier/modifier_battle.lua", LUA_MODIFIER_MOTION_NONE )

function battle_modifier_for_hero(trigger)
	local activator = trigger.activator
	activator:AddNewModifier( activator, nil, "modifier_battle", {} )
end


function battle_modifier_for_hero_remove(trigger)
	local activator = trigger.activator
	activator:RemoveModifierByName("modifier_battle")
end


------------------------------------
-- TRIGGERS Forest
------------------------------------

LinkLuaModifier("modifier_forest", "modifier/modifier_forest.lua", LUA_MODIFIER_MOTION_NONE )

function forest_modifier_for_hero(trigger)
	local activator = trigger.activator
	activator:AddNewModifier( activator, nil, "modifier_forest", {} )
end


function forest_modifier_for_hero_remove(trigger)
	local activator = trigger.activator
	activator:RemoveModifierByName("modifier_forest")
end