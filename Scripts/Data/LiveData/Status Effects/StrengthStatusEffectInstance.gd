extends 
class_name StrengthStatusEffectInstance

func _get_type() -> Enums.StatusEffectType:
	return Enums.StatusEffectType.Strength

func get_modifiers() -> Array[ActionModifierInstance]:
	return [ActionModifierInstance.new(
			Enums.StatType.Damage,
			self.value,
			Enums.OperationType.Additive,
			self,
			[BoolConditionData.new(
					Enums.BoolConditionType.ActorIsAffected,
					true
				)]
		)]
	
func get_triggers():
	pass
