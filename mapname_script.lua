local ScenarioUtils = import('/lua/sim/ScenarioUtilities.lua')
local ScenarioFramework = import('/lua/ScenarioFramework.lua')

local ArmySlotsMexes = { {1}, {2}, {3} }
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

local function HasValue(list, value)
    for _, e in ipairs(list) do
        if e == value then
            return true
        end
    end
    return false
end

local function SpawnResource(position, restype)
    local bp, albedo, size, lod
    if restype == "Mass" then
        albedo = "/env/common/splats/mass_marker.dds"
        bp = "/env/common/props/massDeposit01_prop.bp"
        size = 2
        lod = 100
    else
        albedo = "/env/common/splats/hydrocarbon_marker.dds"
        bp = "/env/common/props/hydrocarbonDeposit01_prop.bp"
        size = 6
        lod = 200
    end
    
    CreateResourceDeposit(restype, position[1], position[2], position[3], size / 2)
    CreatePropHPR(bp, position[1], position[2], position[3], Random(0, 360), 0, 0)
    CreateSplat(position, 0, albedo, size, size, lod, 0, -1, 0)
end

function ScenarioUtils.CreateResources()
    LOG("ADAPTIVE: ScenarioUtils.CreateResources()")
    local slotsActive = {}
    local slotsRemove = {}

    local spawnUnsedSlotResources = ScenarioInfo.Options.unusedSlotResources > 0
    LOG("ADAPTIVE: Options.unusedSlotResources:", spawnUnsedSlotResources and "Untouch" or "Despawn(default)")
    local limitHydrocarbonsPerSpawn = ScenarioInfo.Options.limitHydrocarbonsPerSpawn
    LOG("ADAPTIVE: Options.limitHydrocarbonsPerSpawn:", limitHydrocarbonsPerSpawn)
    local limitMassDepositsPerSpawn = ScenarioInfo.Options.limitMassDepositsPerSpawn
    LOG("ADAPTIVE: Options.limitMassDepositsPerSpawn:", limitMassDepositsPerSpawn)
    local armyList = ListArmies()

    for aindex, amexes in ipairs(ArmySlotsMexes) do
        local active = spawnUnsedSlotResources or HasValue(armyList, "ARMY_" .. aindex)
        for residx, resnum in ipairs(amexes) do
            if active and residx <= limitMassDepositsPerSpawn then
                table.insert(slotsActive, "Mass " .. resnum)
            else
                table.insert(slotsRemove, "Mass " .. resnum)
            end
        end
    end

    for aindex, ahydro in ipairs(ArmySlotsHydro) do
        local active = spawnUnsedSlotResources or HasValue(armyList, "ARMY_" .. aindex)
        for residx, resnum in ipairs(ahydro) do
            if active and residx <= limitHydrocarbonsPerSpawn then
                table.insert(slotsActive, "Hydrocarbon " .. resnum)
            else
                table.insert(slotsRemove, "Hydrocarbon " .. resnum)
            end
        end
    end

    local commonMapMassDepositsSpawnChance = ScenarioInfo.Options.commonMapMassDeposits
    LOG("ADAPTIVE: Options.commonMapMassDeposits(spawn chance):", commonMapMassDepositsSpawnChance)
    local commonMapHydrocarbonsSpawnChance = ScenarioInfo.Options.commonMapHydrocarbons
    LOG("ADAPTIVE: Options.commonMapHydrocarbons(spawn chance):", commonMapHydrocarbonsSpawnChance)

    for mrkname, marker in pairs(ScenarioUtils.GetMarkers()) do
        if marker.resource then
            if HasValue(slotsActive, mrkname) then
                SpawnResource(marker.position, marker.type, true)
                LOG("Spawned active slot resource:", mrkname)
            elseif not HasValue(slotsRemove, mrkname) and (
                    (marker.type == "Mass" and commonMapMassDepositsSpawnChance >= math.random()) or
                    (marker.type == "Hydrocarbon" and commonMapHydrocarbonsSpawnChance >= math.random())) then
                SpawnResource(marker.position, marker.type, true)
                LOG("Spawned common map resource:", mrkname)
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
    LOG("REGROW: Options.forestRegrowChance:", forestRegrowChance)
    LOG("REGROW: Options.forestRegrowDelay:", forestRegrowDelay)    
    LOG("REGROW: Caching Trees...")
    local treeList = {}

    for _, obj in GetReclaimablesInRect({ x0 = 0, y0 = 0, x1 = ScenarioInfo.size[1], y1 = ScenarioInfo.size[2] }) or {} do
        local objbp = obj:GetBlueprint()
        if string.find(objbp.BlueprintId, "tree") then
            local objpos = obj:GetPosition()
            table.insert(treeList, { bp = objbp, pos = VECTOR3(objpos.x, objpos.y, objpos.z), unit = obj, time = 0 })
            myTable = {name = "Alice", age = 30}
        end
    end

    LOG("REGROW: Tree Records Cached:", table.getn(treeList))
    local timeLoop = 1
    local partSize = math.floor(table.getn(treeList) / 60)
    if partSize < 1 then
        LOG("REGROW: Function stopped(Not Enough Tree Objects)")
        return
    end
    WaitSeconds(5)

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
end
