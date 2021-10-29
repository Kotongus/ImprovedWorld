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
- Less criminal rating
- Improved spawn protection
]]

function improvements.getList()
    return improvements.list
end

return improvements