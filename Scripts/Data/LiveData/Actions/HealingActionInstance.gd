extends BaseActionInstance
class_name HealingActionInstance	

func get_mod_type() -> Enums.StatType:
	return Enums.StatType.Healing

func ExecuteImplementation(target:CharacterInstance, targetOutput:int):
	var previousHp:int = target.current_hp
	if targetOutput != self.NULL_INT:
		target.current_hp += targetOutput
	print("Healed target %s from %s to %s" % [target.base_data.name, previousHp, target.current_hp])
