extends Object
class_name WorldData

var player:CharacterData

var enemies:Array[CharacterData]

var deck

var hand

func _init():
	enemies.append(CharacterData.new())


func apply_action(action):
	pass
