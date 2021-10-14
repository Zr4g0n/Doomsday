-- Doomsday controller
--[[
Control PDNC from here
Feed Attack-waves from here
Select type of scenario from here
Some way to spawn in some pre-determined resources 
--]]

local PDNC = require("PDNC")
PDNC.pdnc_core(doomsday_controller_dnc_boxy)

function doomsday_controller_dnc_boxy(x)
	local x = x * 6.28318530717958647692 -- that's Tau, aka 2xPi
	return (((math.sin(x) + (0.111 * math.sin(3 * x))) * 1.124859392575928)+1)/2
end


local doomsday_controller_init = {}
local script_events = {
--	--place the here what you would normaly use Event.register for
	-- Event.register(defines.events.on_player_created, testfunction)
	-- is the same as 
	-- [defines.events.on_player_created] = testfunction,
	-- where testfunction is | local function testfunction() { }
	--[Event] = function, 
	--put stuff here
 
}

doomsday_controller_init.on_nth_ticks = {
	--place the here what you would normaly use 
    --[tick] = function,
    --put stuff here

}

doomsday_controller_init.on_init = function() -- this runs when Event.core_events.init
    --log("EXAMPLE init")
	--put stuff here

    global.doomsday_controller_data = global.doomsday_controller_data or script_data  -- NO TOUCHY

end

doomsday_controller_init.on_load = function() -- this runs when Event.core_events.load
    --log("EXAMPLE load")
	--put stuff here

    script_data = global.doomsday_controller_data or script_data  -- NO TOUCHY
end

doomsday_controller_init.get_events = function()
	--
    return script_events
end

return EXAMPLE_init