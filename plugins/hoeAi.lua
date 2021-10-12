---@type Plugin
local plugin = ...
plugin.name = 'Hoe AI'
plugin.author = 'Koto'
plugin.description = 'Makes hoes say stuff.'

plugin.aiType = "Hurt Ai"

local ouchPhrases = {"OUCH", "YOU IDIOT", "SOMEONE KILL HIM!", "Aaaaaaaaaaaaaaaaa"}
local ouchProbability = 5

local smallTalks = {"How is it goin' ya'll?", "You look so pretty", "Someone start shooting, I need some fun", "How much beer you drinked today?", "this job sucks..."}
local talkProbability = 5

plugin:addHook(
    "HumanDamage",
    ---@param Human hoe
    function (hoe, _, _)
        if hoe.data.customAI == plugin.aiType and hoe.isAlive then
            if math.random(ouchProbability) == 2 then
                local rand = math.random(table.getn(ouchPhrases))
                hoe:speak(ouchPhrases[rand], 2)
            end
        end
    end
)


plugin:addHook(
    "TimeElapsed",
    ---@param integer time
    function (time)
        if time == 60 then
            for _, hoe in ipairs(humans.getAll()) do
                if hoe.data.customAI == plugin.aiType and hoe.isAlive then
                    if math.random(talkProbability) == 2 then
                        local phrase = smallTalks[math.random(table.getn(smallTalks))]
                        local loudLevel = 1
                        
                        if phrase == "this job sucks..." then
                            loudLevel = 0
                        end

                        hoe:speak(phrase, loudLevel)
                    end
                end
            end
        end
    end
)