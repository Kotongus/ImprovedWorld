local plugin = ...;
plugin.name = "Pop Heads & Kick Ass";
plugin.author = "ViniCastilho";
plugin.description = "Pop heads from dead bodies when enough damage is caused";

local headPopDamage = 150;
local grenadeDistance = 10;

local function popHead(_human)
    _human.isAlive = false
    _human.head = 15;
    _human.hair = 15;
    _human.lastUpdatedWantedGroup = -1;
    events.createSound(19, _human.pos, 1, 2);
end


local function GrenadeExplode(_grenade)
    for _, _human in ipairs(humans.getAll()) do
        local dist = _human:getBone(15).pos:dist(_grenade.pos)
        if dist <= grenadeDistance then
            popHead(_human)
        end
    end
end
plugin:addHook("GrenadeExplode", PostGrenadeExplode)


local function HumanDamage(_human, _bone, _damage)
    if _human.head == 15 then return end
    if _bone == 3 then
        if (_human.headHP - _damage) * -1 > headPopDamage + math.random(50) then

            local override = hook.run("HeadPop", _human)
            if override then return end

            popHead(_human)
        end

    end
end
plugin:addHook("HumanDamage", HumanDamage);