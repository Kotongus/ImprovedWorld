---@type Plugin
local plugin = ...
plugin.name = 'Mission OS'
plugin.author = 'Koto'
plugin.description = 'OS for missions pcs'
plugin.gameName = "MissionOS"

local cs = require 'plugins.computerStuff'


plugin:addHook(
    "InitializeGame",
    ---@param Item pc
    ---@param string game
    function (pc, game)
        if game == plugin.gameName then
            cs:drawRect(pc, "1F", Vector(0, 0, 0), Vector(63, 22, 0), "/")

            local message = "Stand by, OS not ready."
            cs:write(pc, Vector(math.ceil(pc.data.display.x / 2) - math.floor(#message / 2), 10, 0), message, "F0")

            cs:refreshScreenPixels(pc)
        end
    end
)


plugin:addHook(
    "ComputerGameLogic",
    ---@param Item pc
    ---@param string character
    ---@param integer charInt
    ---@param string game
    ---@param Player ply
    function (pc, character, charInt, game, ply)
        if game == plugin.gameName then
            cs:drawRect(pc, "1F", Vector(0, 0, 0), Vector(63, 22, 0), "/")

            local message = "Stand by, OS not ready."
            cs:write(pc, Vector(math.ceil(pc.data.display.x / 2) - math.floor(#message / 2), 10, 0), message, "F0")

            cs:refreshScreenPixels(pc)
        end
    end
)