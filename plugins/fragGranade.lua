-- This one is broken, I didn't finish



-- ---@type Plugin
-- local plugin = ...
-- plugin.name = 'Fragmentation grenade'
-- plugin.author = 'Koto'
-- plugin.description = 'Adds fragmentation granades to sub rosa yaaaay'

-- plugin.defaultConfig = {
--     frags = 100,
     
--     bulletType = 0
-- }



-- local watermelon = itemTypes.getByName("AK-47")

-- ---@param rotMatrix rot
-- ---@param Vector pos
-- ---@param Player ply
-- ---@param Item it
-- function spawnBullet (rot, pos, ply, it)
--     -- local b = bullets.create(plugin.defaultConfig.bulletType, pos, Vector(1, 1, 1) * rot, ply)
--     local b = items.create(watermelon, pos, rot)
--     b.isStatic = true
--     -- b.time = 1000
--     -- events.createBullet(plugin.defaultConfig.bulletType, pos, Vector(1, 1, 1) * rot, it)
-- end


-- local r = 10 
-- local th = math.pi / plugin.defaultConfig.frags
-- local fi = 2 * math.pi / plugin.defaultConfig.frags

-- plugin:addHook(
--     "GrenadeExplode",
--     ---@param Item grenade
--     function (grenade)
--         for i = -th, th, 1 do
--             for j = 0, fi , 1 do
--                 x = r * math.cos(i) * math.cos(j)
--                 y = r * math.cos(i) * math.sin(j)
--                 z = r * math.sin(i)
--                 local rot = RotMatrix( 
--                     x, 0, 0, 
--                     0, y, 0, 
--                     0, 0, 0     
--                 )    
--                 spawnBullet(rot, grenade.pos, grenade.grenadePrimer, grenade)

--                 local rot = RotMatrix( 
--                     1, 0, z, 
--                     0, y, 0, 
--                     x, 0, 0     
--                 )    
--                 spawnBullet(rot, grenade.pos, grenade.grenadePrimer, grenade)

--                 local rot = RotMatrix( 
--                     0, 0, 0, 
--                     x, y, z, 
--                     0, 0, 0     
--                 )    
--                 spawnBullet(rot, grenade.pos, grenade.grenadePrimer, grenade)
--             end            

--         end

--     end
-- )