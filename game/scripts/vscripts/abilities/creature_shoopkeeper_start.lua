dota_ability_shoopkeeper_start = class({})
LinkLuaModifier( "modifier_dota_ability_shoopkeeper_start", "abilities/dota_ability_shoopkeeper_start", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function dota_ability_shoopkeeper_start:GetIntrinsicModifierName()
	return "modifier_dota_ability_shoopkeeper_start"
end

modifier_dota_ability_shoopkeeper_start = class({})

--------------------------------------------------------------------------------

function modifier_dota_ability_shoopkeeper_start:IsPurgable()
	return false;
end

--------------------------------------------------------------------------------

function modifier_dota_ability_shoopkeeper_start:IsHidden()
	return true;
end

--------------------------------------------------------------------------------

function modifier_dota_ability_shoopkeeper_start:OnCreated( kv )
	if IsServer() then
		Timers:CreateTimer(0.7, function() -- after pick hero 
			-- Ecriteau durée : 7 secondes
		end)
		Timers:CreateTimer(7.0, function()
			self:GetParent():StartGesture(ACT_DOTA_TAUNT)
			-- Animation de départ
			Timers:CreateTimer(2.0, function()
				-- Particles disparition : particles/shoopkeeper/disparition_smoke.vpcf
				-- Particles disparition
				Timers:CreateTimer(0.3, function()
					-- Forcekill
					self:GetParent():ForceKill( false )
				end)
			end)
		end)
	end
end

--------------------------------------------------------------------------------

function modifier_dota_ability_shoopkeeper_start:DeclareFunctions()
	local funcs = {
	}

	return funcs
end

function modifier_dota_ability_shoopkeeper_start:OnIntervalThink()
	if IsServer() then
	end
end

--------------------------------------------------------------------------------

function modifier_dota_ability_shoopkeeper_start:CheckState()
	local state = {}
	if IsServer()  then
		state =
		{
			[MODIFIER_STATE_STUNNED] = false,
			[MODIFIER_STATE_ROOTED] = false,
		}
		if GameRules:GetGameTime() > self.flExpireTime or self.total_gold <= 0 then
			state[MODIFIER_STATE_MAGIC_IMMUNE] = true
			state[MODIFIER_STATE_INVULNERABLE] = true
			state[MODIFIER_STATE_OUT_OF_GAME] = true
		end
	end
	
	return state
end


--------------------------------------------------------------------------------

function modifier_dota_ability_shoopkeeper_start:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end