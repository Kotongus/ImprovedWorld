local plugin = ...
plugin.name = "Helicopters"
plugin.author = "Koto"
plugin.description = "Adds models to helis"
local heliHealth = 350


local function addHeliModel (heli)
    assert(heli, heli.type.index == 12, "No valid vehicle provided")

    local model = vehicles.create(vehicleTypes[14], heli.pos:clone(), heli.rot:clone(), heli.color)

    model.isLocked = true
    model.health = heliHealth
    model.controllableState = 0
    model.rigidBody.mass = 1000


    model.type = vehicleTypes[0]
    model:updateType()

    model.data.heli = heli
    model.data.isModel = true
    heli.data.model = model
    heli.rigidBody.data.model = heli
    model.rigidBody.data.vehicle = model

    return model
end


plugin:addHook(
    "Logic",
    function()
        for _, vehicle in ipairs(vehicles.getAll()) do
            if vehicle.data.isModel and not vehicle.data.heli.isActive then
                vehicle.data.heli:remove()
                vehicle:remove()
            end
        end


        for i, human in ipairs(humans.getAll()) do

            local heli = human.vehicle

            if heli and heli.type.index == 12 and heli.data.model and heli.health > 0 then
                heli.data.soundCountdown = heli.data.soundCountdown or 0

                if heli.data.soundCountdown < 1 and human.vehicleSeat == 0 then
                    local heliSpeed = heli.rigidBody.vel:clone()
                    heliSpeed = math.abs(heliSpeed.x) + math.abs(heliSpeed.y) + math.abs(heliSpeed.z)

                    local waitTime = 240

                    if heliSpeed > 0.35 then
                        waitTime = 100
                    end

                    heli.data.soundCountdown = waitTime
                    events.createSound(42, heli.pos, 1, 0.5)
                end
            end
        end


        for i, heli in ipairs(vehicles.getAll()) do
            if heli.isActive and heli.type.index == 12 then
                if not heli.data.model then
                    addHeliModel(heli)
                end
                
                heli.data.soundCountdown = heli.data.soundCountdown or 0

                if heli.data.soundCountdown > 0 then
                    heli.data.soundCountdown = heli.data.soundCountdown - 1
                end

                local model = heli.data.model

                if model and model.isActive then
                    model.pos, model.rigidBody.pos =
                        heli.pos:clone() + (-heli.rot:getRight() * 0.3),
                        heli.rigidBody.pos:clone() + (-heli.rigidBody.rot:getRight() * 0.3)


                    model.vel, model.rigidBody.vel = heli.vel:clone(), heli.rigidBody.vel:clone()
                    model.rot, model.rigidBody.rot = heli.rot:clone(), heli.rigidBody.rot:clone()

                    model.rigidBody.rotVel = heli.rigidBody.rotVel:clone()

                    heli.color = model.color
                    heli.health = model.health
                else
                    heli:remove()
                end
            end
        end
    end
)


plugin:addHook(
    "CollideBodies",
    function(aBody, bBody, aLocalPos, bLocalPos, normal, a, b, c, d)

        if not aBody or not bBody then
            return
        end

        local aVehicle, bVehicle = aBody.data.vehicle, bBody.data.vehicle
        local vehicleTable = {{aBody, aVehicle, aLocalPos}, {bBody, bVehicle, bLocalPos}}

        for i, t in ipairs(vehicleTable) do
            local body, vehicle, localPos = table.unpack(t)

            if not body or not vehicle or not vehicle.data.heli then
                return
            end

            vehicle.data.heli.rigidBody:collideLevel(
                localPos or Vector(),
                normal or Vector(),
                a or 0.005,
                b or 0,
                c or 0,
                d or 1
            )
            
            return hook.override
        end
    end
)