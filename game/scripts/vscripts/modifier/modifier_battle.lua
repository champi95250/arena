if modifier_battle == nil then
	modifier_battle = class({})
end

LinkLuaModifier("modifier_battle_day", "modifier/modifier_battle", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_battle_night", "modifier/modifier_battle", LUA_MODIFIER_MOTION_NONE)

function modifier_battle:OnCreated()
	if IsServer() then	
		self.is_day = GameRules:IsDaytime()
		self:StartIntervalThink(0.5)
		self.night = 0
	end
end

function modifier_battle:OnDestroy()
	if IsServer() then	
		local caster = self:GetCaster() 
		if caster:HasModifier("modifier_battle_night") then
			caster:RemoveModifierByName("modifier_battle_night")
		end
		if caster:HasModifier("modifier_battle_day") then
			caster:RemoveModifierByName("modifier_battle_day")
		end
	end
end

function modifier_battle:OnIntervalThink()

    if IsServer() then
    	local caster = self:GetCaster()
    	local parent = self:GetParent()
        -- Get current Daytime cycle
        local current_daytime = GameRules:IsDaytime()

        -- If it is now night, compare with previous statement
        if not current_daytime then

            -- If the current cycle is night and the modifier is already aware of that, do nothing
            if not GameRules:IsDaytime() then
            	self.night = 1 
            else
            	self.night = 0 
            end
        --self.is_day = current_daytime 
        end

        if self.night == 1 then
        	caster:AddNewModifier(caster, nil, "modifier_battle_night", {})
        	if caster:HasModifier("modifier_battle_day") then
				caster:RemoveModifierByName("modifier_battle_day")
			end
            print("night")
        else
            caster:AddNewModifier(caster, nil, "modifier_battle_day", {})
            if caster:HasModifier("modifier_battle_night") then
				caster:RemoveModifierByName("modifier_battle_night")
			end
            print("day")
        end

        self.night = 0 
        print("dayreturn")

        -- State the current cycle in the modifier
           
    end
end


function modifier_battle:IsHidden()
	return true
end

--------------------------------
-- Day : modifier_battle_day
--------------------------------
if modifier_battle_day == nil then
	modifier_battle_day = class({})
end


function modifier_battle_day:DeclareFunctions()
    local decFuncs =
	{
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE
	}
    return decFuncs
end

function modifier_battle_day:OnCreated()
	self.bonus_magic_damage_pct_aura = -50
	self.bonus_damage_pct_aura = 50
end


function modifier_battle_day:GetModifierSpellAmplify_Percentage()
	return self.bonus_magic_damage_pct_aura
end

function modifier_battle_day:GetModifierBaseDamageOutgoing_Percentage()
	return self.bonus_damage_pct_aura
end

function modifier_battle_day:IsHidden()
	return false
end

--------------------------------
-- Day : modifier_battle_day
--------------------------------

if modifier_battle_night == nil then
	modifier_battle_night = class({})
end


function modifier_battle_night:DeclareFunctions()
    local decFuncs =
	{
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE
	}
    return decFuncs
end

function modifier_battle_night:OnCreated()
	self.bonus_magic_damage_pct_aura = 50
	self.bonus_damage_pct_aura = -50
end


function modifier_battle_night:GetModifierSpellAmplify_Percentage()
	return self.bonus_magic_damage_pct_aura
end

function modifier_battle_night:GetModifierBaseDamageOutgoing_Percentage()
	return self.bonus_damage_pct_aura
end

function modifier_battle_night:IsHidden()
	return false
end