item_gift_winter = class({})

--------------------------------------------------------------------------------

function item_gift_winter:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end

--------------------------------------------------------------------------------

function item_gift_winter:OnSpellStart()
	if IsServer() then
		
		local hp_restore_pct = self:GetSpecialValueFor( "hp_restore_pct" )
		print("Lancer SPELL")
		self:GetCaster():EmitSoundParams( "DOTA_Item.FaerieSpark.Activate", 0, 0.5, 0)

		local flHealAmount = self:GetCaster():GetMaxHealth() * hp_restore_pct / 100

		self:GetCaster():Heal( flHealAmount, self )
		print("Heal : " .. flHealAmount .. " soit = " .. hp_restore_pct / 100 .. "%")

		local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/fish_bones_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
		self:SpendCharge()
		
		print("DETRUIT SPELL")
	end
end

--------------------------------------------------------------------------------