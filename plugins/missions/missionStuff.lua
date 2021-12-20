local missionStuff = { _version = "1" }
missionStuff.corporations = {0, 1, 2, 3, 4, 5}
missionStuff.teamBaseIndexList = {[11] = 0, [14] = 1, [17] = 2, [18] = 3, [24] = 4, [26] = 5}


function missionStuff.team (name, buildingIndex, orientation, hasMissions, pos1, pos2)
    return {name = name, buildingIndex = buildingIndex, orientation = orientation, hasMissions = hasMissions, computers = {{computer, pos = pos1}, {computer, pos = pos2}}}
end

---@param integer num
---@return table
function missionStuff:getOrientation(num)
    if num == 1 then
        return orientations.n
    elseif num == 2 then
        return orientations.e
    elseif num == 3 then
        return orientations.s
    elseif num == 4 then
        return orientations.w
    else
        return orientations.n
    end
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
    local team = {computers = {{computer, pos}, {computer, pos}}}

    if index == 0 then
        team = self.team ("OXS International", (self:getBase(index) or {index = 0}).index, 2, true,      Vector(2185.5, 57.5086, 1734),       Vector(2185.5, 57.5086, 1730))

    elseif index == 1 then
        team = self.team ("Prodocon",          (self:getBase(index) or {index = 0}).index, 3, true,      Vector(1818, 41.5086, 1961.5),       Vector(1822, 41.5086, 1961.5))

    elseif index == 2 then
        team = self.team ("Nexaco",            (self:getBase(index) or {index = 0}).index, 2, true,      Vector(2409.5, 41.5086, 1222),       Vector(2409.5, 41.5086, 1218))

    elseif index == 3 then
        team = self.team ("Goldmen Inc",       (self:getBase(index) or {index = 0}).index, 4, true,      Vector(1206.4, 25.5086, 1098),       Vector(1206.4, 25.5086, 1102))

    elseif index == 4 then
        team = self.team ("Pentacom",          (self:getBase(index) or {index = 0}).index, 3, true,      Vector(1514, 25.5086, 1065.5),       Vector(1518, 25.5086, 1065.5))

    elseif index == 5 then
        team = self.team ("Monsota",           (self:getBase(index) or {index = 0}).index, 3, true,      Vector(1066, 25.5086, 2089.5),       Vector(1070, 25.5086, 2089.5))

    end

    return team
end

function missionStuff:flipOrientation(orientation)
    local result = nil

    if orientation >= 3 then
        result = orientation - 2
    else
        result = orientation + 2
    end

    return result
end

function missionStuff:getPcPos(teamOrientation, pos)
    local vec = pos
    local orientation = self:flipOrientation(teamOrientation)
    

    if orientation == 1 then
        vec = vec + Vector(0, 0, 0.1)--z+
    elseif orientation == 2 then
        vec = vec + Vector(-0.1, 0, 0)--x-
    elseif orientation == 3 then
        vec = vec + Vector(0, 0, -0.1)--z-
    elseif orientation == 4 then
        vec = vec + Vector(0.1, 0, 0)--x+
    end

    return vec
end



return missionStuff