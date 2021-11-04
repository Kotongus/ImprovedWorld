---@type Plugin
local mode = ...
mode.name = 'Improved World'
mode.author = 'Koto'

--Here type in your debug spawn and you will spawn there
local debugSpawn = nil --Vector(1518, 26, 1068)


mode.defaultConfig = {
    spawnPositions = { Vector(2452, 37, 1016), Vector(1361, 37, 1016), Vector(1363, 37, 2054) },
	trainCrimLimit = 100
}

local spawningPlayers = {}


function fileExists(name)
	local f = io.open(name,"r")
	if f ~= nil then io.close(f) return true else return false end
 end


mode:addEnableHandler(function (isReload)
	server.type = TYPE_WORLD --+16
	
	if not fileExists("config.txt") then
		server.name = "Kotus | Improved World | Police" --Max length 31
		debugSpawn = nil
	else
		server.name = "Kotus / Testing" --Max length 31
		server.password = "t0"
	end

	server.maxPlayers = 50
	server.worldStartCash = 5000
	server.worldMinCash = 100
	server.worldRespawnTeam = false
	server.worldTraffic = 100

	server.worldCrimeNoSpawn = 500
	
	server.worldCrimeCivCiv = 25
	server.worldCrimeCivTeam = 25
	server.worldCrimeTeamCiv = 20
	server.worldCrimeTeamTeam = 0
	server.worldCrimeTeamTeamInBase = 0

	server.adminPassword = "look mayor i got drip#$3"

	if not isReload then
		server:reset()
	end
end
)


mode.commands["/discord"] = {
	info = "Provides you with our discord link.",
	---@param Player ply
	function (ply, _, _)
		ply:sendMessage("discord.gg/mW8FNeyHhz")
	end

}


---@return integer
local function randSpawn()
    return mode.defaultConfig.spawnPositions[math.random(3)]
end

---@param Player ply
local function spawn(ply)
	if debugSpawn then
		humans.create(debugSpawn, orientations.n, ply)
		return
	end

	if ply.criminalRating < mode.defaultConfig.trainCrimLimit or ply.isAdmin then
		if humans.create(randSpawn(), orientations.n, ply) then
			ply:update()
		end
	elseif humans.create(Vector(2943, 26, 1540), orientations.n, ply) then
		ply:update()
	end
end

mode:addHook(
    'PlayerActions',
    ---@param Player ply
    function (ply)
        if ply.numActions ~= ply.lastNumActions then
			local action = ply:getAction(ply.lastNumActions)

			if action.type == 0 and action.a == 1 and action.b == 1 then
				hook.run("ClickedEnterCity", ply)
				ply.lastNumActions = ply.numActions
			end
		end
    end
)


mode:addHook(
    "Logic",
	function ()
		for _, p in ipairs(players.getAll()) do
			p.spawnTimer = 0
		end
	end

)
mode:addHook(
    'ClickedEnterCity',
    ---@param Player ply
    function (ply)
        spawn(ply)
		hook.run("PostClickedEnterCity", ply)
    end
)


local leftClick = bit32.lshift(1, "0")

mode:addHook(
    "Physics",
    function ()
        for _, hum in ipairs(humans.getAll()) do
            click = bit32.band(hum.inputFlags, leftClick)
            
            if click > 0 then
                hook.run("LeftClick", hum)
            end
        end
    end
)