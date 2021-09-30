---@type Plugin
local plugin = ...
plugin.name = 'Car Crash'
plugin.author = 'One-Eyed Willy'
plugin.description = 'Rattle me bones.'

local json = require 'main.json'

local function onResponse (res)
	if not plugin.isEnabled then return end

	if not res then
		plugin:warn('Request failed')
		return
	end

	if res.status < 200 or res.status > 299 then
		plugin:warn('Error ' .. res.status .. ': ' .. res.body)
		return
	end

	plugin:print('Posted')
end

---Build and post boards to a web server.
function postBoards ()
	local boards = {}

	if hook.run('BuildBoards', boards) then
		return
	end

	local postString

	if #boards == 0 then
		postString = ('{"port":%i,"boards":null}'):format(server.port)
	else
		local body = {
			port = server.port,
			boards = boards
		}

		postString = json.encode(body)
	end

	local cfg = plugin.config
	http.post(cfg.host, cfg.path, {}, postString, 'application/json', onResponse)
end

plugin:addHook('PostResetGame', postBoards)

plugin.defaultConfig = {
	updateSeconds = 10
}

-- calculate TPS every 100 ticks
local sampleInterval = 100
local expFiveSec = 1 / math.exp((16 * sampleInterval) / 5000)
local expOne = 1 / math.exp((16 * sampleInterval) / 60000)
local expFive = 1 / math.exp((16 * sampleInterval) / 300000)
local expFifteen = 1 / math.exp((16 * sampleInterval) / 900000)

local sampleCounter
local lastSampleTime
local recentFiveSec
local recentOne
local recentFive
local recentFifteen

local infoInterval
local infoCounter

plugin:addEnableHandler(function ()
	sampleCounter = 0
	lastSampleTime = os.realClock()
	recentFiveSec = 62.5
	recentOne = 62.5
	recentFive = 62.5
	recentFifteen = 62.5

	infoInterval = plugin.config.updateSeconds * server.TPS
	infoCounter = 0
end)

plugin:addDisableHandler(function ()
	sampleCounter = nil
	lastSampleTime = nil
	recentFiveSec = nil
	recentOne = nil
	recentFive = nil
	recentFifteen = nil

	infoInterval = nil
	infoCounter = nil
end)

local function calcTPS (avg, exp, tps)
	return (avg * exp) + (tps * (1 - exp))
end

plugin:addHook(
	'Logic',
	function ()
		sampleCounter = sampleCounter + 1
		if sampleCounter == sampleInterval then
			sampleCounter = 0

			local now = os.realClock()
			local tps = 1 / (now - lastSampleTime) * sampleInterval

			recentFiveSec = calcTPS(recentFiveSec, expFiveSec, tps)
			recentOne = calcTPS(recentOne, expOne, tps)
			recentFive = calcTPS(recentFive, expFive, tps)
			recentFifteen = calcTPS(recentFifteen, expFifteen, tps)

			lastSampleTime = now
		end

		infoCounter = infoCounter + 1
		if infoCounter == infoInterval then
			infoCounter = 0

			local numPlayers = #players.getNonBots()
			server:setConsoleTitle(string.format('%s | %i player%s | %.2f TPS (%.2f%%)', server.name, numPlayers, numPlayers == 1 and '' or 's', recentOne, recentOne / 62.5 * 100))

			if recentFiveSec < 50 then
				plugin:warn('Tickrate dipped to ' .. recentFiveSec)
				hook.run('TPSDipped', recentFiveSec)
			end
		end
	end
)

plugin.commands['/tps'] = {
	info = "Check the server's TPS.",
	---@param ply Player
	call = function (ply)
		ply:sendMessage(string.format('TPS from last 5s, 1m, 5m, 15m: %.2f, %.2f, %.2f, %.2f', recentFiveSec, recentOne, recentFive, recentFifteen))
	end
}

local a = {}

function plugin.hooks.Logic()

    for _, veh in ipairs(vehicles.getAll()) do

        if math.abs(a[veh.rigidBody.index] - veh.rigidBody.vel.x) >= 0.1 then

            veh.isActive = false
            veh.health = 0

        end

    end

    for _, veh in ipairs(vehicles.getAll()) do

        a[veh.rigidBody.index] = veh.rigidBody.vel.x

    end

end