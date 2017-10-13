--[[	Author: Firetoad
		Original code: lolle
		Date: 17.12.2016
		Extends PlayerResource to include player-based data.	]]

local PlayerResource = CDOTA_PlayerResource
PlayerResource.PlayerData = {}

-- Initializes a player's data
function PlayerResource:InitPlayerData(player_id)
	self.PlayerData[player_id] = {}
	self.PlayerData[player_id]["current_deathstreak"] = 0
	self.PlayerData[player_id]["has_abandoned_due_to_long_disconnect"] = false
	self.PlayerData[player_id]["distribute_gold_to_allies"] = false
	self.PlayerData[player_id]["has_repicked"] = false
	print("player data set up for player with ID "..player_id)
end

-- Verifies if this player ID already has player data assigned to it
function PlayerResource:IsImbaPlayer(player_id)
	if self.PlayerData[player_id] then
		return true
	else
		return false
	end
end

-- Assigns a hero to a player
function PlayerResource:SetPickedHero(player_id, hero_entity)
	if self:IsImbaPlayer(player_id) then
		self.PlayerData[player_id].hero = hero_entity
		self.PlayerData[player_id].hero_name = hero_entity:GetUnitName()
		print("assigned "..self.PlayerData[player_id].hero_name.." to player with ID "..player_id)
	end
end

-- Fetches a player's hero
function PlayerResource:GetPickedHero(player_id)
	if self:IsImbaPlayer(player_id) then
		return self.PlayerData[player_id].hero
	end
	return nil
end

-- Fetches a player's hero name
function PlayerResource:GetPickedHeroName(player_id)
	if self:IsImbaPlayer(player_id) then
		return self.PlayerData[player_id].hero_name
	end
	return nil
end

-- Set a player's repick status
function PlayerResource:CustomSetHasRepicked(player_id, state)
	if self:IsImbaPlayer(player_id) then
		self.PlayerData[player_id]["has_repicked"] = state
	end
end

-- Fetch a player's repick state
function PlayerResource:CustomGetHasRepicked(player_id)
	if self:IsImbaPlayer(player_id) then
		return self.PlayerData[player_id]["has_repicked"]
	else
		return false
	end
end

-- Increase a player's team's player count
function PlayerResource:IncrementTeamPlayerCount(player_id)
	if self:IsImbaPlayer(player_id) then
		if self:GetTeam(player_id) == DOTA_TEAM_GOODGUYS then
			REMAINING_GOODGUYS = REMAINING_GOODGUYS + 1
			print("Radiant now has "..REMAINING_GOODGUYS.." players remaining")
		else
			REMAINING_BADGUYS = REMAINING_BADGUYS + 1
			print("Dire now has "..REMAINING_BADGUYS.." players remaining")
		end
	end
end

-- Decrease a player's team's player count
function PlayerResource:DecrementTeamPlayerCount(player_id)
	if self:IsImbaPlayer(player_id) then
		if self:GetTeam(player_id) == DOTA_TEAM_GOODGUYS then
			REMAINING_GOODGUYS = REMAINING_GOODGUYS - 1
			print("Radiant now has "..REMAINING_GOODGUYS.." players remaining")
		else
			REMAINING_BADGUYS = REMAINING_BADGUYS - 1
			print("Dire now has "..REMAINING_BADGUYS.." players remaining")
		end
	end
end
