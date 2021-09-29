local improvements = { _version = "2" }

improvements.list = [[
- Beer (/beer)
- Helis in shops
- Grabbing (thanks to olv)
- No waiting for respawn
- You spawn directly at the shops
- Uzi costs $150 and has less bullet speed
- Less criminal rating
- Improved spawn protection


[Coming soon]

- Skyscraper corporations
- Bars
- Teasers
]]

function improvements.getList()
    return improvements.list
end

return improvements