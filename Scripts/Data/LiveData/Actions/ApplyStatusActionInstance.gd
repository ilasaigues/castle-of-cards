extends BaseActionInstance
class_name ApplyStatusActionInstance

func Execute():
	var isActionValid = self.is_action_valid(self.action_context)
	
	if !isActionValid: 
		print("Action was not executed due to actor conditions not met")
		return
	
	# This modifier is supposed to impact the amount of turns right?
	var modType = Enums.StatType.StatusEffectTurns
	
	if !self.base_action is BaseStatusEffectActionData:
		print("Status effect action doesn't have status effect data resource assigned")
	
	var statusEffectApplied = self.base_action.status_effect
	var actionValue:int = self.GetInitialValue()

	print("Applying %s status effect. Initial turn count is %s \n      - %s" % \
		[statusEffectApplied.name, actionValue, statusEffectApplied.description])
	var modifiers = self.GetActorModifiers(modType)
	var turns = BaseActionInstance.GetModifiedOutput(actionValue, modifiers)
	
	for tIdx in range(self.action_context.targets.size()):
		var target = self.action_context.setCurrentTarget(tIdx)
		var isTargetActionValid = self.is_action_valid(self.action_context)
		if !isTargetActionValid:
			print("Action is being executed, but not to this target due to conditions not being met")
			continue
	
		var targetModifiers = self.GetTargetModifiers(modType)
		targetModifiers = targetModifiers.filter(func(tm): return !modifiers.has(tm))
		
		var targetTurns = BaseActionInstance.GetModifiedOutput(turns, targetModifiers)
			
		var matchingSE = target.current_status_effects.filter(\
			func(se:BaseStatusEffectInstance): return se.base_data == statusEffectApplied)
			
		if matchingSE.size() > 0:
			matchingSE[0].turns += targetTurns
		else:
			var newStatusEffect=BaseStatusEffectInstance.new(self.base_action.status_effect, turns,target)
			target.current_status_effects.append(newStatusEffect)
			
		print("Final Result (target %s) -> Applied SE %s to target for %s turns" % [target.base_data.name, statusEffectApplied.name, targetTurns])
		

