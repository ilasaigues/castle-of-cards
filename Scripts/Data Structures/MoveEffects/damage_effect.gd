extends MoveEffect
class_name DamageEffect
func apply_effect(move_context:MoveContext,game_state:GameState):
	if are_conditions_met(game_state):
		var base_mod = game_state.get_modifier(move_context,GameState.DataType.DamageDealt)
		
		for target in move_context.targets:
			var final_mod = base_mod.append(target.get_modifier(game_state.DataType.DamageTaken))
			var final_damage = final_mod.Eval(value)
			if final_damage>0:
				target.take_damage(final_damage)
			


