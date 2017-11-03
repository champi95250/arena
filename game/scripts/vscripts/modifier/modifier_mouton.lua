if modifier_mouton == nil then
	modifier_mouton = class({})
end

function modifier_mouton:CheckState()
	local state = {[MODIFIER_STATE_HEXED] = true,
				 [MODIFIER_STATE_DISARMED] = true,
				 [MODIFIER_STATE_SILENCED] = true,
				 [MODIFIER_STATE_MUTED] = true,
				 [MODIFIER_STATE_PASSIVES_DISABLED] = true}
	return state
end

function modifier_mouton:DeclareFunctions()
    local decFuncs = {MODIFIER_PROPERTY_MODEL_CHANGE,
                      MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE}

    return decFuncs
end

function modifier_mouton:GetModifierModelChange()
    return "models/items/hex/sheep_hex/sheep_hex.vmdl"
end
-- models/items/lycan/wolves/blood_moon_hunter_wolves/blood_moon_hunter_wolves.vmdl
-- "models/items/hex/sheep_hex/sheep_hex.vmdl"
-- "models/items/hex/sheep_hex/sheep_hex_gold.vmdl"

function modifier_mouton:GetModifierMoveSpeed_Absolute()
    return 375
end

function modifier_mouton:RemoveOnDeath() return false end

function modifier_mouton:IsHidden() return false end
function modifier_mouton:IsPurgable() return true end
function modifier_mouton:IsDebuff() return true end

function modifier_mouton:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end