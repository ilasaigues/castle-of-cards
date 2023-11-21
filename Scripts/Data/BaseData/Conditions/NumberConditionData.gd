extends BaseConditionData
class_name NumberConditionData

@export var condition_type:Enums.NumberConditionType
@export var value:float

func _init(condition_type:Enums.NumberConditionType, value:bool):
	self.condition_type = condition_type
	self.value = value
