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

function test_biter(points, biter_type, group_size)
	local groups = game.surfaces[1].create_unit_group({
		position = points[1]})
	for i = 0, groups_size do
		groups.add_member(game.surfaces[1].create_entity{
			name = biter_type,
			position = game.surfaces[1].find_non_colliding_position(biter_type, points[1], 2, 0.3, false)})
	end
	groups.set_command{
		type = defines.command.compound,
		structure_type = defines.compound_command.return_last,
		commands = {biter_poly_path(points)}
	}
end

test_biter()


function test_biter()

    local range = {min = -150, max = -60}
    for r = range.min, range.max, 8 do
        local groups = game.surfaces[1].create_unit_group({
            position = {x= -200, y = r}})
        for i = 1, 20 do
            groups.add_member(game.surfaces[1].create_entity{
                name = "behemoth-biter",
                position = game.surfaces[1].find_non_colliding_position("behemoth-biter", {x= -200, y = r}, 50, 1.3, false)})
        end
        groups.set_command{
            type = defines.command.compound,
            structure_type = defines.compound_command.return_last,
            commands = {
                {        
                    type = defines.command.attack_area,
                    destination = {x= -150, y = r},
                    distraction = defines.distraction.none,
                    radius = 10 
                },{        
                    type = defines.command.attack_area,
                    destination = {x= -100, y = r},
                    distraction = defines.distraction.none,
                    radius = 10 
                },{        
                    type = defines.command.attack_area,
                    destination = {x= -30, y = r},
                    distraction = defines.distraction.none,
                    radius = 10 
                }
            }
        }
    end
    
end
test_biter()


local f = game.forces['player']
f.set_gun_speed_modifier('cannon-shell', 100.6)
f.set_gun_speed_modifier('artillery-shell', 6.0)
f.set_gun_speed_modifier('bullet', 100.5)
f.set_gun_speed_modifier('flamethrower', 0)
f.set_gun_speed_modifier('cannon-shell', 100.6)
f.set_gun_speed_modifier('grenade', 1)
f.set_gun_speed_modifier('laser-turret', 22.0)
f.set_gun_speed_modifier('rocket', 27.2)
f.set_gun_speed_modifier('shotgun-shell', 0.2)

/silent-command game.forces["player"].stack_inserter_capacity_bonus = 11

/c script.on_nth_tick(15, function() game.forces["player"].chart_all() end)
game.forces["player"].chart(game.forces["player"].surface, {{x = -radius, y = -radius}, {x = radius, y = radius}})


/c for key,value in pairs(game.surfaces) do game.print(key,value) end
