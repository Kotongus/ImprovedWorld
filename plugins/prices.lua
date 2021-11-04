---@type Plugin
local plugin = ...
plugin.name = 'Prices'
plugin.author = 'Koto'
plugin.description = 'Adds helis to shops and modulates prices.'

plugin.defaultConfig = {
    carsInCarShop = 8
}

--Here you can change car or item prices by typing in their type's name
local prices = {}
prices["Helicopter"] = 15000


plugin:addEnableHandler(function (isReload)
    
    --Here i set the item prices
    for _, itemType in ipairs(itemTypes.getAll()) do
        if prices[itemType.name] then
            itemType.price = prices[itemType.name]
        end
    end

    --Here i set sell (not buy) prices for cars
    for _, vehicleType in ipairs(vehicleTypes.getAll()) do
        if prices[vehicleType.name] then
            vehicleType.price = prices[vehicleType.name]
        end
    end

end)


---@return Building[] carShops
local function getAllCarShops ()
    local carShops = {}
    local i = 1

    for _, c in ipairs(buildings.getAll()) do
        if (c.type == 3) then
            carShops[i] = c
            i = i + 1
        end
    end

    return carShops
end


---@param Building shop
---@return ShopCar[]
local function getAllShopCars (shop)
    local cars = {}

    for i = 0, plugin.defaultConfig.carsInCarShop - 1 do
        cars[i] = shop:getShopCar(i)
    end

    return cars
end


--Called to change prices of cars every time they appear in car shops

---@param ShopCar shopCar
local function fixShopCarPrice (shopCar)
    local carName = shopCar.type.name

    if not prices[carName] then return end
    shopCar.price = prices[carName]
end


--You won't get it...
local sameShops = {}

--Do this but in other function that does repeat when the market resets
plugin:addHook(
    "EconomyCarMarket",
    function ()
        if math.random(5) == 5 then
            local num = math.random(15)
            local heliType = vehicleTypes[12]
        
            for i, shop in ipairs(getAllCarShops()) do
                if sameShops[i] == shop or sameShops[i] == nil then
                    sameShops[i] = shop
                    local car = shop:getShopCar(num)
                    car.type = heliType
                    car.price = heliType.price
                end

            end
        end
    end
)