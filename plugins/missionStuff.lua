local missionStuff = { _version = "1" }
missionStuff.corporations = {0, 1, 2, 3, 4, 5}
missionStuff.teamBaseIndexList = {[11] = 0, [14] = 1, [17] = 2, [18] = 3, [24] = 4, [26] = 5}


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


return missionStuff