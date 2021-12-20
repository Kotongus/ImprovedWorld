---@type Plugin
local plugin = ...
plugin.name = 'Wanted Level'
plugin.author = 'Koto'
plugin.description = 'Wanted level stuff'

local shotMemoryTime = 50


plugin:addHook(
    "BulletCreate",
    ---@param Player shooter
    function (_, _, _, shooter)
        shooter.data.lastShot = os.time()
    end
)


plugin:addHook(
    "PlayerGiveWantedLevel",
    ---@param Player player
    ---@param Player victim
    ---@param HookInteger points
    function (player, victim, points)
        if victim.data.protection then
            return hook.override
        else
            local lastShot = victim.data.lastShot

            if lastShot and (lastShot + shotMemoryTime) >= os.time() then
                return hook.override
            end

        end
    end
)