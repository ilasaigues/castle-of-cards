extends Object
class_name BaseActionInstance

var base_action:BaseActionData
var action_context:ActionContext
var battle_manager:BattleManager

const NULL_INT:int = -1
var modType: Enums.StatType: get = get_mod_type

func _init(baseAction:BaseActionData, actionContext:ActionContext, battleManager:BattleManager):
	self.base_action = baseAction
	self.action_context = actionContext
	self.battle_manager = battleManager
	action_context.action_instance = self
	
func is_action_valid(actionContext: ActionContext):
	var valid = true
	for condition in base_action.conditions:
		if condition is BoolConditionData:
			valid = valid and check_bool_condition(actionContext,condition)
		if condition is NumberConditionData:
			valid = valid and check_number_condition(actionContext,condition)
		if condition is PhaseConditionData:
			valid = valid and check_phase_condition(actionContext,condition)
		if condition is StatusEffectConditionData:
			valid = valid and check_status_effect_condition(actionContext,condition)
	return valid
	
# Can we delete this? Actions are only executed during turns? Well not really. Action
# executions seem to check whether they are valid or not. Actions can be executed by triggers
# outside of the regular turn phase. This means there ARE actions executed in different phases
# Whether we allow for conditioned actions in triggers is the relevant question. We could but
# have them not have phase conditions
func check_phase_condition(_actionContext:ActionContext,condition:PhaseConditionData):
	match condition.phase:
		_:
			return true
			
func check_bool_condition(_actionContext:ActionContext,condition:BoolConditionData):
	match condition.condition_type:
		Enums.BoolConditionType.TargetIsDead:
			return self.action_context.targets.any(func(t): return !t.is_alive())
		_:
			return true
			
func check_number_condition(actionContext:ActionContext,condition:NumberConditionData):
	match condition.condition_type:
		Enums.NumberConditionType.TargetHPLessThan:
			return actionContext.current_target_eval == null or \
				actionContext.current_target_eval.current_hp < condition.numberConditionValue
		Enums.NumberConditionType.ActorHPLessThan:
			return actionContext.current_target_eval != null or \
				actionContext.actor.current_hp < condition.numberConditionValue

func check_status_effect_condition(actionContext: ActionContext, condition: StatusEffectConditionData):
	match condition.condition_type:
		Enums.StatusEffectConditionType.TargetHasStatusEffect:
			return actionContext.current_target_eval == null or \
				actionContext.current_target_eval.current_status_effects\
					.any(func(se:BaseStatusEffectInstance): return se.base_data == condition.status_effect)
		Enums.StatusEffectConditionType.ActorHasStatusEffect:
			return actionContext.current_target_eval != null or \
				actionContext.actor.current_status_effects\
					.any(func(se:BaseStatusEffectInstance): return se.base_data == condition.status_effect)
		
		
func GetModifiers(character: CharacterInstance,modStatType: Enums.StatType) -> Array[ActionModifierInstance]:
	var modifiers:Array[ActionModifierInstance] = []
	
	if character != null:
		for status in character.current_status_effects:
			modifiers.append_array(status.get_modifiers())
			
	for artifact in self.action_context.artifacts:
		modifiers.append_array(artifact.get_modifiers())
	
	## heavy hitter mod stat type does not match?
	var filteredModifier: Array[ActionModifierInstance]=[]
	filteredModifier.assign(\
		modifiers\
			.filter(func(mod) : return mod.is_valid(self.action_context))\
			.filter(func(mod) : return mod.type == modStatType)\
		)
	return filteredModifier

func GetActorModifiers(modStatType: Enums.StatType) -> Array[ActionModifierInstance]:
	return GetModifiers(self.action_context.actor,modStatType)

func GetTargetModifiers(modStatType: Enums.StatType) -> Array[ActionModifierInstance]:
	return GetModifiers(self.action_context.current_target_eval,modStatType)
	
static func GetActionInstance(baseAction:BaseActionData,context:ActionContext,battleMngr:BattleManager):
	match baseAction.type:
		Enums.ActionType.DamageAction:
			return DamageActionInstance.new(baseAction,context,battleMngr)	
		Enums.ActionType.HealAction:
			return HealingActionInstance.new(baseAction,context,battleMngr)	
		Enums.ActionType.ApplyStatusAction:
			return ApplyStatusActionInstance.new(baseAction,context,battleMngr)	
		Enums.ActionType.ChangeArtifactCounterAction:
			return ArtifactCounterActionInstance.new(baseAction,context,battleMngr)
		Enums.ActionType.GainEnergyAction:
			return GainEnergyActionInstance.new(baseAction,context,battleMngr)
		Enums.ActionType.DefenseAction:
			return DefenseActionInstance.new(baseAction,context,battleMngr)
	print("ERROR: No action of type "+ str(baseAction.type)+ " defined.")

static func PrintModifier(mod:ActionModifierInstance):
	var sourceDbg: String
	if mod.source is ArtifactInstance:
		sourceDbg="Source is artifact %s" % mod.source.baseData.name
	else:
		sourceDbg="Source is status effect %s" % mod.source.base_data.name
	print("Applying modifier to stat %s. %s. Op-Amount: %s-%s" % \
	[Enums.StatType.keys()[mod.type], sourceDbg, Enums.OperationType.keys()[mod.operation], mod.amount])
			
static func GetModifiedOutput(initValue: int, modifiers: Array[ActionModifierInstance]):
	var additive = 0
	var multiplicative = 1
	var override = null

	for mod in modifiers:
		# DEBUG
		PrintModifier(mod)
		match mod.operation:
			Enums.OperationType.Additive:
				additive += mod.amount
			Enums.OperationType.Multiplicative:
				multiplicative *= mod.amount
			Enums.OperationType.Override:
				#If theres more than one override modifier then fuck you 
				override = mod.amount
				break
			Enums.OperationType.Interrupt:
				return false

	if initValue == BaseActionInstance.NULL_INT: return initValue

	var value = (initValue + additive) * multiplicative
	if override != null: value = override
	return floor(value)


func GetInitialValue() -> int:
	var valueData:BaseValueData = self.base_action.value

	match valueData.valueType:
		Enums.ValueType.Default:
			return int(valueData.value)
		Enums.ValueType.XCurrResultValue:
			return GetXValue(self.action_context.result,valueData) 
		Enums.ValueType.XCurrResultTargets:
			return GetXValue(self.action_context.targets.size(),valueData)
		Enums.ValueType.XResultTotal:
			return GetXValue(self.action_context.resultData.values().sum(),valueData) 
		Enums.ValueType.ResetStat:
			return NULL_INT

	if !self.action_context.actor.base_data.is_player:
		printerr("A non player character is running an action with an X value")
		return -1

	var actionValue:int
	match valueData.valueType:
		Enums.ValueType.XCurrEnergy:
			actionValue = GetXValue(self.battle_manager.HandMngr.currentEnergy,valueData) 
		Enums.ValueType.XCurrCards:
			actionValue = GetXValue(self.battle_manager.HandMngr.hand.size(),valueData) 

	return actionValue

func GetXValue(xValue:int,valueData:BaseValueData) -> int:
	match valueData.operation:
		Enums.OperationType.Additive:
			return int(xValue + valueData.value)
		Enums.OperationType.Multiplicative:
			return int(xValue * valueData.value)
	printerr("Error calculating X value with an incorrect operation type")
	return -1

func get_mod_type() -> Enums.StatType:
	printerr("This function should never be called on a base level. Missing getter implementation")
	return Enums.StatType.Damage

func valid_data():
	return true

func ExecuteImplementation(_target:CharacterInstance, _output:int):
	printerr("This function should never be called on a base level. Missing action sub execute implementation")

func Execute():
	# Is action caused from this context valid? 
	var isActionValid = self.is_action_valid(self.action_context)

	if !isActionValid: 
		print("Action was not executed due to actor conditions not met")
		return
	
	# Base action initial value (can be nully)
	var actionValue:int = self.GetInitialValue()
	print("%s stat action. Initial action value %s" % [Enums.StatType.keys()[self.modType] , actionValue if actionValue != NULL_INT else "RESET VAL"])

	# Apply actor modifiers
	var modifiers = self.GetActorModifiers(self.modType)
	var actorOutput = BaseActionInstance.GetModifiedOutput(actionValue, modifiers)
	
	# Check for Interrupt Modifier returning a false output
	if !actorOutput:
		print("Action from %s was interrupted" % [self.actor.base_data.name if self.actor else "NONE"])	
		return

	# Iterate over targets
	for tIdx in range(self.action_context.targets.size()):
		var target = self.action_context.setCurrentTarget(tIdx)

		# Is action valid against this target?
		var isTargetActionValid = self.is_action_valid(self.action_context)
		if !isTargetActionValid:
			print("Action is being executed, but not to this target due to conditions not being met")
			continue

		# Get target Modifiers
		var targetModifiers = self.GetTargetModifiers(self.modType)
		targetModifiers = targetModifiers.filter(func(tm): return !modifiers.has(tm))
		var targetOutput = BaseActionInstance.GetModifiedOutput(actorOutput, targetModifiers)
		
		# Check for an Interrupt modifier in this specific target
		if targetOutput is bool and !targetOutput:
			print("Action targeted to %s was interrupted" % [target.base_data.name])	
			continue

		# Run action specific implementation
		self.ExecuteImplementation(target, targetOutput)

		self.action_context.result = targetOutput
		self.action_context.resultData.setTargetResult(target, targetOutput)

		print("Checking for triggers after %s stat action" % Enums.StatType.keys()[self.modType])
		self.battle_manager.RunArtifactsAndStatusEffectsTriggers(Enums.GamePhase.ResponsePhase, self.action_context)
		print("Ran all triggers")
