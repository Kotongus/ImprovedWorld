-- ---@type Plugin
-- local plugin = ...
-- plugin.name = 'v36 Missions'
-- plugin.author = 'Koto'
-- plugin.description = 'Brings back v36 missions'


-- -- 0 - oxs
-- -- 1 - prodo
-- -- 2 - nex
-- -- 3 - gold
-- ---4 - penta
-- -- 5 - mons


-- local ms = require 'plugins.missionStuff'
-- local cs = require 'plugins.computerStuff'


-- local function refilComputers ()
--     -- for _, team in ipairs(teams) do
--     --     for i = 1, 2 do
--     --         if not team.computers[i] then
--     --             cs:spawnPc()
--     --         end
--     --     end
--     -- end
-- end


-- plugin:addHook(
--     "ItemCreate",
--     ---@param ItemType type
--     ---@param Vector pos
--     function (type, pos)
--         if type.name == "Memo" or type.name == "computer" then
--             local base = ms:getOverlapingBase(pos)

--             if type.name == "computer" and base then
--                 local team = ms:getTeamFromBase(base)
--                 print(team.." : ")
--                 print(pos)
--             end

--             if base then
--                 if not pc then
--                     refilComputers()
--                 end
--                 return hook.override
--             end
--         end
--     end

-- )


-- plugin.commands["/base"] = {
--     call = function (ply, hum, args)
--         local base = ms:getBase(tonumber(args[1]))

--         hum:teleport(base.interiorCuboidA + Vector(3, 2, 3))
--     end
-- }


-- plugin.commands["/o"] = {
--     call = function (ply, hum, args)
--         local u = tonumber(args[1])
--         if u == 1 then
--             u = orientations.n
--         elseif u == 2 then
--             u = orientations.e
--         elseif u == 3 then
--             u = orientations.s
--         elseif u == 4 then
--             u = orientations.w
--         else
--             u = orientations.n
--         end
        

--         items.create(itemTypes[39], hum.pos, u)
--     end
-- }