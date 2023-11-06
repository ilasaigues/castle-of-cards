extends Node
class_name GameController

@export var attackCard:CardData



func _ready():
	var gameState = GameState.new()
	
	gameState.player = CharacterData.new()
	gameState.enemies.append(CharacterData.new())
	
	for effect in attackCard.effects:
		var moveContext = MoveContext.new()
		moveContext.source_action_type = MoveContext.MoveSource.PlayerCard
		moveContext.source_character = gameState.player
		moveContext.source_card = attackCard
		moveContext.targets.append(gameState.enemies[0])
		effect.apply_effect(moveContext,gameState)



