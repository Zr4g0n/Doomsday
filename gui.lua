local mod_gui = require 'mod-gui'

local function gui_update(player)
    local gui = mod_gui.get_frame_flow(player)
    local doomsday = gui.doom_stats
    local PDNC = gui.pdnd_stats
    local tab = gui.info_tab
    
    if not doomsday then
        return
    end
    if not PDNC then
        return
    end
    if not tab then
        return
    end
    
    doomsday.clear()
    for i,stat1 in ipairs(doomsday_status()) do
	    doomsday.add{
	        type = "label",
	        caption = stat1
	    }
	end

	PDNC.clear()
    for i,stat2 in ipairs(pdnc_extended_status()) do
	    PDNC.add{
	        type = "label",
	        caption = stat2
	    }
	end
end

local function toggle_frame(player, button)
    local gui = mod_gui.get_frame_flow(player)
    local doom = gui.doom_stat
    local pdnc = gui.pdnd_stat
    local tab = gui.info_tab

    if tab then
        gui.destroy()
        return
    end

    if not tab then
        tab = gui.add{
        	name = "info_tab",
            type = "tabbed-pane",
        }
    end

	if not doom then
        doom = tab.add{
            type = "tab",
            name = "doom_stat",
            caption = "Doom Stats",
            tooltip = "Show debug stats for doom",
        }
        
    end

    if not pdnc then
        pdnc = tab.add{
            type = "tab",
            name = "pdnd_stat",
            caption = "PDNC Stats",
            tooltip = "Show debug stats for PDNC",
        }
    end 
    tab1 = tab.add{type="label", caption="Label 1"}
    tab1 = tab.add_tab(doom, tab1)
    tab2 = tab.add{type="label", caption="Label 2"}
    tab2 = tab.add_tab(pdnc, tab2)
	gui_update(player)
end

local function doom_stat(player)

	-- local gui = mod_gui.get_frame_flow(player)
	-- local DoomStat = gui.doomsday_stats

	-- if DoomStat then
	--     DoomStat.destroy()
	--     return
	-- end

 --    DoomStat = tab.add{
 --        type = "frame",
 --        name = "doomsday_stats",
 --        direction = "vertical",
 --        caption = "Doomsday stats page",
 --        style = mod_gui.frame_style,
 --    }
 --    DoomStat.style.horizontally_stretchable = false
	-- DoomStat.style.vertically_stretchable = false
	-- gui_update(player)
end

local function PDNC_stat(player)
	-- local gui = mod_gui.get_frame_flow(player)
	-- local PDNCstats = gui.pdnd_stats

	-- if PDNCstats then
	--     PDNCstats.destroy()
	--     return
	-- end

 --    PDNCstats = gui.add{
 --        type = "frame",
 --        name = "pdnd_stats",
 --        direction = "vertical",
 --        caption = "PDNC stats pages",
 --        style = mod_gui.frame_style,
 --    }
 --    PDNCstats.style.horizontally_stretchable = false
	-- PDNCstats.style.vertically_stretchable = false
	-- gui_update(player)
end

local function get_sprite_button(player)
    local button_flow = mod_gui.get_button_flow(player)
    local doom = button_flow.doomsday_stats_button
    if not doom then
        doom = button_flow.add{
            type = "sprite-button",
            name = "doomsday_stats_button",
            sprite = "item/raw-fish",
            style = mod_gui.button_style,
            tooltip = "Debug stats for doomsday and PDNC",
        }
    end
    --add admin check here
    doom.visible = true
end

local function on_gui_click(event)
    local gui = event.element
    local player = game.players[event.player_index]
    if not (player and player.valid and gui and gui.valid) then
        return
    end
    if gui.name == "doomsday_stats_button" then
   		toggle_frame(player)
   		gui_update(player)
    end
    if gui.name == "doom_stat" then
   		doom_stat(player)
   		gui_update(player)
    end
    if gui.name == "pdnd_stat" then
   		PDNC_stat(player)
   		gui_update(player)
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

doomsdaygui_init.on_nth_ticks = {
    [60] = on_gui_tick,
}

doomsdaygui_init.on_init = function()
    log("Doomsday GUI init")
    global.poseidon_data = global.poseidon_data or script_data
end

local script_events = {
    [defines.events.on_gui_click] = on_gui_click,
    [defines.events.on_player_created] = on_player_created,
}

doomsdaygui_init.get_events = function()
    return script_events
end

return doomsdaygui_init