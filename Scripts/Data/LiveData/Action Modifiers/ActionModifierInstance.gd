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
	var valid = true
	
	for condition in modifier_conditionals:
		if condition is BoolConditionData:
			valid = valid and check_bool_condition(context, condition)
		if condition is NumberConditionData:
			valid = valid and check_number_condition(context, condition)
		if condition is PhaseConditionData:
			valid = valid and check_phase_condition(context, condition)
		if condition is StatusEffectConditionData:
			valid = valid and check_status_effect_condition(context, condition)
	return valid

func check_status_effect_condition(context: ActionContext, condition: StatusEffectConditionData):
	match condition.condition_type:
		Enums.StatusEffectConditionType.StatusEffectAppliedIs:
			return context.action_instance is ApplyStatusActionInstance and \
				context.action_instance.base_action.status_effect == condition.status_effect
		Enums.StatusEffectConditionType.StatusEffectAppliedIsBuff:
			return context.action_instance is ApplyStatusActionInstance and \
				context.action_instance.base_action.status_effect.isBuff == condition.apply_to_buffs
		Enums.StatusEffectConditionType.TargetHasStatusEffect:
			return context.current_target_eval != null and \
				context.current_target_eval.current_status_effects\
					.any(func(se:BaseStatusEffectInstance): se.base_data == condition.status_effect)
		Enums.StatusEffectConditionType.ActorHasStatusEffect:
			return context.actor.current_status_effects\
				.any(func(se:BaseStatusEffectInstance): se.base_data == condition.status_effect)
		
func check_bool_condition(context:ActionContext, condition:BoolConditionData):
	match condition.condition_type:
		# I don't this will be useful
		Enums.BoolConditionType.TargetIsDead:
			return context.targets.any(func(t: CharacterInstance): t.is_alive())
		Enums.BoolConditionType.ActorIsAffected:
			if context.actor == null: return false
			return source is BaseStatusEffectInstance\
				&& context.actor.current_status_effects.has(source)
		Enums.BoolConditionType.TargetIsAffected:		
			return source is BaseStatusEffectInstance and \
				context.current_target_eval != null and \
				context.current_target_eval.current_status_effects.has(source)
		Enums.BoolConditionType.ActorIsPlayer:
			if context.actor == null: return false
			return context.actor.base_data.is_player
		Enums.BoolConditionType.ActorIsAlly:
			if context.actor == null: return false
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
