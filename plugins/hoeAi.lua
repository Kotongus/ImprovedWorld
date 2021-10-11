---@type Plugin
local plugin = ...
plugin.name = 'Hoe AI'
plugin.author = 'Koto'
plugin.description = 'Makes hoes say stuff.'

plugin.aiType = "Hurt Ai"

local ouchPhrases = {"STOP", "IT HURTS", "DON'T KILL ME", "OUCH", "YOU IDIOT", "i should leave this job...", "Aaaaaaaaaaaaaaaaa"}

plugin:addHook(
    "HumanDamage",
    ---@param Human hoe
    function (hoe, _, _)
        if hoe.data.customAI == plugin.aiType and hoe.isAlive then
            if math.random(2) == 2 then return end
            local rand = math.random(table.getn(ouchPhrases))
            hoe:speak(ouchPhrases[rand], 2)
        end
    end
)