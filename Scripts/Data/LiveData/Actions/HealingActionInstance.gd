extends BaseActionInstance
class_name HealingActionInstance
	
func Execute():
	var isActionValid = self.is_action_valid(self.action_context)
	
	if !isActionValid: 
		print("Action was not executed due to actor conditions not met")
		return
		
	var actionValue:int = self.GetInitialValue()
	var modType = Enums.StatType.Healing
	var actorModifiers = self.GetActorModifiers(modType)
	
	print("Healing targets. Initial value is %s. Actor modifiers (%s)" % [actionValue, actorModifiers.size()])
	var healing = BaseActionInstance.GetModifiedOutput(actionValue, actorModifiers)
	
	for tIdx in range(self.action_context.targets.size()):
		var target = self.action_context.setCurrentTarget(tIdx)
		var targetModifiers = self.GetTargetModifiers(modType)
		targetModifiers = targetModifiers.filter(func(tm): return !actorModifiers.has(tm))
		var targetHealing = BaseActionInstance.GetModifiedOutput(healing, targetModifiers)
		print("Healed target %s from %s to %s" % [target.base_data.name, target.current_hp, target.current_hp+targetHealing])
		target.current_hp += targetHealing
		
