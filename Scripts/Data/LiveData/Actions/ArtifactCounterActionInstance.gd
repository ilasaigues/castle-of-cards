extends BaseActionInstance
class_name ArtifactCounterActionInstance

func get_mod_type() -> Enums.StatType:
	return Enums.StatType.ArtifactCount

func ExecuteImplementation(_target:CharacterInstance, artifactCount:int):
	var artifact:ArtifactInstance = self.action_context.source_trigger.triggerSource
	artifact.count += artifactCount
	print("Increasing artifact %s counter to %s" % [artifact.baseData.name, artifact.count])

func valid_data() -> bool:
	var isContextValid = self.action_context.source_trigger and \
		self.action_context.source_trigger.triggerSource is ArtifactInstance

	if !isContextValid:
		printerr("Artifact Counter action was executed without a source trigger that belongs to an artifact")
	
	return isContextValid
