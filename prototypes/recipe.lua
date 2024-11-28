data:extend({
	{
		type = "recipe",
		name = "teleportation-beacon",
		enabled = false,
		ingredients =	{
			{name="steel-plate", amount=100,type="item"},
			{name="copper-plate", amount=100,type="item"},
			{name="advanced-circuit", amount=100,type="item"},
			{name="accumulator", amount=100,type="item"}
		},
		results = {{name="teleportation-beacon",amount=1,type="item"}},
		energy_required = 5
	},
	{
		type = "recipe",
		name = "teleportation-equipment",
		enabled = false,
		energy_required = 10,
		ingredients =	{
			{name="teleportation-beacon", amount=1,type="item"},
			{name="speed-module", amount=100,type="item"},
			{name="plastic-bar", amount=100,type="item"},
			{name="copper-cable", amount=50,type="item"},
			{name="fission-reactor-equipment", amount=15,type="item"}
		},
		results = {{name="teleportation-equipment",amount=1,type="item"}},
	},
	{
		type = "recipe",
		name = "teleportation-portal",
		enabled = false,
		ingredients = {
			{name="processing-unit", amount=10,type="item"}
		},
		results = {{name="teleportation-portal",amount=1,type="item"}},
		energy_required = 30
	},
})
if settings.startup["Teleportation-telelogistics-enabled"].value then
  data:extend({
    {
      type = "recipe",
      name = "teleportation-teleprovider",
      enabled = false,
      ingredients =	{
        {name="active-provider-chest", amount=1,type="item"},
        {name="advanced-circuit", amount=10,type="item"},
        {name="processing-unit", amount=1,type="item"}
      },
      results = {{name="teleportation-teleprovider",amount=1,type="item"}},
      energy_required = 5
    },
  })
end