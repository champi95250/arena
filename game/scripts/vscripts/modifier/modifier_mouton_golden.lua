if modifier_mouton_golden == nil then
	modifier_mouton_golden = class({})
end

function modifier_mouton_golden:CheckState()
	local state = {[MODIFIER_STATE_HEXED] = true,
				 [MODIFIER_STATE_DISARMED] = true,
				 [MODIFIER_STATE_SILENCED] = true,
				 [MODIFIER_STATE_MUTED] = true,
				 [MODIFIER_STATE_PASSIVES_DISABLED] = true}
	return state
end

function modifier_mouton_golden:DeclareFunctions()
    local decFuncs = {MODIFIER_PROPERTY_MODEL_CHANGE,
                      MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE}

    return decFuncs
end

function modifier_mouton_golden:GetModifierModelChange()
    return "models/items/hex/sheep_hex/sheep_hex_gold.vmdl"
end
-- models/items/lycan/wolves/blood_moon_hunter_wolves/blood_moon_hunter_wolves.vmdl
-- "models/items/hex/sheep_hex/sheep_hex.vmdl"
-- "models/items/hex/sheep_hex/sheep_hex_gold.vmdl"

function modifier_mouton_golden:GetModifierMoveSpeed_Absolute()
    return 425
end

function modifier_mouton_golden:RemoveOnDeath() return false end

function modifier_mouton_golden:IsHidden() return false end
function modifier_mouton_golden:IsPurgable() return true end
function modifier_mouton_golden:IsDebuff() return true end


function modifier_mouton_golden:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end