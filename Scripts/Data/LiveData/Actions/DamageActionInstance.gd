extends BaseActionInstance
class_name DamageActionInstance

func Execute():
	# create list of "responses" to every action
	for target in action_context.targets:
		print ("Prev Target HP: " + str(target.current_hp))
		target.current_hp -= base_action.value
		print ("New Target HP: " + str(target.current_hp))
