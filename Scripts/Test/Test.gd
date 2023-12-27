extends Node

@export var starterDeck:BaseDeckData
@export var playerCharacter:BaseCharacterData

func _ready():
	GameManagerInstance.StartGame(
		starterDeck,
		12345,
		playerCharacter
	)
