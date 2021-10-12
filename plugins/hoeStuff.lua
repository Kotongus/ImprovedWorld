local hoeStuff = { _version = "1" }
hoeStuff.gender = 0 --Dont change it u gay
hoeStuff.hair = 2
hoeStuff.hairColors = {1, 4}
hoeStuff.head = 4

hoeStuff.names = {
    "Zoey",
    "Hannah",
    "Kaylee",
    "Sara",
    "Alexa",
    "Jane",
    "Lana",
    "Jessica",
    "Emmy",
    "Louise",
    "Vanessa",
    "Jouliett",
    "Violetta"
}

---@param Vector pos
---@param string type
---@param string ai
function hoeStuff:spawnHoe(pos, type, ai)
    local bot = players.createBot()
    bot.name = self.names[math.random(table.getn(self.names))]

    bot:update()

    local hoe = humans.create(pos, orientations.n, bot)
    hoe.data.customType = type
    hoe.data.customAI = ai or nil
    hoe.gender = self.gender
    hoe.hair = self.hair

    local hairClr = math.random(2)

    hoe.hairColor = self.hairColors[hairClr]
    hoe.head = self.head
    hoe.skinColor = 4
end


return hoeStuff