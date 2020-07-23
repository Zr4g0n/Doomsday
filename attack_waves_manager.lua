global.attack_waves_manager_final_spawn = false
require("attack_waves")
require("attack_waves_data")
local tick_time = {
	second = 60,  -- in ticks
	minute = 3600,-- in ticks
	hour = 216000,-- in ticks
}

function isValidEnemyUnit(s)
	return game.entity_prototypes[s] and game.entity_prototypes[s].type == "unit" 
end

function attack_waves_manager_get_default_wave_settings(startup_message)
	return {
	biter_spawn_radius = 50, -- the radius that will be searched when trying
	                         -- to spawn in a biter. If failed, no (more)
	                         -- biters will be spawned at that node. 
	startup_message_ticks = 1000, -- The startup message will be printed each time
	                              -- the core is called until this many ticks. 
	                              -- Very useful to verify a wave-set is loaded. 
	startup_message = startup_message or "Default wave settings",
	surface = 1, -- the surface this wave will be spawned on. 1 is the normal surface. 
	}
end

-- looks through the entire set, checking that all the data is as expected. 
-- if include_optinal is 
function attack_waves_manager_error_checker(wave, include_optinal)
	-- https://lua-api.factorio.com/latest/defines.html#defines.distraction
	local distraction_min = 0 
	local distraction_max = 4

	local error_message = {}
	if wave then
		-- attack_waves
		if not (type(wave.attack_waves) == "table") then
			error_message[#error_message+1] = ("attack_wave table is "
			.. type(wave.attack_waves) .. " and not a table!")
		else -- the table existis and contains *something*
			for i = 1, #wave.attack_waves do 
				-- check if the key exists, is of the right type, and within expected range

				-- has_happened
				if not (type(wave.attack_waves[i].has_happened) == "boolean") then
					error_message[#error_message+1] = ("attack_waves[" .. i .. "].has_happened is "
					..type(wave.attack_waves[i].has_happened).."; has to be a boolean!")
				end

				-- trigger_tick
				if not (type(wave.attack_waves[i].trigger_tick) == "number") then
					error_message[#error_message+1] = ("attack_waves[" .. i .. "].trigger_tick is "
						.. wave.attack_waves[i].trigger_tick .."; has to be a number larger than zero!")
				end
				if (type(wave.attack_waves[i].trigger_tick) == "number")
					and wave.attack_waves[i].trigger_tick <= 0 then
					error_message[#error_message+1] = ("attack_waves[" .. i .. "].trigger_tick is "
						.. wave.attack_waves[i].trigger_tick .."; has to be greater than 0!")
				end

				-- biter_to_spawn
				if not (type(wave.attack_waves[i].biter_to_spawn) == "string") then
					error_message[#error_message+1] = ("attack_waves[" .. i .. "].biter_to_spawn is a "
						.. type(wave.attack_waves[i].biter_to_spawn) .."; has to be a string!")
				end
				if (type(wave.attack_waves[i].biter_to_spawn) == "string") 
				and not isValidEnemyUnit(wave.attack_waves[i].biter_to_spawn) then
					error_message[#error_message+1] = ("attack_waves[" .. i .. "].biter_to_spawn is "
						.. wave.attack_waves[i].biter_to_spawn .. " and that's not a known type of biter!")
				end

				-- nodes
				if not (type(wave.attack_waves[i].nodes) == "number") then
					error_message[#error_message+1] = ("attack_waves[" .. i .. "].nodes is a "
						.. type(wave.attack_waves[i].nodes) .."; has to be a number!")
				end
				if (type(wave.attack_waves[i].nodes) == "number") 
				and wave.attack_waves[i].nodes <= 0 then
					error_message[#error_message+1] = ("attack_waves[" .. i .. "].nodes is "
						.. wave.attack_waves[i].nodes .."; has to be a number greater than zero!")
				end

				-- group_size
				if not (type(wave.attack_waves[i].group_size) == "number") then
					error_message[#error_message+1] = ("attack_waves[" .. i .. "].group_size is a "
					.. type(wave.attack_waves[i].group_size).."; has to be a number")
				end
				if (type(wave.attack_waves[i].group_size) == "number") 
				and wave.attack_waves[i].group_size <= 0 then
					error_message[#error_message+1] = ("attack_waves[" .. i .. "].group_size is "
					.. wave.attack_waves[i].group_size.."; has to be a number above 0!")
				end

				-- distraction
				if not (type(wave.attack_waves[i].distraction) == "number") then
					if (include_optinal) and not (type(wave.attack_waves[i].distraction) == "nil") then
						error_message[#error_message+1] = ("attack_waves[" .. i .. "].distraction is a "
						.. type(wave.attack_waves[i].distraction) .. " and not a number between 0 and 4; this is an optional key")
					end
				end
				if (type(wave.attack_waves[i].distraction) == "number")
				and (wave.attack_waves[i].distraction < distraction_min and wave.attack_waves[i].distraction > distraction_max) then
					error_message[#error_message+1] = ("attack_waves[" .. i .. "].distraction is "
						.. wave.attack_waves[i].distraction .. " and not between 0 and 4; this is an optional key")
				end

				-- message
				if not (type(wave.attack_waves[i].message) == "string") then
					if (include_optinal) and not (type(wave.attack_waves[i].message) == "nil") then
						error_message[#error_message+1] = ("attack_waves[" .. i .. "].message was a "
						.. type(wave.attack_waves[i].message) .." and not a string. This is an optional key")
					end
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
				error_message[#error_message+1] = ("number of lines is less than 2; 2 or more is required for the logic to work")
			end
			for i = 1, #wave.lines do
				-- start x and y
				if (type(wave.lines[i].start) == "table") then
					if not (type(wave.lines[i].start.x) == "number") then
						error_message[#error_message+1] = ("wave.lines["..i.."].start.x is "
						.. type(wave.lines[i].start.x) .." and not a number!")
					end
					if not (type(wave.lines[i].start.y) == "number") then
						error_message[#error_message+1] = ("wave.lines["..i.."].start.y is "
						.. type(wave.lines[i].start.y) .." and not a number!")
					end
				else
					error_message[#error_message+1] = ("wave.lines["..i.."].start is a "
						.. type(wave.lines[i].start) .." and not a table!")
				end

				-- stop x and y
				if (type(wave.lines[i].stop) == "table") then
					if not (type(wave.lines[i].stop.x) == "number") then
						error_message[#error_message+1] = ("wave.lines["..i.."].stop.x is "
						.. type(wave.lines[i].stop.x) .." and not a number!")
					end
					if not (type(wave.lines[i].stop.y) == "number") then
						error_message[#error_message+1] = ("wave.lines["..i.."].stop.y is "
						.. type(wave.lines[i].stop.y) .." and not a number!")
					end
				else
					error_message[#error_message+1] = ("wave.lines["..i.."].stop is a "
						.. type(wave.lines[i].stop) .." and not a table!")
				end
			end -- end of loop
		end

		-- settings
		if not (type(wave.settings) == "table") then
			error_message[#error_message+1] = ("settings table is "
			.. type(wave.settings) .. " and not a table!")
		else -- the table existis and contains *something*
			-- check if the key exists, is of the right type, and within expected range

			-- biter_spawn_radius
			if not (type(wave.settings.biter_spawn_radius) == "number") then
				error_message[#error_message+1] = ("wave.settings.biter_spawn_radius is "
				.. type(wave.settings.biter_spawn_radius) .." and not a number!")
			end
			if wave.settings.biter_spawn_radius < 1 then
				error_message[#error_message+1] = ("wave.settings.biter_spawn_radius is "
				.. wave.settings.biter_spawn_radius  .."; has to be a number greater than zero!")
			end

			-- startup_message_ticks
			if not (type(wave.settings.startup_message_ticks) == "number") then
				error_message[#error_message+1] = ("wave.settings.startup_message_ticks is "
				.. type(wave.settings.startup_message_ticks) .." and not a number!")
			end
			if wave.settings.startup_message_ticks < 1 then
				error_message[#error_message+1] = ("wave.settings.startup_message_ticks is "
				.. wave.settings.startup_message_ticks  .."; has to be a number greater than zero!")
			end

			-- startup_message
			if not (type(wave.settings.startup_message) == "string") then
				if include_optinal and not (type(wave.settings.startup_message) == "nil") then
					error_message[#error_message+1] = ("wave.settings.startup_message is "
					.. type(wave.settings.startup_message) .." and not a string! This is optional")
				end
			end
			
			-- surface
			if not (type(wave.settings.surface) == "number") then
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
	else
		error_message = "You checked if nil contains errors? Really? It's empty! There's nothing to check!"
		log(error_message)
		
	end
	return error_message
end

function attack_wave_manager_print_errors(optional)
	local error_message = {}
	for i=1, #global.attack_wave_data_table do
		error_message = attack_waves_manager_error_checker(global.attack_wave_data_table[i], optional)
		for j=1, #error_message do
			game.print("global.attack_wave_data_table["..i.."]." .. error_message[j])
		end 
	end 
end

 -- returns random enemy type of N size, with some noise
 -- 1 - small, 2 medium, 3 big, 4 behemoth-biter
function attack_waves_manager_get_enemy(n)
	if math.random() > 0.5 then return attack_waves_manager_get_biter(n)end
	return attack_waves_manager_get_spitter(n)
end

-- returns biter of N size, see above
function attack_waves_manager_get_biter(n)
	local biters={"small-biter","medium-biter","big-biter","behemoth-biter"}
	--game.print(n)
	n = n + math.random()*0.5
	if n < 1 then n = 1 end
	if n > 4 then n = 4 end
	return biters[math.floor(n + 0.5)]
end

-- returns spitter of N size, see above
function attack_waves_manager_get_spitter(n)
	local spitters={"small-spitter","medium-spitter","big-spitter","behemoth-spitter"}
	n = n + math.random()*0.5
	if n < 1 then n = 1 end
	if n > 4 then n = 4 end
	return spitters[math.floor(n + 0.5)]
end

function attack_waves_manager_core()
	--todo; seperate lines from waves, allow random selection of lines for each wave
	--      unless a wave specifies what set of lines to use
	--game.forces["player"].set_spawn_position(spawn_point, .surface)
	for i = 1, #global.attack_wave_data_table do
		global.attack_wave_data_table[i].attack_waves = attack_waves_remote_control(global.attack_wave_data_table[i])
		-- this is the best way I know to get the 'has happened' boolean back
		-- to the global table while supporting arbitrary number of waves. 
	end
	if game.tick < 300 then
		game.forces["player"].chart(1, {{x = -500, y = -500}, {x = 500, y = 500}})
	end
	local remaining_waves = 0
	for i = 1, #global.attack_wave_data_table do
		for j = 1, #global.attack_wave_data_table[i].attack_waves do
			if not global.attack_wave_data_table[i].attack_waves[j].has_happened then remaining_waves = remaining_waves + 1 end
		end
	end
	if remaining_waves == 0 then
		if  attack_waves_manager_no_biters() then
			game.print("You've won!!!")
		end -- last wave has spawned AND there's no biters left
	end
end

function attack_waves_manager_no_biters() -- returns true if there are no biters left
	return  (game.forces["enemy"].get_entity_count("small-biter") == 0) 
		and (game.forces["enemy"].get_entity_count("medium-biter") == 0)
		and (game.forces["enemy"].get_entity_count("big-biter") == 0)
		and (game.forces["enemy"].get_entity_count("behemoth-biter") == 0)
		and (game.forces["enemy"].get_entity_count("small-spitter") == 0) 
		and (game.forces["enemy"].get_entity_count("medium-spitter") == 0)
		and (game.forces["enemy"].get_entity_count("big-spitter") == 0)
		and (game.forces["enemy"].get_entity_count("behemoth-spitter") == 0)
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
local attack_waves_manager_init = {}
local script_events = {}

attack_waves_manager_init.on_nth_ticks = {
    [240] = attack_waves_manager_core,
    [15] = function() game.forces["player"].chart_all() end,
}

attack_waves_manager_init.on_init = function() -- this runs when Event.core_events.init
    log("attack_waves_manager init")
	--attack_waves_manager_setup() -- generates n->s and s->n waves
    global.attack_waves_manager = global.attack_waves_manager or script_data  -- NO TOUCHY
end

attack_waves_manager_init.on_load = function() -- this runs when Event.core_events.load
    log("attack_waves load")
	--put stuff here
    script_data = global.attack_waves_manager or script_data  -- NO TOUCHY
end

attack_waves_manager_init.get_events = function()
    return script_events
end

return attack_waves_manager_init