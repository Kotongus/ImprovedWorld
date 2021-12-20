---@type Plugin
local plugin = ...
plugin.name = 'Anti Lag'
plugin.author = 'Koto'
plugin.description = 'Less lag'

local lagTimer = 0

plugin:addHook(
    "TPSDipped",
    ---@param integer tps
    function (tps)
        lagTimer = lagTimer + 1
		if lagTimer > 5 then
			server:reset()
		end

		for _, human in ipairs(humans.getAll()) do
			if not human.isAlive then
				human:remove()
			end
		end

		for _, vehicle in ipairs(vehicles.getAll()) do
			if not vehicle.lastDriver then
				vehicle:remove()
			end
		end
    end
)