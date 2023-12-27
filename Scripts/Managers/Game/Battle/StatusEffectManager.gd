extends Node
class_name StatusEffectManager

func create_status_effect(base_data:BaseStatusEffectData) -> BaseStatusEffectInstance:
	match base_data.type:
		Enums.StatusEffectType.Strength:
			pass
		Enums.StatusEffectType.Resilience:
			pass
		Enums.StatusEffectType.Weakness:
			pass
		Enums.StatusEffectType.Fragility:
			pass
		Enums.StatusEffectType.Stun:
			pass
		Enums.StatusEffectType.Poison:
			pass
	
	return null
	
