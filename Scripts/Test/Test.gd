extends Node

@export var starterDeck:BaseDeckData
@export var playerCharacter:BaseCharacterData
@export var testBattle:BaseBattleData

func _ready():
	GameManagerInstance.StartGame(
		starterDeck,
		12345,
		playerCharacter,
		testBattle
	)
