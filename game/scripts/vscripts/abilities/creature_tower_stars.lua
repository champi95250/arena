creature_tower_stars = class({})
LinkLuaModifier( "modifier_creature_tower_stars_positive", "abilities/creature_tower_stars", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_creature_tower_stars", "abilities/creature_tower_stars", LUA_MODIFIER_MOTION_NONE )

function creature_tower_stars:GetIntrinsicModifierName()
	return "modifier_creature_tower_stars"
end

modifier_creature_tower_stars = class({})

--------------------------------------------------------------------------------

function modifier_creature_tower_stars:IsPurgable()
	return false;
end

--------------------------------------------------------------------------------

function modifier_creature_tower_stars:IsHidden()
	return true;
end

--------------------------------------------------------------------------------

function modifier_creature_tower_stars:OnCreated( kv )
	if IsServer() then
		--print("created")
		self:StartIntervalThink( 1.0 )
		self:GetParent():StartGesture(ACT_DOTA_IDLE)
	end
end

function modifier_creature_tower_stars:OnIntervalThink()
	if IsServer() then
		self:GetParent():StartGesture(ACT_DOTA_IDLE)
	end
end

function modifier_creature_tower_stars:IsAura()
    return true
end

function modifier_creature_tower_stars:GetModifierAura()
	return "modifier_creature_tower_stars_positive"
end

function modifier_creature_tower_stars:GetAuraRadius()
	return 350
end

function modifier_creature_tower_stars:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD
end

function modifier_creature_tower_stars:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY + DOTA_UNIT_TARGET_TEAM_FRIENDLY 
end

function modifier_creature_tower_stars:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

--------------------------------------------------------------------------------

function modifier_creature_tower_stars:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MIN_HEALTH,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_creature_tower_stars:GetMinHealth( params )
	return 1
end

--------------------------------------------------------------------------------

function modifier_creature_tower_stars:CheckState()
	local state = {}
	if IsServer()  then
		state =
		{
			[MODIFIER_STATE_STUNNED] = false,
			[MODIFIER_STATE_ROOTED] = false,
		}
	end
	
	return state
end


--------------------------------------------------------------------------------

function modifier_creature_tower_stars:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end




modifier_creature_tower_stars_positive = class({})
function modifier_creature_tower_stars_positive:IsDebuff() return false end
function modifier_creature_tower_stars_positive:IsHidden() return true end
function modifier_creature_tower_stars_positive:IsPurgable() return false end
function modifier_creature_tower_stars_positive:IsPurgeException() return false end
function modifier_creature_tower_stars_positive:IsStunDebuff() return false end
function modifier_creature_tower_stars_positive:RemoveOnDeath() return true end

function modifier_creature_tower_stars_positive:OnCreated( kv )
	if IsServer() then
		self:StartIntervalThink( 0.33 )
	end
end

function modifier_creature_tower_stars_positive:OnIntervalThink()
	if IsServer() then
		if self:GetParent():IsAlive() then
			if self:GetParent():IsRealHero() then
				hero = EntIndexToHScript(self:GetParent():entindex())
				playerID = hero:GetPlayerID()
				local nombredeposer = Score.data[playerID].starobtenue
				print("Nombre D'étoile dispo : " .. nombredeposer)
				if nombredeposer > 0 then
					Score:Startdeposer(hero)
				end
			end
		end
	end
end