local tick_time = {
	second = 60,
	minute = 3600,
	hour = 216000,
}
-- structure is:
-- global.attack_wave_manager_table[set].attack_waves[n].has_happened
-- global.attack_wave_manager_table[set].attack_waves[n].group_size
-- global.attack_wave_manager_table[set].lines[n].start 
-- global.attack_wave_manager_table[set].lines[n].stop 
-- global.attack_wave_manager_table[set].settings.biter_spawn_radius

-- each attack_wave has it's own 'trigger tick' that's unique to that wave. 
-- the lines are per set, and the first line is where the biters will spawn,
-- and the last line is where they will 'end up' assuming no other issues. 
-- each line is divided into equal-size segments determined by:
-- attack_waves[n].nodes. This means that each wave can have a different 
-- number of nodes, useful to make some waves 'wide' while others 'tall'.
-- the map-size is only used when standalone to specify the lines from.
-- While the standalone module does set a custom spawn_point, this doesn't.
global.attack_wave_manager_table =
{{	
	attack_waves = {
		{
			has_happened = false,
			trigger_tick = tick_time.minute*10,
			biter_to_spawn = "small-biter",
			nodes = 40,
			group_size = 6
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*30,
			biter_to_spawn = "small-biter",
			nodes = 40,
			group_size = 6
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*50,
			biter_to_spawn = "small-biter",
			nodes = 40,
			group_size = 6
	}},
	lines ={{
			start = {x = -100, y = -100},
			stop  = {x = 100, y = 100}
		},{
			start = {x = 100, y = 100},
			stop  = {x = -100, y = -100}
		},{
			start = {x = -1, y = -1},
			stop  = {x = 1, y = 1}
	}},
	settings = {
		biter_spawn_radius = 50,
		startup_message_ticks = 1000,
		surface = 1,
	}
},{	
	attack_waves = {
		{
			has_happened = false,
			trigger_tick = tick_time.minute*15,
			biter_to_spawn = "small-biter",
			nodes = 40,
			group_size = 6
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*20,
			biter_to_spawn = "small-biter",
			nodes = 40,
			group_size = 6
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*50,
			biter_to_spawn = "small-biter",
			nodes = 40,
			group_size = 6
	}},
	lines ={{
			start = {x = 100, y = 100},
			stop  = {x = -100, y = -100}
		},{
			start = {x = -100, y = -100},
			stop  = {x = 100, y = 100}
		},{
			start = {x = -1, y = -1},
			stop  = {x = 1, y = 1}
	}},
	settings = {
		biter_spawn_radius = 50,
		startup_message_ticks = 1000,
		surface = 1,
	}
},{	
	attack_waves = {
		{
			has_happened = false,
			trigger_tick = tick_time.minute*25,
			biter_to_spawn = "small-biter",
			nodes = 40,
			group_size = 6
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*35,
			biter_to_spawn = "small-biter",
			nodes = 40,
			group_size = 6
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*50,
			biter_to_spawn = "small-biter",
			nodes = 40,
			group_size = 6
	}},
	lines =lines ={{
			start = {x = 0, y = 100},
			stop  = {x = 100, y = 100}
		},{
			start = {x = 0, y = -100},
			stop  = {x = 100, y = -100}
		},{
			start = {x = 1, y = -1},
			stop  = {x = -1, y = 1}
	}},
	settings = {
		biter_spawn_radius = 50,
		startup_message_ticks = 1000,
		surface = 1,
	}
}}

function attack_waves_manager_core()
	for i = 1, #global.attack_wave_manager_table do
		global.attack_wave_manager_table[i].attack_waves = attack_waves_remote_control(global.attack_wave_manager_table[i])
		-- this is the best way I know to get the 'has happened' boolean back
		-- to the global table while supporting arbitrary number of waves. 
	end
end

-- run attack_waves_manager_core() every few seconds. Not more needed really. 
