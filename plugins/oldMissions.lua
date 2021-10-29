-- ---@type Plugin
-- local plugin = ...
-- plugin.name = 'v36 Missions'
-- plugin.author = 'Koto'
-- plugin.description = 'Adds back v36 missions'

-- local ms = require 'plugins.missionStuff'
-- local cs = require 'plugins.computerStuff'
-- local pc = false

-- plugin:addHook(
--     "ItemCreate",
--     ---@param ItemType type
--     ---@param Vector pos
--     function (type, pos)
--         if type.name == "Memo" or type.name == "computer" then
--             local base = ms:getOverlapingBase(pos)

--             if base then
--                 if not pc then
--                     cs:spawnPc(pos + Vector(0, 0, 0.01), orientations.n, "Roulette")
--                     pc = true
--                 end
--                 return hook.override
--             end
--         end
--     end

-- )