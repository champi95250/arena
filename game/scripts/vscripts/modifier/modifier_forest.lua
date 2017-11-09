if modifier_forest == nil then
	modifier_forest = class({})
end

function modifier_forest:CheckState()
	local state = {
	}

	return state
end

function modifier_forest:DeclareFunctions()
    local decFuncs =
	{
		MODIFIER_PROPERTY_BONUS_DAY_VISION,
		MODIFIER_PROPERTY_BONUS_NIGHT_VISION
	}
    return decFuncs
end

function modifier_forest:OnCreated()
	self.vision_reduction = -1375
	self.vision_reduction_night = -475
	if IsServer() then	
	end
end

function modifier_forest:OnDestroy()
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self:GetAbility()
	end
end

function modifier_forest:IsHidden()
	return false
end

function modifier_forest:GetBonusDayVision()
	return self.vision_reduction end

function modifier_forest:GetBonusNightVision()
return self.vision_reduction_night end