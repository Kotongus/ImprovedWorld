local improvements = { _version = "1" }

improvements.list = [[
- Beer (/beer)
- Less criminal rating
- No waiting for respawn
- You spawn directly at the shops
- Uzi costs $150 and has less bullet speed
- Improved spawn protection
- Bullets hit trains


[Coming soon]
- Helis in shops
- New kind of missions/events
- Better AI
]]

function improvements.getList()
    return improvements.list
end

return improvements