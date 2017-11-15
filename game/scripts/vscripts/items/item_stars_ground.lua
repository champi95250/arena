item_stars_ground = class({})

--------------------------------------------------------------------------------

function item_stars_ground:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end

--------------------------------------------------------------------------------

function item_stars_ground:OnSpellStart()
	if IsServer() then
		
		self:GetCaster():EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )

		local heroa = self:GetCaster()
		hero = EntIndexToHScript(heroa:entindex())
		Score:ScoreItemRamser( hero, 1 )

		local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/mango_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
		self:SpendCharge()

		
	end
end

--------------------------------------------------------------------------------