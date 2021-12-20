---@type Plugin
local plugin = ...
plugin.name = 'Magnum'
plugin.author = 'Koto'
plugin.description = 'Magnums for admins'

local magnum = itemTypes.getByName("Magnum")
local ammo = itemTypes.getByName(".45 Bullets")

plugin:addHook("EventBullet", function(type, pos, vel, item)
    --[[] ]
    print(item.class, item.index, tostring(item.data["sup"]));
    item:speak("Pew!", 2);
    (item.data["ply"]):sendMessage("Working");
    if item.data["sup"] then
        events.creatSound(71, pos, 1, 4);
        return hook.override;
    end
    --]]
    --return hook.override;
end);

plugin.commands["/supuzi"] = {
    info = "Arm yourself with a suppressed Uzi.";
    usage = "/supuzi";
    canCall = function (ply) return ply.isAdmin end;
    call = function (ply)
        if not ply.human then ply:sendMessage("Not spawned in."); end
        local uzi = items.create(itemTypes[9], ply.human.pos + Vector(0, 2, 0), orientations.n);
        uzi.data["sup"] = true;
        uzi.data["ply"] = ply;
    end
}

plugin.commands["/magnum"] = {
    info = "Arm yourself with a magnum.",
    usage = "/magnum [ammo]",

	canCall = function (ply) return ply.isAdmin end,


    call = function(ply, _, args)
        if ply.human then
            items.create(magnum, ply.human.pos + Vector(0, 2, 0), orientations.n)

            local count = args[1]
            if not count then count = 1 end

            for c = 1, count, 1 do
                items.create(ammo, ply.human.pos + Vector(0, 2, 0), orientations.n)
            end

        else ply:sendMessage("You need to spawn to get a magnum.") end
    end
}