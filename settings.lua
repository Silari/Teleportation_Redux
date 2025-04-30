data:extend({
	{
		type = "bool-setting",
		name = "Teleportation-telelogistics-enabled",
		setting_type = "startup",
		default_value = false,
	},
	{
		type = "bool-setting",
		name = "Teleportation-all-beacons-for-all",
		setting_type = "runtime-global",
		default_value = false,
	},
	{
		type = "bool-setting",
		name = "Teleportation-Dynamic-Loop",
		setting_type = "runtime-global",
		default_value = true,
	},
	{
		type = "bool-setting",
		name = "Teleportation-straight-jump-ignores-collisions",
		setting_type = "runtime-per-user",
		default_value = false
	},
	{
		type = "int-setting",
		name = "Teleportation-page-size",
		setting_type = "runtime-per-user",
		default_value = 20,
		minimum_value = 5,
		maximum_value = 50
	},
})

if true then  -- Now in use
    data:extend({
	{   -- How much energy in kJ jumping to a location takes per meter
		type = "int-setting",
		name = "Teleportation-equip-portal",
		setting_type = "startup",
		default_value = 250,
		minimum_value = 50,
		maximum_value = 1000
	},
	{   -- How much energy in MJ jumping to a beacon takes
		type = "int-setting",
		name = "Teleportation-equip-beacon",
		setting_type = "startup",
		default_value = 50,
		minimum_value = 5,
		maximum_value = 500
	},
	{   -- How much energy in MJ a beacon uses to be a sender/receiver
		type = "int-setting",
		name = "Teleportation-beacon-usage",
		setting_type = "startup",
		default_value = 100,
		minimum_value = 10,
		maximum_value = 1000
	},
	{   -- How much energy in MJ a beacon stores
		type = "int-setting",
		name = "Teleportation-beacon-storage",
		setting_type = "startup",
		default_value = 300,
		minimum_value = 300,
		maximum_value = 3000
	},
	{   -- How much energy in MW a beacon receives
		type = "int-setting",
		name = "Teleportation-beacon-charge",
		setting_type = "startup",
		default_value = 5,
		minimum_value = 5,
		maximum_value = 50
	}
})
end