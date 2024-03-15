extends Resource
class_name BaseActionData
# This class holds the template data for an action of any type.
# An actual instance of the action will be created based on this, with the type determined by the first variable
@export var type:Enums.ActionType
@export var value: BaseValueData
@export var conditions:Array[BaseConditionData]=[]
@export var fireTriggers:bool=true

