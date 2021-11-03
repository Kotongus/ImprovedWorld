local missionStuff = { _version = "1" }
missionStuff.corporations = {0, 1, 2, 3, 4, 5}
missionStuff.teamBaseIndexList = {[11] = 0, [14] = 1, [17] = 2, [18] = 3, [24] = 4, [26] = 5}

local function team (name, buildingIndex, orientation, hasMissions)
    return {name = name, buildingIndex = buildingIndex, orientation = orientation, hasMissions = hasMissions, computers = {{computer, pos = pos1}, {computer, pos = pos2}}}
end

---@param integer num
---@return table
function missionStuff:getOrientation(num)
    local u = num

    if u == 1 then
        u = orientations.n
    elseif u == 2 then
        u = orientations.e
    elseif u == 3 then
        u = orientations.s
    elseif u == 4 then
        u = orientations.w
    else
        u = orientations.n
    end

    return u
end

---@param integer index
---@return Building?
function missionStuff:getBase(index)
    local counter = 0

    for _, building in ipairs(buildings.getAll()) do
        if building.type == 1 then
            if counter == index then
                return building
            else
                counter = counter + 1
            end
        end
    end
end


---@param Vector pos
---@param Vector pointA
---@param Vector pointB
---@return boolean
function missionStuff:overlapsArea(pos, pointA, pointB)
    local result = (pointB.x > pos.x and pos.x > pointA.x) and (pointB.z > pos.z and pos.z > pointA.z)

    if result then
        return true
    else return false end
end


---@param Vector pos
---@return Building?
function missionStuff:getOverlapingBase(pos)
    for _, baseIndex in ipairs(self.corporations) do
        local base = self:getBase(baseIndex)

        if base and self:overlapsArea(pos, base.interiorCuboidA, base.interiorCuboidB) then
            return base
        end
    end
end


function missionStuff:getTeamFromBase(base)
    local team = self.teamBaseIndexList[base.index]
    return team
end

---@param integer index
function missionStuff:getTeam(index)
    local team = {name, buildingIndex, orientation, hasMissions, computers = {{computer, pos}, {computer, pos}}}

    if index == 0 then
        team = team ("OXS International", (self:getBase(index) or {index = 0}).index, 2, true,      Vector(2185.5, 57.5, 1734),       Vector(2185.5, 57.5, 1730))

    elseif index == 1 then
        team = team ("Prodocon",          (self:getBase(index) or {index = 0}).index, 3, true,      Vector(1818, 41.5, 1961.5),       Vector(1822, 41.5, 1961.5))

    elseif index == 2 then
        team = team ("Nexaco",            (self:getBase(index) or {index = 0}).index, 2, true,      Vector(2409.5, 41.5, 1222),       Vector(2409.5, 41.5, 1218))

    elseif index == 3 then
        team = team ("Goldmen Inc",       (self:getBase(index) or {index = 0}).index, 4, true,      Vector(1206.4, 25.5, 1098),       Vector(1206.4, 25.5, 1102))

    elseif index == 4 then
        team = team ("Pentacom",          (self:getBase(index) or {index = 0}).index, 3, true,      Vector(1514, 25.5, 1065.5),       Vector(1518, 25.5, 1065.5))

    elseif index == 5 then
        team = team ("Monsota",           (self:getBase(index) or {index = 0}).index, 3, true,      Vector(1066, 25.5, 2089.5),       Vector(1070, 25.5, 2089.5))

    end
end



return missionStuff