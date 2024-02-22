extends Object
class_name ArtifactInstance

var baseData:BaseArtifactData
var count:int
var mods:Array[ActionModifierInstance] = []
var triggers:Array[BaseTriggerInstance] = []

func _init(base_data:BaseArtifactData):
	self.baseData = base_data
	for baseMod in baseData.modifiers:
		mods.append(ActionModifierInstance.new(self, baseMod))
		
	for baseTriger in baseData.triggers:
		triggers.append(BaseTriggerInstance.new(baseTriger))

func get_modifiers() -> Array[ActionModifierInstance]:
	return mods
	
func get_triggers() -> Array[BaseTriggerInstance]:
	return triggers
