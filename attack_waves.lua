-- valid biter names:
-- small-biter     small-spitter
-- medium-biter    medium-spitter
-- big-biter       big-spitter
-- behemoth-biter  behemoth-spitter
-- defaults. Used when attack_waves is run standalone
local settings = {
	biter_spawn_radius = 50,
	startup_message_ticks = 1000,
	map_size = {x = 2000, y = 2000},
	surface = 1,
	spawn_point = {x = 0, y = 0},
}

local tick_time = {
	second = 60,
	minute = 3600,
	hour = 216000,
}

-- defaults. Used when attack_waves is run standalone
local lines ={{
		start = {x = 0 - map_size.x/2.1, y = 0 - map_size.y/3},
		stop  = {x = map_size.x/2.1,     y = 0 - map_size.y/3}
	},{
		start = {x = 0 - map_size.x/2.1, y = map_size.y/2.1},
		stop  = {x = map_size.x/2.1,     y = map_size.y/2.1}
	},{
		start = {x = map_size.x/40,     y = map_size.y/2.3},
		stop  = {x = 0 - map_size.x/40, y = map_size.y/2.3}
	}}

-- defaults. Used when attack_waves is run standalone
global.waves = {{
	has_happened = false,
	trigger_tick = tick_time.minute*20,
	biter_to_spawn = "small-biter",
	nodes = 40,
	group_size = 6
},	{
	has_happened = false,
	trigger_tick = tick_time.minute*30,
	biter_to_spawn = "small-spitter",
	nodes = 5,
	group_size = 50
},	{
	has_happened = false,
	trigger_tick = tick_time.minute*40,
	biter_to_spawn = "medium-spitter",
	nodes = 38,
	group_size = 9
},	{
	has_happened = false,
	trigger_tick = tick_time.minute*50,
	biter_to_spawn = "medium-biter",
	nodes = 38,
	group_size = 9
},	{
	has_happened = false,
	trigger_tick = tick_time.minute*60,
	biter_to_spawn = "big-spitter",
	nodes = 22,
	group_size = 18	
},	{
	has_happened = false,
	trigger_tick = tick_time.minute*70,
	biter_to_spawn = "big-biter",
	nodes = 18,
	group_size = 18	
},	{
	has_happened = false,
	trigger_tick = tick_time.minute*90,
	biter_to_spawn = "behemoth-spitter",
	nodes = 14,
	group_size = 30	
},	{
	has_happened = false,
	trigger_tick = tick_time.minute*91,
	biter_to_spawn = "behemoth-biter",
	nodes = 8,
	group_size = 40	
}}
function biter_poly_path(points)
	local list_of_commands = {}
	for i=1, #points do
		list_of_commands[i] = {
			type = defines.command.attack_area,
			destination = points[i],
			distraction = defines.distraction.by_anything,
			radius = 3 
		}
	end
	return list_of_commands
end

function spawn_biters_with_path(points, biter_type, group_size)
	local groups = game.surfaces[settings.surface].create_unit_group({
		position = points[1]})
	-- first x,y in points[] is used as the spawn point.
	-- maybe skip loop if no possition is found instead of re-trying group_size number of times?
	for i = 0, group_size do
		location = {x = points[1].x, y = points[1].y} -- first points are always spawn point
		local spawn_point = game.surfaces[1].find_non_colliding_position(biter_type, location, settings.biter_spawn_radius, 0.3, false)
		if not spawn_point == nil then -- incase no possition is found
			groups.add_member(game.surfaces[1].create_entity{
				name = biter_type,
				position = spawn_point
			})
		end
	end
	groups.set_command{
		type = defines.command.compound,
		structure_type = defines.compound_command.return_last,
		commands = biter_poly_path(points)
	}
end

function spawn_biters(biter_type, nodes, group_size, points)
	local map_size = settings.map_size -- maybe get from map-gen settings?
	local step_size = {}
	for i = 1, #lines do
		step_size[i] =
		{
			x = (lines[i].stop.x - lines[i].start.x)/nodes,
			y = (lines[i].stop.y - lines[i].start.y)/nodes
		}
	end
	local paths = {} 
	for i=1, nodes do
		for j = 1, #lines do
			path[j] = {
				x = (lines[j].start.x + (step_size[j].x * i)),
				y = (lines[j].start.y + (step_size[j].y * i))
			}
		end -- final list of paths used to spawn biters and give them attack coords.
		spawn_biters_with_path(paths,
		biter_type, 
		group_size)
	end
end

function attack_waves_core()
	-- game.force.player.
	game.forces["player"].set_spawn_position(settings.spawn_point, settings.surface)
	local tick = game.tick
	if tick < settings.startup_message_ticks then
		game.print("Attack waves loaded! Running " .. #global.waves .. " waves. Stand by for first wave!")
	end
	for i = 1, #global.waves do
		if tick >= global.waves[i].trigger_tick and not global.waves[i].has_happened then
			spawn_biters(global.waves[i].biter_to_spawn, global.waves[i].nodes, global.waves[i].group_size)
			global.waves[i].has_happened = true
			if (i ~= #global.waves) then 
				local time_until_next_wave = global.waves[i + 1].trigger_tick - global.waves[i].trigger_tick
				game.print("Wave number " .. i .. " has spawned! Next wave in " .. ((time_until_next_wave/60)/60) .. "min!")
			else
				game.print("The final wave has spawned!")
			end
		end
	end
end

function attack_waves_remote_control(data)
	settings = data.settings
	waves = data.waves
	lines = data.lines
	local tick = game.tick
	if tick < settings.startup_message_ticks then
		game.print("Attack waves loaded! Running " .. #waves .. " waves. Stand by for first wave!")
	end
	for i = 1, #waves do
		if tick >= waves[i].trigger_tick and not waves[i].has_happened then
			spawn_biters(waves[i].biter_to_spawn, waves[i].nodes, waves[i].group_size)
			waves[i].has_happened = true
		end
	end
	return waves
end

local attack_waves_init = {}

local script_events = {
	--place the here what you would normaly use Event.register for
	-- Event.register(defines.events.on_player_created, testfunction)
	-- is the same as 
	-- [defines.events.on_player_created] = testfunction,
	-- where testfunction is | local function testfunction() { }
	--[Event] = function, 
	--put stuff here
 
}

attack_waves_init.on_nth_ticks = {
	--place the here what you would normaly use 
    --[tick] = function,
    --put stuff here
    [240] = attack_waves_core,
}

attack_waves_init.on_init = function() -- this runs when Event.core_events.init
    log("attack_waves init")
	--put stuff here

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