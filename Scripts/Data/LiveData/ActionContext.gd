extends Object
class_name ActionContext

var phase:Enums.GamePhase
var actor:CharacterInstance
var targets:Array[CharacterInstance]
var source_card:CardInstance
#var source_trigger:TriggerInstance

func _init(
	phase:Enums.GamePhase,
	actor:CharacterInstance,
	targets:Array[CharacterInstance],
	source_card:CardInstance
	):
	self.phase=phase
	self.actor=actor
	self.targets=targets
	self.source_card=source_card
