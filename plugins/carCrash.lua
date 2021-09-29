---@type Plugin
local plugin = ...
plugin.name = 'Car Crashes'
plugin.author = 'arrrgggg'
plugin.description = 'rattle me bones'

function plugin.hooks.Logic()

    for _, man in ipairs(humans.getAll()) do
        
        man.despawnTime = 100

    end

end

