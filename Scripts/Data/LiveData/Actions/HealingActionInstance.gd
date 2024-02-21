extends BaseActionInstance
class_name HealingActionInstance
	
func Execute():
	var actorEffects = self.action_context.actor.current_status_effects
	
	var modType = Enums.StatType.Healing
	var actorModifiers = self.GetModifiers(self.action_context.actor, modType)
	var healing = BaseActionInstance.GetModifiedOutput(base_action.value, actorModifiers)
	
	for target in self.action_context.targets:
		var targetModifiers = self.GetModifiers(target, modType)
		var targetHealing = BaseActionInstance.GetModifiedOutput(healing, targetModifiers)
		print("healing target")
		print(target.current_hp)
		target.current_hp += targetHealing
		print(target.current_hp)

