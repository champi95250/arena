SPAWN_CRYSTAL_POINT = {} -- Spawn Point activé? 1 = oui
SPAWN_CRYSTAL_POINT[1] = 1
SPAWN_CRYSTAL_POINT[2] = 1
SPAWN_CRYSTAL_POINT[3] = 1
SPAWN_CRYSTAL_POINT[4] = 1
SPAWN_CRYSTAL_POINT[5] = 1
SPAWN_CRYSTAL_POINT[6] = 1
SPAWN_CRYSTAL_POINT[7] = 1
SPAWN_CRYSTAL_POINT[8] = 1

SPAWN_CRYSTAL_GOLDEN_POINT = {} -- Spawn Point activé? 1 = oui
SPAWN_CRYSTAL_GOLDEN_POINT[1] = 1
SPAWN_CRYSTAL_GOLDEN_POINT[2] = 1
SPAWN_CRYSTAL_GOLDEN_POINT[3] = 1
SPAWN_CRYSTAL_GOLDEN_POINT[4] = 1


function GameMode:Thinkcustomcrystal()
    Timers:CreateTimer(0.0, function()
        print("-- Spawn Crystal --")
        print("CRYSTAL 1 : " .. SPAWN_CRYSTAL_POINT[1])
        print("CRYSTAL 2 : " .. SPAWN_CRYSTAL_POINT[2])
        print("CRYSTAL 3 : " .. SPAWN_CRYSTAL_POINT[3])
        print("CRYSTAL 4 : " .. SPAWN_CRYSTAL_POINT[4])
        print("CRYSTAL 5 : " .. SPAWN_CRYSTAL_POINT[5])
        print("CRYSTAL 6 : " .. SPAWN_CRYSTAL_POINT[6])
        print("CRYSTAL 7 : " .. SPAWN_CRYSTAL_POINT[7])
        print("CRYSTAL 8 : " .. SPAWN_CRYSTAL_POINT[8])
        GameMode:Spawncrystal()
        return 20.0 -- 30 secondes 
    end)
end

function GameMode:Thinkcustomcrystalgolden()
    Timers:CreateTimer(0.0, function()
        print("-- Spawn Crystal Golden--")
        print("CRYSTAL 1 : " .. SPAWN_CRYSTAL_GOLDEN_POINT[1])
        print("CRYSTAL 2 : " .. SPAWN_CRYSTAL_GOLDEN_POINT[2])
        print("CRYSTAL 3 : " .. SPAWN_CRYSTAL_GOLDEN_POINT[3])
        print("CRYSTAL 4 : " .. SPAWN_CRYSTAL_GOLDEN_POINT[4])
        GameMode:Spawncrystalgolden()
        local random = RandomInt(30, 70)
        print("Random Temps :" .. random)
        return random
    end)
end

function GameMode:Spawncrystal()
    local random = RandomInt(1, 8)
    local point = Entities:FindByName(nil, "point_unit_"..random)
    local summon_origin = point:GetAbsOrigin()
    if SPAWN_CRYSTAL_POINT[random] == 1 then
    SPAWN_CRYSTAL_POINT[random] = 0 
    local crystal = CreateUnitByName("npc_dota_crystal_stone", summon_origin, false, nil, nil, DOTA_TEAM_NEUTRALS)
    FindClearSpaceForUnit(crystal, summon_origin, true)
    crystal.original = random
    crystal.particle_name = ParticleManager:CreateParticle("particles/crystal/aura.vpcf", PATTACH_POINT_FOLLOW, crystal)
    ParticleManager:SetParticleControl(crystal.particle_name, 0, crystal:GetAbsOrigin())

    elseif SPAWN_CRYSTAL_POINT[1] == 0 and SPAWN_CRYSTAL_POINT[2] == 0 and SPAWN_CRYSTAL_POINT[3] == 0 and SPAWN_CRYSTAL_POINT[4] == 0 and SPAWN_CRYSTAL_POINT[5] == 0 and SPAWN_CRYSTAL_POINT[6] == 0 and SPAWN_CRYSTAL_POINT[7] == 0 and SPAWN_CRYSTAL_POINT[8] == 0 then
        -- nothing
        print("impossible de crée de nouveau Crystal")
    else
        GameMode:Spawncrystal()
    end
end

function GameMode:Spawncrystalgolden()
    local random = RandomInt(1, 4)
    local point = Entities:FindByName(nil, "point_unit_golden_"..random)
    local summon_origin = point:GetAbsOrigin()
    if SPAWN_CRYSTAL_GOLDEN_POINT[random] == 1 then
    SPAWN_CRYSTAL_GOLDEN_POINT[random] = 0 
    local crystal = CreateUnitByName("npc_dota_crystal_stone_golden", summon_origin, false, nil, nil, DOTA_TEAM_NEUTRALS)
    FindClearSpaceForUnit(crystal, summon_origin, true)
    crystal.original = random
    crystal.particle_name = ParticleManager:CreateParticle("particles/crystal/aura_golden.vpcf", PATTACH_POINT_FOLLOW, crystal)
    ParticleManager:SetParticleControl(crystal.particle_name, 0, crystal:GetAbsOrigin())

    elseif SPAWN_CRYSTAL_GOLDEN_POINT[1] == 0 and SPAWN_CRYSTAL_GOLDEN_POINT[2] == 0 and SPAWN_CRYSTAL_GOLDEN_POINT[3] == 0 and SPAWN_CRYSTAL_GOLDEN_POINT[4] == 0 then
        -- nothing
        print("impossible de crée de nouveau Crystal Golden")
    else
        GameMode:Spawncrystalgolden()
    end
end