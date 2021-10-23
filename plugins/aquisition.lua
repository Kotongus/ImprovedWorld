-- ---@type Plugin
-- local plugin = ...
-- plugin.name = 'Aquisition'
-- plugin.author = 'Koto'
-- plugin.description = 'Adds an epic aquisition mission.'


-- local function calculateSpace (building)
--     local vec = building.interiorCuboidA - building.interiorCuboidB
--     local rot = nil
    

--     local space = Vector()

--     space.x = math.abs(vec.x)
--     space.y = math.abs(vec.y)
--     space.z = math.abs(vec.z)

--     return { space, rot }
-- end



-- plugin.commands["/check"] = {
--     call = function (ply)
--         for i, building in ipairs(buildings.getAll()) do
--             if building.type == 4 then
--                 local space = calculateSpace(building)[1]
--                 space.x = space.x / 2
--                 space.y = 15
--                 space.z = space.z / 2 - space.z / 4

--                 ply.human:teleport((building.interiorCuboidA) + space)
--                 return
--             end
--         end
--     end
-- }