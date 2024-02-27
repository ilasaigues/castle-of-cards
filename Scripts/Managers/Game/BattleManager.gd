extends Node
class_name BattleManager

var battleData:BaseBattleData

var DeckMngr:DeckManager
var HandMngr:HandManager
var GameMngr:GameManager

var enemies: Array[CharacterInstance]


# Initializes default data
func StartBattle(gameManager:GameManager, deckManager:DeckManager, battleData:BaseBattleData):
	self.battleData=battleData
	DeckMngr = deckManager
	GameMngr = gameManager
	HandMngr = HandManager.new()
	HandMngr.start_new_game(deckManager,GameMngr)
	print("Instantiate enemies")
	for data in battleData.enemies:
		enemies.append(CharacterInstance.new(data))
		var printStr:String = "Enemy instantiated. \n"
		for se in data.starting_status_effects:
			printStr += "     - Status effect: %s (%s)\n" % [se.name, se.description]
		print(printStr)
		
# Runs through the initial phase of starting a battle
func StartPhase():
	print("Start phase started")
	
	var actions:Array[BaseActionInstance] = []
	var currentStatusEffects = []
	for character in enemies:
		currentStatusEffects.append_array(character.current_status_effects)
		for se in character.current_status_effects:
			# Submit an action coreography reflecting the status effect inflictedk
			for trigger in se.triggers:
				actions.append_array(trigger.GetTriggeredActions(Enums.GamePhase.BattleStart, null, self))

	# Artifact SE interactions:
	# - some artifacts can induce status effects
	# - artifacts may deal damage base on status effects?
	# 	- we can make an argument against artifacts that have StartPhase conditionals
	#	with actions that have conditionals. Maybe Artifacts with start phase triggers
	#	should not execute conditioned actions
	# - however, actions from start phase artifacts can be modified by status effects (strength)
	#	 - we can make an argument against having this artifacts ignore player SE.
	#	 and enemies too?
		
		
	for artifact in GameMngr.ArtifactMngr.Artifacts:
		var triggers=artifact.get_triggers()
		
		var artifactTriggerActions:Array[BaseActionInstance]
		for trigger in triggers:
			artifactTriggerActions.append_array(trigger.GetTriggeredActions(Enums.GamePhase.BattleStart, null, self))
		
		if artifactTriggerActions.size() == 0: continue
		
		actions.append_array(artifactTriggerActions)
		print("Instantiating (but not running) artifact's %s triggers (%s), actions (%s). Artifact description: %s" % \
			[artifact.baseData.name,triggers.size(), artifactTriggerActions.size(), artifact.baseData.description])
	
	var actionQueue:Array[BaseActionInstance] = []
	actionQueue.append_array(actions)
	
	# Dont you fucking date touch this. This is the closes thing to a child I'll ever have
	while !actionQueue.is_empty():
		self.SortByStatusEffectModifierAndTriggers(actionQueue)
	
		var action = actionQueue.front()
		actionQueue.remove_at(0)
		action.Execute()
	
		var newStatusEffects:Array[BaseStatusEffectInstance] = []
		for character in enemies + [GameMngr.PlayerCharacter]:
			newStatusEffects.append_array(\
				character.current_status_effects.filter(\
					func(se): return !currentStatusEffects.has(se)\
				)\
			)
			
		var newActions = []
		for se in newStatusEffects:
			currentStatusEffects.append(se)
			for trigger in se.triggers:
				actionQueue.append_array(trigger.GetTriggeredActions(Enums.GamePhase.BattleStart, null, self))
				
	print("Start phase ended")

func StartTurn():
	print("Turn phase started")
	for character in enemies:
		for se in character.current_status_effects:
			# Submit an action coreography reflecting the status effect inflicted
			continue
	
	for artifact in GameMngr.ArtifactMngr.Artifacts:
		var triggers=artifact.get_triggers()
		
		# Triggers are executed iteratively and not interact between each other.
		# Pray to your gods we don't create initial status effects or artifacts with
		# interactions between each other that depend on the order
		var actions = []
		for trigger in triggers:
			actions.append_array(trigger.GetTriggeredActions(Enums.GamePhase.BattleStart, null, self))
		
		if actions.size() == 0: continue
		
		print("Running artifact %s triggers (%s), actions (%s). Artifact description: %s" % \
			[artifact.baseData.name,triggers.size(), actions.size(), artifact.baseData.description])
		for action in actions:
			action.Execute()
	
	print("Start phase ended")

	
# This is absolutely cursed but, it works to a reasonable degree. Please, don't dare to touch it ;
func SortByStatusEffectModifierAndTriggers(actions:Array[BaseActionInstance]):
	actions.sort_custom(func(a1, a2): \
		return (a1 is ApplyStatusActionInstance and !(a2 is ApplyStatusActionInstance)) \
			or (!(a2 is ApplyStatusActionInstance) and !(a1 is ApplyStatusActionInstance)) \
			or (a2 is ApplyStatusActionInstance and a1 is ApplyStatusActionInstance \
				and !(!self.IsPriorityApplyStatusAction(a1) and self.IsPriorityApplyStatusAction(a2))\
			)
	)
	
func IsPriorityApplyStatusAction(action:ApplyStatusActionInstance):
	var isPriority = action.base_action.status_effect.modifiers.any(func(m:BaseActionModifierData): return m.type == Enums.StatType.StatusEffectTurns)
	isPriority = isPriority or action.base_action.status_effect.triggers.any(func(m:BaseTriggerData): \
		return m.triggered_actions.any(func(ta: BaseActionData): return ta is BaseStatusEffectActionData)\
		and m.conditions.any(func(c:BaseConditionData): return c is PhaseConditionData)\
	)
	
	return isPriority
	
func IsPriorityBaseStatusEffectAction(actionData:BaseActionData):
	var isPriority = actionData is BaseStatusEffectActionData
	if !isPriority: return false
	
	var seApplied:BaseStatusEffectData
	seApplied = actionData.status_effect
	
	var seHasSeModifiers = seApplied.modifiers.any(\
		func(mod:BaseActionModifierData): return mod.type==Enums.StatType.StatusEffectTurns\
	)
	if seHasSeModifiers: return true
	
	return seApplied.triggers.any(func(triggerData:BaseTriggerData):\
		return (triggerData.conditions.any(func(c:BaseConditionData): return c is PhaseConditionData)) \
			and triggerData.triggered_actions.any(func(ta: BaseActionData): return self.IsPriorityBaseStatusEffectAction(ta) )
	)
	
