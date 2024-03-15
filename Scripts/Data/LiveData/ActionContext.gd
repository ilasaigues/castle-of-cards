extends Object
class_name ActionContext

var phase:Enums.GamePhase
var actor:CharacterInstance
var targets:Array[CharacterInstance]
var artifacts: Array[ArtifactInstance]
var source_card:CardInstance
var current_target_eval:CharacterInstance
var action_instance:BaseActionInstance
var result: int
var resultData:ResultData
var source_trigger:BaseTriggerInstance

func _init(
	initPhase:Enums.GamePhase,
	initActor:CharacterInstance,
	initTargets:Array[CharacterInstance],
	initSourceCard:CardInstance,
	initArtifacts:Array[ArtifactInstance]
	):
	self.phase=initPhase
	self.actor=initActor
	self.targets=initTargets
	self.source_card=initSourceCard
	self.artifacts=initArtifacts
	self.resultData=ResultData.new()

func setCurrentTarget(idx: int) -> CharacterInstance:
	if idx < 0 or idx >= self.targets.size(): printerr("Action context invalid target setting")
	self.current_target_eval=targets[idx]
	return self.current_target_eval
