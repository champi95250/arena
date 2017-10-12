if modifier_prevent_game_start == nil then
	modifier_prevent_game_start = class({})
end

function modifier_prevent_game_start:CheckState()
	local state = {
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	}

	return state
end

function modifier_prevent_game_start:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE
	}
 
	return funcs
end

function modifier_prevent_game_start:GetOverrideAnimation()
	return ACT_DOTA_DISABLED
end

function modifier_prevent_game_start:GetOverrideAnimationRate()
	return 0.5
end

function modifier_prevent_game_start:OnCreated()
	if IsServer() then	
		local caster = self:GetCaster()
		local particleName = "particles/base/immuniser_first_spawn.vpcf"
		local particle_effect = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(particle_effect, 0, caster:GetAbsOrigin())
		self.existing_particle_spawn = particle_effect
	end
end

function modifier_prevent_game_start:OnDestroy()
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self:GetAbility()

		-- Destroy breath particle when motion interrupted
		if self.existing_particle_spawn then
			local destroy_existing_particle_spawn = self.existing_particle_spawn
			self.existing_particle_spawn = nil
			-- Delay before destroying particle
			Timers:CreateTimer(0.4, function()
				ParticleManager:DestroyParticle(destroy_existing_particle_spawn, false)
				ParticleManager:ReleaseParticleIndex( destroy_existing_particle_spawn )
			end)
		end
	end
end

function modifier_prevent_game_start:IsHidden()
	return true
end