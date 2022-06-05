if Teleportation == nil then
  Teleportation = {}
end
if Teleportation.config == nil then
  Teleportation.config = {}
end

--[[Defines how much energy should be in Personal Teleporter equipment to use Targeter for straight jump. NOT ZERO VALUE!
    Note: Personal Teleporter stats are: buffer = 100MJ, charge rate = 500kW.
    Default is 250000 (250kJ/m). ]]
--Teleportation.config.energy_in_equipment_to_use_portal = 250000
Teleportation.config.energy_in_equipment_to_use_portal = settings.startup["Teleportation-equip-portal"].value * 1000

--[[Defines how much energy should be in Personal Teleporter equipment to jump to Teleporter Beacon. NOT ZERO VALUE!
    Note: Personal Teleporter stats are: buffer = 100MJ, charge rate = 500kW.
    Default is 50000000 (50MJ). ]]
-- Teleportation.config.energy_in_equipment_to_use_beacon = 50000000
Teleportation.config.energy_in_equipment_to_use_beacon = settings.startup["Teleportation-equip-beacon"].value * 1000000

--[[Defines how much energy should be in Teleporter Beacon to accept it's activation. NOT ZERO VALUE!
    Note: Teleporter Beacon stats are: buffer = 300MJ, charge rate = 5MW.
    Default is 100000000 (100MJ). ]]
-- Teleportation.config.energy_in_beacon_to_activate = 100000000
Teleportation.config.energy_in_beacon_to_activate = settings.startup["Teleportation-beacon-usage"].value * 1000000
