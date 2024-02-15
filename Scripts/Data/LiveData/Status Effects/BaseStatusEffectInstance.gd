extends Object
class_name BaseStatusEffectInstance

var type:Enums.StatusEffectType : get = _get_type

var base_data:BaseStatusEffectData
var turns:int
var modifiers:Array[ActionModifierInstance]=[]

func _get_type() -> Enums.StatusEffectType:
	return base_data.type

func _init(base_data: BaseStatusEffectData):
	self.base_data=base_data
	self.turns=base_data.turns
	print("Initializing stat eff %s " % Enums.StatusEffectType.keys()[base_data.type])
	for mod in base_data.modifiers:
		print(mod.amount)
		print(mod.modifier_conditionals)
		self.modifiers.append(ActionModifierInstance.new(self, mod))
	
func get_modifiers() -> Array[ActionModifierInstance]:
	return self.modifiers
	
func get_triggers():
	pass 
	
