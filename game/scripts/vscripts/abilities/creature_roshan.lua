creature_roshan = class({})
LinkLuaModifier( "modifier_creature_roshan", "abilities/creature_roshan", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function creature_roshan:GetIntrinsicModifierName()
	return "modifier_creature_roshan"
end

function creature_roshan:IsHidden()
	return true;
end

modifier_creature_roshan = class({})

--------------------------------------------------------------------------------

function modifier_creature_roshan:IsPurgable()
	return false;
end

--------------------------------------------------------------------------------

function modifier_creature_roshan:IsHidden()
	return false;
end

--------------------------------------------------------------------------------

function modifier_creature_roshan:OnCreated( kv )
	if IsServer() then
   
        ExecuteOrderFromTable({
			UnitIndex = self:GetParent():entindex(),
			OrderType = DOTA_UNIT_ORDER_STOP
			})

        Timers:CreateTimer(2.0, function()
			local foundPlayers = {}
		    for _, playerStart in pairs( HeroList:GetAllHeroes() ) do
		    	playerStart = playerStart:GetPlayerOwner():GetAssignedHero()
		    	local player_ent = EntIndexToHScript(playerStart:entindex())
		        table.insert( foundPlayers, { player = player_ent } )
		    end
		    local numPlayer = TableCount(foundPlayers)
		    local Randomplayer = RandomInt(1, numPlayer)
		    --print("NOMBRE DE PLAYER : " .. numPlayer)
		    --print("PLAYER : " .. foundPlayers[Randomplayer].player:entindex())
				ExecuteOrderFromTable({
				UnitIndex = self:GetParent():entindex(),
				TargetIndex = foundPlayers[Randomplayer].player:entindex(),
				OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET
				})
		end)
		self:StartIntervalThink( 15.0 )
	end
end

--------------------------------------------------------------------------------

function modifier_creature_roshan:DeclareFunctions()
	local funcs = {
	}

	return funcs
end

function modifier_creature_roshan:OnIntervalThink()
	if IsServer() then
		--print("Roshan Attack Now")
        self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_4)
        Timers:CreateTimer(0.6, function()
            EmitGlobalSound("Roshan.Cryy") -- Timer 0.6
        end)
        
        ExecuteOrderFromTable({
			UnitIndex = self:GetParent():entindex(),
			OrderType = DOTA_UNIT_ORDER_STOP
			})

        Timers:CreateTimer(1.5, function()
			local foundPlayers = {}
		    for _, playerStart in pairs( HeroList:GetAllHeroes() ) do
		    	playerStart = playerStart:GetPlayerOwner():GetAssignedHero()
		    	local player_ent = EntIndexToHScript(playerStart:entindex())
		        table.insert( foundPlayers, { player = player_ent } )
		    end
		    local numPlayer = TableCount(foundPlayers)
		    local Randomplayer = RandomInt(1, numPlayer)
		    --print("NOMBRE DE PLAYER : " .. numPlayer)
		    --print("PLAYER : " .. foundPlayers[Randomplayer].player:entindex())
				ExecuteOrderFromTable({
				UnitIndex = self:GetParent():entindex(),
				TargetIndex = foundPlayers[Randomplayer].player:entindex(),
				OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET
				})
		end)
	end
end

--------------------------------------------------------------------------------

function modifier_creature_roshan:CheckState()
	local state = {}
	if IsServer()  then
		state =
		{
		}
	end
	
	return state
end


--------------------------------------------------------------------------------

function modifier_creature_roshan:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end