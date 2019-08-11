-- for best performance, run this module *instead of* normal vanilla biters.
-- From testing, don't spawn more than 400 biters per wave, and no more
-- than 100 biters per node. Let there be at least 30s between waves to 
-- let the biters clear out from the spawn-line. Try to keep total number
-- of biters under about 1000 for performance reasons. Use bigger biters
-- if it's too easy, or bigger earlier. Remember that spitters have no
-- flat resistance, so even tier 1 ammo can kill them, eventually. 

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

-- the table contains multiple, different waves. Each elements 
-- contains the attack waves themselves, the lines to make the
-- paths from, as well as some settings. Here's how to address
-- each sub-element. Set is a full set of all settings, N is 
-- the N'th wave. They can be in any order; the trigger_tick
-- is the only value that matters for when a wave spawns. 

-- structure is:
-- global.attack_wave_manager_table[set].attack_waves[n].has_happened
-- global.attack_wave_manager_table[set].attack_waves[n].group_size
-- global.attack_wave_manager_table[set].attack_waves[n].message (optional)
-- global.attack_wave_manager_table[set].lines[n].start.x
-- global.attack_wave_manager_table[set].lines[n].stop.y
-- global.attack_wave_manager_table[set].settings.biter_spawn_radius
-- global.attack_wave_manager_table[set].settings.surface

--attack_waves = {{
	--has_happened = false, -- used to keep track of what waves have and
	                        -- haven't spawned. You don't have to keep them
	                        -- ordered
	--trigger_tick = tick_time.minute*1, -- time, in ticks, at which this
	                                     -- when this wave will be spawned
	--biter_to_spawn = "small-biter",
	--nodes = 10, -- number of groups and how many segments each line is split into. 
	--group_size = 5 -- number of biters *per node* that will spawn. 
	                 -- group_size * nodes = total number of biters spawned
--}}

--settings = {
	--biter_spawn_radius = 50, -- the radius that will be searched when trying
	                           -- to spawn in a biter. If failed, no (more)
	                           -- biters will be spawned at that node. 
	--startup_message_ticks = 1000, -- The startup message will be printed each time
	                                -- the core is called until this many ticks. 
	                                -- Very useful to verify a wave-set is loaded. 
	--startup_message = "Normal east to west attack wave loaded. Contains this many waves: ",
	--surface = 1, -- the surface this wave will be spawned on. 1 is the normal surface. 
--}

-- lines have some assumptions built in that's important to know
-- The first line is the line where the biters will be spawned. 
-- Each line will be split into nodes pre wave, and the order of
-- start and stop matters, since each group will go to it's 'segment'
-- of the line. The last line is where the biters will end up if alive
-- Suports any number of lines greater than 1. 1 line *might* work but
-- it's not supported. They might just spawn and go passive. 

--lines = {{ -- first line, where biters spawn
	--start = {x = 1000, y = 100},
	--stop  = {x = 1000, y = -100}
--},{ -- the first target
	--start = {x = -200, y = 100},
	--stop  = {x = -200, y = -100}
--},{ -- final target. Notice how the Y component is flipped, meaning the
	  -- the biters will cross paths. This is intentional to make sure the
	  -- area that's crossed over gets the most heavy biter-load.
	--start = {x = 20, y = -50},
	--stop  = {x = 20, y = 50}
--}},

local tick_time = {
	second = 60,  -- in ticks
	minute = 3600,-- in ticks
	hour = 216000,-- in ticks
}

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
