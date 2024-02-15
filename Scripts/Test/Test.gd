extends Node

@export var starterDeck:BaseDeckData
@export var playerCharacter:BaseCharacterData
@export var testBattle:BaseBattleData
@export var artifact:BaseArtifactData

func _ready():
	print("Test script. Checking artifact modifier conditionals")
	print(artifact.id)
	print(artifact.name)
	print("Artifact has %s modifiers " % artifact.modifiers.size())
	print(artifact.modifiers[0].modifier_conditionals.size())
	GameManagerInstance.StartGame(
		starterDeck,
		12345,
		playerCharacter,
		testBattle
	)
