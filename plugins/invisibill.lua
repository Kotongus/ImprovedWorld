---@type Plugin
local plugin = ...
plugin.name = 'Invisi-bill'
plugin.author = 'Koto'
plugin.description = 'Invisi-bill RP but only for admins.'

--https://www.youtube.com/watch?v=s0FvxHuCUwE

plugin.commands["/invisibill"] = {
    canCall = function (ply) return ply.isAdmin end,
    ---@param Player ply
    call = function (ply, _, _)
        if not ply.human then
            ply:sendMessage("You need to get a human to become invisi-bill")
            return
        end

        local invisiCar = vehicles.create(vehicleTypes[8], ply.human.pos, orientations.n, 1)
        local invisiWeapon = items.create(itemTypes.getByName("Auto 5"), ply.human.pos, orientations.n)

        ply.human:mountItem(invisiWeapon, 0)
    end
}