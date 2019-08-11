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

local settings = {}
local waves = {}
local lines = {}

function attack_waves_remote_control(data)
	settings = data.settings
	waves = data.waves
	lines = data.lines
	local tick = game.tick
	if tick < settings.startup_message_ticks then
		game.print(settings.startup_message .. #waves)
	end
	for i = 1, #waves do
		if tick >= waves[i].trigger_tick and not waves[i].has_happened then
			spawn_biters(waves[i].biter_to_spawn, waves[i].nodes, waves[i].group_size)
			if not waves[i].message == nil then
				game.print(waves[i].message)
			end
			waves[i].has_happened = true
		end
	end
	return waves
end

--[[
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

return attack_waves_init]]