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
	for statusEffectData in baseData.starting_status_effects:
		current_status_effects.append(BaseStatusEffectInstance.new(statusEffectData))

