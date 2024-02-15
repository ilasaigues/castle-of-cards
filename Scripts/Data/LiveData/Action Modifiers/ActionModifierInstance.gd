extends Object
class_name ActionModifierInstance

var type:Enums.StatType
var amount:float
var operation:Enums.OperationType
var modifier_conditionals:Array[BaseConditionData]
var source

func _init(baseData:BaseActionModifierData, source):
	self.type=baseData.type
	self.amount=baseData.amount
	self.operation=baseData.operation
	self.modifier_conditionals=baseData.modifier_conditionals
	self.source = source


func is_valid(context:ActionContext):
	for condition in modifier_conditionals:
		if condition is BoolConditionData:
			pass
		if condition is NumberConditionData:
			pass
		if condition is PhaseConditionData:
			return condition.phase == context.phase

func check_bool_condition(context:ActionContext, condition:BoolConditionData):
	match condition.condition_type:
		Enums.BoolConditionType.TargetIsDead:
			return !context.target.is_alive()
		Enums.BoolConditionType.ActorIsAffected:
			return source is BaseStatusEffectInstance\
				&& context.actor.current_status_effects.has(source)
		Enums.BoolConditionType.TargetIsAffected:		
			return source is BaseStatusEffectInstance\
				&& context.target.current_status_effects.has(source)
		Enums.BoolConditionType.ActorIsPlayer:
			return context.actor.base_data.is_player
		Enums.BoolConditionType.ActorIsAlly:
			return context.actor.base_data.is_player == context.target.base_data.is_player
	
func check_number_condition(context:ActionContext, condition:NumberConditionData):
	match condition.condition_type:
		Enums.NumberConditionType.ArtifactCounterEquals:
			if source is ArtifactInstance:
				var artifact = source as ArtifactInstance
				return artifact.count == self.amount
			print_rich("[color=#FF0000]ERROR: ARTIFACT CONDITION IN NON-ARTIFACT MODIFIER[/color]")
			return false
		Enums.NumberConditionType.TargetHPLessThan:
			return context.target.current_hp < self.amount
		Enums.NumberConditionType.ActorHPLessThan:
			return context.actor.current_hp < self.amount
	
func check_phase_condition(context:ActionContext, condition:PhaseConditionData):
	return context.phase == condition.phase

static func GetActionModifiers(gameManager:GameManager) -> Array[ActionModifierInstance]:
	var modifiers:Array[ActionModifierInstance] = []
	for status in gameManager.PlayerCharacter.current_status_effects:
		for mod in status.get_modifiers():
				modifiers.append(mod)
	for artifact in gameManager.ArtifactMngr.Artifacts:
		#loop through the artifact's modifier instances
		continue
	return modifiers
