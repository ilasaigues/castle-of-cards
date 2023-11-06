extends Node
class_name ArtifactData

@export var modifiers:Array[MoveModifier]

func get_modifier(type:GameState.DataType) -> NumberData:
	return NumberData.new(0)
