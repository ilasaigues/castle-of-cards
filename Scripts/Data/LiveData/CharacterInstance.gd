extends Object
class_name CharacterInstance

var base_data:BaseCharacterData

var current_hp = 0

var current_defense = 0

var current_status_effects:Array[BaseStatusEffectInstance]

func is_alive():
	return current_hp > 0

func _init(baseData:BaseCharacterData):
	self.base_data = baseData
	current_hp = baseData.max_hp
	print("initializing character")
	for statusEffectData in baseData.starting_status_effects:
		print(statusEffectData.modifiers.size())
		print(statusEffectData.modifiers[0].modifier_conditionals.size())
		current_status_effects.append(BaseStatusEffectInstance.new(statusEffectData))
	print("char end")

