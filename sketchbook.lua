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
    local groups = game.surfaces[1].create_unit_group({
        position = {x= -20, y = -20}})

    groups.add_member(game.surfaces[1].create_entity{
        name = "behemoth-biter",
        position = game.surfaces[1].find_non_colliding_position("behemoth-biter", {x= -20, y = -20}, 5, 0.3, false)})

    groups.set_command{
        type = defines.command.compound,
        structure_type = defines.compound_command.return_last,
        commands = {
            {        
                type = defines.command.attack_area,
                destination = {x= 20, y = 20},
                distraction = defines.distraction.none,
                radius = 3 
            },
			{        
                type = defines.command.attack_area,
                destination = {x= 20, y = -20},
                distraction = defines.distraction.none,
                radius = 3 
            },
            {        
                type = defines.command.attack_area,
                destination = {x= -20, y = -20},
                distraction = defines.distraction.none,
                radius = 3 
            },
            {        
                type = defines.command.attack_area,
                destination = {x= 20, y = 20},
                distraction = defines.distraction.none,
                radius = 3 
            },
            {        
                type = defines.command.attack_area,
                destination = {x= 20, y = -20},
                distraction = defines.distraction.none,
                radius = 3 
            },
            {        
                type = defines.command.attack_area,
                destination = {x= 0, y = 0},
                distraction = defines.distraction.none,
                radius = 3 
            },

        }
    }
end
test_biter()


