---@type Plugin
local plugin = ...
plugin.name = 'Magnum'
plugin.author = 'Koto'
plugin.description = 'Magnums for admins'

local magnum = itemTypes.getByName("Magnum")
local ammo = itemTypes.getByName(".45 Bullets")


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