extends BaseActionInstance
class_name HealingActionInstance
	
func Execute():
	var actorEffects = self.action_context.actor.current_status_effects
	
	var modType = Enums.StatType.Healing
	var actorModifiers = self.GetModifiers(self.action_context.actor, modType)
	print("Original healing %s" % base_action.value)
	var healing = BaseActionInstance.GetModifiedOutput(base_action.value, actorModifiers)
	
	for target in self.action_context.targets:
		var targetModifiers = self.GetModifiers(target, modType)
		var targetHealing = BaseActionInstance.GetModifiedOutput(healing, targetModifiers)
		print("Healed target from %s to %s" % [target.current_hp, target.current_hp+targetHealing])
		target.current_hp += targetHealing
		
