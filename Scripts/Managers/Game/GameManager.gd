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
		debugBattle: BaseBattleData,
		artifactsData:Array[BaseArtifactData]):
	PlayerCharacter = CharacterInstance.new(playerCharacterData)
	print(str("Starting game with player ",playerCharacterData.name,", deck with ",starterDeckData.cards.size(), " cards, seed: ", runSeed))
	DeckMngr.setDeck(starterDeckData)
	BattleMngr.StartBattle(self,DeckMngr,debugBattle)
	ArtifactMngr.InitArtifacts(artifactsData)
	
	# Turn start 
	# 	Draw cards (each individual card drawn may have triggers)
	# Play card (target selection) (may have triggers)
	# Discard
	# End turn
	print("Strating battle. Should deal 6 damage to all enemies due to Fast Drawer and \
	Heavy Hitter artifacts, AND Strength status effect on player, AND Fragility on targets\n")
	BattleMngr.StartPhase()
	print("\n")
	
	return
	print("Playing strike card against enemy. Should deal 9 damage (3 base + 1 heavy \
	hitter + 2 Strength, times 1.5 for Fragility)\n")
	BattleMngr.HandMngr.play_card(0,[BattleMngr.enemies[0]])
	print("\n")
	
	print("Playing heal card to heal enemy. Result: should heal for 0 due to disease SE \
	on target\n")
	BattleMngr.HandMngr.play_card(2,[BattleMngr.enemies[0]])
	print("\n")
	
	print("Playing stun strike card against same enemy. Result: should damage for 6 damage\
	(1 base + 1 heavy hitter + 2 strength, times 1.5 for Fragility). Since target hp is less than\
	6, card inflicts Stun for 8 turns due to Stunner artifact (4 base x2 to stuns)\n")
	BattleMngr.HandMngr.play_card(3,[BattleMngr.enemies[0]])
	print("\n")
	
	print("Playing Poison Sting card against same enemy. Result: should inflict Poison only if\
	target is stunned, and only for 1 turn (1 base, but Stunner artifact is not applied)\n")
	BattleMngr.HandMngr.play_card(4,[BattleMngr.enemies[0]])

func GetHandSize():
	return 5

func GetEnergyPerTurn():
	return 3
