extends Object
class_name ArtifactInstance

var baseData:BaseArtifactData
var count:int

func _init(base_data:BaseArtifactData):
	self.baseData = base_data

func get_modifiers() -> Array[ActionModifierInstance]:
	var mods:Array[ActionModifierInstance] = []
	for baseMod in baseData.modifiers:
		mods.append(ActionModifierInstance.new(self, baseMod))
	return mods
	
func get_triggers() -> Array[BaseTriggerInstance]:
	var triggers:Array[BaseTriggerInstance] = []
	for baseTriger in baseData.triggers:
		triggers.append(BaseTriggerInstance.new(baseTriger))
	return triggers
