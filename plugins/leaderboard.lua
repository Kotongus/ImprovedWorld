---@type Plugin
local plugin = ...
plugin.name = 'Leaderboard'
plugin.author = 'Koto'
plugin.description = "Adds a leaderboard that shows who's the best drinker."

local db = SQLite.new("leaderboard.db")

plugin:addEnableHandler(
    function (_)
        local leaderboard = db:query('SELECT * FROM drunkLeaderboard')

        if not leaderboard then
            db:query('CREATE TABLE drunkLeaderboard (playerID int NOT NULL UNIQUE, record int)')
        end        
    end
)


plugin:addHook(
    "BeerDrinked",
    ---@param Human drinker
    function (drinker)
    ---Update your own record
        local drunkLevel = drinker.data["drunkLevel"]
        local plyID = drinker.player.phoneNumber

        local userExists = db:query("SELECT * FROM drunkLeaderboard WHERE playerID = "..plyID)

        if not userExists or not userExists[1] then
            db:query("INSERT INTO drunkLeaderboard VALUES ("..plyID..", 1)")
        end

        local beat = db:query("SELECT playerID FROM drunkLeaderboard WHERE record < "..drunkLevel.." AND playerID = "..plyID)

        if not beat or not beat[1] then return end
        db:query("UPDATE drunkLeaderboard SET record = "..drunkLevel.." WHERE playerID = "..plyID)
        
    end
)

plugin.commands["/record"] = {
    info = "Get your personal drunk level record.",
    ---@param Player ply
    call = function (ply, _, _)
        local record = db:query("SELECT record FROM drunkLeaderboard WHERE playerID = "..ply.phoneNumber)

        if not record or not record[1] then
            ply:sendMessage("You haven't drinked anything yet.")
            return
        end

        ply:sendMessage("Your highest drunk level is: "..record[1][1])
        
    end
}



plugin.commands["/leaderboard"] = {
    info = "Get a list of the most pathologic drinkers on server.",
    ---@param Player ply
    ---@return table board
    call = function (ply, _, _)
        local board = db:query("SELECT * FROM drunkLeaderboard ORDER BY record DESC")
        if not board then
            ply:sendMessage("There are no drinking records yet.")
            return
        end

        for i, v in ipairs(board) do
            if i > 10 then break end
            local name = accounts.getByPhone(v[1]).name
            ply:sendMessage(i..". "..name..":  "..v[2])
        end
    end
}