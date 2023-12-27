extends Resource
class_name BaseCardData

@export_category("Card Data")
@export var id:String
@export var name:String
@export var cost:int

@export_category("Usability")
@export var requires_targetting:bool
@export var target: Enums.ActionTargetType
@export var exhaust:bool
@export var x_cost:bool
@export var action_list:Array[BaseActionData]

@export_category("Info")
@export var description:String
@export var sprite:Texture2D
@export var rarity:int
