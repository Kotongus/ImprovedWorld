---@type Plugin
local plugin = ...
plugin.name = 'Beer'
plugin.author = 'Koto'
plugin.description = 'Adds beer to sub rosa yaaaay'

plugin.defaultConfig = {
    defaultDrunkCooldown = 5000,
    intensitivity = 4
}

local bottle = itemTypes.getByName("Bottle")
local leftClick = bit32.lshift(1, "0")


---@param Player ply
local function spawnBeer(ply)
    items.create(bottle, ply.human.pos, orientations.n)
end


---@param Human human
local function createBeerStats(human)
    human.data["drunkLevel"] = 0
    human.data["drunkCooldown"] = 0
end


---@param Human hum
local function handleBeer(human)
    
    local drunk = human.data["drunkLevel"]
    if drunk == nil then return end
    local cooldown = human.data["drunkCooldown"]
    
    if drunk > 0 and cooldown ~= 0 then
        human.damage = plugin.defaultConfig.intensitivity * drunk
        human.data["drunkCooldown"] = human.data["drunkCooldown"] - 1
    elseif cooldown == 0 then
        human.data["drunkLevel"] = 0
    end
     
end


---@param Human human
---@param Item beer
local function drinkBeer(human, beer)
    if human.data["drunkLevel"] == nil then
        createBeerStats(human)
    end

    human.data["drunkLevel"] = human.data["drunkLevel"] + 1
    human.data["drunkCooldown"] = plugin.defaultConfig.defaultDrunkCooldown
    beer:remove()

    hook.run("BeerDrinked", human)
end



plugin:addHook(
    "Physics",
    function ()
        for _, hum in ipairs(humans.getAll()) do
            handleBeer(hum)
            click = bit32.band(hum.inputFlags, leftClick)
            
            if click > 0 then
                local item = hum:getInventorySlot(0).primaryItem
                if item ~= nil and item.type == bottle then
                    drinkBeer(hum, item)
                end
            end
        end
    end
)


plugin.commands["/beer"] = {
    info = 'Get some beer to get drunk.',
	usage = '/beer',

	---@param ply Player
	---@param args string[]
	call = function (ply, _, args)
        if not ply.human then
            ply:sendMessage("You need to first spawn to get beer.")
        else
            spawnBeer(ply)
        end
    end
}

plugin.commands["/drunk"] = {
    info = 'Check your drunk level.',
	usage = '/drunkLevel',

	---@param ply Player
	---@param args string[]
	call = function (ply, _, args)
        if ply.human.data["drunkLevel"] and ply.human.data["drunkLevel"] ~= 0 then
            ply:sendMessage("Your drunk level is: " .. ply.human.data["drunkLevel"])
        else
            ply:sendMessage("Congratulations, You are not drunk!")
        end
    end
}