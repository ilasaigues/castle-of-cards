extends BaseActionInstance
class_name HealingActionInstance
	
func Execute():
	var actorEffects = self.action_context.actor.current_status_effects
	
	var modType = Enums.StatType.Healing
	var actorModifiers = self.GetActorModifiers(modType)
	print("Original healing %s" % base_action.value)
	var healing = BaseActionInstance.GetModifiedOutput(base_action.value, actorModifiers)
	
	for tIdx in range(self.action_context.targets.size()):
		var target = self.action_context.setCurrentTarget(tIdx)
		var targetModifiers = self.GetTargetModifiers(modType)
		targetModifiers = targetModifiers.filter(func(tm): return !actorModifiers.has(tm))
		var targetHealing = BaseActionInstance.GetModifiedOutput(healing, targetModifiers)
		print("Healed target from %s to %s" % [target.current_hp, target.current_hp+targetHealing])
		target.current_hp += targetHealing
		
