if modifier_respawn_immu == nil then
	modifier_respawn_immu = class({})
end

function modifier_respawn_immu:CheckState()
	local state = {
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		-- [MODIFIER_STATE_STUNNED] = true,
		-- [MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		-- [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	}

	return state
end

function modifier_respawn_immu:IsHidden()
	return false
end