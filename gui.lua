local mod_gui = require 'mod-gui'

local function gui_update(player)
    local gui = mod_gui.get_frame_flow(player)
    local frame = gui.doomsday_stats
    if not frame then
        return
    end
    
    frame.clear()
    for i,stat in ipairs(doomsday_status()) do
	    frame.add{
	        type = "label",
	        caption = stat
	    }
	end
end

local function toggle_frame(player)
    local gui = mod_gui.get_frame_flow(player)
    local frame = gui.doomsday_stats
    
    if frame then
        frame.destroy()
        return
    end
    
    frame = gui.add{
        type = "frame",
        name = "doomsday_stats",
        direction = "vertical",
        caption = "Doomsday stats",
        style = mod_gui.frame_style,
    }
    
    frame.style.horizontally_stretchable = false
    frame.style.vertically_stretchable = false
    gui_update(player)
end

local function get_sprite_button(player)
    local button_flow = mod_gui.get_button_flow(player)
    local button = button_flow.doomsday_stats_button
    if not button then
        button = button_flow.add{
            type = "sprite-button",
            name = "doomsday_stats_button",
            sprite = "item/raw-fish",
            style = mod_gui.button_style,
            tooltip = "Show debug stats for doomsday",
        }
    end
    
    button.visible = true
end

local function on_gui_click(event)
    local gui = event.element
    local player = game.players[event.player_index]
    if not (player and player.valid and gui and gui.valid) then
        return
    end
    
    if gui.name == "doomsday_stats_button" then
        toggle_frame(player)
    end
end

local function on_player_created(event)
    local player = game.players[event.player_index]
    if not (player and player.valid) then
        return
    end
    
    get_sprite_button(player)
end

local function gui_update_all()
    for _, player in pairs(game.players) do
        if player and player.valid then
            gui_update(player)
        end
    end
end

local function on_gui_tick(event)
	gui_update_all()
end



local doomsdaygui_init = {}

local script_events = {
    --place the here what you would normaly use Event.register for
    -- Event.register(defines.events.on_player_created, testfunction)
    -- is the same as 
    -- [defines.events.on_player_created] = testfunction,
    -- where testfunction is | local functuin testfunction() { }
    --[Event] = function, 
    --put stuff here
    [defines.events.on_gui_click] = on_gui_click,
    [defines.events.on_player_created] = on_player_created,
}

doomsdaygui_init.on_nth_ticks = {
    --place the here what you would normaly use 
    --[tick] = function,
    --put stuff here
    [60] = on_gui_tick,
}

doomsdaygui_init.on_init = function() -- this runs when Event.core_events.init
    log("doomsdaygui init")
    --put stuff here

    global.doomsdaygui_data = global.doomsdaygui_data or script_data  -- NO TOUCHY

end

doomsdaygui_init.on_load = function() -- this runs when Event.core_events.load
    log("doomsdaygui load")
    --put stuff here

    script_data = global.doomsdaygui_data or script_data  -- NO TOUCHY
end

doomsdaygui_init.get_events = function()
    return script_events
end

return doomsdaygui_init