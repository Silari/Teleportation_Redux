-- Old TODO notes from old-changelist.txt:
-- • add Telelogistics balance: Beacons spend energy to collect items from Teleproviders. Energy is being spent per each item teleported and depends on distance [and item complexity]
-- • add global setting: switch if the Beacons should reserve some energy to be ready to accept player's teleportation (or it should be per-Beacon setting) : SILARI: this seems pointless, unless maybe in conjunction with telelogistics energy use. No point reserving energy for teleporting if the only energy use IS teleporting.
-- • add Telelogistics feature: player can be supplied with requested items via Teleproviders, if he's equipped with Personal Teleporter equipment and it's charged enough and he's got enough free inventory space
-- • add ability to copy-paste Teleprovider settings (a linked destination Beacon is being meant)

-- Silari's TODO notes

-- Fix the max_stack code in telelogistics.TopUpCount to use the actual stack size of the item.
-- Also, optimize that. It's calling TopUpCount and counting all the items in the chest for every type of item in the chest - it only needs to count ONCE.

-- Teleportation update:
-- Make clicking a beacon open up the teleporter GUI? Note that beacons are currently set as active = false when placed! I might wanna remove that. It doesn't really do much other than stop the player from opening the beacon as a chest, and if it opens like that I could add a mod gui next to it to add details/rename.

-- Message for Ctrl+Y jumping: if the beacon doesn't have enough energy, you just get a Can't Jump message.
-- Note that it checks every beacon by distance until it finds one that works, so you can't just unsupress the 'not enough energy' message in activatebeacon
--  Though I think I might have pre-checked for every other possible error, so maybe I can make the generic message "Not enough energy on any beacon" -- Did this, so it should be fine now

-- Maybe switch things up to use the linked chests/linked belts. Some downsides: only allows same entity type transfer, always bi-directional, no throughput limit.

-- Maybe have vehicle modifier values in settings

--
--Change how the new jump targeting works
--ONE: Have it use the bounding box created to find a jumpable point. Ensure that even clicking with it allows jumping!
--TWO: Require that the position being jumped to is charted, possibly a setting to require visibility. Technically you could find nests by attempting to jump into unvisible areas, and I think the 'can't find a spot' message would take precedence over the 'not enough energy' one. No equipment is first though IIRC.

require("util")
require("config")
require("control-common")
require("control-teleportation")
require("control-telelogistics")


--===================================================================--
--########################## EVENT HANDLERS #########################--
--===================================================================--
--First using
script.on_init(function(event)
  for i, force in pairs(game.forces) do
    force.reset_technologies()
    force.reset_recipes()
  end
  Telelogistics_InitializeGeneralGlobals()
end)

--Migrations
function on_changed()
    --Updates the Teleporter GUIs and rebuilds teleporter list.
    Teleportation_Migrate()
    --Ensures global needed for Telelogistics are created. This use to be in on_tick.
    Telelogistics_InitializeGeneralGlobals()
end
script.on_configuration_changed(on_changed)

script.on_event(defines.events.on_player_selected_area, Teleport_Area)

function paste_teleport(event)
    --if isdebug then game.print("Paste: " .. event.source.name) end
    -- We can only copy to a teleprovider, so check that first.
    if event.destination and event.destination.name == "teleportation-teleprovider" then
        if event.source and event.source.name == "teleportation-beacon" then
            -- Copy from beacon to provider - set the beacon as this provider's destination
            --if isdebug then game.print("Pasted: " .. event.destination.name) end
            local beacon_key = Common_CreateEntityKey(event.source)
            local provider_key = Common_CreateEntityKey(event.destination)
            -- This links the two entities just like using the GUI would.
            Telelogistics_LinkProviderWithBeacon(provider_key, beacon_key)
        elseif event.source and event.source.name == "teleportation-teleprovider" then
            -- Copy from provider to provider - set the same beacon as the destination.
            local source_key = Common_CreateEntityKey(event.source)
            local dest_key = Common_CreateEntityKey(event.destination)
            Telelogistics_CopyProvider(source_key, dest_key)
        end
    end
end
script.on_event(defines.events.on_entity_settings_pasted, paste_teleport)

-- Handles updating beacon buffers when technology is researched (or unresearched)
function upgradebeacons(event)
    if not global.Teleportation then return end -- No beacons built yet, so skip it.
    if event.research.name == "teleportation-tech-storage" then -- We only care if its our research
        local basebuffer = settings.startup["Teleportation-beacon-storage"].value * 1000000
        for i = #global.Teleportation.beacons, 1, -1 do -- Iterate over all our saved beacons
            local interface = global.Teleportation.beacons[i].energy_interface
            if interface and interface.valid then -- Energy interface is valid.
                if interface.force.name == event.research.force.name then -- Belongs to force that did the research
                    interface.electric_buffer_size = basebuffer * (1 + GetBeaconBonus(interface.force))
                end
            end
        end
    end
end
script.on_event(defines.events.on_research_finished, upgradebeacons)
script.on_event(defines.events.on_research_reversed, upgradebeacons)

--When beacon get placed by entity of any force, all players of this force should get their GUI updated.
--When teleprovider get placed, it should be remembered.
script.on_event({defines.events.on_built_entity, defines.events.on_robot_built_entity}, function(event) 
  if event.created_entity.name == "teleportation-beacon" then
    Teleportation_RememberBeacon(event.created_entity)
  elseif event.created_entity.name == "teleportation-teleprovider" then
    Telelogistics_RememberProvider(event.created_entity)
  elseif event.created_entity.name == "teleportation-portal" then
    local player = event.created_entity.last_user
    player.cursor_stack.set_stack({name = "teleportation-portal", count = 1})
    event.created_entity.destroy()
  elseif event.created_entity.name == "entity-ghost" then
    if event.created_entity.ghost_name == "teleportation-portal" then
      event.created_entity.destroy()
    end
  end
end)

--When beacon, belonging to some force, get removed, all players of this force should get their GUI updated.
script.on_event({defines.events.on_pre_player_mined_item, defines.events.on_robot_pre_mined, defines.events.on_entity_died, defines.events.script_raised_destroy}, function(event)
  local entity = event.entity
  if event.entity.name == "teleportation-beacon" and entity.valid then
    -- If the entity isn't valid we can't remove it, but it'd get removed later by the Migration checks.
    Teleportation_ForgetBeacon(entity)
  elseif event.entity.name == "teleportation-teleprovider" then
    Telelogistics_ForgetProvider(entity)
  end
end)

--When new player get created in game: new game for single player or new player connected to multiplayer game, or player joined the game -
--we should update his GUI. So if his force owns beacons - he'll see them.
script.on_event({defines.events.on_player_created, defines.events.on_player_joined_game}, function(event)
  local player = game.players[event.player_index]
  Teleportation_UpdateGui(player.force)
end)

--When forces get merged, all beacons which belong to both forces should become common (should belong to the resulting force).
script.on_event(defines.events.on_forces_merging, function(event) 
  -- This feels like it's unfinished - seems all it does is update the GUI of the merged force.
  -- Though looking through, I don't think there's anything that NEEDS to be done. All the 
  -- beacons will be on the new force automatically, and everything else doesn't track force.
  --local force_to_destroy = event.source
  --local force_to_reassign_to = event.destination
  Teleportation_UpdateGui(event.destination)
end)

--When player points on the ground while holding anything in his hand
--DEPRECATED, should be using the shortcut based remote
script.on_event(defines.events.on_pre_build, function(event)
  local player = game.players[event.player_index]
  --player.print("Putting item " .. game.tick)
  if Common_IsHolding({name="teleportation-portal", count=1}, player) then
    local destination = event.position
    if Teleportation_ActivatePortal(player, destination) and global.Teleportation.player_settings[player.name].beacons_list_is_sorted_by == 3 then
      --If the player successfully teleported, update the GUI to resort beacons IF they're sorting by closest to player.
      Teleportation_UpdateMainWindow(player)
    end
  end
end)


script.on_event(defines.events.on_tick, function(event)
  if not global.tick_of_last_check then
    global.tick_of_last_check = event.tick
  end
  if event.tick - global.tick_of_last_check >= 30 then
    global.tick_of_last_check = event.tick
    Teleportation_EnergyProgressUpdate()
    Teleportation_RemindSelectedBeacons()
  end
  Telelogistics_ProcessProvidersQueue()
end)

--When player get clicked the button - something should happen =).
script.on_event(defines.events.on_gui_click, function(event)
  if not string.find(event.element.name, "teleportation_") then
    return
  end
  Teleportation_ProcessGuiClick(event.element)
  if event.element and event.element.valid then
    Telelogistics_ProcessGuiClick(event.element)
  end
end)

--===================================================================--
--############################ FUNCTIONS ############################--
--===================================================================--

