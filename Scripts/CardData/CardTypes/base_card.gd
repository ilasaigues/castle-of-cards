extends Resource
class_name BaseCard

@export var cost:int
@export var name:String
#@export var image:Texture2D
@export var properties:Array[CardProperty]
@export var description:String


func get_parsed_description():
	var desc = description
	for i in range(0,properties.size()):
		desc = desc.replace(str("{",i,"}"),str(properties[i].parameter))
	return desc
