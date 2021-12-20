---@type Plugin
local plugin = ...
plugin.name = 'Constant items'
plugin.author = 'Koto'
plugin.description = 'Change item.data.const to true for no despawning'

plugin:addHook(
    "ItemDelete",
    ---@param Item item
    function (item)
        if item.data.const then
            item.despawnTime = 99999
            return hook.override
        end
    end
)