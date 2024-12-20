--[[Global variables hierarchy in this part of mod:
  storage
    Telelogistics = {}; dictionary
      teleproviders = {}; list
        entity = LuaEntity; contains such fields as built_by (last_user since 0.14.6), position, surface, force and so on - needed to operate with
        key = entity.surface.name .. "-" .. entity.position.x .. "-" .. entity.position.y; it's an id for gui elements representing this provider
        receiver_key = string; storage.Teleportation.beacons[].key of the beacon receiving items from this provider
      index_of_last_processed_provider = number; for processing providers' queue
]]

--===================================================================--
--########################## EVENT HANDLERS #########################--
--===================================================================--

script.on_event("teleportation-hotkey-adjust-teleprovider", function(event)
  local player = game.players[event.player_index]
  -- If player pressed linking hotkey, and has a teleprovider selected, open the link window
  if player.selected and player.selected.name == "teleportation-teleprovider" and player.selected.force.name == player.force.name then
    Telelogistics_OpenLinkerWindow(player, Common_CreateEntityKey(player.selected))
  else
    Telelogistics_CloseLinkerWindow(player)
  end
end)

--===================================================================--
--############################ FUNCTIONS ############################--
--===================================================================--

--Ensures that globals were initialized. Called by on_configuration_changed
function Telelogistics_InitializeGeneralGlobals()
  if not storage.Telelogistics then
    storage.Telelogistics = {}
  end
  if not storage.Telelogistics.teleproviders then
    storage.Telelogistics.teleproviders = {}
  end
end

--Saves built provider to the global list
function Telelogistics_RememberProvider(entity)
  local provider = {
    entity = entity,
    key = Common_CreateEntityKey(entity)
  }
  table.insert(storage.Telelogistics.teleproviders, provider)
  --game.print("Remembered")
end

--Removes destroyed provider from the global list
function Telelogistics_ForgetProvider(entity)
  local key_to_forget = Common_CreateEntityKey(entity)
    for i = #storage.Telelogistics.teleproviders, 1, -1 do
    local provider = storage.Telelogistics.teleproviders[i]
    if provider.key == key_to_forget then
      table.remove(storage.Telelogistics.teleproviders, i)
      --game.print("Forgot")
      return
    end
  end
end

function Telelogistics_LinkProviderWithBeacon(provider_key, beacon_key)
  local provider = Common_GetTeleproviderByKey(provider_key)
  local beacon = Common_GetBeaconByKey(beacon_key)
  if provider and beacon then
    provider.receiver_key = beacon_key
    --game.print("Linked")
  end
end

function Telelogistics_CancelProviderLink(provider_key)
  local provider = Common_GetTeleproviderByKey(provider_key)
  if provider then
    provider.receiver_key = nil
    --game.print("Unlinked")
  end
end

-- Copies the target beacon from one Telelogistics provider to another.
function Telelogistics_CopyProvider(provider_key, dest_key)
    local provider = Common_GetTeleproviderByKey(provider_key)
    local dest_beacon -- Will get filled with target beacon, if any.
    if provider then
        -- This is the internal key used to represent the beacon this provider is using.
        dest_beacon = provider.receiver_key
    end
    if dest_beacon then
        -- We found a destination beacon, find the data for our pasted teleprovider
        local newprovider = Common_GetTeleproviderByKey(dest_key)
        if newprovider then -- Add the beacon as the receiver for this provider.
            newprovider.receiver_key = dest_beacon
        end
    else -- No destination beacon set on copied source, so remove any from the destination.
        Telelogistics_CancelProviderLink(dest_key)
    end
end


--TODO This can skip an item if a beacon is removed. I COULD fix that by having the removal code find the beacon in the list, and if it's < index_of_last_processed_provider then reduce it by 1 to compensate.
--Processes providers causing them to send items to the beacons
function Telelogistics_ProcessProvidersQueue()
  -- If there are no Teleproviders, do nothing
  if #storage.Telelogistics.teleproviders == 0 then return end
  if settings.global["Teleportation-Dynamic-Loop"].value then
    --dynamic speed, attempt every provider over a second.
    local last_index = storage.Telelogistics.index_of_last_processed_provider or 0
    local target_index = last_index + math.ceil(#storage.Telelogistics.teleproviders/60)
    local current_index = last_index + 1
    while current_index <= target_index do
        --Attempt to process the Provider at the current_index, if one exists.
        --Note it's possible for current_index to be greater than the number of providers, if the count changed within
        --the last second (if some were removed, for example)
        if storage.Telelogistics.teleproviders[current_index] then
            Telelogistics_ProcessProvider(current_index)
        end
        current_index = current_index + 1
    end
    --Set our last processed provider to the last target, or 0 
    if target_index > #storage.Telelogistics.teleproviders then
        target_index = 0
    end
    storage.Telelogistics.index_of_last_processed_provider = target_index
  else
    -- Static speed, one provider per tick.
    local last_index = storage.Telelogistics.index_of_last_processed_provider or 0
    local current_index = last_index + 1
    if storage.Telelogistics.teleproviders[current_index] then
        Telelogistics_ProcessProvider(current_index)
        storage.Telelogistics.index_of_last_processed_provider = current_index
    else
        storage.Telelogistics.index_of_last_processed_provider = 0
    end
  end
end

function Telelogistics_ProcessProvider(provider)
  local thisitem = storage.Telelogistics.teleproviders[provider]
  if not Common_IsEntityOk(thisitem.entity) then
    --PrintToAllPlayers("processing: ".. tostring(provider))
    table.remove(storage.Telelogistics.teleproviders, provider)
    --game.players[1].print("Processing: provider is not valid")
    return
  end
  -- TODO This is where I'd add code to add player logistics
  if not thisitem.receiver_key then
    --game.players[1].print("Processing: receiver is not set")
    return
  end
  local beacon = Common_GetBeaconByKey(thisitem.receiver_key)
  if not beacon or not beacon.entity or not beacon.entity.valid then
    --game.players[1].print("Processing: not linked")
    thisitem.receiver_key = nil
    return
  end
  local beacon_inventory = beacon.entity.get_inventory(defines.inventory.chest)
  local provider_inventory = thisitem.entity.get_inventory(defines.inventory.chest)
  local provider_inventory_contents = provider_inventory.get_contents()
  for key, data in pairs(provider_inventory_contents) do
    --log(serpent.block(data))
    item_name = data.name
    count = data.count
    quality = data.quality
    --log(item_name .. " : " .. serpent.block(count))
    if item_name and count then 
      local remainder = TopUpCount(beacon_inventory, item_name)
      if  remainder > 0 then
        -- Need to limit the amount we transfer to the amount availalble or the top-up value, whichever is smaller.
        local amount_to_transfer = count
        if amount_to_transfer > remainder then amount_to_transfer = remainder end
        local inserted_count = beacon_inventory.insert({name = item_name, count = amount_to_transfer, quality=quality})
        if inserted_count > 0 then
          provider_inventory.remove({name = item_name, count = inserted_count, quality=quality})
          --game.players[1].print("Provider processed")
        end
      end
    end
  end
end

function TopUpCount(chest, name)
  local total_count=0
  -- loop over all items in the chest ant return a count of the total number of items in there
  -- not sure if different stacks of the same item show up as multiples so just assume they do
  -- and total them up
  local max_stack = 100 -- need to fill this in properly by queerying the stack size for this particular item
  local inventory_contents =chest.get_contents()
    for item_name, item_count in pairs(inventory_contents) do
      if item_name == name then
        total_count = total_count + item_count
      end
    end
  local remaining = max_stack - total_count
  if remaining >=0 then
    return remaining
  else
    return 0
  end
end

--===================================================================--
--############################### GUI ###############################--
--===================================================================--
function Telelogistics_ProcessGuiClick(gui_element)
  local player_index = gui_element.player_index
  local player = game.players[player_index]
  if gui_element.name == "teleportation_button_link_provider_with_beacon" then
    Telelogistics_LinkProviderWithBeacon(gui_element.parent.parent.name, gui_element.parent.name)
    Telelogistics_CloseLinkerWindow(player)
  elseif gui_element.name == "teleportation_linker_window_button_cancel_link" then
    Telelogistics_CancelProviderLink(gui_element.parent.name)
    Telelogistics_CloseLinkerWindow(player)
  elseif gui_element.name == "teleportation_linker_window_button_cancel" then
    Telelogistics_CloseLinkerWindow(player)
  end
end

function Telelogistics_OpenLinkerWindow(player, provider_key)
  local provider = Common_GetTeleproviderByKey(provider_key)
  if not provider then return end
  if not player.force.name == provider.entity.force.name then return end
  local gui = player.gui.center
  if gui.teleportation_linker_window then
    --close the old window and reopen, in case it's a different Teleprovider
    Telelogistics_CloseLinkerWindow(player)
  end
  local window = gui.add({type="frame", name="teleportation_linker_window", direction="vertical", caption={"caption-linker-window"}})
  local scroll = window.add({type="scroll-pane", name="teleportation_linkable_beacons_scroll", direction="vertical"})
  scroll.style.maximal_height = 150
  scroll.style.minimal_width = 200
  local gui_table = scroll.add({type="table", name=provider_key, column_count=1})
  --gui_table.style.cell_spacing = 0
  local list = storage.Teleportation.beacons
  Teleportation_InitializePlayerGlobals(player)
  local list_sorted = Teleportation_GetBeaconsSorted(list, player.force.name, storage.Teleportation.player_settings[player.name].beacons_list_is_sorted_by, player)
  for i, beacon in pairs(list_sorted) do
    local is_linked = false
    if provider.receiver_key == beacon.key then
      is_linked = true
    end
    Telelogistics_AddRow(gui_table, beacon, i, is_linked)
  end
  local buttons_flow = window.add({type="flow", name=provider_key, direction="horizontal"})
  buttons_flow.add({type="button", name = "teleportation_linker_window_button_cancel_link", style="teleportation_button_style_cancel_link"})
  buttons_flow.add({type="button", name = "teleportation_linker_window_button_cancel", caption={"caption-button-cancel"}})
end

function Telelogistics_AddRow(parent_gui, beacon, beacon_index, is_already_linked)
  local this_row = parent_gui.add({type="flow", name=beacon.key, direction="horizontal"})
  if is_already_linked then
    this_row.add({type="button", name="teleportation_sprite", style="teleportation_sprite_style_done_small"})
  else
    this_row.add({type="button", name="teleportation_button_link_provider_with_beacon", style="teleportation_button_style_link_small"})
  end
  this_row.add({type="label", name="teleportation_label_selectible_beacon_name", caption=beacon.name})
end

function Telelogistics_CloseLinkerWindow(player)
  local gui = player.gui.center
  if gui.teleportation_linker_window then
    gui.teleportation_linker_window.destroy()
  end
end