---@type Plugin
local plugin = ...
plugin.name = 'Join Info'
plugin.author = 'Koto'
plugin.description = "Adds join messages to inform players about improvements."

local improvements = require 'plugins.improvements'

plugin.defaultConfig = {
    paperMessage = "discord.gg/mW8FNeyHhz\nWelcome to Kotus Improved World, here is the list of improvements: \n"..improvements.getList(),
    ticks = 2
}

local newspaperType = itemTypes.getByName("Newspaper")
local db = SQLite.new("leaderboard.db")

---@return string
local function getMemo ()
    local board = db:query("SELECT * FROM drunkLeaderboard ORDER BY record DESC")
    local phrase = plugin.defaultConfig.paperMessage.."\n\nType /beer to get some beer, here are people who drunk the most:"

    if board then

        for i, v in ipairs(board) do
            if i > 10 then break end
            local name = accounts.getByPhone(v[1]).name
            phrase = phrase.."\n"..i..". "..name..":  "..v[2].." beers"
        end
    end

    return phrase
end


local function givePaper (human)
    if human.player.isBot or human.player.isZombie then return end

    local paper = items.create(newspaperType, human.pos, orientations.n)
    paper.despawnTime = 30
    paper:setMemo(getMemo())

    human:mountItem(paper, 0)
end



plugin:addHook(
    "PlayerSpawnedIn",
    ---@param Player ply
    function (ply)
        ply:sendMessage("Monsota is now police, apply and kill red nicks for money")
        ply:sendMessage("________________________")
        ply:sendMessage("ALSO JOIN OUR DISCORD")
        ply:sendMessage("discord.gg/mW8FNeyHhz")
        givePaper(ply.human)
    end
)