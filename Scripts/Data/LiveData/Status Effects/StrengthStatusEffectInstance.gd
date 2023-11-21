extends BaseStatusEffectInstance
class_name StrengthStatusEffectInstance

func _get_type() -> Enums.StatusEffectType:
	return Enums.StatusEffectType.Strength

func get_modifiers():
	return ActionModifierInstance.new\
		(
			Enums.StatType.Damage,
			self.value,
			Enums.OperationType.Additive,
			self,
			[BoolConditionData.new\
				(
					Enums.BoolConditionType.ActorIsAffected,
					true
				)]
		)
	pass
	
func get_triggers():
	pass
