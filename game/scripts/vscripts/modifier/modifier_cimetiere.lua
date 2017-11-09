if modifier_cimetiere == nil then
	modifier_cimetiere = class({})
end

function modifier_cimetiere:CheckState()
	local state = {
	}

	return state
end

function modifier_cimetiere:DeclareFunctions()
    local decFuncs =
	{
		MODIFIER_EVENT_ON_DEATH
	}
    return decFuncs
end

function modifier_cimetiere:OnCreated()
	if IsServer() then	
	end
end

function modifier_cimetiere:OnDestroy()
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self:GetAbility()
	end
end

function modifier_cimetiere:IsHidden()
	return false
end

function modifier_cimetiere:OnDeath(keys)
	if IsServer() then
		local caster = self:GetParent()
		local unit = keys.unit
		if caster == unit and caster:IsRealHero() then
			local gosth = CreateUnitByName("npc_dota_neutral_ghost", caster:GetAbsOrigin(), false, caster, caster, caster:GetTeamNumber())
			gosth:AddNewModifier(self.caster, self.ability, "modifier_kill", {duration = 5})
			local playerid = caster:GetPlayerID()
            if playerid then
                gosth:SetControllableByPlayer(playerid, true)
			end
		end
	end
end