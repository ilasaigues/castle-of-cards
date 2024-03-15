extends Node
class_name BattleManager

var BattleData:BaseBattleData

var DeckMngr:DeckManager
var HandMngr:HandManager
var GameMngr:GameManager

var playerTurn:bool
var enemies: Array[CharacterInstance]

# Initializes default data
func StartBattle(gameManager:GameManager, deckManager:DeckManager, battleData:BaseBattleData):
	self.BattleData = battleData
	DeckMngr = deckManager
	GameMngr = gameManager
	HandMngr = HandManager.new()
	HandMngr.start_new_game(deckManager,GameMngr)
	self.playerTurn=true
	print("Instantiate enemies")
	for data in self.BattleData.enemies:
		enemies.append(CharacterInstance.new(data))
		var printStr:String = "Enemy instantiated. \n"
		for se in data.starting_status_effects:
			printStr += "     - Status effect: %s (%s)\n" % [se.name, se.description]
		print(printStr)
		
# Runs through the initial phase of starting a battle
func StartPhase():
	print("Start phase started")
	self.RunArtifactsAndStatusEffectsTriggers(Enums.GamePhase.BattleStart)
	print("Start phase ended")

func StartTurn():
	print("Turn phase started")
	
	if self.playerTurn:
		self.CharacterDefenseReset(self.GameMngr.PlayerCharacter)
		self.HandMngr.new_turn()
	else:
		for enemy in self.enemies:
			self.CharacterDefenseReset(enemy)

	self.RunArtifactsAndStatusEffectsTriggers(Enums.GamePhase.TurnStart)
	print("Turn phase start ended")

func PlayCard(cardIdx:int, targets:Array[CharacterInstance]):
	print("Active turn phase started")
	self.HandMngr.play_card(cardIdx, targets)
	print("Active turn phase ended")

func CharacterDefenseReset(character:CharacterInstance):
	var defenseAC = ActionContext.new(Enums.GamePhase.PreTurnStart, null, [character], null, [])
	
	var valueData = BaseValueData.new()
	valueData.valueType = Enums.ValueType.ResetStat

	var defenseBreakAD = BaseActionData.new()
	defenseBreakAD.type = Enums.ActionType.DefenseAction
	defenseBreakAD.value = valueData
	
	BaseActionInstance.GetActionInstance(defenseBreakAD, defenseAC, self)\
		.Execute()
	
func EndTurn():
	pass

func RunArtifactsAndStatusEffectsTriggers(phase:Enums.GamePhase,previousAction:ActionContext=null):
	var actions:Array[BaseActionInstance] = []
	var currentStatusEffects = []
	var playerCharacter:CharacterInstance = GameMngr.PlayerCharacter
	
	for character in enemies + [playerCharacter]:
		currentStatusEffects.append_array(character.current_status_effects)
		for se in character.current_status_effects:
			var seTriggerActions:Array[BaseActionInstance]=[]
			for trigger in se.triggers:
				seTriggerActions.append_array(trigger.GetTriggeredActions(phase, previousAction, self))
				
			if seTriggerActions.size() == 0: continue

			actions.append_array(seTriggerActions)
			print("Creating Trigger actions for Status Effect %s #(%s)" % [se.base_data.name, seTriggerActions.size()])

	for artifact in GameMngr.ArtifactMngr.Artifacts:
		var triggers=artifact.get_triggers()
		
		var artifactTriggerActions:Array[BaseActionInstance]=[]
		for trigger in triggers:
			artifactTriggerActions.append_array(trigger.GetTriggeredActions(phase, previousAction, self))
		
		if artifactTriggerActions.size() == 0: continue
		
		print("Creating Trigger actions for artifact %s #(%s)" % [artifact.baseData.name, artifactTriggerActions.size()])
		actions.append_array(artifactTriggerActions)
	
	var actionQueue:Array[BaseActionInstance] = []
	actionQueue.append_array(actions)
	
	# Dont you fucking dare touch this. This is the closes thing to a child I'll ever have
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
			
		for se in newStatusEffects:
			currentStatusEffects.append(se)
			for trigger in se.triggers:
				actionQueue.append_array(trigger.GetTriggeredActions(phase, previousAction, self))
				
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
	
