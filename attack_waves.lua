global.attack_waves_debug = false
function biter_poly_path(points, waves)
	local distraction = waves.distraction or defines.distraction.by_anything
	if global.attack_waves_debug and not waves.distraction then
		game.print("No distraction set, using default by_anything. trigger_tick: " .. waves.trigger_tick)
	end
	-- defaults setting
	local list_of_commands = {}
	for i=1, #points do
		list_of_commands[i] = {
			type = defines.command.attack_area,
			destination = points[i],
			distraction = distraction,
			radius = 5, 
		}
	end
	return list_of_commands
end

function spawn_biters_with_path(points, waves, settings)
	local groups = game.surfaces[settings.surface].create_unit_group({
		position = points[1]})
	-- first x,y in points[] is used as the spawn point.
	-- maybe skip loop if no possition is found instead of re-trying group_size number of times?
	for i = 0, waves.group_size do
		location = {x = points[1].x, y = points[1].y} -- first points are always spawn point
		local spawn_point = game.surfaces[settings.surface].find_non_colliding_position(waves.biter_to_spawn, location, settings.biter_spawn_radius, 0.3, false)
		if spawn_point == nil then 
			if global.attack_waves_debug then
				game.print("settings.biter_spawn_radius " .. settings.biter_spawn_radius)
				game.print("waves.biter_to_spawn " .. waves.biter_to_spawn)
				game.print("spawn_point.x " .. spawn_point.x)
				game.print("spawn_point.y " .. spawn_point.y)
				game.print("[gps="..location.x..","..location.y.."]")
			end-- incase no possition is found
		else
			groups.add_member(game.surfaces[settings.surface].create_entity{
				name = waves.biter_to_spawn,
				position = spawn_point,
			})
			if global.attack_waves_debug then
				game.print("Spawned " .. waves.biter_to_spawn .. " at x: " .. spawn_point.x .. ", y: " .. spawn_point.y .. " successfully!")
			end
		end
	end
	groups.set_command{
		type = defines.command.compound,
		structure_type = defines.compound_command.return_last,
		commands = biter_poly_path(points, waves),
	}
end

function spawn_biters(settings, waves, lines)

	-- local map_size = settings.map_size -- maybe get from map-gen settings?
	local step_size = {}
	for i = 1, #lines do
		step_size[i] =
		{
			x = (lines[i].stop.x - lines[i].start.x)/waves.nodes,
			y = (lines[i].stop.y - lines[i].start.y)/waves.nodes,
		}
	end
	local paths = {} 
	for i=1, waves.nodes do
		for j = 1, #lines do
			paths[j] = {
				x = (lines[j].start.x + (step_size[j].x * i)),
				y = (lines[j].start.y + (step_size[j].y * i)),
			}
		end -- final list of paths used to spawn biters and give them attack coords.
		spawn_biters_with_path(paths,
		waves, 
		settings)
	end
end

function attack_waves_remote_control(data)
	local offset = 3600*10
	local tick = game.tick - offset
	if (tick < data.settings.startup_message_ticks) and not (data.settings.startup_message == nil) then
		game.print(data.settings.startup_message .. #data.attack_waves)
	end
	for i = 1, #data.attack_waves do
		if tick >= data.attack_waves[i].trigger_tick and not data.attack_waves[i].has_happened then
			spawn_biters(data.settings, data.attack_waves[i], data.lines)
			if not (data.attack_waves[i].message == nil) then
				game.print(data.attack_waves[i].message)
			end
			data.attack_waves[i].has_happened = true
		end
	end
	return data.attack_waves
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