extends Node
class_name BattleManager

var battleData:BaseBattleData

var DeckMngr:DeckManager
var HandMngr:HandManager
var GameMngr:GameManager


func StartBattle(gameManager:GameManager, deckManager:DeckManager, battleData:BaseBattleData):
	self.battleData=battleData
	DeckMngr = deckManager
	GameMngr = gameManager
	HandMngr = HandManager.new()
	HandMngr.start_new_game(deckManager,GameMngr)
	
