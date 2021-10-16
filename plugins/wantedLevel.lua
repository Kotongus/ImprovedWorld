---@type Plugin
local plugin = ...
plugin.name = 'Wanted Level'
plugin.author = 'Koto'
plugin.description = 'Wanted level stuff'


plugin:addHook(
    "PlayerGiveWantedLevel",
    ---@param Player player
    ---@param Player victim
    ---@param HookInteger points
    function (player, victim, points)
        if victim.data.protection then
            return hook.override
        end
    end
)