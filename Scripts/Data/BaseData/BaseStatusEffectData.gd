extends Resource
class_name BaseStatusEffectData

@export var name:String
@export var description:String
@export var modifiers:Array[BaseActionModifierData]=[]
@export var triggers:Array[BaseTriggerData]=[]
@export var isBuff:bool

