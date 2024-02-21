extends Object
class_name BaseActionInstance

var base_action:BaseActionData
var action_context:ActionContext

func _init(base_action:BaseActionData, action_context:ActionContext):
	self.base_action = base_action
	self.action_context = action_context
	
func Execute():
	print ("This is the base action, it shoulnd't be called")

func GetModifiers(character: CharacterInstance,modType: Enums.StatType) -> Array[ActionModifierInstance]:
	var modifiers:Array[ActionModifierInstance] = []
	for status in character.current_status_effects:
		modifiers.append_array(status.get_modifiers())
	for artifact in self.action_context.artifacts:
		modifiers.append_array(artifact.get_modifiers())
		
	var filteredModifier: Array[ActionModifierInstance]
	filteredModifier.assign(\
		modifiers\
			.filter(func(mod) : return mod.is_valid(self.action_context))\
			.filter(func(mod) : return mod.type == modType)\
		)
	return filteredModifier
	
static func GetActionInstance(baseAction:BaseActionData,context:ActionContext):
	match baseAction.type:
		Enums.ActionType.DamageAction:
			return DamageActionInstance.new(baseAction,context)	
		Enums.ActionType.HealAction:
			return HealingActionInstance.new(baseAction,context)	
		Enums.ActionType.ApplyStatusAction:
			return ApplyStatusActionInstance.new(baseAction,context)	
	print("ERROR: No action of type "+ str(baseAction.type)+ " defined.")

static func PrintModifier(mod:ActionModifierInstance):
	var sourceDbg: String
	if mod.source is ArtifactInstance:
		sourceDbg="Source is artifact %s" % mod.source.baseData.name
	else:
		sourceDbg="Source is status effect %s" % Enums.StatusEffectType.keys()[mod.source.type]
	print("Applying modifier to stat %s. %s. Op-Amount: %s-%s" % \
	[Enums.StatType.keys()[mod.type], sourceDbg, Enums.OperationType.keys()[mod.operation], mod.amount])
			
static func GetModifiedOutput(initValue: int, modifiers: Array[ActionModifierInstance]) -> int:
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

	var value = (initValue + additive) * multiplicative
	if override != null: value = override
	return value
