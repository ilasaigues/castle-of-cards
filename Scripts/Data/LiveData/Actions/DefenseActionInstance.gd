extends BaseActionInstance
class_name DefenseActionInstance

func get_mod_type() -> Enums.StatType:
	return Enums.StatType.Defense

func ExecuteImplementation(target:CharacterInstance, targetDefense:int):
	var previousDefense:int = target.current_defense
	if targetDefense != self.NULL_INT:
		target.current_defense = previousDefense + targetDefense
	else:
		# Armor reset 
		target.current_defense = 0

	print("Armored up (or armor reset) target %s from %s to %s" % [target.base_data.name, previousDefense, target.current_defense])
