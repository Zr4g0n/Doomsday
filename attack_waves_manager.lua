local tick_time = {
	second = 60,
	minute = 3600,
	hour = 216000,
}
-- structure is:
-- global.attack_wave_manager_table[set].attack_waves[n].has_happened
-- global.attack_wave_manager_table[set].attack_waves[n].group_size
-- global.attack_wave_manager_table[set].attack_waves[n].message (optional)
-- global.attack_wave_manager_table[set].lines[n].start.x
-- global.attack_wave_manager_table[set].lines[n].stop.y
-- global.attack_wave_manager_table[set].settings.biter_spawn_radius
-- global.attack_wave_manager_table[set].settings.surface

-- each attack_wave has it's own 'trigger tick' that's unique to that wave. 
-- the lines are per set, and the first line is where the biters will spawn,
-- and the last line is where they will 'end up' assuming no other issues. 
-- each line is divided into equal-size segments determined by:
-- attack_waves[n].nodes. This means that each wave can have a different 
-- number of nodes, useful to make some waves 'wide' while others 'tall'.
-- the map-size is only used when standalone to specify the lines from.
-- While the standalone module does set a custom spawn_point, this doesn't.

-- valid biter names:
-- small-biter     small-spitter
-- medium-biter    medium-spitter
-- big-biter       big-spitter
-- behemoth-biter  behemoth-spitter

global.attack_wave_manager_table =
{{	
	attack_waves = {
		{
			has_happened = false,
			trigger_tick = tick_time.minute*1,
			biter_to_spawn = "small-biter",
			nodes = 10,
			group_size = 5
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*8,
			biter_to_spawn = "small-biter",
			nodes = 7,
			group_size = 10
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*10,
			biter_to_spawn = "small-biter",
			nodes = 10,
			group_size = 10
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*11,
			biter_to_spawn = "small-biter",
			nodes = 10,
			group_size = 10
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*16,
			biter_to_spawn = "small-biter",
			nodes = 10,
			group_size = 10
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*20,
			biter_to_spawn = "small-biter",
			nodes = 10,
			group_size = 10
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*13,
			biter_to_spawn = "small-biter",
			nodes = 10,
			group_size = 10
	}},
	lines = {{
			start = {x = -1000, y = 100},
			stop  = {x = -1000, y = -100}
		},{
			start = {x = 200, y = 100},
			stop  = {x = 200, y = -100}
		},{
			start = {x = -20, y = -50},
			stop  = {x = -20, y = 50}
	}},
	settings = {
		biter_spawn_radius = 50,
		startup_message_ticks = 1000,
		startup_message = "Normal east to west attack wave loaded. Contains this many waves: ",
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
		lines = {{
			start = {x = 1000, y = 100},
			stop  = {x = 1000, y = -100}
		},{
			start = {x = -200, y = 100},
			stop  = {x = -200, y = -100}
		},{
			start = {x = 20, y = -50},
			stop  = {x = 20, y = 50}
	}},
	settings = {
		biter_spawn_radius = 50,
		startup_message_ticks = 1000,
		startup_message = "Normal west to east attack wave loaded. Contains this many waves: ",
		surface = 1,
	}
},{	
	attack_waves = {
		{ -- First wave to drain the first ammo from all players. 10 players assumed. 
			has_happened = false,
			trigger_tick = tick_time.minute*5,
			biter_to_spawn = "small-biter",
			nodes = 2,
			group_size = 65,
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*5,
			biter_to_spawn = "medium-biter",
			nodes = 2,
			group_size = 20,
			message = "Have you seen my friends?~ Hehe, ho - haha! Magic!",
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*15,
			biter_to_spawn = "behemoth-spitter",
			nodes = 2,
			group_size = 3,
			message = "Aaaaa-haha, AAAAAAAaaaahahahahahah!!!!!!!!",
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*25,
			biter_to_spawn = "behemoth-spitter",
			nodes = 2,
			group_size = 15,
			message = "You're still alive? My appologies, please, allow me to correct my misstake!",
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*35,
			biter_to_spawn = "behemoth-spitter",
			nodes = 2,
			group_size = 60,
			message = "Death will be here soon enough. Just give up now and I won't have to waste my time any longer.",
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*44.5,
			biter_to_spawn = "behemoth-biter",
			nodes = 2,
			group_size = 100,
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*45,
			biter_to_spawn = "behemoth-spitter",
			nodes = 2,
			group_size = 60,
			message = "How are you even still alive? WHY WON'T YOU DIE ALREADY!?",
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*54.5,
			biter_to_spawn = "behemoth-biter",
			nodes = 4,
			group_size = 100,
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*55,
			biter_to_spawn = "behemoth-spitter",
			nodes = 4,
			group_size = 80,
			message = "DIE!!! DIE!!! DIE!!! DIE!!! DIE!!! DIE!!! DIE!!!",
	}},
	lines = {
		{
			start = {x = -1200, y = 0},
			stop  = {x = 1200, y = 0}
		},{
			start = {x = -200, y = 0},
			stop  = {x = 200, y = 0}
		},{
			start = {x = 20, y = 0},
			stop  = {x = -20, y = 0}
	}},
	settings = {
		biter_spawn_radius = 100,
		startup_message_ticks = 1000,
		startup_message = "Double-sided attack wave loaded. How many waves will fuck you up? The answer is ",
		surface = 1,
	}
}}

function attack_waves_manager_core()
	--game.forces["player"].set_spawn_position(spawn_point, .surface)
	for i = 1, #global.attack_wave_manager_table do
		global.attack_wave_manager_table[i].attack_waves = attack_waves_remote_control(global.attack_wave_manager_table[i])
		-- this is the best way I know to get the 'has happened' boolean back
		-- to the global table while supporting arbitrary number of waves. 
	end
end

script.on_nth_tick(240, attack_waves_manager_core)
-- run attack_waves_manager_core() every few seconds. Not more needed really. 
