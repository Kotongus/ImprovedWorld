local plugin = ...;
plugin.name = "Pop Heads & Kick Ass";
plugin.author = "ViniCastilho";
plugin.description = "Pop heads from dead bodies when enough damage is caused";

local headPopDamage = 200;

--[[] ]
local function PostHumanCreate(_human)
    _human.data["headDamage"] = 0;
    print("This one can lose his/her head!");
end
plugin:addHook("PostHumanCreate", PostHumanCreate);
--]]

local function PlayerDeathTax(_player)
    _player.human.data["headDamage"] = 0;
end
plugin:addHook("PlayerDeathTax", PlayerDeathTax);

local function HumanDamage(_human, _bone, _damage)
    if not _human.data["headDamage"] or _human.head == 15 then return end
    if not _human.isAlive and _bone == 3 then
        _human.data["headDamage"] = _human.data["headDamage"] + _damage;
        if _human.data["headDamage"] > headPopDamage + math.random(50) then
            _human.head = 15;
            _human.hair = 15;
            _human.lastUpdatedWantedGroup = -1;
            _human.data["headDamage"] = nil;
            events.createSound(19, _human.pos, 1, 2);
        end

    end
end
plugin:addHook("HumanDamage", HumanDamage);