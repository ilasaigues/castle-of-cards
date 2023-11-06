extends Object
class_name GameState

var player:CharacterData
var enemies:Array[CharacterData]

var artifacts:Array[ArtifactData]


enum DataType{
	HP,
	DamageDealt,
	DamageTaken,
	Shield,
	HealingDealt,
	HealingTaken,
	EnergyGainPerRound,
	CardDrawPerRound
}

func get_modifier(move_context:MoveContext, type:DataType) -> NumberData:
	var mod = NumberData.new(0)
	if move_context.source_character == player:
		mod.append(player.get_modifier(type))
		for artifact in artifacts:
			mod.append(artifact.get_modifier(type))
	elif move_context.source_character == null:
		for artifact in artifacts:
			mod.append(artifact.get_modifier(type))
	else:
		mod.append(move_context.source_character.get_modifier(type))
	return mod
	
func get_targets(context:MoveContext, target_type:MoveEffect.TargetType):
	var targets:Array[CharacterData]
	match target_type:
		MoveEffect.TargetType.Self:
			targets.append(context.source_character)
		MoveEffect.TargetType.All:
			targets.append(context.source_character)
			targets.append_array(enemies)
		MoveEffect.TargetType.EnemySingle:
			if context.selected_target:
				targets.append(context.selected_target)
			else:
				push_error("enemy single selected but none was provided")
		MoveEffect.TargetType.RandomEnemy:
			if context.source_character == player:
				targets.append(enemies[randi_range(0,enemies.size()-1)])
			else:
				targets.append(player)
		MoveEffect.TargetType.AllAllies:
			if context.source_character == player:
				targets.append(player)
			else:
				targets.append_array(enemies)
		MoveEffect.TargetType.AllAlliesExcludeSelf:
			if context.source_character == player:
				targets.append(player)
			else:
				targets.append_array(enemies)
				targets.erase(context.source_character)
		MoveEffect.TargetType.ParentAffected:
			print("IOU")
		MoveEffect.TargetType.ParentDamaged:
			print("IOU")
		MoveEffect.TargetType.ParentKilled:
			print("IOU")
		MoveEffect.TargetType.ParentHealed:
			print("IOU")
	return targets
