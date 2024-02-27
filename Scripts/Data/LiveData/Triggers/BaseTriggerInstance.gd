extends Object
class_name BaseTriggerInstance

var trigger_action_type:Enums.ActionType
var conditions:Array[BaseConditionData]
var target:Enums.TriggerTargetType
var triggered_actions:Array[BaseActionData]
var trigger_actor:Enums.TriggerActor
var source

func _init(source, base_data:BaseTriggerData):
	self.trigger_action_type=base_data.trigger_action_type
	self.conditions=base_data.conditions
	self.target=base_data.target
	self.triggered_actions=base_data.triggered_actions
	self.trigger_actor=base_data.trigger_actor
	self.source = source
	
# Assume that this is called when battle starts. What do I need?
func GetTriggeredActions(phase:Enums.GamePhase,\
	actionContext:ActionContext,\
	battleMngr:BattleManager) -> Array[BaseActionInstance]:
	
	# Generate a dummy action context for computing valid triggers such as when
	# start turn phase begins
	if actionContext == null:
		var sourceCharacter: CharacterInstance
		
		# Artifacts can have actions that are executed as by the player
		if self.trigger_actor == Enums.TriggerActor.ArtifactTriggerByPlayer:
			sourceCharacter=battleMngr.GameMngr.PlayerCharacter
			
		actionContext = ActionContext.new(phase, sourceCharacter, [], null, [])
		
	if !is_trigger_valid(actionContext): return []
		
		
	var actions:Array[BaseActionInstance]=[]
	for actionData in self.triggered_actions:
		# Create a context and execute action ()
		var actor = actionContext.actor
		# If source is an arttifact, we will most likely want to animate that,
		# but we can't while action context reference only character instances
		if source is BaseStatusEffectInstance: actor = source.character
		
		var targets = get_trigger_targets(actionContext, battleMngr)
		
		var triggeredActionContext = ActionContext.new(phase,\
			actor,\
			targets,\
			null,\
			battleMngr.GameMngr.ArtifactMngr.Artifacts)
			
		var action = BaseActionInstance.GetActionInstance(actionData,triggeredActionContext)
		actions.append(action)
		
	return actions
	
func get_trigger_targets(actionContext:ActionContext,battleMngr:BattleManager) -> Array[CharacterInstance]:
	var targets:Array[CharacterInstance]=[]
	var player = battleMngr.GameMngr.PlayerCharacter
	match self.target:
		Enums.TriggerTargetType.Player:
			targets = [player]
		Enums.TriggerTargetType.ActorEnemy:
			if actionContext.action_instance == null: targets = []
			else: targets = [actionContext.actor]
		Enums.TriggerTargetType.RandomEnemy:
			var playerEnemies = battleMngr.enemies
			if source is ArtifactInstance and playerEnemies.size() > 0: 
				var idx = randi() % battleMngr.enemies.size()
				targets = [playerEnemies[idx]] 
			elif source is BaseStatusEffectInstance:
				if source.character == player:
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
			if source is ArtifactInstance:
				targets = battleMngr.enemies 
			elif source is BaseStatusEffectInstance:
				if source.character == player:
					targets = battleMngr.enemies 
				else:
					targets = [player]
		Enums.TriggerTargetType.All:
			targets = [player] + battleMngr.enemies
		Enums.TriggerTargetType.AllAllies:
			if source is BaseStatusEffectInstance:
				if source.character != player:
					targets = battleMngr.enemies.duplicate()
					targets.erase(source.character)
			else:
				printerr("All allies target artifact should not exist")
			
	return targets
	
func is_trigger_valid(context:ActionContext) -> bool:
	var valid = true
	for condition in self.conditions:
		if condition is BoolConditionData:
			valid = valid and check_bool_condition(context, condition)
		if condition is NumberConditionData:
			valid = valid and check_number_condition(context, condition)
		if condition is PhaseConditionData:
			valid = valid and check_phase_condition(context, condition)
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
			if source is ArtifactInstance:
				var artifact = source as ArtifactInstance
				return artifact.count == self.amount
			print_rich("[color=#FF0000]ERROR: ARTIFACT CONDITION IN NON-ARTIFACT MODIFIER[/color]")
			return false
		Enums.NumberConditionType.CharacterHPLessThan:
			return source is BaseStatusEffectInstance and\
				 source.character.current_target_eval.current_hp < self.amount
		_:
			printerr("Trigger number condition is invalid")
			return false
func check_phase_condition(context:ActionContext, condition:PhaseConditionData) -> bool:	
	return context.phase == condition.phase
	
func check_trigger_condition(context:ActionContext, condition:TriggerConditionData) -> bool:
	if context.action_instance == null: return false
	
	match condition.condition_type:
		Enums.TriggerConditionType.ActorExecutesAction:
			var actionType = context.action_instance.base_action.type
			if actionType == null: 
				printerr("Shouldnt have an ActorExecutesAction condition without a type")
				return false
			var valid = condition.actionType == actionType
			valid = valid and (condition.amount == 0 or context.result >= condition.amount)
			return valid 
		Enums.TriggerConditionType.ActorExectuesActionTarget:	
			var actionType = context.action_instance.base_action.type
			var valid = condition.actionType == null or condition.actionType == actionType
			valid = valid and source is BaseStatusEffectInstance
			valid = valid and context.targets.has(source.character)
			valid = valid and (condition.amount == 0 or context.result >= condition.amount)
			return valid 
		Enums.TriggerConditionType.ActorKillsTrigger:
			var actionType = context.action_instance.base_action.type
			var valid = actionType == Enums.ActionType.DamageAction
			valid = valid and source is BaseStatusEffectInstance
			valid = valid and context.targets.has(source.character)
			valid = valid and !source.character.is_alive()
			return valid
		_:
			printerr("Trigger trigger condition is invalid")
			return false
				
