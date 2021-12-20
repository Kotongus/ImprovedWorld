local plugin = ...
plugin.name = "Car Crashes"
plugin.author = "Koto"
plugin.description = "Adds car crashes"

local crashVelDivider = 2.5
local crashStep = 0.34
local heliExplosionStep = 0.6


local function explodeVehicle(car)
    if car.data.model then
        car.data.model.health = 0
        car.data.model.color = 0
        car.data.model:updateType()
    else
        car.health = 0
        car.color = 0
        car:updateType()
    end

    car.controllableState = 0
    car:updateDestruction(2, 0, car.pos, Vector())


    for i = 1, 4 do
        local exploder = items.create(itemTypes.getByName("Box"), car.pos, car.rot)

        if exploder then
            exploder:explode()
            events.createExplosion(car.pos + Vector(math.random(), math.random(), math.random()))

            local multipliers = {math.random(0, 1) - 1, math.random(0, 1) - 1, math.random(0, 1) - 1}

            exploder.despawnTime = 5000

            exploder.rigidBody.vel:set(exploder.rigidBody.vel + Vector(math.random() / 10 * multipliers[1], math.random() / 10 * multipliers[2], math.random() / 10 * multipliers[3]))
        end
    end
end


local function crashVehicle(car, crashOverAll)
    --Break windows
    if car.type.index == 12 then
        for i = 0, 7 do
            if not car.data.model:getIsWindowBroken(i) then
                car.data.model:updateDestruction(0, i, car.pos, Vector())
                car.data.model:setIsWindowBroken(i, true)
            end
        end

        if crashOverAll > heliExplosionStep and car.health > 0 then
            explodeVehicle(car)
        end
    else
        for i = 0, 7 do
            if not car:getIsWindowBroken(i) then
                car:updateDestruction(0, i, car.pos, Vector())
                car:setIsWindowBroken(i, true)
            end
        end
    end

    --Reject passengers
    for _, h in ipairs(humans.getAll()) do
        if h.vehicle and h.vehicle.index == car.index then
            h.vehicle = nil
            h:addVelocity(car.data.lastVel / crashVelDivider)
        end
    end

    car.gasControl = -0.5
end

plugin:addHook(
    "Physics",
    function ()
        for _, v in ipairs(vehicles.getAll()) do
            v.data.ticks = (v.data.ticks or 0) + 1

            if v.trafficCar and not v.data.lastPos and v.data.ticks > 5 then
                v.data.lastPos = v.pos:clone()
            elseif not v.data.heli and v.data.ticks > 5 then
                if not v.data.lastPos then
                    v.data.lastPos = v.pos:clone()
                end

                local velocity = v.pos - v.data.lastPos


                if not v.data.lastVel then
                    v.data.lastVel = velocity
                end

                local crash = v.data.lastVel - velocity

                crash.x = math.abs(crash.x)
                crash.y = math.abs(crash.y)
                crash.z = math.abs(crash.z)

                local strongness = 0

                if v.data.model then
                    strongness = 0.4
                end

                local crashOverAll = crash.x + crash.z + crash.y
                if crashOverAll >= crashStep + strongness then
                    crashVehicle(v, crashOverAll)
                end


                v.data.lastPos = v.pos:clone()
                v.data.lastVel = velocity
            end
        end
    end
)