---@type Plugin
local plugin = ...
plugin.name = 'Fixed Uzi'
plugin.author = 'pvbcl'
plugin.description = 'Fixes uzi.'

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
end)
