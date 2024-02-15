extends Object
class_name ActionModifierInstance

var type:Enums.StatType
var amount:float
var operation:Enums.OperationType
var modifier_conditionals:Array[BaseConditionData]
var source

func _init(source, baseData:BaseActionModifierData):
	self.type=baseData.type
	self.amount=baseData.amount
	self.operation=baseData.operation
	self.modifier_conditionals=baseData.modifier_conditionals
	self.source = source

func is_valid(context:ActionContext):
	print(Enums.StatType.keys()[self.type])
	print(modifier_conditionals.size())
	var valid = true
	for condition in modifier_conditionals:
		if condition is BoolConditionData:
			valid = valid and check_bool_condition(context, condition)
		if condition is NumberConditionData:
			valid = valid and check_number_condition(context, condition)
		if condition is PhaseConditionData:
			valid = valid and check_phase_condition(context, condition)
	return valid

func check_bool_condition(context:ActionContext, condition:BoolConditionData):
	match condition.condition_type:
		# I don't this will be useful
		Enums.BoolConditionType.TargetIsDead:
			return context.targets.any(func(t: CharacterInstance): t.is_alive())
		Enums.BoolConditionType.ActorIsAffected:
			return source is BaseStatusEffectInstance\
				&& context.actor.current_status_effects.has(source)
		Enums.BoolConditionType.TargetIsAffected:		
			return source is BaseStatusEffectInstance\
				&& context.targets.any(func(t: CharacterInstance): t.current_status_effects.has(source))
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
