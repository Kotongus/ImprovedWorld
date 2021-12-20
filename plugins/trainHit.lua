---@type Plugin
local plugin = ...
plugin.name = 'Train Hit'
plugin.author = 'pvbcl'
plugin.description = 'Makes bullets hit trains.'
plugin.defaultConfig = {
    trainVehicleTypeName = 'Train'
}

plugin:addHook('PostPhysicsBullets',
    function ()
        for _, bullet in ipairs(bullets.getAll()) do
            for _, vehicle in ipairs(vehicles.getAll()) do
                if vehicle.type.name == (plugin.config.trainVehicleTypeName or 'Train') then
                    local intersect = physics.lineIntersectVehicle(vehicle, bullet.pos, bullet.lastPos)
                    if intersect.hit then
                        events.createBulletHit(2, intersect.pos, intersect.normal)
                    end
                end
            end
        end
    end
)
