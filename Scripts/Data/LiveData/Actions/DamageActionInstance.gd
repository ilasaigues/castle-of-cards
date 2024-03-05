extends BaseActionInstance
class_name DamageActionInstance

func Execute():
	var modType = Enums.StatType.Damage

	var actionValue:int = self.GetInitialValue()

	print("Damage action. Initial damage %s" % actionValue)
	var modifiers = self.GetActorModifiers(modType)
	var damage = BaseActionInstance.GetModifiedOutput(actionValue, modifiers)
	
	for tIdx in range(self.action_context.targets.size()):
		var target = self.action_context.setCurrentTarget(tIdx)
		var targetModifiers = self.GetTargetModifiers(modType)
		targetModifiers = targetModifiers.filter(func(tm): return !modifiers.has(tm))
		
		var targetDmg = BaseActionInstance.GetModifiedOutput(damage, targetModifiers)
		print("Damaged target %s from %s to %s" % [target.base_data.name, target.current_hp, target.current_hp-targetDmg])
		
		target.current_hp -= targetDmg		
		self.action_context.result = targetDmg

		print("Checking for triggers after damaging")
		self.battle_manager.RunArtifactsAndStatusEffectsTriggers(Enums.GamePhase.ResponsePhase, self.action_context)
		print("Ran all triggers")
