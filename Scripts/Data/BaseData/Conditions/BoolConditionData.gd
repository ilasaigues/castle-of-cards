extends BaseConditionData
class_name BoolConditionData

@export var condition_type:Enums.BoolConditionType
@export var value:bool

func _init(condition_type:Enums.BoolConditionType, value:bool):
	self.condition_type = condition_type
	self.value = value

