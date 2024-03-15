extends BaseActionInstance
class_name DamageActionInstance

func get_mod_type() -> Enums.StatType:
	return Enums.StatType.Damage

func ExecuteImplementation(target:CharacterInstance, targetDmg:int):
	if targetDmg == self.NULL_INT:
		return 

	var previousDefense:int = target.current_defense
	var previousHp:int = target.current_hp

	if previousDefense > 0:
		# Hit armor animation
		target.current_defense -= min(targetDmg, previousDefense)

	if previousDefense > 0 and previousDefense <= targetDmg:
		# Break armor animation
		var _removethis = 2

	if previousDefense < targetDmg:
		target.current_hp = max(0, previousHp - (targetDmg - previousDefense))
		# Take damage animation

	print("Damaged target %s from %s/%s to %s/%s (defense/HP)" % [target.base_data.name, previousDefense, previousHp, target.current_defense, target.current_hp])
