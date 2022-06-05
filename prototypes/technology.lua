data:extend({
    {
        type = "technology",
        name = "teleportation-tech",
        icon = "__Teleportation_Redux__/graphics/teleporter_icon.png",
        icon_size = 128,
        effects = {
            {
                type = "unlock-recipe",
                recipe = "teleportation-beacon"
            }
        },
        prerequisites = {"electric-energy-accumulators", "advanced-electronics"},
        unit = {
            count = 500,
            ingredients = {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 1},
                {"chemical-science-pack", 1}
            },
            time = 60
        }
    },
    {
		type = "technology",
		name = "teleportation-tech-adv",
		icon = "__Teleportation_Redux__/graphics/technology_adv_icon.png",
		icon_size = 128,
		effects =	{
			{
				type = "unlock-recipe",
				recipe = "teleportation-equipment"
			}
		},
		prerequisites = {"teleportation-tech", "fusion-reactor-equipment"},
		unit =
		{
			count = 2000,
			ingredients = {
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1},
				{"chemical-science-pack", 1},
				{"utility-science-pack", 1}
			},
			time = 15
		}
	},
    {
        type = "technology",
        name = "teleportation-tech-storage",
        icons = {
            {
                icon = "__Teleportation_Redux__/graphics/teleporter_icon.png",
                icon_size = 128
            },
            {
                icon = "__core__/graphics/icons/technology/effect-constant/effect-constant-battery.png",
                icon_size = 64,
                mip_maps = 2,
                shift = {16,16}
            }
        },
        prerequisites = {"teleportation-tech"},
        unit = {
            --count = 1000,        
            count_formula = "250 * L",
            ingredients = {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 1},
                {"chemical-science-pack", 1}
            },
            time = 60
        },
        upgrade = true,
        max_level = 4
    }
})

if settings.startup["Teleportation-telelogistics-enabled"].value then
    data:extend({
        {
            type = "technology",
            name = "teleportation-telelogistics",
            icon = "__Teleportation_Redux__/graphics/telelogistics-technology.png",
            icon_size = 128,
            effects = {
                {
                  type = "unlock-recipe",
                  recipe = "teleportation-teleprovider"
                }
            },
            prerequisites = {"logistic-system","teleportation-tech"},
            unit = {
                count = 300,
                ingredients = {
                      {"automation-science-pack", 1},
                      {"logistic-science-pack", 1},
                      {"chemical-science-pack", 1},
                      {"production-science-pack", 1},
                      {"utility-science-pack", 1}
                },
                time = 60
            }
        },
    })
end