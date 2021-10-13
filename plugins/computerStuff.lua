local computerStuff = { _version = "1" }
computerStuff.screenX = 63
computerStuff.screenY = 22


---@param Item pc
---@param string path
---@param integer ascii 1 for ascii art and 2 for pure color rects
function computerStuff:setPcImage (pc, path, ascii)
    local image = Image.new()
    image:loadFromFile("./images/"..path..".png")

    for iY = 0, pc.data.display.y do
        for iX = 0, pc.data.display.x do
            local r, g, b = image:getRGB(iX, iY)

            if pc.data.display.frame[iY + 1] and pc.data.display.frame[iY + 1][iX + 1] then
                pc.data.display.frame[iY + 1][iX + 1].color = string.rep(self:rgbToCga(r, g, b), ascii or 2)
                pc.data.display.frame[iY + 1][iX + 1].character = "O"
            end
        end
    end
end

---@param integer r, g, b
function computerStuff:rgbToCga(r, g, b)
	if r == 0 and g == 0 and b == 0 then
        return "0"
    elseif r == 0 and g == 0 and b == 170 then
        return "1"
    elseif r == 0 and g == 170 and b == 0 then
        return "2"
    elseif r == 0 and g == 170 and b == 170 then
        return "3"
    elseif r == 170 and g == 0 and b == 0 then
        return "4"
    elseif r == 170 and g == 0 and b == 170 then
        return "5"
    elseif r == 170 and g == 85 and b == 0 then
        return "6"
    elseif r == 170 and g == 170 and b == 170 then
        return "7"
    elseif r == 85 and g == 85 and b == 85 then
        return "8"
    elseif r == 85 and g == 85 and b == 255 then
        return "9"
    elseif r == 85 and g == 255 and b == 85 then
        return "A"
    elseif r == 85 and g == 255 and b == 255 then
        return "B"
    elseif r == 255 and g == 85 and b == 85 then
        return "C"
    elseif r == 255 and g == 85 and b == 255 then
        return "D"
    elseif r == 255 and g == 255 and b == 85 then
        return "E"
    elseif r == 255 and g == 255 and b == 255 then
        return "F"
    end
end


---@param Vector pos
---@return Item
function computerStuff:spawnPc (pos, rot, game)
    local pc = items.create(itemTypes.getByName("computer"), pos, rot)
    pc.data.display = { x = self.screenX, y = self.screenY, frame = {} }
    pc.data.gameName = game
    pc.data.game = {}

    pc.computerCursor = -1

    for iY = 0, self.screenY do
        pc.data.display.frame[iY + 1] = {}
        for iX = 0, self.screenX do
            pc.data.display.frame[iY + 1][iX + 1] = {}
        end
    end

    pc.data.customType = "Custom Computer"

    hook.run("InitializeGame", pc, game)

    return pc
end


---@param Item pc
function computerStuff:refreshScreenPixels (pc)
    local x = pc.data.display.x
    local y = pc.data.display.y

    for iY = 0, y do
        local lineText = ""

        for iX = 0, x do
            if pc.data.display.frame[iY + 1] and pc.data.display.frame[iY + 1][iX + 1] then
                lineText = lineText .. (pc.data.display.frame[iY + 1][iX + 1].character or " ")
                pc:computerSetColor(iY, iX, tonumber("0x".. (pc.data.display.frame[iY + 1][iX + 1].color or "11")))
            end
        end

        pc:computerSetLine(iY, lineText)
        pc:computerTransmitLine(iY - 1)
    end
end

---@param Item pc
---@param Vector pos
---@param string message
---@param string color
function computerStuff:write (pc, pos, message, color)
    for i = 1, string.len(message) do
        pc.data.display.frame[pos.y][pos.x + i - 1] = { color = color or "0F", character = string.sub(message, i, i)}
    end
end

---@param Item pc
---@return Player
function computerStuff:getPcUser (pc)
    if pc.parentHuman and pc.parentHuman.player then
        return pc.parentHuman.player
    else
        return nil
    end
end


return computerStuff