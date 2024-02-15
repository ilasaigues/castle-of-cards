extends Object
class_name ArtifactInstance

var baseData:BaseArtifactData
var count:int

func _init(base_data:BaseArtifactData):
	self.baseData = base_data

func Get_Modifiers() -> Array[ActionModifierInstance]:
	var mods:Array[ActionModifierInstance] = []
	if baseData.count>0 && count >= baseData.count:
		for baseMod in baseData.modifiers:
			mods.append(ActionModifierInstance.new(baseMod,self))
	return mods
