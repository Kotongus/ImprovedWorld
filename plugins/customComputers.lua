---@type Plugin
local plugin = ...
plugin.name = 'Custom Computers'
plugin.author = 'Koto'
plugin.description = 'Custom computers for gambling or other stuff.'

local cs = require 'plugins.computerStuff'





plugin:addHook(
    "PostItemComputerInput",
    ---@param Item computer
    ---@param integer character
    function (computer, character)
        if computer.data.customType == "Custom Computer" then


            cs:refreshScreenPixels(computer)
            hook.run("ComputerGameLogic", computer, string.char(character), character, computer.data.gameName, cs:getPcUser(computer))
            computer.computerTopLine = 0
            computer.computerCursor = -1
        end
    end
)
