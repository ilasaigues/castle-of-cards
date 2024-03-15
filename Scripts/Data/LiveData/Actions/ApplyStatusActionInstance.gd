extends BaseActionInstance
class_name ApplyStatusActionInstance

func get_mod_type() -> Enums.StatType:
	return Enums.StatType.StatusEffectTurns

func ExecuteImplementation(target:CharacterInstance, seTurns:int):
	var statusEffectApplied = self.base_action.status_effect
	var matchingSE = target.current_status_effects.filter(\
		func(se:BaseStatusEffectInstance): return se.base_data == statusEffectApplied)
		
	if matchingSE.size() > 0:
		matchingSE[0].turns += seTurns
	else:
		var newStatusEffect=BaseStatusEffectInstance.new(self.base_action.status_effect, seTurns,target)
		target.current_status_effects.append(newStatusEffect)
		
	print("Final Result (target %s) -> Applied SE %s to target for %s turns" % [target.base_data.name, statusEffectApplied.name, seTurns])

func valid_data() -> bool:
	var valid:bool = true
	if !self.base_action is BaseStatusEffectActionData:
		print("Status effect action doesn't have status effect data resource assigned")
		valid = false
	return valid
