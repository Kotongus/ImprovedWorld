---@type Plugin
local plugin = ...
plugin.name = 'Timer'
plugin.author = 'Koto'
plugin.description = 'Adds timers that help you with async functions.'


local timers = {}
timers.tickDelays = {}
timers.secondDelays = {}
timers.loops = {}

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


local function executeLoop (index)
    local loop = timers.loops[index]
    loop.func(loop.args)
    if queueDelete then
        table.remove(timers.loops, index)
    else
        loop.startTime = os.time()
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


function timers.loop (delay, func, args)
    local tableLength = table.getn(timers.loops)

    timers.loops[tableLength + 1] = {startTime = os.time(), delay = delay, func = func, args = args, queueDelete = false}

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


        --Loops
        for i, loop in ipairs(timers.loops) do
            if loop.startTime + loop.delay <= os.time() then
                executeLoop(i)
            end
        end
    end
)


---@param table args
local function timeElapsed (args)
    hook.run("TimeElapsed", args.time)
end

timers.loop(1, timeElapsed, {time = 1})
timers.loop(2, timeElapsed, {time = 2})
timers.loop(5, timeElapsed, {time = 5})
timers.loop(60, timeElapsed, {time = 60})
timers.loop(150, timeElapsed, {time = 150})
timers.loop(300, timeElapsed, {time = 300})