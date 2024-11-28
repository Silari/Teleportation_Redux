data:extend({
  {
      type  = "item-subgroup",
      name  = "teleportation",
      group = "logistics",
      order = "ba",
  },
  {
    type = "item",
    name = "teleportation-beacon",
    subgroup = "teleportation",
    icon = "__Teleportation_Redux__/graphics/icon.png",
    icon_size = 32,
    order = "a[items]-b[teleportation-beacon]",
    place_result="teleportation-beacon",
    stack_size= 5,
	},
  {
    type = "item",
    name = "teleportation-beacon-electric-energy-interface",
    icon = "__base__/graphics/icons/accumulator.png",
    icon_size = 32,
    hidden = true,
    subgroup = "teleportation",
    order = "e[electric-energy-interface]-b[electric-energy-interface]",
    place_result = "teleportation-beacon-electric-energy-interface",
    stack_size = 1
  },
  {
    type = "item",
    name = "teleportation-equipment",
    localised_description = {"item-description.teleportation-equipment",settings.startup["Teleportation-equip-beacon"].value .. "MJ",settings.startup["Teleportation-equip-portal"].value .. "kJ"},
    icon = "__Teleportation_Redux__/graphics/Personal_Teleporter_item.png",
    icon_size = 32,
    place_as_equipment_result = "teleportation-equipment",
    subgroup = "equipment",
    order = "g-a-a",
    stack_size= 5,
  },
  {
    type = "item",
    name = "teleportation-portal",
    icon = "__Teleportation_Redux__/graphics/portal-32.png",
    icon_size = 32,
	subgroup = "equipment",
	order = "g-a-a",
    place_result = "teleportation-portal",
    stackable = false,
    stack_size = 1
  },
  {
    type = "selection-tool",
    name = "teleportation-targeter",
    icon = "__Teleportation_Redux__/graphics/portal-32.png",
    icon_size = 32,
	subgroup = "other",
	order = "g-a-a",
    stack_size = 1,
    hidden = true,
    alt_select = {
        border_color = {
            b = 0,
            g = 1,
            r = 0
        },
        cursor_box_type = "copy",
        mode = {
            "blueprint"
        },
    },    
    flags = {
        "not-stackable",
        "spawnable",
        "only-in-cursor"
    },
    select = {
        border_color = {
            b = 255,
            g = 255,
            r = 255
        },
        cursor_box_type = "copy",
        mode = {
            "any-tile"
        }
    },
  },
})
if settings.startup["Teleportation-telelogistics-enabled"].value then
  data:extend({
    {
      type = "item",
      name = "teleportation-teleprovider",
      icon = "__Teleportation_Redux__/graphics/teleprovider-icon.png",
      icon_size = 32,
      subgroup = "teleportation",
      order = "a[items]-b[teleportation-teleprovider]",
      place_result = "teleportation-teleprovider",
      stack_size = 50
    },
  })
end

--Shortcut to give the player a jump targeter
targeter_shortcut = {
      action = "spawn-item",
      associated_control_input = "teleportation-hotkey-jump-targeter",
      icon = "__Teleportation_Redux__/graphics/portal-32.png",
      icon_size = 32,
      small_icon = "__Teleportation_Redux__/graphics/portal-32.png",
      small_icon_size = 32,
      item_to_spawn = "teleportation-targeter",
      localised_name = {
        "shortcut.make-teleportation-targeter"
      },
      name = "give-teleportation-targeter",
      order = "o[other]-t[teleportation-targeter]",
      style = "default",
      type = "shortcut"
}
data:extend({targeter_shortcut})