local improvements = { _version = "2" }

improvements.list = [[
- Buy beer for $50 /beer
- Bar with girls at the city centre
- Helis in shops
- Grabbing (thanks to olv)
- No waiting for respawn
- You spawn directly at the shops
- Uzi costs $150 and has less bullet speed
- Less criminal rating
- Improved spawn protection
- Anti lag system
]]

function improvements.getList()
    return improvements.list
end

return improvements