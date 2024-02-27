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
#var source_trigger:TriggerInstance

func _init(
	phase:Enums.GamePhase,
	actor:CharacterInstance,
	targets:Array[CharacterInstance],
	source_card:CardInstance,
	artifacts:Array[ArtifactInstance]
	):
	self.phase=phase
	self.actor=actor
	self.targets=targets
	self.source_card=source_card
	self.artifacts=artifacts

func setCurrentTarget(idx: int) -> CharacterInstance:
	if idx < 0 or idx >= self.targets.size(): printerr("Action context invalid target setting")
	self.current_target_eval=targets[idx]
	return self.current_target_eval
