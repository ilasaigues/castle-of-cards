extends Node
class_name GameManager

var DeckMngr:DeckManager
var BattleMngr:BattleManager
var ArtifactMngr:ArtifactManager
var PlayerCharacter:CharacterInstance
var Gold:int

func _init():
	DeckMngr = DeckManager.new()
	BattleMngr = BattleManager.new()
	ArtifactMngr = ArtifactManager.new()
	DeckMngr.name = "Deck Manager"
	BattleMngr.name = "Battle Manager"
	ArtifactMngr.name = "Artifact Manager"
	self.add_child(DeckMngr)
	self.add_child(BattleMngr)
	self.add_child(ArtifactMngr)


func StartGame(
		starterDeckData,
		runSeed,
		playerCharacterData:BaseCharacterData,
		debugBattle: BaseBattleData):
	PlayerCharacter = CharacterInstance.new(playerCharacterData)
	print(str("Starting game with player ",playerCharacterData.name,", deck with ",starterDeckData.cards.size(), " cards, seed: ", runSeed))
	DeckMngr.setDeck(starterDeckData)
	BattleMngr.StartBattle(self,DeckMngr,debugBattle)
	#test
	BattleMngr.HandMngr.play_card(0,[BattleMngr.enemies[0]])

func GetHandSize():
	return 5

func GetEnergyPerTurn():
	return 3
