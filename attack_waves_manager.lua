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
	--!!!! nodes * group_size should be *less than* 200 for optimal performance!!!
	--distraction = defines.distraction.none, -- optional, defaults to 'anything'
	--message = "test", -- is followed by #waves -- optinal
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

--[[ -- here's the structure laid out. You can have as many sets, waves,
     -- and lines as desired.  
global.attack_wave_manager_table =
{
	{	-- first set of attack-waves
		attack_waves =
		{
			{ 	-- first wave
			
			},{	-- second wave
				
			}
		},
		lines = 
		{
			{   -- first line
				
			},{ -- second line
			
			}
		},
		settings = 
		{

		}
	},{	-- second set of attack-waves
		attack_waves =
		{
			{ 	-- first wave
			
			},{	-- second wave
				
			}
		},
		lines = 
		{
			{   -- first line
				
			},{ -- second line
			
			}
		},
		settings = 
		{

		}
	}
}
--]]
global.attack_waves_manager_final_spawn = false
require("attack_waves")
local tick_time = {
	second = 60,  -- in ticks
	minute = 3600,-- in ticks
	hour = 216000,-- in ticks
}

function attack_waves_manager_get_default_wave_settings(startup_message)
	local message = startup_message or "Default wave settings"
	local settings = {
	biter_spawn_radius = 50, -- the radius that will be searched when trying
	                         -- to spawn in a biter. If failed, no (more)
	                         -- biters will be spawned at that node. 
	startup_message_ticks = 1000, -- The startup message will be printed each time
	                              -- the core is called until this many ticks. 
	                              -- Very useful to verify a wave-set is loaded. 
	startup_message = message,
	surface = 1, -- the surface this wave will be spawned on. 1 is the normal surface. 
	}
	return settings
end 

function attack_waves_manager_error_checker(wave)
	local error_message = {}
	if wave then
		-- attack_waves
		if not type(wave.attack_waves) == "table" then
			error_message[#error_message+1] = ("attack_wave table is "
			.. type(wave.attack_waves) .. " and not a table!")
		else -- the table existis and contains *something*
			for i = 1, #wave.attack_waves do 
				-- check if the key exists, is of the right type, and within expected range

				-- has_happened
				if not type(wave.attack_waves[i].has_happened) == "boolean" then
					error_message[#error_message+1] = ("attack_waves[" .. i .. "].has_happened is "
					..type(wave.attack_waves[i].has_happened).."; has to be a boolean!")
				end

				-- trigger_tick
				if not type(wave.attack_waves[i].trigger_tick) == "number" then
					error_message[#error_message+1] = ("attack_waves[" .. i .. "].trigger_tick is "
						.. wave.attack_waves[i].trigger_tick .."; has to be a number larger than zero!")
				end
				if type(wave.attack_waves[i].trigger_tick) == "number"
					and wave.attack_waves[i].trigger_tick <= 0 then
					error_message[#error_message+1] = ("attack_waves[" .. i .. "].trigger_tick is "
						.. wave.attack_waves[i].trigger_tick .."; has to be greater than 0!")
				end

				-- biter_to_spawn
				if not type(wave.attack_waves[i].biter_to_spawn) == "string" then
					error_message[#error_message+1] = ("attack_waves[" .. i .. "].biter_to_spawn is a "
						.. type(wave.attack_waves[i].biter_to_spawn) .."; has to be a string!")
				end
				if type(wave.attack_waves[i].biter_to_spawn) == "string" 
					and not -- TODO: automatically get list of valid biters
					  (wave.attack_waves[i].biter_to_spawn == "small-biter"
					or wave.attack_waves[i].biter_to_spawn == "medium-biter"
					or wave.attack_waves[i].biter_to_spawn == "big-biter"
					or wave.attack_waves[i].biter_to_spawn == "behemoth-biter"
					or wave.attack_waves[i].biter_to_spawn == "small-spitter"
					or wave.attack_waves[i].biter_to_spawn == "medium-spitter"
					or wave.attack_waves[i].biter_to_spawn == "big-spitter"
					or wave.attack_waves[i].biter_to_spawn == "behemoth-spitter")
					then
					error_message[#error_message+1] = ("attack_waves[" .. i .. "].biter_to_spawn is "
						.. wave.attack_waves[i].biter_to_spawn .. " and that's not a known type of biter!")
				end

				-- nodes
				if not type(wave.attack_waves[i].nodes) == "number" then
					error_message[#error_message+1] = ("attack_waves[" .. i .. "].nodes is a "
						.. type(wave.attack_waves[i].nodes) .."; has to be a number!")
				end
				if type(wave.attack_waves[i].nodes) == "number" 
					and wave.attack_waves[i].nodes <= 0 then
					error_message[#error_message+1] = ("Attack_waves[" .. i .. "].nodes is "
						.. wave.attack_waves[i].nodes .."; has to be a number greater than zero!")
				end

				-- group_size
				if not type(wave.attack_waves[i].group_size) == "number" then
					error_message[#error_message+1] = ("attack_waves[" .. i .. "].group_size is a "
					.. type(wave.attack_waves[i].group_size).."; has to be a number")
				end
				if type(wave.attack_waves[i].group_size) == "number" 
					and wave.attack_waves[i].group_size <= 0 then
					error_message[#error_message+1] = ("attack_waves[" .. i .. "].group_size is "
					.. type(wave.attack_waves[i].group_size).."; has to be a number")
				end

				-- distraction
				if not type(wave.attack_waves[i].distraction) == "number"
					and (wave.attack_waves[i].distraction >=  0 and wave.attack_waves[i].distraction <= 4) then
					error_message[#error_message+1] = ("attack_waves[" .. i .. "].distraction is a "
						.. type(wave.attack_waves[i].distraction) .. " incorrect; This is an optional key")
				end

				-- message
				if not type(wave.attack_waves[i].message) == "string" then
					error_message[#error_message+1] = ("attack_waves[" .. i .. "].message was a "
						.. type(wave.attack_waves[i].message) .." and not a string. This is an optional key")
				end
			end -- end of loop
		end

		-- lines
		if not type(wave.lines) == "table" then
			error_message[#error_message+1] = ("lines table is "
			.. type(wave.lines) .. " and not a table!")
		else -- the table existis and contains *something*
			-- check if the key exists, is of the right type, and within expected range
			if #wave.lines < 2 then
				error_message[#error_message+1] = ("number of lines is less than 2; this won't work correctly.")
			end
			for i = 1, #wave.lines do
				-- start x and y
				if type(wave.lines[i].start) == "table" then
					if not type(wave.lines[i].start.x) == "number" then
						error_message[#error_message+1] = ("wave.lines["..i.."].start.x is "
						.. type(wave.lines[i].start.x) .." and not a number!")
					end
					if not type(wave.lines[i].start.y) == "number" then
						error_message[#error_message+1] = ("wave.lines["..i.."].start.y is "
						.. type(wave.lines[i].start.y) .." and not a number!")
					end
				else
					error_message[#error_message+1] = ("wave.lines["..i.."].start is a "
						.. type(wave.lines[i].start) .." and not a table!")
				end

				-- stop x and y
				if type(wave.lines[i].stop) == "table" then
					if not type(wave.lines[i].stop.x) == "number" then
						error_message[#error_message+1] = ("wave.lines["..i.."].stop.x is "
						.. type(wave.lines[i].stop.x) .." and not a number!")
					end
					if not type(wave.lines[i].stop.y) == "number" then
						error_message[#error_message+1] = ("wave.lines["..i.."].stop.y is "
						.. type(wave.lines[i].stop.y) .." and not a number!")
					end
				else
					error_message[#error_message+1] = ("wave.lines["..i.."].stop is a "
						.. type(wave.lines[i].stop) .." and not a table!")
				end
			end -- end of loop
		end

		-- settomgs
		if not type(wave.settings) == "table" then
			error_message[#error_message+1] = ("settings table is "
			.. type(wave.settings) .. " and not a table!")
		else -- the table existis and contains *something*
			-- check if the key exists, is of the right type, and within expected range

			-- biter_spawn_radius
			if not type(wave.settings.biter_spawn_radius) == "number" then
				error_message[#error_message+1] = ("wave.settings.biter_spawn_radius is "
				.. type(wave.settings.biter_spawn_radius) .." and not a number!")
			end
			if wave.settings.biter_spawn_radius < 1 then
				error_message[#error_message+1] = ("wave.settings.biter_spawn_radius is "
				.. wave.settings.biter_spawn_radius  .."; has to be a number greater than zero!")
			end

			-- startup_message_ticks
			if not type(wave.settings.startup_message_ticks) == "number" then
				error_message[#error_message+1] = ("wave.settings.startup_message_ticks is "
				.. type(wave.settings.startup_message_ticks) .." and not a number!")
			end
			if wave.settings.startup_message_ticks < 1 then
				error_message[#error_message+1] = ("wave.settings.startup_message_ticks is "
				.. wave.settings.startup_message_ticks  .."; has to be a number greater than zero!")
			end

			-- startup_message
			if not type(wave.settings.startup_message) == "string" then
				error_message[#error_message+1] = ("wave.settings.startup_message is "
				.. type(wave.settings.startup_message) .." and not a string! This is optional")
			end
			
			-- surface
			if not type(wave.settings.surface) == "number" then
				error_message[#error_message+1] = ("wave.settings.surface is "
				.. type(wave.settings.surface) .." and not a number! ")
			end
		end

		if #error_message > 0 then
			for i = 1, #error_message do
				log(error_message[i])
			end
		else
			error_message[1] = " contains no errors"
		end
		return error_message
	else
		error_message = "You checked if nil contains errors? Really? It's empty! There's nothing to check!"
		log(error_message)
		return error_message
	end
end

function attack_wave_manager_print_errors()
	game.print("test1")
	local error_message = {}
	for i=1, #global.attack_wave_manager_table do
		error_message = attack_waves_manager_error_checker(global.attack_wave_manager_table[i])
		for j=1, #error_message do
			game.print("global.attack_wave_manager_table["..i.."]." .. error_message[j])
		end 
	end 
end

global.attack_wave_manager_table =
{{	
	attack_waves = {
		{
			has_happened = false,
			trigger_tick = tick_time.minute*1,
			biter_to_spawn = "small-biter",
			nodes = 10,
			group_size = 10--5
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*8,
			biter_to_spawn = "small-biter",
			nodes = 7,
			group_size = 13--10
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*10,
			biter_to_spawn = "small-biter",
			nodes = 11,
			group_size = 9--10
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*11,
			biter_to_spawn = "small-biter",
			nodes = 12,
			group_size = 12--10
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*16,
			--biter_to_spawn = "small-biter",
			nodes = 5,
			group_size = 20--10
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*20,
			biter_to_spawn = "small-biter",
			nodes = 10,
			group_size = 10--10
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*33,
			biter_to_spawn = "small-biter",
			nodes = 11,
			group_size = 9--10
	}},
	lines = {{
			start = {x =-200, y = 100}, -- x = -1000
			stop  = {x =-200, y =-100} -- x = -1000
		},{
			start = {x =-100, y = 100},
			stop  = {x =-100, y =-100}
		},{
			start = {x =   0, y = 100},
			stop  = {x =   0, y =-100}
		},{
			start = {x = 20, y = -20},
			stop  = {x = 20, y =  20}
	}},
	settings = attack_waves_manager_get_default_wave_settings("Normal east to west attack wave loaded. Contains this many waves: ")
},{	
	attack_waves = {
		{
			has_happened = false,
			trigger_tick = tick_time.minute*2,
			biter_to_spawn = "small-biter",
			nodes = 10,--40,
			group_size = 10--6
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*4,
			biter_to_spawn = "small-biter",
			nodes = 10,--40,
			group_size = 10--6
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*6,
			biter_to_spawn = "small-biter",
			nodes = 10,--40,
			group_size = 10--6
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*8,
			biter_to_spawn = "small-biter",
			nodes = 10,--40,
			group_size = 10--6
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*10,
			biter_to_spawn = "small-biter",
			nodes = 10,--40,
			group_size = 10--6
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*12,
			biter_to_spawn = "small-biter",
			nodes = 10,--40,
			group_size = 10--6
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*14,
			biter_to_spawn = "small-biter",
			nodes = 10,--40,
			group_size = 10--6
	}},
		lines = {{
			start = {x = 200, y = 100}, -- x = 1000
			stop  = {x = 200, y =-100} -- x = 1000
		},{
			start = {x = 100, y = 100},
			stop  = {x = 100, y =-100}
		},{
			start = {x =   0, y = 100},
			stop  = {x =   0, y =-100}
		},{
			start = {x =-100, y = 100},
			stop  = {x =-100, y =-100}
		},{
			start = {x =  20, y = -50},
			stop  = {x =  20, y =  50}
	}},
	settings = attack_waves_manager_get_default_wave_settings("Normal west to east attack wave loaded. Contains this many waves: ")
	
},{
	-- brutal set of waves designed to push players to the brink of death every time.
	-- these use the lack of flat resistance on the behemoth spitter to freak the 
	-- player out hard by spawning them very eary
	attack_waves = {
		{ -- First wave to drain the first ammo from all players. 10 players assumed. 
			has_happened = false,
			trigger_tick = tick_time.minute*5,
			biter_to_spawn = "small-biter",
			nodes = 2,
			group_size = 65,
			distraction = defines.distraction.none,
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*5,
			biter_to_spawn = "medium-biter",
			nodes = 2,
			group_size = 20,
			distraction = defines.distraction.none,
			message = "Have you seen my friends?~ Hehe, ho - haha! Magic!",
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*15,
			biter_to_spawn = "small-biter",
			nodes = 13,
			group_size = 20,
			distraction = defines.distraction.none,
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*15.5,
			biter_to_spawn = "behemoth-spitter",
			nodes = 13,
			group_size = 1,
			distraction = defines.distraction.none,
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*16,
			biter_to_spawn = "small-biter",
			nodes = 13,
			group_size = 20,
			distraction = defines.distraction.none,
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*25,
			biter_to_spawn = "behemoth-spitter",
			nodes = 3,
			group_size = 15,
			distraction = defines.distraction.none,
			message = "You're still alive? My appologies, please, allow me to correct my misstake!",

		},{
			has_happened = false,
			trigger_tick = tick_time.minute*35,
			biter_to_spawn = "behemoth-spitter",
			nodes = 2,
			group_size = 60,
			message = "Death will be here soon enough. Just give up now and I won't have to waste my time any longer.",
			distraction = defines.distraction.none,
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*44.5,
			biter_to_spawn = "behemoth-biter",
			nodes = 2,
			group_size = 100,
			distraction = defines.distraction.none,
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*45,
			biter_to_spawn = "behemoth-spitter",
			nodes = 2,
			group_size = 60,
			distraction = defines.distraction.none,
			message = "How are you even still alive? WHY WON'T YOU DIE ALREADY!?",
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*54.5,
			biter_to_spawn = "behemoth-biter",
			nodes = 10,
			group_size = 20,
			distraction = defines.distraction.none,
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*55,
			biter_to_spawn = "behemoth-biter",
			nodes = 10,
			group_size = 20,
			distraction = defines.distraction.none,
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*55.5,
			biter_to_spawn = "behemoth-spitter",
			nodes = 10,
			group_size = 20,
			distraction = defines.distraction.none,
			message = "DIE!!! DIE!!! DIE!!! DIE!!! DIE!!! DIE!!! DIE!!!",
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*56,
			biter_to_spawn = "behemoth-biter",
			nodes = 10,
			group_size = 20,
			distraction = defines.distraction.none,
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*56.5,
			biter_to_spawn = "behemoth-spitter",
			nodes = 10,
			group_size = 20,
			distraction = defines.distraction.none,
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*57,
			biter_to_spawn = "behemoth-biter",
			nodes = 10,
			group_size = 20,
			distraction = defines.distraction.none,
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*57.5,
			biter_to_spawn = "behemoth-spitter",
			nodes = 10,
			group_size = 20,
			distraction = defines.distraction.none,
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*58,
			biter_to_spawn = "behemoth-biter",
			nodes = 10,
			group_size = 20,
			distraction = defines.distraction.none,
	}},
	lines = {
		-- a simple tight march. Designed to avoid biters using 
		-- neighbouring paths. It's supposed to be one wide wave
		-- of biters, not two globs
		{
			start = {x = -100, y = -300}, 
			stop  = {x =  100, y = -300}
		},{
			start = {x = -100, y = -250},
			stop  = {x =  100, y = -250} 
		},{
			start = {x = -100, y = -200},
			stop  = {x =  100, y = -200} 
		},{
			start = {x = -100, y = -150},
			stop  = {x =  100, y = -150} 
		},{
			start = {x = -100, y = -100},
			stop  = {x =  100, y = -100} 
		},{
			start = {x = -100, y =  -50},
			stop  = {x =  100, y =  -50} 
		},{
			start = {x = -100, y =    0},
			stop  = {x =  100, y =    0} 
		},{
			start = {x = -100, y =   50},
			stop  = {x =  100, y =   50} 
		},{
			start = {x =   20, y =    0},
			stop  = {x =  -20, y =    0}
	}},
	settings = attack_waves_manager_get_default_wave_settings(
		"Double-sided attack wave loaded. How many waves will fuck you up? The answer is ")
}}
function attack_waves_manager_get_enemy(n)
	if math.random() > 0.5 then return attack_waves_manager_get_biter(n)end
	return attack_waves_manager_get_spitter(n)
end

function attack_waves_manager_get_biter(n)
	local biters={"small-biter","medium-biter","big-biter","behemoth-biter"}
	--game.print(n)
	n = n + math.random()*0.5
	if n < 1 then n = 1 end
	if n > 4 then n = 4 end
	return biters[math.floor(n + 0.5)]
end
function attack_waves_manager_get_spitter(n)
	local spitters={"small-spitter","medium-spitter","big-spitter","behemoth-spitter"}
	n = n + math.random()*0.5
	if n < 1 then n = 1 end
	if n > 4 then n = 4 end
	return spitters[math.floor(n + 0.5)]
end



function attack_waves_manager_setup()
	local target_wave_size = 300
	local offset_start_time = tick_time.minute*6
	local time_between_waves = 1 * tick_time.minute * (math.random()+0.5)
	local number_of_waves = (tick_time.hour*1.5) / time_between_waves
	local new_set = {settings={}, lines={},attack_waves={}}
	new_set.settings={
		biter_spawn_radius = 20,
		startup_message_ticks = 1000,
		startup_message = "Automatically generated wave. South to north. Waves generated: ", --#waves
		surface = 1,
	}
	new_set.lines={ -- from south marching north towards spawn
		{
			start = {x = -100, y = 300}, 
			stop  = {x =  100, y = 300}
		},{
			start = {x = -100, y = 250},
			stop  = {x =  100, y = 250} 
		},{
			start = {x = -100, y = 200},
			stop  = {x =  100, y = 200} 
		},{
			start = {x = -100, y = 150},
			stop  = {x =  100, y = 150} 
		},{
			start = {x = -100, y = 100},
			stop  = {x =  100, y = 100} 
		},{
			start = {x = -100, y =  50},
			stop  = {x =  100, y =  50} 
		},{
			start = {x = -100, y =   0},
			stop  = {x =  100, y =   0} 
		},{
			start = {x = -100, y =  -50},
			stop  = {x =  100, y =  -50} 
		},{
			start = {x =   20, y =   0},
			stop  = {x =  -20, y =   0}
	}}
	local random_holder = 0
	for i=1, number_of_waves do
		random_holder = math.random(2,20)
		new_set.attack_waves[i] = {
			has_happened = false,
			trigger_tick = offset_start_time + time_between_waves*i,
			biter_to_spawn = attack_waves_manager_get_enemy(i/(number_of_waves/6)),
			nodes = random_holder,
			group_size = target_wave_size/random_holder,
			distraction = defines.distraction.none,
		}
	end
	new_set_mirror = deepcopy(new_set)
	for i=1, number_of_waves do
		random_holder = math.random(2,20)
		new_set_mirror.attack_waves[i].biter_to_spawn = attack_waves_manager_get_enemy(i/(number_of_waves/6))
		new_set_mirror.attack_waves[i].nodes = random_holder
		new_set_mirror.attack_waves[i].group_size = target_wave_size/random_holder
	end
	for i=1, #new_set_mirror.lines do
		new_set_mirror.lines[i].start.y = -1 * new_set_mirror.lines[i].start.y
		new_set_mirror.lines[i].stop.y = -1 * new_set_mirror.lines[i].stop.y
	end
	new_set_mirror.settings.startup_message = "Automatically generated wave. North to south. Waves generated: " --#waves

	--global.attack_wave_manager_table[4] = new_set
	--global.attack_wave_manager_table[5] = new_set_mirror
	global.attack_wave_manager_table[#global.attack_wave_manager_table+1] = new_set --4
	global.attack_wave_manager_table[#global.attack_wave_manager_table+1] = new_set_mirror --5
	global.attack_wave_manager_table[#global.attack_wave_manager_table+1] = deepcopy(global.attack_wave_manager_table[3])--6
	global.attack_wave_manager_table[#global.attack_wave_manager_table+1] = deepcopy(global.attack_wave_manager_table[3])--7
	global.attack_wave_manager_table[#global.attack_wave_manager_table+1] = deepcopy(global.attack_wave_manager_table[3])--8
	
	local new_lines ={ -- from south marching north towards spawn
		{
			start = {x = -100, y = 300}, 
			stop  = {x =  100, y = 300}
		},{
			start = {x = -20, y = 120}, 
			stop  = {x =  20, y = 120}
		},{
			start = {x =   20, y =   0},
			stop  = {x =  -20, y =   0}
	}}
	global.attack_wave_manager_table[6].lines=new_lines
	local new_lines2 ={ -- from south marching north towards spawn
		{
			start = {x = 300, y =-100}, 
			stop  = {x = 300, y = 100}
		},{
			start = {x = 120, y =-100}, 
			stop  = {x = 120, y = 100}
		},{
			start = {x =   0, y =  20},
			stop  = {x =   0, y = -20}
	}}
	global.attack_wave_manager_table[7].lines=new_lines
	local new_lines3 ={ -- from south marching north towards spawn
		{
			start = {x = -300, y =-100}, 
			stop  = {x = -300, y = 100}
		},{
			start = {x = -120, y =-100}, 
			stop  = {x = -120, y = 100}
		},{
			start = {x =   0, y =  20},
			stop  = {x =   0, y = -20}
	}}
	global.attack_wave_manager_table[8].lines=new_lines
	for i = 1, #global.attack_wave_manager_table[6].attack_waves do
	--for i = 1, 17 do
		global.attack_wave_manager_table[6].attack_waves[i].message = nil
		--global.attack_wave_manager_table[7].attack_waves[i].message = nil
		--global.attack_wave_manager_table[8].attack_waves[i].message = nil
	end
	for i = 1, #global.attack_wave_manager_table[7].attack_waves do
		global.attack_wave_manager_table[7].attack_waves[i].message = nil
	end
	for i = 1, #global.attack_wave_manager_table[8].attack_waves do
		global.attack_wave_manager_table[8].attack_waves[i].message = nil
	end

	global.attack_wave_manager_table[#global.attack_wave_manager_table+1]={
	attack_waves = {
		{
			has_happened = false,
			trigger_tick = tick_time.minute*2,
			biter_to_spawn = attack_waves_manager_get_enemy(1),
			nodes = 3,
			group_size = 30
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*2.25,
			biter_to_spawn = attack_waves_manager_get_enemy(1),
			nodes = 3,
			group_size = 30
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*2.5,
			biter_to_spawn = attack_waves_manager_get_enemy(1),
			nodes = 3,
			group_size = 30
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*11,
			biter_to_spawn = attack_waves_manager_get_enemy(2),
			nodes = 3,
			group_size = 50
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*21,
			biter_to_spawn = attack_waves_manager_get_enemy(5*math.random()),
			nodes = 3,
			group_size = 50
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*21.33,
			biter_to_spawn = attack_waves_manager_get_enemy(5*math.random()),
			nodes = 3,
			group_size = 50
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*21.66,
			biter_to_spawn = attack_waves_manager_get_enemy(5*math.random()),
			nodes = 3,
			group_size = 50
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*31.25,
			biter_to_spawn = attack_waves_manager_get_enemy(4),
			nodes = 3,
			group_size = 50
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*41,
			biter_to_spawn = attack_waves_manager_get_enemy(4),
			nodes = 3,
			group_size = 50
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*41.25,
			biter_to_spawn = attack_waves_manager_get_enemy(4),
			nodes = 3,
			group_size = 50
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*41.5,
			biter_to_spawn = attack_waves_manager_get_enemy(4),
			nodes = 3,
			group_size = 50
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*51.0,
			biter_to_spawn = attack_waves_manager_get_enemy(4),
			nodes = 3,
			group_size = 50
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*51.25,
			biter_to_spawn = attack_waves_manager_get_enemy(4),
			nodes = 3,
			group_size = 50
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*51.5,
			biter_to_spawn = attack_waves_manager_get_enemy(4),
			nodes = 3,
			group_size = 50
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*51.75,
			biter_to_spawn = attack_waves_manager_get_enemy(4),
			nodes = 3,
			group_size = 50
		},{
			has_happened = false,
			trigger_tick = tick_time.minute*52.0,
			biter_to_spawn = attack_waves_manager_get_enemy(4),
			nodes = 3,
			group_size = 50
	}},
	lines = {{
			start = {x = 220, y = 220}, -- x = -1000
			stop  = {x = 180, y = 180} -- x = -1000
		},{
			start = {x = 125, y = 125},
			stop  = {x = 115, y = 115}
		},{
			start = {x =   0, y =   0},
			stop  = {x =   0, y =   0}
		}},
	settings = attack_waves_manager_get_default_wave_settings("South-east to north-west attack wave loaded. Contains this many waves: ")
	}

	for i=1, #global.attack_wave_manager_table do
		attack_waves_manager_error_checker(global.attack_wave_manager_table[i])
	end -- this will log any and all errors to the console
end

function attack_waves_manager_core()
	--todo; seperate lines from waves, allow random selection of lines for each wave
	--      unless a wave specifies what set of lines to use
	--game.forces["player"].set_spawn_position(spawn_point, .surface)
	for i = 1, #global.attack_wave_manager_table do
		global.attack_wave_manager_table[i].attack_waves = attack_waves_remote_control(global.attack_wave_manager_table[i])
		-- this is the best way I know to get the 'has happened' boolean back
		-- to the global table while supporting arbitrary number of waves. 
	end
	if game.tick < 300 then
		game.forces["player"].chart(1, {{x = -500, y = -500}, {x = 500, y = 500}})
	end
	local counter = 0
	for i = 1, #global.attack_wave_manager_table do
		for j = 1, #global.attack_wave_manager_table[i].attack_waves do
			if not global.attack_wave_manager_table[i].attack_waves[j].has_happened then counter = counter + 1 end
		end
	end
	if counter == 0 then
		global.attack_waves_manager_final_spawn = true
	end
	if  global.attack_waves_manager_final_spawn
	and game.forces["enemy"].get_entity_count("small-biter") == 0 
	and game.forces["enemy"].get_entity_count("medium-biter") == 0
	and game.forces["enemy"].get_entity_count("big-biter") == 0
	and game.forces["enemy"].get_entity_count("behemoth-biter") == 0
	and game.forces["enemy"].get_entity_count("small-spitter") == 0 
	and game.forces["enemy"].get_entity_count("medium-spitter") == 0
	and game.forces["enemy"].get_entity_count("big-spitter") == 0
	and game.forces["enemy"].get_entity_count("behemoth-spitter") == 0 
	then
		game.print("You've won!!!")
	end
end

-- stolen from http://lua-users.org/wiki/CopyTable
function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

-- The following stuff is to make it easier to run multiple different 
-- copies of the same event. Thanks HORNWITSER

--script.on_nth_tick(240, attack_waves_manager_core)
local attack_waves_init = {}
local script_events = {}

attack_waves_init.on_nth_ticks = {
    [240] = attack_waves_manager_core,
    [15] = function() game.forces["player"].chart_all() end,
}

attack_waves_init.on_init = function() -- this runs when Event.core_events.init
    log("attack_waves_manager init")
	attack_waves_manager_setup() -- generates n->s and s->n waves
    global.attack_waves_data = global.attack_waves_data or script_data  -- NO TOUCHY
end

attack_waves_init.on_load = function() -- this runs when Event.core_events.load
    log("attack_waves load")
	--put stuff here
    script_data = global.attack_waves_data or script_data  -- NO TOUCHY
end

attack_waves_init.get_events = function()
    return script_events
end

return attack_waves_init