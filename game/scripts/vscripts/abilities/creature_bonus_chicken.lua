creature_bonus_chicken = class({})
LinkLuaModifier( "modifier_creature_bonus_chicken", "abilities/creature_bonus_chicken", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function creature_bonus_chicken:GetIntrinsicModifierName()
	return "modifier_creature_bonus_chicken"
end

modifier_creature_bonus_chicken = class({})

--------------------------------------------------------------------------------

function modifier_creature_bonus_chicken:IsPurgable()
	return false;
end

--------------------------------------------------------------------------------

function modifier_creature_bonus_chicken:IsHidden()
	return true;
end

--------------------------------------------------------------------------------

function modifier_creature_bonus_chicken:OnCreated( kv )
	self.total_gold = self:GetAbility():GetSpecialValueFor( "total_gold" )
	self.time_limit = self:GetAbility():GetSpecialValueFor( "time_limit" )
	if IsServer() then
		self.flAccumDamage = 0
		self.nBagsDropped = 0
		self.bTeleporting = false
		self.vCenter = Vector( 0, 0, 0 )
		ExecuteOrderFromTable({
			UnitIndex = self:GetParent():entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			Position = self.vCenter
			})

		self.flExpireTime = GameRules:GetGameTime() + self.time_limit
		self:StartIntervalThink( 3.0 )
	end
end

--------------------------------------------------------------------------------

function modifier_creature_bonus_chicken:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_MIN_HEALTH,
		MODIFIER_EVENT_ON_TELEPORTED,
	}

	return funcs
end

function modifier_creature_bonus_chicken:OnIntervalThink()
	if IsServer() then
		if not self.bTeleporting then
			ExecuteOrderFromTable({
			UnitIndex = self:GetParent():entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			Position = self.vCenter + RandomVector( 4500 )
			})
		end

		if GameRules:GetGameTime() > self.flExpireTime then
			self:GetParent():ForceKill( false ) -- Teleport Kill
		end
	end
end

--------------------------------------------------------------------------------

function modifier_creature_bonus_chicken:OnTakeDamage( params )
	if IsServer() then
		local hUnit = params.unit
		local hAttacker = params.attacker
		if hAttacker == nil or hAttacker:IsBuilding() then
			return 0
		end
		if hUnit == self:GetParent() then
			if hAttacker:IsHero() then
				--print("UNIT : " .. hUnit .. " and Attacker " .. hAttacker)
				attacker = EntIndexToHScript(hAttacker:entindex())
				if self.total_gold > 0 then
				Score:ScoreChicken( attacker, 1 )
				self.total_gold = self.total_gold - 1
				end
				if self.total_gold <= 0 then
					self:GetParent():ForceKill( false ) -- Teleport Kill
				end
			else
				if not hAttacker:IsHero() and  not hAttacker:GetUnitName() == "npc_dota_creature_bonus_chicken" then
					local attacker = hAttacker:GetMainControllingPlayer()
					-- attacker = EntIndexToHScript(hAttacker:entindex())
					if self.total_gold > 0 then
					Score:ScoreChicken( attacker, 1 )
					self.total_gold = self.total_gold - 1
					end
					if self.total_gold <= 0 then
						self:GetParent():ForceKill( false ) -- Teleport Kill
					end
				end
			end
		end
	end

	return 0
end

--------------------------------------------------------------------------------

function modifier_creature_bonus_chicken:OnTeleported( params )
	if IsServer() then
		if params.unit == self:GetParent() then
			self:GetParent():ForceKill( false )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_creature_bonus_chicken:GetModifierMoveSpeed_Absolute( params )
	if IsServer() then
		return 600 + ( self.total_gold * 10 )
	end
	return 600
end

--------------------------------------------------------------------------------

function modifier_creature_bonus_chicken:GetMinHealth( params )
	return 1
end

--------------------------------------------------------------------------------

function modifier_creature_bonus_chicken:CheckState()
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

function modifier_creature_bonus_chicken:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end