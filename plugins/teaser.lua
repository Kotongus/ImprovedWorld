---@type Plugin
local plugin = ...
plugin.name = 'Teasers'
plugin.author = 'Koto'
plugin.description = "Replaces magnums with teasers."

local teaserReload = 10
local teaseTime = 8

---@param Human human
---@param boolean isTeased
local function tease (human, isTeased)
    if not human.isAlive then return end
    if isTeased then
        human.damage = 60
        return
    end

    human.damage = 60

    local a = math.random() / 100
    local b = math.random() / 100
    local aMultiplier = math.random(2) == 2
    local bMultiplier = math.random(2) == 2

    if aMultiplier then
        aMultiplier = -1
    else aMultiplier = 1 end

    if bMultiplier then
        bMultiplier = -1
    else bMultiplier = 1 end

    human:addVelocity(Vector(a * aMultiplier, 0.06 * aMultiplier, b * bMultiplier))
    human.data.teased = teaseTime
end

plugin:addHook(
    "TimeElapsed",
    ---@param integer time
    function (time)
        if time == 1 then
            for _, human in ipairs(humans.getAll()) do
                if human.data.teased then
                    human.data.teased = human.data.teased - 1

                    if human.data.teased <= 0 then
                        human.data.teased = nil
                    end
                end
            end


            for _, item in ipairs(items.getAll()) do
                if item.type.name == "Magnum" then
                    if item.data.reloadTime then
                        if item.data.reloadTime <= 0 then
                            item.bullets = 1
                            item.data.reloadTime = teaserReload
                        elseif item.data.reloadTime > 0 then
                            item.data.reloadTime = item.data.reloadTime - 1
                        end


                    else
                        item.data.reloadTime = teaserReload
                    end
                end
            end 
        end
    end
)


plugin:addHook(
    "HumanLimbInverseKinematics",
    ---@param Human human
    function (human)
        if human.data.teased then
            return hook.override
        end
    end
)


plugin:addHook(
    "PostHumanDamage",
    function (human, bone, damage)
        if damage == 0 then
            if human.data.teased then
                tease(human, true)
            else
                tease(human)
            end            
        end
    end
)