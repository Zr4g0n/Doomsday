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

require("attack_waves")
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
			biter_to_spawn = "small-biter",
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
	settings = {
		biter_spawn_radius = 10,
		startup_message_ticks = 1000,
		startup_message = "Normal east to west attack wave loaded. Contains this many waves: ",
		surface = 1,
	}
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
	settings = {
		biter_spawn_radius = 50,
		startup_message_ticks = 1000,
		startup_message = "Normal west to east attack wave loaded. Contains this many waves: ",
		surface = 1,
	}
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
	settings = {
		biter_spawn_radius = 100,
		startup_message_ticks = 1000,
		startup_message = "Double-sided attack wave loaded. How many waves will fuck you up? The answer is ", --#waves
		surface = 1,
	}
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
	local offset_start_time = tick_time.minute*20
	local time_between_waves = 2 * tick_time.minute * (math.random()+0.5)
	local number_of_waves = tick_time.hour / time_between_waves
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
			biter_to_spawn = attack_waves_manager_get_enemy(i/(number_of_waves/4)),
			nodes = random_holder,
			group_size = 200/random_holder,
			distraction = defines.distraction.none,
		}
	end
	new_set_mirror = deepcopy(new_set)
	for i=1, number_of_waves do
		random_holder = math.random(2,20)
		new_set_mirror.attack_waves[i].biter_to_spawn = attack_waves_manager_get_enemy(i/(number_of_waves/4))
		new_set_mirror.attack_waves[i].nodes = random_holder
		new_set_mirror.attack_waves[i].group_size = 200/random_holder
	end
	for i=1, #new_set_mirror.lines do
		new_set_mirror.lines[i].start.y = -1 * new_set_mirror.lines[i].start.y
		new_set_mirror.lines[i].stop.y = -1 * new_set_mirror.lines[i].stop.y
	end
	new_set_mirror.settings.startup_message = "Automatically generated wave. North to south. Waves generated: " --#waves

	--global.attack_wave_manager_table[4] = new_set
	--global.attack_wave_manager_table[5] = new_set_mirror
	global.attack_wave_manager_table[#global.attack_wave_manager_table+1] = new_set
	global.attack_wave_manager_table[#global.attack_wave_manager_table+1] = new_set_mirror
end

function attack_waves_manager_core()
	--game.forces["player"].set_spawn_position(spawn_point, .surface)
	for i = 1, #global.attack_wave_manager_table do
		global.attack_wave_manager_table[i].attack_waves = attack_waves_remote_control(global.attack_wave_manager_table[i])
		-- this is the best way I know to get the 'has happened' boolean back
		-- to the global table while supporting arbitrary number of waves. 
	end
	local value = 1+math.random()*4
	if game.tick < 300 then
		game.forces["player"].chart(1, {{x = -500, y = -500}, {x = 500, y = 500}})
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