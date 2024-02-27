extends Object
class_name BaseStatusEffectInstance

var type:Enums.StatusEffectType : get = _get_type

var base_data:BaseStatusEffectData
var turns:int
var modifiers:Array[ActionModifierInstance]=[]
var triggers:Array[BaseTriggerInstance]=[]
var character:CharacterInstance

func _get_type() -> Enums.StatusEffectType:
	return base_data.type

func _init(base_data: BaseStatusEffectData, turns: int, character:CharacterInstance):
	self.base_data=base_data
	self.turns=turns
	self.character=character
	for mod in base_data.modifiers:
		self.modifiers.append(ActionModifierInstance.new(self, mod))
	for trigger in base_data.triggers:
		self.triggers.append(BaseTriggerInstance.new(self, trigger))
	
func get_modifiers() -> Array[ActionModifierInstance]:
	return self.modifiers
	
func get_triggers():
	pass 
	
