data.raw["gui-style"].default["teleportation_label_style"] = {
  type = "label_style",
  font = "default",
  font_color = {r=1, g=1, b=1},
  top_padding = 7,
  bottom_padding = 0,
}
data.raw["gui-style"].default["teleportation_button_style"] = {
  type = "button_style",
  --parent = "button_style",
  top_padding = 1,
  right_padding = 5,
  bottom_padding = 1,
  left_padding = 5,
  left_click_sound =
  {
    {
      filename = "__core__/sound/gui-click.ogg",
      volume = 1
    }
  }
}

data.raw["gui-style"].default["teleportation_button_style_link_small"] = {
  type = "button_style",
  --parent = "button_style",
  width = 32,
  height = 16,
  top_padding = 0,
  right_padding = 0,
  bottom_padding = 0,
  left_padding = 0,
  font = "default",---button",
  default_graphical_set =
  {
      filename = "__Teleportation_Redux__/graphics/buttons.png",
      priority = "extra-high-no-scale",
      width = 32,
      height = 16,
      x = 160,
      y = 96,
  },
  hovered_graphical_set =
  {
      filename = "__Teleportation_Redux__/graphics/buttons.png",
      priority = "extra-high-no-scale",
      width = 32,
      height = 16,
      x = 160,
      y = 112,
  },
  clicked_graphical_set =
  {
      filename = "__Teleportation_Redux__/graphics/buttons.png",
      width = 32,
      height = 16,
      x = 160,
      y = 128,
  },
  left_click_sound =
  {
    filename = "__core__/sound/gui-click.ogg",
    volume = 1
  }
}

data.raw["gui-style"].default["teleportation_button_style_cancel_link"] = {
  type = "button_style",
  --parent = "button_style",
  width = 32,
  height = 32,
  top_padding = 0,
  right_padding = 0,
  bottom_padding = 0,
  left_padding = 0,
  font = "default",---button",
  default_graphical_set =
  {
      filename = "__Teleportation_Redux__/graphics/buttons.png",
      priority = "extra-high-no-scale",
      width = 32,
      height = 32,
      x = 224,
      y = 0,
  },
  hovered_graphical_set =
  {
      filename = "__Teleportation_Redux__/graphics/buttons.png",
      priority = "extra-high-no-scale",
      width = 32,
      height = 32,
      x = 224,
      y = 32,
  },
  clicked_graphical_set =
  {
      filename = "__Teleportation_Redux__/graphics/buttons.png",
      width = 32,
      height = 32,
      x = 224,
      y = 64,
  },
  left_click_sound =
  {
    filename = "__core__/sound/gui-click.ogg",
    volume = 1
  }
}

data.raw["gui-style"].default["teleportation_sprite_style_done_small"] = {
  type = "button_style",
  --parent = "button_style",
  width = 32,
  height = 16,
  top_padding = 0,
  right_padding = 0,
  bottom_padding = 0,
  left_padding = 0,
  font = "default",---button",
  default_graphical_set =
  {
      filename = "__Teleportation_Redux__/graphics/buttons.png",
      priority = "extra-high-no-scale",
      width = 32,
      height = 16,
      x = 192,
      y = 96,
  },
  hovered_graphical_set =
  {
      filename = "__Teleportation_Redux__/graphics/buttons.png",
      priority = "extra-high-no-scale",
      width = 32,
      height = 16,
      x = 192,
      y = 96,
  },
  clicked_graphical_set =
  {
      filename = "__Teleportation_Redux__/graphics/buttons.png",
      width = 32,
      height = 16,
      x = 192,
      y = 96,
  },
  left_click_sound =
  {
    filename = "__core__/sound/gui-click.ogg",
    volume = 1
  }
}


