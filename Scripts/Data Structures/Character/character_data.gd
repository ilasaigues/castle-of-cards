extends Node
class_name CharacterData

@export var hp:int = 20
@export var shield:int


func take_damage(damage:int):
	print (str("taking ",damage," damage"))
	print (str("HP before: ",hp))
	hp-=damage;
	print (str("HP after: ",hp))
	if hp <= 0:
		print("ded")

func get_modifier(type:GameState.DataType) -> NumberData:
	return NumberData.new(0)
