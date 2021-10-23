---@type Plugin
local plugin = ...
plugin.name = 'New Hooks'
plugin.author = 'Koto'
plugin.description = "Adds new hooks."

local requiredSpawnTicks = 5


plugin:addHook(
    "Physics",
    function ()
        for _, h in ipairs(humans.getAll()) do
            if not h.player then goto continue end

            if not h.data["spawnTicks"] then
                h.data["spawnTicks"] = 1
                goto continue

            -- if spawn ticks are 0 then it means they already spawned
            elseif h.data["spawnTicks"] == 0 then
                goto continue
            elseif h.data["spawnTicks"] >= requiredSpawnTicks then
                h.data["spawnTicks"] = 0
                hook.run("PlayerSpawnedIn", h.player)
            else h.data["spawnTicks"] = h.data["spawnTicks"] + 1 end

            ::continue::
        end
    end
)


plugin:addHook(
    "PlayerGiveWantedLevel",
    ---@param Player ply
    ---@param Player victim
    function (ply, victim)
        victim.data.lastAttacker = ply
    end
)


plugin:addHook(
    "PlayerDeathTax",
    ---@param Player ply
    function (ply)
        if not ply.human then return end
        hook.run("HumanDeath", ply.human, ply.data.lastAttacker)
    end
)