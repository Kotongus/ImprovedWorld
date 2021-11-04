---@type Plugin
local plugin = ...
plugin.name = 'Roulette'
plugin.author = 'Koto'
plugin.description = 'Roulette game for custom pcs.'

plugin.gameName = "Roulette"

local STATE_BET = 0
local STATE_PICK = 1
local STATE_SPIN = 2
local STATE_END = 3

local pickPhrase = "Place your bet on a color"
local colorPickCoords = Vector(24, 8, 0)

local betPhrase = "Enter your bet:"
local maxBetLength = 6
local betCoords = Vector(24, 10, 0)
local upperBetCoords = Vector(23, 3, 0)

local spinCoords = Vector(0, 11, 0)
local spinLineLength = 32
local maxOffset = 10
local startVelocity = 20
local stopNum = 8
local waitTicks = 10


local cs = require 'plugins.computerStuff'


local function updateColorPick (pc)
    local color = pc.data.game.selectedColor

    cs:write(pc, colorPickCoords + Vector(0, 0 * 3, 0), " ")
    cs:write(pc, colorPickCoords + Vector(0, 1 * 3, 0), " ")
    cs:write(pc, colorPickCoords + Vector(0, 2 * 3, 0), " ")

    cs:write(pc, colorPickCoords + Vector(0, color * 3, 0), ">")
end


---@return table
local function getRouletteColors ()
    local colors = {}

    for i = 1, spinLineLength + 200 do
        --Is even
        if i % 2 == 0 then
            colors[i] = 0
        --Isn't even
        else
            colors[i] = 1
        end
    end

    local greens = math.floor((spinLineLength + 200) / 10)
    for i = 1, greens do
        colors[i * 10] = 2
    end

    return colors
end


---@param Item pc
local function spinRoulette (pc)
    pc.data.game.roulettePos = pc.data.game.roulettePos + 1
    local pos = pc.data.game.roulettePos

    for i = 1, spinLineLength do
        local color = nil

        if pc.data.game.colors[i - 1 + pos] == 0 then
            color = "FF"
        elseif pc.data.game.colors[i - 1 + pos] == 1 then
            color = "44"
        else color = "AA" end

        cs:write(pc, spinCoords + Vector((i - 1) * 2, 0, 0), "OO", color)
    end

    cs:write(pc, Vector(1, spinCoords.y, 0), "|", "91")
    cs:write(pc, Vector(63, spinCoords.y, 0), "|", "91")
    cs:write(pc, Vector(spinLineLength, spinCoords.y - 1, 0), [[\/]], "11")
end


---@param Item pc
local function updateBet (pc)
    pc.data.game.inputBet = pc.data.game.inputBet:sub(1, maxBetLength)
    local bet = pc.data.game.inputBet
    if bet == "" then
        bet = nil
    end
    cs:write(pc, betCoords + Vector(4, 0, 0), "$"..(bet or 0)..string.rep(" ", maxBetLength), "02")
end



---@param Item pc
---@param integer state
local function changeGameState (pc, state)
    if state == STATE_BET then
        pc.data.game = {}
        pc.data.game.state = STATE_BET
        pc.data.game.inputBet = ""
        cs:setPcImage(pc, "roulette/roulette1")

        cs:write(pc, betCoords - Vector(0, 1, 0), betPhrase, "F0")
        cs:write(pc, betCoords, ">")

        cs:refreshScreenPixels(pc)
    

    elseif state == STATE_PICK then
        local bet = "0"
        if pc.data.game.inputBet ~= "" then
            bet = pc.data.game.inputBet
        end

        pc.data.game.user = cs:getPcUser(pc)
        if not pc.data.game.user then
            changeGameState(pc, STATE_BET)
            return
        end

        pc.data.game.user.money = pc.data.game.user.money - tonumber(bet)
        pc.data.game.user:updateFinance()

        pc.data.game.state = STATE_PICK

        cs:setPcImage(pc, "roulette/roulette2")
        pc.data.game.selectedColor = 0

        bet = pc.data.game.inputBet
        if bet == "" then bet = "0" end

        cs:write(pc, upperBetCoords, "Bet: $"..bet, "02")
        cs:write(pc, upperBetCoords + Vector(-6, 2, 0), pickPhrase, "F0")
        updateColorPick(pc)
        
        cs:write(pc, Vector(36, 22, 0), 'Press "M" to return to menu')

        cs:refreshScreenPixels(pc)


        
    elseif state == STATE_SPIN then
        pc.data.game.state = STATE_SPIN
        pc.data.game.colors = getRouletteColors()

        pc.data.game.ticks = 0
        pc.data.game.roulettePos = 0 + math.random(maxOffset)
        pc.data.game.rouletteStartPos = pc.data.game.roulettePos
        pc.data.game.velocity = startVelocity
        pc.data.game.waitTicks = waitTicks


        cs:setPcImage(pc, "roulette/roulette3")
        cs:refreshScreenPixels(pc)
    


    elseif state == STATE_END then
        pc.data.game.state = STATE_END

        if pc.data.game.selectedColor == pc.data.game.colors[pc.data.game.roulettePos + 1] then
            cs:setPcImage(pc, "roulette/win")
            cs:write(pc, Vector(28, 11, 0), "You won $"..pc.data.game.inputBet.."!")

            local bet = pc.data.game.inputBet
            
            if bet == "" then
                bet = nil
            end

            local multiplier = 1
            if pc.data.game.selectedColor == 2 then multiplier = 10 end

            pc.data.game.user.money = pc.data.game.user.money + tonumber(bet) * 2 * multiplier
            pc.data.game.user:sendMessage("+$"..tonumber(bet) * multiplier.." (Won on roulette)")
            
        else
            cs:setPcImage(pc, "roulette/lose")
        end
        
        
        cs:refreshScreenPixels(pc)
    end
end



plugin:addHook(
    "InitializeGame",
    ---@param Item pc
    ---@param string game
    function (pc, game)
        if game == plugin.gameName then
            pc.data.game = { state = STATE_BET, user, inputBet = "", selectedColor, colors = {}, roulettePos, rouletteStartPos, velocity, ticks, rouletteStop, waitTicks }

            changeGameState(pc, STATE_BET)

            -- cs:refreshScreenPixels(pc)
        end
    end
)


---@return Item[]
local function getAllSpiningRoulettes ()
    local roulettes = {}
    for _, pc in ipairs(items.getAll()) do
        if pc.data.gameName == plugin.gameName and pc.data.game and pc.data.game.state == STATE_SPIN then
            table.insert(roulettes, pc)
        end
    end

    return roulettes
end


local function velToTick (vel)
    local result = startVelocity - math.floor(vel)
    return result
end


plugin:addHook(
    "Logic",
    function ()
        for _, pc in ipairs(getAllSpiningRoulettes()) do
            if pc.data.game.ticks <= 0 then
                if pc.data.game.rouletteStop and pc.data.game.waitTicks > 0 then
                        pc.data.game.waitTicks = pc.data.game.waitTicks - 1
                        pc.data.game.ticks = startVelocity

                        if (math.random() * 10) > 9 then
                            spinRoulette(pc)
                            cs:refreshScreenPixels(pc)
                        end
                elseif pc.data.game.rouletteStop and pc.data.game.waitTicks <= 0 then
                        changeGameState(pc, STATE_END)
                else

                    pc.data.game.velocity = pc.data.game.velocity - 0.05

                    local tick = velToTick(pc.data.game.velocity)
                    if tick ~= stopNum then
                        pc.data.game.ticks = tick
                    else
                        pc.data.game.rouletteStop = true
                    end

                    spinRoulette(pc)
                    cs:refreshScreenPixels(pc)
                end
            else
                pc.data.game.ticks = pc.data.game.ticks - 1
            end


        end
    end
)


plugin:addHook(
    "TimeElapsed",
    function (time)
        if time == 5 then
            for _, pc in ipairs(items.getAll()) do
                if pc.data.gameName == plugin.gameName and pc.data.game and pc.data.game.state == STATE_END then
                    changeGameState(pc, STATE_BET)
                end
            end
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
        if game ~= plugin.gameName then return end

        if pc.data.game.state == STATE_BET then
            if tonumber(character) then
                pc.data.game.inputBet = pc.data.game.inputBet .. character
                updateBet(pc)
                cs:refreshScreenPixels(pc)

            --Backspace
            elseif charInt == 8 then
                pc.data.game.inputBet = pc.data.game.inputBet:sub(1, -2)
                updateBet(pc)
                cs:refreshScreenPixels(pc)
            elseif charInt == 10 and (tonumber(pc.data.game.inputBet) or 0) <= ply.money then
                changeGameState(pc, STATE_PICK)
            end


        elseif pc.data.game.state == STATE_PICK then
            --Up arrow
            if charInt == 16 then
                pc.data.game.selectedColor = math.clamp(pc.data.game.selectedColor - 1, 0, 2)
                updateColorPick(pc)
                cs:refreshScreenPixels(pc)
            --Down arrow
            elseif charInt == 17 then
                pc.data.game.selectedColor = math.clamp(pc.data.game.selectedColor + 1, 0, 2)
                updateColorPick(pc)
                cs:refreshScreenPixels(pc)
            elseif charInt == 10 then
                changeGameState(pc, STATE_SPIN)
            elseif character == "M" then
                local bet = "0"
                if pc.data.game.inputBet ~= "" then
                    bet = pc.data.game.inputBet
                end

                pc.data.game.user.money = pc.data.game.user.money + tonumber(bet)
                pc.data.game.user:updateFinance()
                changeGameState(pc, STATE_BET)
            end
        end

    end
)