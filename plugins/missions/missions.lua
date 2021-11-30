---@type Plugin
local plugin = ...
plugin.name = 'v36 Missions'
plugin.author = 'Koto'
plugin.description = 'Brings back v36 missions'

local ms = require 'plugins.missions.missionStuff'
local cs = require 'plugins.computerStuff'


local teamList = {}


local function initTeams()
    for _, i in ipairs(ms.corporations) do
        teamList[i + 1] = ms:getTeam(i)
    end
end


-- 0 - oxs
-- 1 - prodo
-- 2 - nex
-- 3 - gold
---4 - penta
-- 5 - mons

plugin:addHook(
    "PlayerSpawnedIn",
    function ()
        if not teamList[1] then
            initTeams()
        end
    end
)


local function refilComputers ()
    for _, i in ipairs(ms.corporations) do
        local team = teamList[i + 1]

        for i = 1, 2 do
            if not team.computers[i].computer then
                local OS = "MissionOS"
                --if not team.hasMissions then OS = "PoliceOS" end

                local pc = cs:spawnPc(ms:getPcPos(team.orientation, team.computers[i].pos), ms:getOrientation(ms:flipOrientation(team.orientation)) or orientations.w, OS)
                team.computers[i].computer = pc
            end
        end
    end
end


plugin:addHook(
    "ItemCreate",
    ---@param ItemType type
    ---@param Vector pos
    function (type, pos)
        if type.name == "Memo" or type.name == "computer" then
            local base = ms:getOverlapingBase(pos)
            
            if base then
                return hook.override
            end
        end
    end

)


plugin:addHook(
    "TimeElapsed",
    ---@param integer time
    function (time)
        if time == 5 then
            if not teamList[1] then return end
            refilComputers()
        end
    end
)