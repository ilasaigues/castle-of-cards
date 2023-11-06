extends Resource
class_name CardData


@export var cost:int
@export var effects:Array[MoveEffect]
@export var description:String

func get_parsed_description():
	var desc = description
	for i in range(0,effects.size()):
		desc = desc.replace(str("{",i,"}"),str(effects[i].value))
	return desc
