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

if false then  -- Not currently used, though default values are set to the currently used values
    data:extend({
	{   -- How much energy in MJ jumping to a beacon takes
		type = "int-setting",
		name = "Teleportation-equip-beacon",
		setting_type = "startup",
		default_value = 50,
		minimum_value = 50,
		maximum_value = 50
	},
	{   -- How much energy in kJ jumping to a location takes per meter
		type = "int-setting",
		name = "Teleportation-equip-portal",
		setting_type = "startup",
		default_value = 250,
		minimum_value = 250,
		maximum_value = 250
	},
	{   -- How much energy in MJ a beacon uses to be a sender/receiver
		type = "int-setting",
		name = "Teleportation-beacon-usage",
		setting_type = "startup",
		default_value = 100,
		minimum_value = 100,
		maximum_value = 100
	},
	{   -- How much energy in MJ a beacon stores
		type = "int-setting",
		name = "Teleportation-beacon-storage",
		setting_type = "startup",
		default_value = 300,
		minimum_value = 300,
		maximum_value = 3001
	},
	{   -- How much energy in MW a beacon stores
		type = "int-setting",
		name = "Teleportation-beacon-charge",
		setting_type = "startup",
		default_value = 100,
		minimum_value = 100,
		maximum_value = 100
	}
})
end

--[[
Types of settings:
	• startup - game must be restarted if changed (such a setting may affect prototypes' changes)
	• runtime-global - per-world setting
	• runtime-per-user - per-user setting

Types of values:
	• bool-setting
	• double-setting
	• int-setting
	• string-setting

Files being processed by the game:
	• settings.lua
	• settings-updates.lua
	• settings-final-fixes.lua
	
Using in DATA.lua:
data:extend({
   {
      type = "int-setting",
      name = "setting-name1",
      setting_type = "runtime-per-user",
      default_value = 25,
      minimum_value = -20,
      maximum_value = 100,
      per_user = true,
   },
   {
      type = "bool-setting",
      name = "setting-name2",
      setting_type = "runtime-per-user",
      default_value = true,
      per_user = true,
   },
   {
      type = "double-setting",
      name = "setting-name3",
      setting_type = "runtime-per-user",
      default_value = -23,
      per_user = true,
   },
   {
      type = "string-setting",
      name = "setting-name4",
      setting_type = "runtime-per-user",
      default_value = "Hello",
      allowed_values = {"Hello", "foo", "bar"},
      per_user = true,
   },
})

Using in LOCALE.cfg:
	[mod-setting-name]
	setting-name1=Seting name
	[mod-setting-description]
	setting-name1=Seting description

Using in CONTROL.lua and in other code for reading:
	EVENT: on_runtime_mod_setting_changed - called when a player changed its setting
		event.player_index
		event.setting
	GET: settings.startup["setting-name"].value - current value of startup setting; can be used in DATA.lua
	GET: settings.global["setting-name"].value - current value of per-world setting
	GET: set = settings.get_player_settings(LuaPlayer) - current values for per-player settings; then use set["setting-name"].value
	GET: settings.player - default values
]]