local improvements = { _version = "2" }

improvements.list = [[
- Monsota is now police
- Buy beer for $50 /beer
- Randomised shirt colors
- /shirt [color] to change shirt color for free
- Bar with girls at the city centre
- Helis in shops
- No waiting for respawn
- Popping heads
- You spawn directly at shops
- Uzi costs $150
- Helis explode when they hit a wall too hard
]]

function improvements.getList()
    return improvements.list
end

return improvements