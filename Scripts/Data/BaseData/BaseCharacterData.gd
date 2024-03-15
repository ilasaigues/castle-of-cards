extends Resource
class_name BaseCharacterData

@export var id:String = ""
@export var name:String = ""
@export var prefab:Node = null
@export var max_hp:int = 0
@export var starting_status_effects:Array[BaseStatusEffectData] = []
@export var starting_status_effects_turns:Array[int] = []
@export var is_player:bool = false

# Remove later
@export var starting_defense:int
