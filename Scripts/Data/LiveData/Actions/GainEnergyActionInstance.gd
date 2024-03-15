extends BaseActionInstance
class_name GainEnergyActionInstance

func get_mod_type() -> Enums.StatType:
	return Enums.StatType.EnergyGain

func ExecuteImplementation(target:CharacterInstance, energyGain:int):
	var handManager:HandManager=self.battle_manager.HandMngr
	var previousEnergy:int = handManager.currentEnergy
	if energyGain != self.NULL_INT:
		handManager.currentEnergy += energyGain
	else:
		handManager.currentEnergy = 0

	print("Gained energy from %s to %s" % [target.base_data.name, previousEnergy, handManager.currentEnergy])
