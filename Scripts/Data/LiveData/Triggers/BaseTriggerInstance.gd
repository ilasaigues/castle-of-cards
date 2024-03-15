extends Object
class_name BaseTriggerInstance

var trigger_action_type:Enums.ActionType
var conditions:Array[BaseConditionData]
var target:Enums.TriggerTargetType
var triggered_actions:Array[BaseActionData]
var trigger_actor:Enums.TriggerActor
var triggerSource

func _init(source, base_data:BaseTriggerData):
	self.trigger_action_type=base_data.trigger_action_type
	self.conditions=base_data.conditions
	self.target=base_data.target
	self.triggered_actions=base_data.triggered_actions
	self.trigger_actor=base_data.trigger_actor
	self.triggerSource = source
	
# Assume that this is called when battle starts. What do I need?
func GetTriggeredActions(phase:Enums.GamePhase,\
	previousAction:ActionContext,\
	battleMngr:BattleManager) -> Array[BaseActionInstance]:
	
	# Generate a dummy action context for computing valid triggers such as when
	# start turn phase begins
	if previousAction == null:
		
		var sourceCharacter: CharacterInstance
		# Artifacts can have actions that are executed as by the player
		if self.trigger_actor == Enums.TriggerActor.ArtifactTriggerByPlayer:
			sourceCharacter=battleMngr.GameMngr.PlayerCharacter
			
		previousAction = ActionContext.new(phase, sourceCharacter, [], null, [])
	
	if !is_trigger_valid(phase,previousAction,battleMngr): return []
	
	var actions:Array[BaseActionInstance]=[]
	for actionData in self.triggered_actions:
		# Create a context and execute action ()
		var actor = previousAction.actor
		
		# Status effects can create environment actions or character actions.
		# This changes whether Character status effects are applied
		if self.triggerSource is BaseStatusEffectInstance: 
			if self.trigger_actor == Enums.TriggerActor.StatusEffect:
				actor = self.triggerSource.character
			if self.trigger_actor == Enums.TriggerActor.StatusEffectEnvironment:
				actor = null
		elif self.triggerSource is ArtifactInstance:
			if self.trigger_actor == Enums.TriggerActor.ArtifactTriggerByEnvironment:
				actor = null

		var targets = get_trigger_targets(previousAction, battleMngr)
		
		var triggeredActionContext = ActionContext.new(phase,\
			actor,\
			targets,\
			null,\
			battleMngr.GameMngr.ArtifactMngr.Artifacts)
		triggeredActionContext.result = previousAction.result
		triggeredActionContext.source_trigger = self
		
		var action = BaseActionInstance.GetActionInstance(actionData,triggeredActionContext,battleMngr)
		actions.append(action)
		
	return actions
	
func get_trigger_targets(actionContext:ActionContext,battleMngr:BattleManager) -> Array[CharacterInstance]:
	var targets:Array[CharacterInstance]=[]
	var player = battleMngr.GameMngr.PlayerCharacter
	match self.target:
		Enums.TriggerTargetType.Self:
			if self.triggerSource is BaseStatusEffectInstance:
				targets = [self.triggerSource.character]
		Enums.TriggerTargetType.Player:
			targets = [player]
		Enums.TriggerTargetType.ActorEnemy:
			if actionContext.action_instance == null: targets = []
			else: targets = [actionContext.actor]
		Enums.TriggerTargetType.RandomEnemy:
			var playerEnemies = battleMngr.enemies
			if self.triggerSource is ArtifactInstance and playerEnemies.size() > 0: 
				var idx = randi() % battleMngr.enemies.size()
				targets = [playerEnemies[idx]] 
			elif self.triggerSource is BaseStatusEffectInstance:
				if self.triggerSource.character == player:
					if playerEnemies.size() == 0: targets = []
					var idx = randi() % battleMngr.enemies.size()
					targets = [playerEnemies[idx]] 
				else:
					targets = [player]
		Enums.TriggerTargetType.RandomCharacter:
			var allTrgts = [player] + battleMngr.enemies
			targets = [ allTrgts[randi() % allTrgts.size()] ]
		Enums.TriggerTargetType.AllEnemies:
			var playerEnemies = battleMngr.enemies
			if self.triggerSource is ArtifactInstance:
				targets = playerEnemies 
			elif self.triggerSource is BaseStatusEffectInstance:
				if self.triggerSource.character == player:
					targets = playerEnemies 
				else:
					targets = [player]
		Enums.TriggerTargetType.All:
			targets = [player] + battleMngr.enemies
		Enums.TriggerTargetType.AllAllies:
			if self.triggerSource is BaseStatusEffectInstance:
				if self.triggerSource.character != player:
					targets = battleMngr.enemies.duplicate()
					targets.erase(self.triggerSource.character)
			else:
				printerr("All allies target artifact should not exist")
			
	return targets
	
func is_trigger_valid(phase:Enums.GamePhase,context:ActionContext,battleMngr:BattleManager) -> bool:
	var valid = true
	valid = valid and (context.action_instance == null or \
		context.action_instance.base_action.fireTriggers)
	
	for condition in self.conditions:
		if condition is BoolConditionData:
			valid = valid and check_bool_condition(context, condition)
		if condition is NumberConditionData:
			valid = valid and check_number_condition(context, condition)
		if condition is PhaseConditionData:
			valid = valid and check_phase_condition(phase, condition, battleMngr)
		if condition is TriggerConditionData:
			valid = valid and check_trigger_condition(context, condition)
	return valid

func check_bool_condition(context:ActionContext, condition:BoolConditionData) -> bool:
	if context == null: return false
	
	match condition.condition_type:
		# What differs between this condition and the targetIsDeath trigger condition?
		# Keep them separated for now until we confirm these can be expressed as triggerCondition
		Enums.BoolConditionType.TargetIsDead:
			return context.targets.any(func(t): return !t.is_alive())
		_:
			printerr("Trigger boolean condition is invalid")
			return false
			
func check_number_condition(context:ActionContext, condition:NumberConditionData) -> bool:
	match condition.condition_type:
		Enums.NumberConditionType.ArtifactCounterEquals:
			if self.triggerSource is ArtifactInstance:
				var artifact = self.triggerSource as ArtifactInstance
				return fmod(artifact.count, condition.numberConditionValue) == 0
			print_rich("[color=#FF0000]ERROR: ARTIFACT CONDITION IN NON-ARTIFACT MODIFIER[/color]")
			return false
		Enums.NumberConditionType.CharacterHPLessThan:
			return self.triggerSource is BaseStatusEffectInstance and\
				self.triggerSource.character.current_hp < condition.numberConditionValue
		Enums.NumberConditionType.TargetHPLessThan:
			return self.triggerSource is BaseStatusEffectInstance and\
				context.current_target_eval.current_hp < condition.numberConditionValue
		_:
			printerr("Trigger number condition is invalid")
			return false

func check_phase_condition(phase:Enums.GamePhase, condition:PhaseConditionData, battleMngr:BattleManager) -> bool:
	var isValid:bool = phase == condition.phase	

	if !isValid: return false
	match phase:
		Enums.GamePhase.TurnStart:
			return is_character_turn(battleMngr)
		Enums.GamePhase.TurnEnd:
			return is_character_turn(battleMngr)

	return isValid

func is_character_turn(battleMngr:BattleManager):
	if !(self.triggerSource is BaseStatusEffectInstance): return true
	var isPlayerTurnAndTrigger = battleMngr.playerTurn and self.triggerSource.character.base_data.is_player
	var isEnemyTurnAndTrigger = !battleMngr.playerTurn and battleMngr.enemies.has(self.triggerSource.character)
	var isValid = isPlayerTurnAndTrigger or isEnemyTurnAndTrigger
	return isValid

func check_trigger_condition(context:ActionContext, condition:TriggerConditionData) -> bool:
	if context.action_instance == null: return false
	
	match condition.condition_type:
		Enums.TriggerConditionType.ActorExecutesAction:
			var actionType = context.action_instance.base_action.type
			if actionType == null: 
				printerr("Shouldnt have an ActorExecutesAction condition without a type")
				return false
			var valid = condition.actionType == actionType
			valid = valid and (condition.triggerConditionValue == 0 or context.result >= condition.triggerConditionValue)
			return valid 
		Enums.TriggerConditionType.ActorExectuesActionTarget:
			var actionType = context.action_instance.base_action.type
			var valid = condition.actionType == null or condition.actionType == actionType
			valid = valid and self.triggerSource is BaseStatusEffectInstance
			valid = valid and context.current_target_eval == self.triggerSource.character
			valid = valid and (condition.triggerConditionValue == 0 or context.result >= condition.triggerConditionValue)
			return valid 
		Enums.TriggerConditionType.ActorKillsTrigger:
			var actionType = context.action_instance.base_action.type
			var valid = actionType == Enums.ActionType.DamageAction
			valid = valid and self.triggerSource is BaseStatusEffectInstance
			valid = valid and context.targets.has(self.triggerSource.character)
			valid = valid and !self.triggerSource.character.is_alive()
			return valid
		_:
			printerr("Trigger trigger condition is invalid")
			return false
				
