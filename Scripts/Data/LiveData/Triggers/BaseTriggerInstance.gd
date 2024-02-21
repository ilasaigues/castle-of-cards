extends Object
class_name BaseTriggerInstance

var trigger_action_type:Enums.ActionType
var conditions:Array[BaseConditionData]
var triggered_actions:Array[BaseActionInstance]

func _init(base_data:BaseTriggerData):
	self.triggered_action_type=base_data.trigger_action_type
	self.conditions=base_data.conditions
#	self.triggered_actions=base_data.triggered_actions 
	
