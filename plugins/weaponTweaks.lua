---@type Plugin
local plugin = ...
plugin.name = 'Weapon Tweaks'
plugin.author = 'pvbcl & Koto'
plugin.description = 'Tweaks weapons.'

plugin.defaultConfig = {
    uziItemTypeName = "Uzi"
}

plugin:addEnableHandler(function (isReload)
    local itemType = itemTypes.getByName(plugin.defaultConfig.uziItemTypeName or "Uzi")
    local magazineItemType = itemTypes.getByName(plugin.defaultConfig.uziItemTypeName .. " Magazine" or "Uzi Magazine")
    itemType.price = 150
    itemType.bulletVelocity = 6.6666665077209 -- Equals to default 9mm bullet velocity
    itemType.fireRate = 7
    magazineItemType.price = 15
    magazineItemType.magazineAmmo = 25


    local pistolMag = itemTypes.getByName("9mm Magazine")
    pistolMag.magazineAmmo = 15

    
    --Koto's fingergun fix
    local invisiGun = itemTypes.getByName("Auto 5")
    invisiGun.bulletVelocity = 8 -- Equals to default 9mm bullet velocity
    invisiGun.fireRate = 3
    invisiGun.bulletSpread = 0
    invisiGun.secondaryGripStiffness = 999


    local magnum = itemTypes.getByName("Magnum")

    magnum.bulletVelocity = 0.47
    magnum.bulletSpread = 0


end)


plugin.commands["/fingergun"] = {
    canCall = function (ply) return ply.isAdmin end,
    ---@param Player ply
    ---@param string[] args
    call = function (ply, _, args)
        local invisiGun = itemTypes.getByName("Auto 5")
        invisiGun.bulletVelocity = tonumber(args[1])
        invisiGun.fireRate = tonumber(args[2])
        invisiGun.bulletSpread = tonumber(args[3])
    end
}