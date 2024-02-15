extends BaseActionInstance
class_name DamageActionInstance

func Execute():
	var actorEffects = self.action_context.actor.current_status_effects
	var actorModifiers = self.GetActorModifiers()

	# Get modifiers for actor that increase damage
	var filteredModifier: Array[ActionModifierInstance]
	filteredModifier.assign(\
		actorModifiers\
			.filter(func(mod) : return mod.is_valid(self.action_context))\
			.filter(func(mod) : return mod.type == Enums.StatType.Damage)\
		)

	var damage = BaseActionInstance.GetModifiedOutput(base_action.value, filteredModifier)
	
	for target in self.action_context.targets:
		var targetModifiers: Array[ActionModifierInstance]
		for effect in target.current_status_effects:
			targetModifiers.append_array(effect.get_modifiers())

		# Get modifiers for target that affect damage
		var filteredTargetModifiers: Array[ActionModifierInstance]
		filteredTargetModifiers.assign(\
			targetModifiers\
				.filter(func(mod) : return mod.is_valid(self.action_context))\
				.filter(func(mod) : return mod.type == Enums.StatType.Damage)\
		)

		var targetDmg = BaseActionInstance.GetModifiedOutput(damage, filteredTargetModifiers)
		print("dealing damage to target")
		print(target.current_hp)
		target.current_hp -= targetDmg
		print(target.current_hp)

#GetActorModifiers
