extends BaseActionInstance
class_name ApplyStatusActionInstance

func Execute():
	var actorEffects = self.action_context.actor.current_status_effects
	
	# This modifier is supposed to impact the amount of turns right?
	var modType = Enums.StatType.StatusEffectAmount
	var modifiers = self.GetModifiers(self.action_context.actor, modType)
	print("Original status effect amount %s" % base_action.value)
	print("No clue on how to apply new status effects")
#	
#	var turns = BaseActionInstance.GetModifiedOutput(base_action.value, modifiers)
#	print(Enums.ActionType.keys()[self.base_action.type])
#	var statusEffectApplied = self.base_action.statusEffectType
#
#	for target in self.action_context.targets:
#		var targetModifiers = self.GetModifiers(target, modType)
#		var targetTurns = BaseActionInstance.GetModifiedOutput(turns, targetModifiers)
#		print("applied SE % to target for %s turns" % [\
#			Enums.StatusEffectType.keys()[statusEffectApplied], targetTurns])
#		var matchingSE = target.current_status_effects.filter(\
#			func(se:BaseStatusEffectInstance): return se.type == statusEffectApplied)
#		if matchingSE.size() > 0:
#			matchingSE[0].turns += targetTurns

