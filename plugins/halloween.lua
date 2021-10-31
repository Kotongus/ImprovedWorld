local plugin = ...;
plugin.name = "halloween.lua";
plugin.author = "ViniCastilho";
plugin.description = "Spawns zombies around World mode that drop money when killed.";

local function Spawn(vector, location)
    return { vector = vector; location = location; };
end

local o = {orientations.n, orientations.s, orientations.e, orientations.w};
local function O() return o[math.random(1,4)]; end

local next = 0;

local spawn_positions = {
    Spawn(Vector(1807.75, 75, 1536.5), "Central Park");
    Spawn(Vector(1621, 70, 1471.5), "Burger Lower Parking Lot");
    Spawn(Vector(1956.5, 66, 1700), "South Bank Upper Parking Lot");
    Spawn(Vector(2032, 58, 1835.5), "7th & Flinn Top Parking Lot");
    Spawn(Vector(1184.5, 42, 1470), "Megacorp Tower Parking Lot");
    Spawn(Vector(1887.5, 50, 1245.5), "North Bank Upper Parking Lot");
    Spawn(Vector(1279.25, 46, 1629.5), "West Bank Parking Lot");
    Spawn(Vector(2327.5, 46, 1581.5), "East Cosmetics Shop Parking Lot");
    Spawn(Vector(1649.5, 70, 1598.25), "West Cosmetics Shop Parking Lot");
    Spawn(Vector(1650, 70, 1375.5), "4th & David NW Platform");
    Spawn(Vector(1360, 26, 1220), "2nd & Carmack Lower Parking Lot");
    Spawn(Vector(2012.75, 50, 1219.25), "2nd & 3rd Shortcut");
    Spawn(Vector(2019.25, 34, 1087.75), "1st & 2nd Shortcut");
};

local tracker = {}
for i = 1, #spawn_positions do tracker[i] = 0; end

local function Zombies(c)
    local spawn_index = math.random(#spawn_positions);
    local amount = math.random(3,5);
    if tracker[spawn_index] < 0 then tracker[spawn_index] = 0; end
    tracker[spawn_index] = tracker[spawn_index] + amount;
    --chat.tellAdmins(spawn_positions[spawn_index].location .. ' ' .. tracker[spawn_index]);

    for i = 1, amount do
        local player_bot = players.createBot();
        player_bot.isZombie = true;
        player_bot.data["z"] = true;
        player_bot.data["tracker"] = spawn_index;
        
        local pos = spawn_positions[spawn_index].vector + Vector(-2+math.random()*4, 0, -2+math.random()*4);
        local zombie = humans.create(pos, O(), player_bot);
        zombie.isBleeding = true;
        zombie.bloodLevel = 90;
        zombie.skinColor = -1;
        zombie.hairColor = 6;
        --| Headless zombies disabled
        --if math.random() < 1 then zombie.head = 15; zombie.hair = 15; end
        zombie.lastUpdatedWantedGroup = -1;
    end
    chat.announce("> Zombies spawned near " .. tostring(spawn_positions[spawn_index].location) .. "!");
    if not c then
        chat.announce("Shoot them before they bleed out to get money!");
        chat.announce("Keep track of where they are with /trackz");
    end
end

plugin.commands["/zs"] = {
    info = "Spawns zombies on a random locataion.";
    usage = "/zspawn";
    canCall = function(ply) return ply.isAdmin; end;
    call = function(_, _, args)
        local times = 1;
        if args[1] then
            times = tostring(args[1]);
        end
        --chat.tellAdmins(type(args[1]) .. ' ' .. tostring(args[1]));
        for i = 1, times do
            Zombies(true);
        end
    end;
};

plugin.commands["/trackz"] = {
    info = "Returns known zombie sightings";
    usage = "/trackzombies";
    call = function(player)
        events.createMessage(6, "Known zombie sightings:", player.index, 1);
        for k, v in ipairs(tracker) do
            if v > 0 then
                events.createMessage(6, "* " .. spawn_positions[k].location, player.index, 1);
            else tracker[k] = 0 end
        end
    end;
}

plugin:addHook("PlayerDeathTax", function(player)
    --chat.tellAdmins("Zombie killed!");
    if player.data["z"] then
        local t = player.data["tracker"];
        --chat.tellAdmins(spawn_positions[t].location .. ' ' .. tracker[t]);
        tracker[t] = tracker[t] - 1;
        if tracker[t] < 0 then tracker[t] = 0; end
        if player.data["playerHit"] then
            events.createSound(25,player.human.pos, 1, 2);
            local item = items.create(itemTypes[18], player.human.pos+Vector(0,1,0), orientations.n);
            item.cashPureValue = 5;
        end
    end
end);

plugin:addHook("HumanDamage", function(victim, bone, damage)
    if not victim.player then return end
    if victim.player.data["z"] then
        --| Headless zombies disabled
        --if bone == 3 and victim.head == 15 then victim.headHP = 100; victim.health = 70; victim.bloodLevel = 85; end 
        victim.player.data["playerHit"] = true;
    end
end);

plugin:addHook("EconomyCarMarket", function()
    --chat.tellAdmins("Attempting to generate zombies!");
    local times = 0
    while true do
        local chance = math.random();
        --chat.tellAdmins(chance .. ' ... ' .. next);
        if chance - next < (0.75^(times+1)) then times = times+1; next = 0; else next = 0.2; break; end
    end
    if times == 0 then return end
    for i = 1, times-1 do
        Zombies(true);
    end
    Zombies();
end);