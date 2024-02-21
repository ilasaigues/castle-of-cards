extends BaseActionInstance
class_name ApplyStatusActionInstance

func Execute():
	var actorEffects = self.action_context.actor.current_status_effects
	
	# This modifier is supposed to impact the amount of turns right?
	var modType = Enums.StatType.StatusEffectAmount
	var modifiers = self.GetModifiers(self.action_context.actor, modType)
	print("Original status effect amount %s" % base_action.value)
	var damage = BaseActionInstance.GetModifiedOutput(base_action.value, modifiers)
	
	for target in self.action_context.targets:
		var targetModifiers = self.GetModifiers(target, modType)
		print(targetModifiers.size())
		var targetDmg = BaseActionInstance.GetModifiedOutput(damage, targetModifiers)
		print("Damaged target from %s to %s" % [target.current_hp, target.current_hp-targetDmg])
		target.current_hp -= targetDmg

