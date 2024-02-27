extends Resource
class_name BaseTriggerData

@export var trigger_action_type:Enums.ActionType
@export var conditions:Array[BaseConditionData]
@export var target:Enums.TriggerTargetType
@export var triggered_actions:Array[BaseActionData]
@export var trigger_actor:Enums.TriggerActor
