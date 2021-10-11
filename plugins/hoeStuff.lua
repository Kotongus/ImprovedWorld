local hoeStuff = { _version = "1" }
hoeStuff.gender = 0 --Dont change it u gay
hoeStuff.hair = 2
hoeStuff.hairColors = {1, 4}
hoeStuff.head = 4

hoeStuff.names = {}

---@param Vector pos
---@param string type
---@param string ai
function hoeStuff:spawnHoe(pos, type, ai)
    local bot = players.createBot()
    local hoe = humans.create(pos, orientations.n, bot)
    hoe.data.customType = type
    hoe.data.customAI = ai or nil
    hoe.gender = self.gender
    hoe.hair = self.hair

    local hairClr = math.random(2)
    if hairClr == 1 then
        hairClr = 1
    else
        hairClr = 4
    end

    hoe.hairColor = hairClr
    hoe.head = self.head
    hoe.skinColor = 4
end


return hoeStuff