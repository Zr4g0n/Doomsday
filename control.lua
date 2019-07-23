require "pdnc"
require "doomsday"

function start_init()
	pdnc_setup()
	--game.surfaces[global.pdnc_surface].ticks_per_day = pdnc_min_to_ticks(10.0)
end

function start_load()
	pdnc_on_load()
	doomsday_on_load()
end

script.on_init(start_init)
script.on_load(start_load)
script.on_nth_tick(global.pdnc_stepsize, pdnc_core)