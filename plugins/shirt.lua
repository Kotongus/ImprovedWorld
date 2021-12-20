---@type Plugin
local plugin = ...
plugin.name = 'Cosmetics'
plugin.author = 'Koto'
plugin.description = "Changes shirt colors and stuff"

local colorsName = { ["white"] = 0, ["pink"] = 1, ["cream"] = 2, ["blue"] = 4, ["red"] = 5, ["black"] = 9, ["green"] = 11 }
local randColors = { 0, 4, 5, 9, 11 }

plugin:addHook(
    "PostClickedEnterCity",
    ---@param Player ply
    function (ply)
        local rand = math.random(5)
        local color = randColors[rand]

        ply.model = 0
        ply.tieColor = 0
        ply.human.model = 0
        ply.human.tieColor = 0
        
        ply.human.suitColor = color
        ply.suitColor = color

        ply.human.lastUpdatedWantedGroup = -1
        ply:update()
    end
)


plugin:addHook(
    "TimeElapsed",
    function (time)
        if time == 1 then
            for _, human in ipairs(humans.getAll()) do
                if human.data.disco and human.isAlive and human.model ~= 1 then
                    local color = human.suitColor
                    for i = 1, #randColors do
                        if randColors[i] == color then
                            color = randColors[i + 1]
                            break
                        end
                    end

                    human.suitColor = color
                    human.lastUpdatedWantedGroup = -1
                end
            end
        end
    end
)


plugin.commands["/shirt"] = {
    call = function (ply, _, args)
        if args[1] == "list" then
            local list = {
                "Shirt color list:",
                "- White",
                "- Pink",
                "- Cream",
                "- Blue",
                "- Red",
                "- Black",
                "- Green"
            }

            for _, v in ipairs(list) do
                ply:sendMessage(v)
            end

            return
        end

        if not ply.human then
            ply:sendMessage("You have to first spawn to change your shirt color")
            return
        end

        if ply.human.model ~= 0 then
            ply:sendMessage("You cannot change your shirt color while you have a suit")
            return
        end

        local color = colorsName[args[1]:lower()]

        if not color and args[1] ~= "sus" and args[1] ~= "disco" then
            color = tonumber(args[1])
            if not color then
                ply:sendMessage("You provided wrong color")
                return
            end
        end

        if args[1] == "sus" then color = colorsName["red"] end
        if args[1] == "disco" and (ply.isAdmin or ply.data.isVip) then
            ply.human.data.disco = not ply.human.data.disco
            if ply.human.data.disco then
                ply:sendMessage("Disco mode: ON")
                color = 0
            else
                ply:sendMessage("Disco mode: OFF")
                color = 0
            end
        end

        ply.human.suitColor = color
        ply.human.lastUpdatedWantedGroup = -1
        ply:update()
    end
}