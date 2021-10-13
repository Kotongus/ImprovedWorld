---@type Plugin
local plugin = ...
plugin.name = 'Night Clubs'
plugin.author = 'Koto'
plugin.description = 'Adds night clubs with gambling, beer, and girls.'

local tableType = itemTypes.getByName("Table")
local cs = require 'plugins.computerStuff'
local hs = require 'plugins.hoeStuff'

local tablesPos = Vector(1670, 72.7, 1515)
local tableCount = 8
local beersOnTable = 3

local computersPos = Vector(1641, 73.5, 1487)
local computerCount = 4

local hoesPos = Vector(1650, 73.5, 1502)
local hoeCount = 8


local function getPcByIndex (i)
    for _, item in ipairs(items.getAll()) do
        if item.data.computerIndex == i then
            return true
        end
    end

    return false
end


local function removeTables ()
    for _, item in ipairs(items.getAll()) do
        if item.data.customType == "Club Table" then
            item:remove()
        end
    end
end


local function spawnTables ()
    for i = 1, tableCount do
        local t = items.create(tableType, tablesPos + Vector(-4, 0, 0) * (i - 1), orientations.n)
        t.data.customType = "Club Table"
        t.data.beers = {}

        t.isStatic = true
        t.hasPhysics = true
        t.despawnTime = 9999999999999999

    end
end


local function spawnComputers ()
    for i = 1, computerCount do
        if not getPcByIndex(i) then
            local pc = cs:spawnPc(computersPos + Vector(0, 0, 4) * (i - 1), orientations.w, "Roulette")
            pc.data.computerIndex = i
            pc.despawnTime = 9999999999999999
            pc.isStatic = true


            local t = items.create(tableType, (computersPos - Vector(0, 0.75, 0)) + Vector(0, 0, 4) * (i - 1), orientations.w)
            t.data.customType = "Club Computer Table"

            t.isStatic = true
            t.hasPhysics = true
            t.despawnTime = 9999999999999999
        end
    end
end


local bottle = itemTypes.getByName("Bottle")

---@param Vector pos
---@return Item beer
local function spawnBeer (pos)
    local beer = items.create(bottle, pos, orientations.n)
    beer.data.customType = "Beer"
    beer.isStatic = true
    beer.data.staticPickable = true
    beer.despawnTime = 9999999999999999
    return beer
end

local function spawnHoes ()
    for i = 1, hoeCount do
        hs:spawnHoe(hoesPos + Vector(2 * i, 0, math.random(10)), "Bar Hoe", "Hurt Ai")
    end
end

local function garbageCollectHoes ()
    for _, hoe in ipairs(humans.getAll()) do
        if hoe.data.customType == "Bar Hoe" and not hoe.isAlive then
            hoe:remove()
        end
    end
end


local function getTables()
    local tables = {}

    for i, item in ipairs(items.getAll()) do
        if item.data.customType == "Club Table" then
            tables[i] = item
        end
    end


    return next(tables)
end


local function getHoes()
    local hoes = {}

    for i, human in ipairs(humans.getAll()) do
        if human.data.customType == "Bar Hoe" and human.isAlive then
            hoes[i] = human
        end
    end


    return next(hoes)
end


local function getComputers()
    local pcs = {}

    for i, item in ipairs(items.getAll()) do
        if item.data.gameName == "Roulette" then
            pcs[i] = item
        end
    end

    return table.getn(pcs) == computerCount
end


local function spawnBeerOnTables ()
    for _, t in ipairs(items.getAll()) do
        if t.data.customType == "Club Table" then
            for i = 1, 3 do
                for i = 1, 3 do
                    if not t.data.beers[i] then
                        local beer = spawnBeer(t.pos - Vector(-0.5, 0, 0) + Vector(-0.5 * (i - 1), 0.78, 0))
                        t.data.beers[i] = beer
                    end
                end
            end
        end
    end
end



plugin:addHook(
    "BeerDrinked",
    ---@param Human human
    ---@param Item beer
    function (human, beer)
        for _, t in ipairs(items.getAll()) do
            if t.data.customType == "Club Table" then
                for i = 1, 6 do
                    if t.data.beers[i] and t.data.beers[i].index == beer.index then
                        t.data.beers[i] = nil
                    end
                end
            end
        end
    end
)

plugin:addHook(
    "PostResetGame",
    ---@param integer reason
    function (reason)
        if reason ~= RESET_REASON_ENGINECALL then return end
        if not getTables() then
            spawnTables()
        end

        if not getComputers() then
            spawnComputers()
        end

        if not getHoes() then
            spawnHoes()
        end
    end
)

plugin:addHook(
    "TimeElapsed",
    ---@param integer time
    function (time)
        if time == 300 then
            if not getHoes() then
                garbageCollectHoes()
                spawnHoes()
            end

            spawnBeerOnTables()
        end
    end
)


plugin:addHook(
    "PlayerSpawnedIn",
    ---@param Player ply
    function (ply)
        if not getTables() then
            spawnTables()
            spawnBeerOnTables()
        end        

        if not getComputers() then
            spawnComputers()
        end

        if not getHoes() then
            spawnHoes()
        end
    end
)
