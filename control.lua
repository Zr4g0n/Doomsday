local modules = {
    require("silo-script"),
    require("pdnc"),
    require("doomsday"),
    require("gui"),
}

script.on_init(function()
    for i,mod in ipairs(modules) do
        if mod.on_init then
            mod.on_init()
        end
    end
end)

script.on_load(function()
    for i,mod in ipairs(modules) do
        if mod.on_load then
            mod.on_load()
        end
    end
end)

script.on_configuration_changed(function(data)
    for i,mod in ipairs(modules) do
        if mod.on_configuration_changed then
            mod.on_configuration_changed(data)
        end
    end
end)

local function register_tick_handlers()
    local ticks = {}
    for i,mod in ipairs(modules) do
    	print("-------------------------------")
        print(mod.on_nth_ticks)
        print("-------------------------------")
        if mod.on_nth_ticks then
            mod_ticks = mod.on_nth_ticks
            for t,f in pairs(mod_ticks) do
                if not ticks[t] then
                    ticks[t] = {}
                end
                
                table.insert(ticks[t], f)
            end
        end
    end
    
    for t,fs in pairs(ticks) do
        script.on_nth_tick(t, function(event_data)
            for i,f in ipairs(fs) do
                f(event_data)
            end
        end)
    end
end
register_tick_handlers()

local function register_events()
    local events = {}
    for i,mod in ipairs(modules) do
        if mod.get_events then
            mod_events = mod.get_events()
            for e,f in pairs(mod_events) do
                if not events[e] then
                    events[e] = {}
                end
                
                table.insert(events[e], f)
            end
        end
    end

    for e,fs in pairs(events) do
        script.on_event(e, function(event_data)
            for i,f in ipairs(fs) do
                f(event_data)
            end
        end)
    end
end
register_events()

for i,mod in ipairs(modules) do
    if mod.add_remote_interfaces then
        mod.add_remote_interfaces()
    end
end

for i,mod in ipairs(modules) do
    if mod.add_commands then
        mod.add_commands()
    end
end



--[[
This is a example of what to put at the end of your code, ie doomsday.lua
replaze EXAMPLE with any name you want
replace tick with number if ticks and function with the function name to call




local EXAMPLE_init = {}

EXAMPLE_init.on_nth_ticks = {
    [tick] = function,
}

EXAMPLE_init.on_init = function() 
    log("EXAMPLE init")

    global.EXAMPLE_data = global.poseidon_data or script_data  -- NO TOUCHY

end

EXAMPLE_init.on_load = function()
    game.print("EXAMPLE load")

    script_data = global.EXAMPLE_data or script_data  -- NO TOUCHY
end

local script_events = {
	[Event] = function,
}

EXAMPLE_init.get_events = function()
    return script_events
end

return EXAMPLE_init
]]