extends Object
class_name BaseStatusEffectInstance

var type:Enums.StatusEffectType : get = _get_type

var value:int

func _get_type() -> Enums.StatusEffectType:
	return -1

func _init(value:int):
	self.value=value

func get_modifiers() -> Array[ActionModifierInstance]:
	return []
	
func get_triggers():
	pass
