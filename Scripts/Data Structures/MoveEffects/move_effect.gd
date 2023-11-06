extends Resource
class_name MoveEffect

enum TargetType
{
	NONE,
	Self,
	All, 
	EnemySingle,
	RandomEnemy,
	AllAllies,
	AllAlliesExcludeSelf,
	ParentAffected,
	ParentDamaged,
	ParentKilled,
	ParentHealed
}

@export var target:TargetType
@export var value:float

@export var conditionals:Array[MoveEffectConditional]

@export var sub_moves:Array[MoveEffect]


func apply_effect(move_data:MoveContext,game_state:GameState):
	pass
	
func are_conditions_met(game_state:GameState):
	var valid = true
	for conditional in conditionals:
		if !conditional.is_met(game_state):
			valid = false
			break
	return valid
