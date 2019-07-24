require "pdnc"
require "doomsday"

function start_init()
	pdnc_setup()
end

function start_load()
	pdnc_on_load()
	doomsday_on_load()
end

script.on_init(start_init)
script.on_load(start_load)
script.on_nth_tick(global.pdnc_stepsize, pdnc_core)