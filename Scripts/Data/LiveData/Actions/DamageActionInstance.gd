extends BaseActionInstance
class_name DamageActionInstance

func Execute():
	var actorEffects = self.action_context.actor.current_status_effects
	
	var modType = Enums.StatType.Damage
	var modifiers = self.GetModifiers(self.action_context.actor, modType)
	var damage = BaseActionInstance.GetModifiedOutput(base_action.value, modifiers)
	for target in self.action_context.targets:
		var targetModifiers = self.GetModifiers(target, modType)
		var targetDmg = BaseActionInstance.GetModifiedOutput(damage, targetModifiers)
		print("dealing damage to target")
		print(target.current_hp)
		target.current_hp -= targetDmg
		print(target.current_hp)

#GetActorModifiers
