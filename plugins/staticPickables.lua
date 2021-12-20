---@type Plugin
local plugin = ...
plugin.name = 'Static Pickable'
plugin.author = 'Koto'
plugin.description = 'Adds items that are static until somone picks them up.'

--Set item.data.staticPickable to true to allow anyone pick it up, or set it to an integer representing a team

plugin:addHook(
    "Physics",
    function ()
        for _, item in ipairs(items.getAll()) do
            if item.data.staticPickable then
                if item.parentHuman then
                    if item.data.staticPickable == true or item.parentHuman.player.team == item.data.staticPickable then
                        item.isStatic = false
                        item.data.staticPickable = nil
                    else
                        item:unmount()
                    end
                end
            end
        end
    end
)