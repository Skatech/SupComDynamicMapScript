local ScenarioUtils = import('/lua/sim/ScenarioUtilities.lua')
local ScenarioFramework = import('/lua/ScenarioFramework.lua')

local ArmySlotsMexes = { {0,2,4,6}, {1,3,5,7}, {32,34,36,48}, {33,35,37,49} }
local ArmySlotsHydro = { }

function OnPopulate()
    ScenarioUtils.InitializeArmies()
    ScenarioFramework.SetPlayableArea('AREA_1' , false)
end

function OnStart(scenario)
    LOG("========================================")
    LOG("ADAPTIVE: OnStart()")
    ForkThread(GrowingTreesLoop)
end

table.hasValue = function(array, value)
    for i = 1, table.getn(array) do
        if value == array[i] then
            return true
        end
    end
    return false
end

table.convertValues = function(array, converter)
    local result = {}
    for i = 1, table.getn(array) do
        table.insert(result, converter(array[i], i))
    end
    return result
end

local helpers = {
    armyIndexFromName = function(name)
        return tonumber(string.match(name, "ARMY_(.*)") or 0)
    end,

    createResourceID = function(resnum, trueMassFalseHydro)
        return trueMassFalseHydro and (resnum > 9 and "Mass " or "Mass 0") .. resnum
            or (resnum > 9 and "Hydrocarbon " or "Hydrocarbon 0") .. resnum
    end,

    spawnResource = function(position, restype)
        local ismass = restype == "Mass"
        local bp = ismass and "/env/common/props/massDeposit01_prop.bp" or "/env/common/props/hydrocarbonDeposit01_prop.bp"
        local albedo = ismass and "/env/common/splats/mass_marker.dds" or "/env/common/splats/hydrocarbon_marker.dds"
        local size = ismass and 2 or 6
        local lod = ismass and 100 or 200
    
        CreateResourceDeposit(restype, position[1], position[2], position[3], size / 2)
        CreatePropHPR(bp, position[1], position[2], position[3], Random(0, 360), 0, 0)
        CreateSplat(position, 0, albedo, size, size, lod, 0, -1, 0)
    end
}

function ScenarioUtils.CreateResources()
    LOG("ADAPTIVE: ScenarioUtils.CreateResources()")
    local spawnUnsedSlotResources = ScenarioInfo.Options.unusedSlotResources > 0
    LOG("ADAPTIVE: Options.unusedSlotResources:", spawnUnsedSlotResources and "Untouch" or "Despawn(default)")
    local limitHydrocarbonsPerSpawn = ScenarioInfo.Options.limitHydrocarbonsPerSpawn
    LOG("ADAPTIVE: Options.limitHydrocarbonsPerSpawn:", limitHydrocarbonsPerSpawn)
    local limitMassDepositsPerSpawn = ScenarioInfo.Options.limitMassDepositsPerSpawn
    LOG("ADAPTIVE: Options.limitMassDepositsPerSpawn:", limitMassDepositsPerSpawn)
    local activeArmies = table.convertValues(ListArmies(), helpers.armyIndexFromName)    
    local slotsActive, slotsRemove = {}, {}

    for aindex, amexes in ipairs(ArmySlotsMexes) do
        local active = spawnUnsedSlotResources or table.hasValue(activeArmies, aindex)
        for residx, resnum in ipairs(amexes) do
            if active and residx <= limitMassDepositsPerSpawn then
                table.insert(slotsActive, helpers.createResourceID(resnum, true))
            else
                table.insert(slotsRemove, helpers.createResourceID(resnum, true))
            end
        end
    end

    for aindex, ahydro in ipairs(ArmySlotsHydro) do
        local active = spawnUnsedSlotResources or table.hasValue(activeArmies, aindex)
        for residx, resnum in ipairs(ahydro) do
            if active and residx <= limitHydrocarbonsPerSpawn then
                table.insert(slotsActive, helpers.createResourceID(resnum, false))
            else
                table.insert(slotsRemove, helpers.createResourceID(resnum, false))
            end
        end
    end

    local commonMapMassDepositsSpawnChance = ScenarioInfo.Options.commonMapMassDeposits
    LOG("ADAPTIVE: Options.commonMapMassDeposits(spawn chance):", commonMapMassDepositsSpawnChance)
    local commonMapHydrocarbonsSpawnChance = ScenarioInfo.Options.commonMapHydrocarbons
    LOG("ADAPTIVE: Options.commonMapHydrocarbons(spawn chance):", commonMapHydrocarbonsSpawnChance)

    for mrkname, marker in pairs(ScenarioUtils.GetMarkers()) do
        if marker.resource then
            if table.hasValue(slotsActive, mrkname) then
                helpers.spawnResource(marker.position, marker.type)
                LOG("  - spawned active slot resource:", mrkname)
            elseif not table.hasValue(slotsRemove, mrkname) and (
                    (marker.type == "Mass" and commonMapMassDepositsSpawnChance >= math.random()) or
                    (marker.type == "Hydrocarbon" and commonMapHydrocarbonsSpawnChance >= math.random())) then
                helpers.spawnResource(marker.position, marker.type)
                LOG("  - spawned common map resource:", mrkname)
            end
        end
    end
end

function GrowingTreesLoop()
    local forestRegrowChance = ScenarioInfo.Options.forestRegrowChance
    local forestRegrowDelay = ScenarioInfo.Options.forestRegrowDelay
    if forestRegrowChance < 0.01 then
        LOG("REGROW: Disabled in Options")
        return
    end
    LOG("========================================")
    LOG("REGROW: Options.forestRegrowChance:", math.floor(forestRegrowChance * 100) .. " prc/min")
    LOG("REGROW: Options.forestRegrowDelay:", forestRegrowDelay .. " min")
    LOG("REGROW: Caching Trees...")
    local treeList = {}

    for _, obj in GetReclaimablesInRect({ x0 = 0, y0 = 0, x1 = ScenarioInfo.size[1], y1 = ScenarioInfo.size[2] }) or {} do
        local objbp = obj:GetBlueprint()
        if string.find(objbp.BlueprintId, "tree") then
            local objpos = obj:GetPosition()
            table.insert(treeList, { bp = objbp, pos = VECTOR3(objpos.x, objpos.y, objpos.z), unit = obj, time = 0 })
        end
    end

    LOG("REGROW: Tree Records Cached:", table.getn(treeList))
    local timeLoop = 1
    local partSize = math.floor(table.getn(treeList) / 60)
    WaitSeconds(1)

    while partSize > 0 do
        local waitspot = partSize
        for treeidx, treerec in ipairs(treeList) do
            if treeidx > waitspot then
                waitspot = waitspot + partSize
                WaitSeconds(1)
            end
            
            if treerec.time > 0 then
                if treerec.time + forestRegrowDelay <= timeLoop and forestRegrowChance >= math.random() then
                    treerec.unit = CreateProp(treerec.pos, treerec.bp.BlueprintId)
                    -- LOG("REGROW: Tree Regrown:", treeidx, treerec.time, timeLoop)
                    treerec.time = 0
                end
            elseif treerec.unit:BeenDestroyed() then
                treerec.time = timeLoop
                -- LOG("REGROW: Tree Destroyed:", treeidx, timeLoop)
            end
        end
        timeLoop = timeLoop + 1
    end

    LOG("REGROW: Function stopped(Not Enough Tree Objects)")
end
