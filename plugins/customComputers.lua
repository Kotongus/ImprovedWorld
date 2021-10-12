---@type Plugin
local plugin = ...
plugin.name = 'Custom Computers'
plugin.author = 'Koto'
plugin.description = 'Custom computers for gambling or other stuff.'

local computerStuff = require 'plugins.computerStuff'


local function getPcUser (pc)
    for _, item in ipairs(humans.getAll()) do
        if human and item.index == pc.index then
            return pc
        end
    end
end


plugin:addHook(
    "PostItemComputerInput",
    ---@param Item computer
    ---@param integer character
    function (computer, character)
        if computer.data.customType == "Custom Computer" then
            computer.computerTopLine = 0
            computerStuff:refreshScreenPixels(computer)
            hook.run("ComputerGameLogic", computer, string.char(character), character, computer.data.gameName, getPcUser(computer))
        end
    end
)
