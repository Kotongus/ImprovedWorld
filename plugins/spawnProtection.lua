---@type Plugin
local plugin = ...
plugin.name = 'Spawn Protection'
plugin.author = 'Koto'
plugin.description = 'Adds spawn protection.'


plugin.defaultConfig = {
    --In seconds
    protectionTime = 60
}


local dangerItems = {
    itemTypes.getByName("AK-47"),
    itemTypes.getByName("M-16"),
    itemTypes.getByName("Magnum"),
    itemTypes.getByName("MP5"),
    itemTypes.getByName("Uzi"),
    itemTypes.getByName("9mm"),
    itemTypes.getByName("Grenade")
}


---@param ItemType type
---@return boolean isOnList
function isOnList (type)
    if not type then return false end

    local isOnList = false
    for _, t in ipairs(dangerItems) do
        if t == type then
            isOnList = true
            break
        end
    end
    
    return isOnList
end


---@param Item item
---@return boolean result
function isReloaded (item)
    if item.bullets > 0 then
        return true
    else return false end
end


---@param Human human
function heal (human)
    human.isBleeding = false
    human.damage = 0

    human.health = 100
	human.bloodLevel = 100
	human.chestHP = 100
	human.headHP = 100
	human.leftArmHP = 100
	human.rightArmHP = 100
	human.leftLegHP = 100
	human.rightLegHP = 100
end

plugin.commands["/heal"] = {
    canCall = function (ply) return ply.isAdmin end,
    ---@param Player ply
    call = function (ply, _, _)
        if not ply.human then return end
        heal(ply.human)
    end
}


---@param Player ply
function addSpawnProtection (ply)
    ply.data.protection = plugin.defaultConfig.protectionTime
    ply.human.isImmortal = true
    --ply:sendMessage("You got spawn protection for " .. plugin.defaultConfig.protectionTime .. " seconds.")
end


---@param Player ply
---@param boolean expited
function removeSpawnProtection (ply, expired)
    if not ply then return end
    ply.data.protection = nil

    if ply.human then
        ply.human.isImmortal = false
        heal(ply.human)
    end

    if expired then
        ply:sendMessage("Your spawn protection expired.")
        
        hook.run("SpawnProtectionExpired", ply)
    end
end


plugin:addHook(
    "Physics",
    function ()
        for _, ply in ipairs(players.getAll()) do
            if not ply.human or not ply.data.protection then return end

            if ply.data.protection <= 0 then
                removeSpawnProtection(ply, true)

            elseif ply.human:getInventorySlot(0).primaryItem ~= nil or ply.human:getInventorySlot(1).primaryItem ~= nil then

                local result = false

                local right = ply.human:getInventorySlot(0)
                local left = ply.human:getInventorySlot(1)


                if right.primaryItem ~= nil then
                    result = isOnList(right.primaryItem.type) and isReloaded(right.primaryItem)
                    
                elseif left.primaryItem ~= nil and not result then
                    result = isOnList(left.primaryItem.type) and isReloaded(left.primaryItem)

                end

                if result and ply.human then removeSpawnProtection(ply, true)
                elseif result and not ply.human then removeSpawnProtection(ply, false) end

            elseif ply.human.vehicle then
                removeSpawnProtection(ply, true)
            end
        end
    end
)


plugin:addHook(
    "HumanDamage",
    ---@param Human human
    function (human)
        if human.player.data.protection then
            return hook.override
        end
    end
)


plugin:addHook(
    "HumanGrabbing",
    ---@param Human grabbingHuman
    function (grabbingHuman, _, _, _)
        if not grabbingHuman.player.data.protection then return end
        removeSpawnProtection(grabbingHuman.player, true)
    end
)

plugin:addHook(
    "TimeElapsed",
    ---@param integer time
    function (time)
        if time == 1 then
            for _, ply in ipairs(players.getAll()) do
                if ply.data.protection then
                    ply.data.protection = ply.data.protection - 1
                end
            end
        end
    end
)


plugin:addHook(
    "PlayerSpawnedIn",
    ---@param Player ply
    function (ply)
        if not ply.isBot and not ply.isZombie then
            removeSpawnProtection(ply, false)
            addSpawnProtection(ply)
        end
    end
)


plugin.commands["/prot"] = {
    info = "See when your spawn protection ends.",

    ---@param ply Player
	---@param args string[]
    call = function (ply, _, args)
        if not ply.human then return end
        if not ply.data.protection then
            ply:sendMessage("You are not spawn protected.")
            return
        end

        local secondsLeft = ply.data.protection
        ply:sendMessage("You got " .. secondsLeft .. " seconds of spawn protection left.")
    end
}