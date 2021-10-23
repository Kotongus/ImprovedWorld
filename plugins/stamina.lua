---@type Plugin
local plugin = ...
plugin.name = 'Stamina Fix'
plugin.author = 'Koto'
plugin.description = 'Removes stamina cuz its duuuumb.'


plugin:addHook(
    "Physics",
    function ()
        for _, ply in ipairs(players.getAll()) do
            if not ply.human then return end
            ply.human.stamina = 125
            ply.human.maxStamina = 125
        end
    end
)