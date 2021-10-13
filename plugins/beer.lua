---@type Plugin
local plugin = ...
plugin.name = 'Beer'
plugin.author = 'Koto'
plugin.description = 'Adds beer to sub rosa yaaaay'

plugin.defaultConfig = {
    defaultDrunkCooldown = 3500,
    intensitivity = 3,
    beerPrice = 50
}

local bottle = itemTypes.getByName("Bottle")
local leftClick = bit32.lshift(1, "0")


---@param Player ply
---@return Item beer
local function spawnBeer(ply)
    local beer = items.create(bottle, ply.human.pos, orientations.n)
    beer.data.customType = "Beer"
    return beer
end


---@param Human human
local function createBeerStats(human)
    human.data["drunkLevel"] = 0
    human.data["drunkCooldown"] = 0
end


---@param Human human
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
    hook.run("BeerDrinked", human, beer)
    beer:remove()
end



plugin:addHook(
    "Physics",
    function ()
        for _, hum in ipairs(humans.getAll()) do
            handleBeer(hum)
            click = bit32.band(hum.inputFlags, leftClick)
            
            if click > 0 then
                local item = hum:getInventorySlot(0).primaryItem
                if item ~= nil and item.data.customType == "Beer" then
                    drinkBeer(hum, item)
                end
            end
        end
    end
)


plugin.commands["/beer"] = {
    info = 'Buy beer for $'..plugin.defaultConfig.beerPrice..'.',
	usage = '/beer',

	---@param ply Player
	---@param args string[]
	call = function (ply, _, args)
        local price = plugin.defaultConfig.beerPrice

        if not ply.human then
            ply:sendMessage("You need to first spawn to buy beer.")
        elseif ply.money >= price then
            ply.money = ply.money - price
            ply:updateFinance()

            local beer = spawnBeer(ply)
            ply.human:mountItem(beer, 0)
        elseif ply.money < price then
            ply:sendMessage("You don't have enought money for beer...")
        end
    end
}


plugin.commands["/drunk"] = {
    info = 'Check your drunk level.',

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