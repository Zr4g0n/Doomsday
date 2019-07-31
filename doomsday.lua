-- doomsday module. Requires the programmable day-night cycle (pdnc) module to work. 
-- made by Zr4g0n
-- this module currently has issues with the event module and 'on nth tick'. 
require("pdnc") --is this the best way to do this?
global.doomsday_enabled = true
global.doomsday = global.doomsday or {} -- used to check if this exists. 
global.doomsday_start = 2.75 -- in ingame days. Use n.75 to make sure doomsday is at midnight. 
global.doomsday_pollution = 20 -- amount to be applied per tick
global.doomsday_surface = 1
global.doomsday_enable_players_online_compensator = false
global.doomsday_current_fuzzy_playercount = 1.5 -- start assuming 1.5 players! :V
global.doomsday_use_early_death = false
global.doomsday_early_death_has_happened = false
global.doomsday_use_different_spawn = false
global.doomsday_different_spawn = {x = -2000, y = -500}
global.doomsday_has_happened = false 

function doomsday_status()
	stats = {
		"Time Left: " .. doomsday_time_left(),
		"global.doomsday_start: " .. global.doomsday_start,
		"global.doomsday_pollution: " .. global.doomsday_pollution,
		"global.doomsday_surface: " .. global.doomsday_surface,
		"global.doomsday_enabled: " .. pdnc_bool_to_string(global.doomsday_enabled),
		"global.doomsday_enable_players_online_compensator: " .. pdnc_bool_to_string(global.doomsday_enable_players_online_compensator),
		"global.doomsday_current_fuzzy_playercount: " .. global.doomsday_current_fuzzy_playercount,
		"global.doomsday_use_early_death: " .. pdnc_bool_to_string(global.doomsday_use_early_death),
		"global.doomsday_early_death_has_happened: " .. pdnc_bool_to_string(global.doomsday_early_death_has_happened),
		"global.doomsday_use_different_spawn: " .. pdnc_bool_to_string(global.doomsday_use_different_spawn),
		"global.doomsday_different_spawn: x = " .. global.doomsday_different_spawn.x .. ", y = " .. global.doomsday_different_spawn.y,
		"doomsday_has_happened: " .. pdnc_bool_to_string(global.doomsday_has_happened),
	}
	return stats
end

function doomsday_console_status()
		--logs to console, used for debuging
		log("Time Left: " .. doomsday_time_left())
		log("global.doomsday_start: " .. global.doomsday_start)
		log("global.doomsday_pollution: " .. global.doomsday_pollution)
		log("global.doomsday_surface: " .. global.doomsday_surface)
		log("global.doomsday_enabled: " .. pdnc_bool_to_string(global.doomsday_enabled))
		log("global.doomsday_enable_players_online_compensator: " .. pdnc_bool_to_string(global.doomsday_enable_players_online_compensator))
		log("global.doomsday_current_fuzzy_playercount: " .. global.doomsday_current_fuzzy_playercount)
		log("global.doomsday_use_early_death: " .. pdnc_bool_to_string(global.doomsday_use_early_death))
		log("global.doomsday_early_death_has_happened: " .. pdnc_bool_to_string(global.doomsday_early_death_has_happened))
		log("global.doomsday_use_different_spawn: " .. pdnc_bool_to_string(global.doomsday_use_different_spawn))
		log("global.doomsday_different_spawn: x = " .. global.doomsday_different_spawn.x .. ", y = " .. global.doomsday_different_spawn.y)
		log("doomsday_has_happened: " .. pdnc_bool_to_string(global.doomsday_has_happened))
	return stats
end

function doomsday_toggle()
	global.doomsday_enabled = not global.doomsday_enabled
	doomsday_status()
end

function doomsday_setup()
	if global.doomsday_use_different_spawn then
		doomsday_activate_different_spawn()
	end
end

function doomsday_activate_different_spawn()
	game.forces["player"].set_spawn_position(global.doomsday_different_spawn, game.surfaces[global.doomsday_surface])
end

function doomsday_core()
	local current_time = game.tick / game.surfaces[global.doomsday_surface].ticks_per_day
	local x = current_time * 6.2831853 --2pi
	local returnvalue = 0
	if(global.doomsday_enable_players_online_compensator)then
		doomsday_players_online_compensator()
	end
	if global.doomsday_use_early_death
		and (current_time > 1) 
		and not global.doomsday_early_death_has_happened then
		local radius = 128
		local pollution = 2500
		local nodes = 5
		doomsday_pollute_ring(radius, pollution, nodes)
	end
	local x = current_time * 6.2831853 --2pi
	local returnvalue = 0
	if (current_time >= global.doomsday_start) 
		and not global.doomsday_has_happened then
		local position = {x = 0, y = 0}
		local radius = 256
		local nodes = 8
		local groupsize = 20
		local biter_to_spawn = "behemoth-biter"
		local line_start_point = {x = 100, y = 150}
		local line_end_point = {x = 200, y = -80}
		if global.doomsday_use_different_spawn then
			position = global.doomsday_different_spawn
		end
		--doomsday_biter_attack_circle(position, radius, nodes, groupsize, biter_to_spawn)
		--doomsday_pollution_zero_hour()
		doomsday_biter_attack_line(line_start_point, line_end_point, nodes, groupsize)

		--doomsday_biter_attack_a_b()
		global.doomsday_has_happened = true
		log("Doomsday activated at tick: " .. game.tick)
	end
end

function doomsday_dnc(x)
	local current_time = game.tick / game.surfaces[global.doomsday_surface].ticks_per_day
	x = x * 6.28318530717958647692 --tau
	local returnvalue = 0
	local time_since_doomsday = global.doomsday_start + 1 - current_time
	if global.time_since_doomsday == 0 then time_since_doomsday = 0.00000000000000001
	if (current_time < global.doomsday_start) then
		returnvalue = pdnc_scaler(math.pow(pdnc_c_boxy(x), (1 + current_time / 4)))
	elseif (current_time < global.doomsday_start + 1) then
		returnvalue = pdnc_scaler(math.pow(time_since_doomsday, 7))
	else
		returnvalue = pdnc_scaler(math.pow(pdnc_c_boxy(x), 6.125)*0.5)
	end
	if returnvalue < 0.0 then returnvalue = 0.0 end
	if returnvalue > 1.0 then returnvalue = 1.0 end
	if returnvalue ~= returnvalue then returnvalue = 0.5 end
	if returnvalue == math.huge then returnvalue = 1.0 end
	if returnvalue == -math.huge then returnvalue = 0.0 end
	return returnvalue
end

function doomsday_pollution_zero_hour(current_time)
	local radius = 128 --make global
	local pollution = global.doomsday_pollution -- total pollution applied per tick
	local nodes = 5 -- the number of nodes to spread
	doomsday_pollute_ring(radius*0.66,pollution,nodes*0.66)
	doomsday_pollute_ring(radius*1.00,pollution,nodes*1.00)
	doomsday_pollute_ring(radius*1.50,pollution,nodes*1.50)
end


function doomsday_normal_curve(x)
	return (1+ ((math.sin(x) + (0.111 * math.sin(3 * x))) * 1.124859392575928))/2
	-- magic numbers to make it scale to (-1, 1)
end

function doomsday_pollute_ring(radius,pollution,nodes) -- spawn a ring of pollution based on radius, amount of pollution and number of points in the ring. 
	local p = global.pdnc_stepsize * pollution -- needed to make it 'step size independant'
	p = p / nodes
	local position = {x = 0.0, y = 0.0}
	if global.doomsday_use_different_spawn then
		position = global.doomsday_different_spawn
	end
	--game.surfaces[global.doomsday_surface].pollute(position, p) --circle + center point
	local step = (math.pi * 2) / (nodes - 1)
	for i=0, (nodes - 1) do 
		position = {x = math.sin(step*i)*radius, y = math.cos(step*i)*radius}        
		game.surfaces[global.doomsday_surface].pollute(position, p)
	end
end

function doomsday_time_left()
	if (global.doomsday_start > 0)then
		local ticks_until_doomsday = game.surfaces[global.doomsday_surface].ticks_per_day * global.doomsday_start
		local ticks = ticks_until_doomsday - game.tick
		if (ticks >= 0) then 
			local seconds = math.floor(ticks/ 60)
			local minutes = math.floor(seconds / 60)
			local hours = math.floor(minutes / 60)
			local days = math.floor(hours / 24)
			return(string.format("-" .. "%d:%02d:%02d:%02d", hours, minutes % 60, seconds % 60, ticks % 60))
		else
			ticks = ticks * -1 
			local seconds = math.floor(ticks / 60)
			local minutes = math.floor(seconds / 60)
			local hours = math.floor(minutes / 60)
			local days = math.floor(hours / 24)
			return(string.format("%d:%02d:%02d:%02d", hours, minutes % 60, seconds % 60, ticks % 60) .. " ago...")
		end
	else
		return("Nothing to see here, move along! No doomsday here, nope!")
	end
end

function doomsday_time_left_with_ticks()
	local tick = (((game.surfaces[global.doomsday_surface].ticks_per_day * global.doomsday_start) - game.tick)%60)
	return doomsday_time_left() .. ":" .. string.format("%02d", tick)
end

function doomsday_players_online_compensator()
	local target = #game.connected_players
	local current = global.doomsday_current_fuzzy_playercount
	local step_size = 0.02 -- (at 21 ticks per iteration, that's 17.5sec per player change.
	
	if(current < 0)then
		game.print("Error; 'current' number of players' is less than 0!")
	end
	if(target < 0)then
		game.print("Error; 'number of players' is less than 0!")
	end
	
	if(current == target) then
		-- do nothing, this should be most of the time
	elseif ( current < target) then
		current = current + step_size
	elseif ( current > target) then
		current = current - step_size
	else 
		-- do nothing?
	end
	local modifier = 20/(0.1 * current * current + 6) -- Nice, smooth curve that should hopefully give boost equal to the playercount!
	game.forces.player.character_running_speed_modifier = modifier
	global.doomsday_current_fuzzy_playercount = current
end

function doomsday_biter_attack_circle(position, radius, nodes, groupsize, biter_to_spawn)
    local step = ((math.pi * 2) / nodes)
    for i=0, nodes do
    	local spawn_position = {x = 0, y = 0}
		spawn_position.x = math.sin(step*i)*radius + position.x
		spawn_position.y = math.cos(step*i)*radius + position.y
		local surface = game.surfaces[global.doomsday_surface]
        local groups = surface.create_unit_group({position = spawn_position})
        for j=0, groupsize do
        	local non_colliding_position = surface.find_non_colliding_position(biter_to_spawn, spawn_position, 15, 0.8, false)
        	if non_colliding_position ~= nil then
				groups.add_member(surface.create_entity{
				name = biter_to_spawn, 
				position = non_colliding_position})
			end
        end
        groups.set_command{
			type = defines.command.attack_area,
			destination = position,
			distraction = defines.distraction.none,
			radius = 10 }
    end
end

function doomsday_biter_attack_line(line_start_point, line_end_point, nodes, groupsize)
	for i=0, nodes do
		local spawn_position = {x = ((line_start_point.x - line_end_point.x)/nodes)*i, y = ((line_start_point.y - line_end_point.y)/nodes)*i}
		local groups = game.surfaces[1].create_unit_group({position = spawn_position})
		for j=0, groupsize do
			groups.add_member(game.surfaces[1].create_entity{
				name = "big-biter", 
				position = game.surfaces[1].find_non_colliding_position("big-biter", spawn_position, 5, 0.3, false)})
		end
		groups.set_command{
			type = defines.command.attack_area,
			destination = position,
			distraction = defines.distraction.none,
			radius = 10 }
	end
end

-- spawns biters at a, to attack b without distractions
function doomsday_biter_attack_a_b(spawn_biter_position, attack_position, groupsize, biter_to_spawn)
	local groups = game.surfaces[1].create_unit_group({position = spawn_biter_position})
	for j=0, groupsize do
		groups.add_member(game.surfaces[1].create_entity{
			name = biter_to_spawn, 
			position = game.surfaces[1].find_non_colliding_position(biter_to_spawn, spawn_position, 5, 0.3, false)})
	end
	groups.set_command{
		type = defines.command.attack_area,
		destination = attack_position,
		distraction = defines.distraction.none,
		radius = 10 }
	end
end

--[[
function reduce_brightness(n)
	global.pdnc_max_brightness = 1 - ((global.pdnc_current_time / global.pdnc_doomsday_start)*n)
	if(global.pdnc_max_brightness < n) then
		global.pdnc_max_brightness = n
	end
end 
]]



-- This is a example of what to put at the end of your code, ie doomsday.lua
-- replaze EXAMPLE with any name you want
-- replace tick with number if ticks and function with the function name to call
-- everywhere there is a blank space is where you put stuff in

local doomsday_init = {}

local script_events = {
	--place the here what you would normaly use Event.register for
	-- Event.register(defines.events.on_player_created, testfunction)
	-- is the same as 
	-- [defines.events.on_player_created] = testfunction,
	-- where testfunction is | local functuin testfunction() { }
	--[Event] = function, 
	--put stuff here

}

doomsday_init.on_nth_ticks = {
	--place the here what you would normaly use 
	--[tick] = function,
	--put stuff here
	--[60] = doomsday_console_status, -- prints status to console ever second
	
}

doomsday_init.on_init = function() -- this runs when Event.core_events.init
	log("doomsday init")
	--put stuff here
	doomsday_setup()
	global.doomsday_data = global.doomsday_data or script_data  -- NO TOUCHY
end

doomsday_init.on_load = function() -- this runs when Event.core_events.load
	log("doomsday load")
	--put stuff here
	script_data = global.doomsday_data or script_data  -- NO TOUCHY
end

doomsday_init.get_events = function()
	return script_events
end

return doomsday_init

--Event.register(-global.pdnc_stepsize, doomsday_pdnc_program) --intentionally using the PDNC stepsize so the functions sync this can be skipped, since it's called from pdnc!
--Event.register(Event.core_events.init, doomsday_setup)
