extends Node
class_name CharacterData

var _hp: int = 20
var _armor: int = 0


func apply_action(action):
	pass



func take_damage(damage:int):
	_hp -= damage
	if _hp <= 0:
		print("ded")
