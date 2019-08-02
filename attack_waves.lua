--[[
	Fort Mead
	2000 x 3000
	-1000, -1500 -> 1000, 1500
	spawn 0, -1000
--]]
global.time_between_waves = 3600
global.waves = {{ -- 0
	has_happened = false,
	trigger_tick = global.time_between_waves, -- 10min
	biter_to_spawn = "small-biter",
	nodes = 63,
	group_size = 6
},	{ -- 1
	has_happened = false,
	trigger_tick = global.time_between_waves*2, -- 20min
	biter_to_spawn = "small-biter",
	nodes = 42,
	group_size = 9
},{ -- 2
	has_happened = false,
	trigger_tick = global.time_between_waves*4, -- 40min
	biter_to_spawn = "medium-biter",
	nodes = 22,
	group_size = 18	
},	{ -- 3
	has_happened = false,
	trigger_tick = global.time_between_waves*6, -- 60min
	biter_to_spawn = "big-spitter",
	nodes = 18,
	group_size = 18	
},	{ -- 4
	has_happened = false,
	trigger_tick = global.time_between_waves*8, -- 80min,
	biter_to_spawn = "big-biter",
	nodes = 14,
	group_size = 30	
},	{ -- 5
	has_happened = false,
	trigger_tick = global.time_between_waves*10, -- 100min,
	biter_to_spawn = "behemoth-biter",
	nodes = 8,
	group_size = 40	
},	{ -- 6
	has_happened = false,
	trigger_tick = global.time_between_waves*12, -- 120min,
	biter_to_spawn = "behemoth-biter",
	nodes = 3,
	group_size = 50	
}, 	{ -- 7
	has_happened = false,
	trigger_tick = global.time_between_waves*12.1, -- 121min,
	biter_to_spawn = "behemoth-biter",
	nodes = 6,
	group_size = 40	
}, 	{ -- 8
	has_happened = false,
	trigger_tick = global.time_between_waves*12.2, -- 122min,
	biter_to_spawn = "behemoth-biter",
	nodes = 9,
	group_size = 30	
}, 	{ -- 9
	has_happened = false,
	trigger_tick = global.time_between_waves*12.3, -- 123min,
	biter_to_spawn = "behemoth-biter",
	nodes = 12,
	group_size = 20	
}}

function biter_poly_path(points)
	local list_of_commands = {}
	for i=1, #points do
		list_of_commands[i] = {
			type = defines.command.attack_area,
			destination = points[i],
			distraction = defines.distraction.none,
			radius = 3 
		}
	end
	return list_of_commands
end

function spawn_biters_with_path(points, biter_type, group_size)
	local groups = game.surfaces[1].create_unit_group({
		position = points[1]})

	for i = 0, group_size do
		location = {x = points[1].x, y = points[1].y}
		groups.add_member(game.surfaces[1].create_entity{
			name = biter_type,
			position = game.surfaces[1].find_non_colliding_position(biter_type, location, 10, 0.3, false)})
	end
	groups.set_command{
		type = defines.command.compound,
		structure_type = defines.compound_command.return_last,
		commands = biter_poly_path(points)
	}
end

function spawn_biters(biter_type, nodes, group_size)
	local map_size = {x = 2000, y = 3000} -- maybe get from map-gen settings?
	local points = {
		{
			start = {x = 0 - map_size.x/2.2, y = 0 - map_size.y/3},
			stop  = {x = map_size.x/2.2,     y = 0 - map_size.y/3}
		},{
			start = {x = 0 - map_size.x/2.2, y = map_size.y/2.1},
			stop  = {x = map_size.x/2.2,     y = map_size.y/2.1}
		},{
			start = {x = map_size.x/5,     y = map_size.y/8},
			stop  = {x = 0 - map_size.x/5, y = map_size.y/8}
		}
	}
	local step_size = {
		{ 
			x = (points[1].stop.x - points[1].start.x)/nodes,
			y = (points[1].stop.y - points[1].start.y)/nodes
		},{
			x = (points[2].stop.x - points[2].start.x)/nodes,
			y = (points[2].stop.y - points[2].start.y)/nodes
		},{
			x = (points[3].stop.x - points[3].start.x)/nodes,
			y = (points[3].stop.y - points[3].start.y)/nodes
		}
	}
	for i=0, nodes do
		spawn_biters_with_path(
			{{
				x = (points[1].start.x + (step_size[1].x * i)),
				y = (points[1].start.y + (step_size[1].y * i))
			},{
				x = (points[2].start.x + (step_size[2].x * i)),
				y = (points[2].start.y + (step_size[2].y * i))
			},{
				x = (points[3].start.x + (step_size[3].x * i)),
				y = (points[3].start.y + (step_size[3].y * i))
			}},
		biter_type, 
		group_size)
	end
end

function attack_waves_core()
	-- game.force.player.
	local spawn_point = {x = 0, y = 1100}
	game.forces["player"].set_spawn_position(spawn_point, 1)
	local tick = game.tick
	if tick < 480 then
		local t = global.waves[1].trigger_tick - game.tick
		game.print("The first wave will spawn in in " .. ((t/60)/60) .. "min!")
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

script.on_nth_tick(240, attack_waves_core)