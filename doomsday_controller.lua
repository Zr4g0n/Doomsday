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
