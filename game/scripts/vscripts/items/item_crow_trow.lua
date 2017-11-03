item_crow_trow = class({})

LinkLuaModifier( "modifier_item_item_crow_trow", "items/item_crow_trow.lua", LUA_MODIFIER_MOTION_NONE ) 
LinkLuaModifier( "modifier_item_vision_crow_trow", "items/item_crow_trow.lua", LUA_MODIFIER_MOTION_NONE ) 

--------------------------------------------------------------------------------

function item_crow_trow:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_PASSIVE
end

function item_crow_trow:GetIntrinsicModifierName()
return "modifier_item_item_crow_trow" end

function item_crow_trow:OnOwnerDied(params)
	local hOwner = self:GetOwner()
	if hOwner.IsReincarnating and hOwner:IsReincarnating() then
		return nil
	end
	local vLocation = hOwner:GetAbsOrigin()
	for i = 0, 8 do
		local item1 = hOwner:GetItemInSlot(i)
		if item1 and item1:GetName() == "item_crow_trow" then
			hOwner:DropItemAtPositionImmediate(item1, vLocation)
		end
	end
	
end

--------------------------------------------------------------------------------

if modifier_item_item_crow_trow == nil then modifier_item_item_crow_trow = class({}) end
function modifier_item_item_crow_trow:IsHidden() return false end
function modifier_item_item_crow_trow:IsDebuff() return false end
function modifier_item_item_crow_trow:IsPurgable() return false end
function modifier_item_item_crow_trow:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_item_crow_trow:OnCreated(keys)
	if IsServer() then
		local parent = self:GetParent()
		if parent:HasModifier("modifier_item_item_crow_trow") then
			parent:AddNewModifier(parent, ability, "modifier_item_vision_crow_trow", {})
			self:StartIntervalThink(4)
		end
	end
end

function modifier_item_item_crow_trow:OnDestroy(keys)
	if IsServer() then
		local parent = self:GetParent()
		if not parent:HasModifier("modifier_item_item_crow_trow") then
			parent:RemoveModifierByName("modifier_item_vision_crow_trow")
		end
	end
end

function modifier_item_item_crow_trow:OnIntervalThink()
	if IsServer() then
		local parent = self:GetParent()
		local teamid = parent:GetTeamNumber()
		print(KILLSREMAINING_ITEM)
		if KILLSREMAINING_ITEM == 1 then
			print(KILLSREMAINING_ITEM)
      		Score:ScoreGem( parent )
     	end
	end
end

--------------------------------------------------------------------------------

if modifier_item_vision_crow_trow == nil then modifier_item_vision_crow_trow = class({}) end
function modifier_item_vision_crow_trow:IsHidden() return false end
function modifier_item_vision_crow_trow:IsDebuff() return true end
function modifier_item_vision_crow_trow:IsPurgable() return false end
function modifier_item_vision_crow_trow:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_vision_crow_trow:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_PROVIDES_FOW_POSITION, MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}

	return decFuncs
end

function modifier_item_vision_crow_trow:OnCreated(keys)
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.curse_slow = -25
	if IsServer() then
		local parent = self:GetParent()
		if parent:HasModifier("modifier_item_vision_crow_trow") then
		end
	end
end

function modifier_item_vision_crow_trow:GetModifierMoveSpeedBonus_Percentage( params )
	return self.curse_slow
end

function modifier_item_vision_crow_trow:OnDestroy(keys)
	if IsServer() then
		local parent = self:GetParent()
		if not parent:HasModifier("modifier_item_vision_crow_trow") then
			
		end
	end
end

function modifier_item_vision_crow_trow:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end

function modifier_item_vision_crow_trow:CheckState()
	if self:GetParent():HasModifier("modifier_slark_shadow_dance") then
		return nil
	end
	
	local state = {[MODIFIER_STATE_INVISIBLE] = false, [MODIFIER_STATE_PROVIDES_VISION] = true}
	return state
end

--------------------------------------------------------------------------------