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

function modifier_respawn_immu:OnCreated()
	if IsServer() then	
		local caster = self:GetCaster()
		local particleName = "particles/base/immuniser_spawn.vpcf"
		local particle_effect = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(particle_effect, 0, caster:GetAbsOrigin())
		self.existing_particle_respawn = particle_effect
	end
end

function modifier_respawn_immu:OnDestroy()
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self:GetAbility()

		-- Destroy breath particle when motion interrupted
		if self.existing_particle_respawn then
			local destroy_existing_particle_respawn = self.existing_particle_respawn
			self.existing_particle_respawn = nil
			-- Delay before destroying particle
			Timers:CreateTimer(0.4, function()
				ParticleManager:DestroyParticle(destroy_existing_particle_respawn, false)
				ParticleManager:ReleaseParticleIndex( destroy_existing_particle_respawn )
			end)
		end
	end
end

function modifier_respawn_immu:IsHidden()
	return false
end