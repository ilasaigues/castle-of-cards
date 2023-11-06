extends Object
class_name MoveContext

enum MoveSource{
	PlayerCard,
	PlayerTrigger,
	EnemyAction,
	EnemyTrigger
}

var parent_move:MoveEffect
var source_action_type:MoveSource
var source_card:CardData
var source_character:CharacterData
var targets:Array[CharacterData]
