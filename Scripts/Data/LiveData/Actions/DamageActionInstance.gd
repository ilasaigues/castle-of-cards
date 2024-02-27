extends BaseActionInstance
class_name DamageActionInstance

func Execute():
	var modType = Enums.StatType.Damage
	
	var modifiers = self.GetActorModifiers(modType)
	print("Damage action. Initial damage %s" % base_action.value)
	var damage = BaseActionInstance.GetModifiedOutput(base_action.value, modifiers)
	
	for tIdx in range(self.action_context.targets.size()):
		var target = self.action_context.setCurrentTarget(tIdx)
		var targetModifiers = self.GetTargetModifiers(modType)
		targetModifiers = targetModifiers.filter(func(tm): return !modifiers.has(tm))
		
		var targetDmg = BaseActionInstance.GetModifiedOutput(damage, targetModifiers)
		print("Damaged target from %s to %s" % [target.current_hp, target.current_hp-targetDmg])
		target.current_hp -= targetDmg

