---@type Plugin
local plugin = ...
plugin.name = 'Timer'
plugin.author = 'Koto'
plugin.description = 'Adds timers that help you with async functions.'

local timers = { _version = "1" }
timers.tickDelays = {}
timers.secondDelays = {}
timers.secondLoops = {}

---@param integer index
---@param boolean isTickDelay
local function executeDelay (index, isTickDelay)
    if isTickDelay then
        local tickDelay = timers.tickDelays[index]

        tickDelay.func(tickDelay.args)
        table.remove(timers.tickDelays, index)
    else
        local secondDelay = timers.secondDelays[index]

        secondDelay.func(secondDelay.args)
        table.remove(timers.secondDelays, index)
    end

end


---@param integer delay
function timers.tickDelay (delay, func, args)
    local tableLength = table.getn(timers.tickDelays)
    
    timers.tickDelays[tableLength + 1] = {delay = delay, func = func, args = args}
end


---@param integer delay
function timers.secondDelay (delay, func, args)
    local tableLength = table.getn(timers.secondDelays)
    
    timers.secondDelays[tableLength + 1] = {startTime = os.time(), delay = delay, func = func, args = args}
end



plugin:addHook(
    "Physics",
    function ()
        --Tick delay
        for i, tickDelay in ipairs(timers.tickDelays) do
            tickDelay.delay = tickDelay.delay - 1
            if tickDelay.delay <= 0 then
                executeDelay(i, true)
            end
        end

        --Second delay
        for i, secondDelay in ipairs(timers.secondDelays) do
            if secondDelay.startTime + secondDelay.delay <= os.time() then
                executeDelay(i, false)
            end
        end
    end
)


return timers