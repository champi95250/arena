if modifier_wolf == nil then
	modifier_wolf = class({})
end

function modifier_wolf:CheckState()
	local state = {
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_PASSIVES_DISABLED] = true,
		[MODIFIER_STATE_SILENCED] = true,
	}

	return state
end

function modifier_wolf:DeclareFunctions()
    local decFuncs = {MODIFIER_PROPERTY_MODEL_CHANGE,
                    MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
                  	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
                  	MODIFIER_EVENT_ON_ATTACK,
                  	MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
                  	MODIFIER_PROPERTY_MODEL_SCALE,
                    MODIFIER_PROPERTY_PROVIDES_FOW_POSITION}

    return decFuncs
end

function modifier_wolf:GetModifierModelChange()
    return "models/items/lycan/wolves/blood_moon_hunter_wolves/blood_moon_hunter_wolves.vmdl"
end
-- models/items/lycan/wolves/blood_moon_hunter_wolves/blood_moon_hunter_wolves.vmdl
-- "models/items/hex/sheep_hex/sheep_hex.vmdl"
-- "models/items/hex/sheep_hex/sheep_hex_gold.vmdl"

function modifier_wolf:RemoveOnDeath() return false end

function modifier_wolf:OnAttack(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() and not self:GetParent():IsIllusion() then
			local target = keys.target
			print("Attack wolf")
			if target:HasModifier("modifier_mouton") then
				target:ForceKill(true)
				local wolf_attacker = EntIndexToHScript(self:GetParent():entindex())
				Score:ScoreLoup( wolf_attacker, 2 )
				print(wolf_attacker:GetUnitName())
			end
			if target:HasModifier("modifier_mouton_golden") then
				target:ForceKill(true)
				local wolf_attacker = EntIndexToHScript(self:GetParent():entindex())
				Score:ScoreLoupGolden( wolf_attacker, 3 )
				print(wolf_attacker:GetUnitName())
			end
		end
	end
end

function modifier_wolf:CheckState()
	if self:GetParent():HasModifier("modifier_slark_shadow_dance") then
		return nil
	end
	
	local state = {[MODIFIER_STATE_INVISIBLE] = false, [MODIFIER_STATE_PROVIDES_VISION] = true}
	return state
end

function modifier_wolf:OnCreated(params)
    if IsServer() then
		local attacker = EntIndexToHScript(self:GetParent():entindex())
		if self.valeur == nil then
			self.valeur = 0
		end
		-- 670 range
		if attacker:GetUnitName() == "npc_dota_hero_lina" then
			print("Lina is a wolf")
			self.valeur = -530 -- Retire encore 10
		elseif attacker:GetUnitName() == "npc_dota_hero_gyrocopter" then
			print("Gyro is a wolf")
			self.valeur = -225 -- Retire encore 10
		elseif attacker:GetUnitName() == "npc_dota_hero_sniper" then
			print("Sniper is a wolf")
			self.valeur = -410 -- Retire encore 10
		elseif attacker:GetUnitName() == "npc_dota_hero_queenofpain" then
			print("QOP is a wolf")
			self.valeur = -410 -- Retire encore 10
		-- 600 range
		elseif attacker:GetUnitName() == "npc_dota_hero_rubick" or attacker:GetUnitName() == "npc_dota_hero_windrunner" or attacker:GetUnitName() == "npc_dota_hero_crystal_maiden" or attacker:GetUnitName() == "npc_dota_hero_invoker" or attacker:GetUnitName() == "npc_dota_hero_mirana" or attacker:GetUnitName() == "npc_dota_hero_lion" or attacker:GetUnitName() == "npc_dota_hero_silencer"then
			self.valeur = -460 -- Retire encore 10
		elseif attacker:GetUnitName() == "npc_dota_hero_viper" then
			print("Viper is a wolf")
			self.valeur = -435 -- Retire encore 10
		elseif attacker:GetUnitName() == "npc_dota_hero_drow_ranger" then
			print("Drow is a wolf")
			self.valeur = -485 -- Retire encore 10
		-- 350 range
		elseif attacker:GetUnitName() == "npc_dota_hero_zuus" or attacker:GetUnitName() == "npc_dota_hero_morphling" then
			self.valeur = -210
		else
			print("Melee Heroes")
			self.valeur = 0
		end
    end
end

function modifier_wolf:GetModifierMoveSpeed_Absolute()
    return 500
end

function modifier_wolf:GetModifierAttackRangeBonus()
	return self.valeur
end

function modifier_wolf:GetModifierProjectileSpeedBonus()
	return 3000
end

function modifier_wolf:GetModifierModelScale()
	return 2
end


function modifier_wolf:IsHidden()
	return false
end

function modifier_wolf:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end