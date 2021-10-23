---@type Plugin
local plugin = ...
plugin.name = 'Police'
plugin.author = 'Koto'
plugin.description = "Replaces monsota with police."

local shotMemoryTime = 50

local policeTeam = 1
local killReward = 250
local policeCoordsA = Vector()
local policeCoordsB = Vector()
local memoType = itemTypes.getByName("Memo").index


local function getMonsBuilding ()
    for _, building in ipairs(buildings.getAll()) do
        if building.index == 26 then
            return building
        end
    end
end


---@param Player policeman
---@param Player criminal
local function rewardPoliceman (policeman, criminal)
    local moneyToGive = killReward + math.clamp(math.floor((criminal.criminalRating - 100) / 2), 0, 100)

    policeman.money = policeman.money + moneyToGive
    policeman:updateFinance()

    policeman:sendMessage("+$"..moneyToGive.." (Killed a criminal)")
end

---@param Player policeman
local function firePoliceman (policeman)
    policeman.team = 17
    policeman.human.model = 0
    policeman.human.tieColor = 0
    policeman.human.suitColor = 0

    policeman.human.lastUpdatedWantedGroup = -1
    policeman:update()

    
    policeman:sendMessage("You got fired from police because you killed innocent")
end

---@param Player ply
local function hirePoliceman(ply)
    ply.team = policeTeam

    ply.human.model = 1

    ply.human.tieColor = 8

    ply.human.suitColor = 3

    ply.human.lastUpdatedWantedGroup = -1
    ply:update()

    
    ply:sendMessage("You applied as a policeman, kill red nicks and get rewarded")
end


plugin:addHook(
    'PlayerActions',
    ---@param Player ply
    function (ply)
        if ply.numActions ~= ply.lastNumActions then
			local action = ply:getAction(ply.lastNumActions)

            if action.type == 0 and action.a == 20 and (action.b == 1 or action.b == 0) and ply.human then
                local pos = ply.human.pos
                local mons = getMonsBuilding()

                local coordA = mons.interiorCuboidA - Vector(10, 10, 10)
                local coordB = mons.interiorCuboidB + Vector(10, 10, 10)

                local result = (coordB.x > pos.x and pos.x > coordA.x) and (coordB.z > pos.z and pos.z > coordA.z)

                if result then
                    hirePoliceman(ply)
                end
            end
		end
    end
)


plugin:addHook(
    "HumanDeath",
    ---@param Human human
    ---@param Player killer
    function (human, killer)
        if killer and (human.player.isBot or human.player.isZombie) then
            if human.player.criminalRating >= 100 and killer.team == policeTeam then
                rewardPoliceman(killer, human.player)
            elseif human.player.criminalRating < 100 and killer.team == policeTeam then
                local lastShot = human.player.data.lastShot

                if not lastShot or (lastShot + shotMemoryTime) <= os.time() then
                    firePoliceman(killer)
                end
            end
        end
    end
)


plugin:addHook(
    "ItemCreate",
    ---@param ItemType type
    ---@param Vector pos
    function (type, pos)
        if type.index == memoType then
            local mons = getMonsBuilding()

            local coordA = mons.interiorCuboidA
            local coordB = mons.interiorCuboidB

            local result = (coordB.x > pos.x and pos.x > coordA.x) and (coordB.z > pos.z and pos.z > coordA.z)

            if result then
                return hook.override
            end
        end
    end
)