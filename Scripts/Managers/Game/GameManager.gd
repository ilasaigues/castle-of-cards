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
	print("Strating battle. Should: \n")
	print(" - run Eye of Terror artifact's trigger and add Terrifier status effect, for 12 turns, to Player")
	print(" - run Commander Status effect trigger from Enemy 2 and add Hyped Up status effect, for 10 turns, to Enemy 1")
	print(" - run Terrifier Status effect trigger from Player and inflict Frightened to Enemy 1 (0 turns, due to Hyped Up modifier) and to Enemy 2 (10 turns)")
	print(" - run Stronk Boi artifact's trigger and set Strength status effect to player (3 turns)")
	print(" - deal 6 damage to all enemies due to Fast Drawer and \
	Heavy Hitter artifacts, AND Strength status effect on player, AND Fragility on targets\n")
	print(" -  player receives 3 damage after attacking Enemy 1 due to SpikesSE (deals only 3 without applying their StrenghSE\n")
	print(" -  player receives 5 damage after attacking Enemy 2 due to ParrySE (deals half of 6 + 2 Strength\n")
	BattleMngr.StartPhase()
	print("\n")
	
	print("Strating Turn. Should\n")
	print(" - run Healthy Boi artifact's trigger at the turn start and cause the player to heal for 7 HP\
	 (3 base + 4 from Easily Healable artifact). Proficient Healer is NOT applied since the Healthy Boi\
	 artifact trigger is set to be enacted by the ENVIRONMENT, NOT PLAYER\n")
	BattleMngr.StartTurn()
	print("\n")
	
	print("Playing hand strike card against enemy. Should:")
	print(" - deal 12 damage (1 for each card in hand base (5) + 1 heavy hitter + 2 Strength, times 1.5 for Fragility)")
	print(" - should trigger a damage action from Enemy 2 due to Parry Status Effect and deal 8 damage to player (half the damage dealt (6) + 2 Strength)\n")
	BattleMngr.PlayCard(1,[BattleMngr.enemies[1]])
	print("\n")
	return
	
	print("Playing heal card to heal enemy for 5. Result: should heal for 0 due to disease SE \
	on target, even after applying the Proficient Healer artifact +5 modifier to player's heal actions\n")
	BattleMngr.PlayCard(2,[BattleMngr.enemies[0]])
	print("\n")

	print("Playing strike card against enemy. Should:") 
	print(" - deal 9 damage (3 base + 1 heavy hitter + 2 Strength, times 1.5 for Fragility)")
	print(" - should trigger a damage action from Enemy 1 due to Spikes Status Effect and deal 3 damage to player\n")
	print(" - after playing card AggresiveHealer trigges a healing action for 7 (3 per target + Easily Healable 4 [But not proficient healer since the environment is the actor])\n")
	BattleMngr.PlayCard(1,[BattleMngr.enemies[0]])
	print("\n")
	
	print("Playing stun strike card against same enemy. Result: should damage for 6 damage\
	(1 base + 1 heavy hitter + 2 strength, times 1.5 for Fragility). Since target hp is less than\
	6, card inflicts Stun for 8 turns due to Stunner artifact (4 base x2 to stuns)\n")
	BattleMngr.PlayCard(3,[BattleMngr.enemies[1]])
	print("\n")
	
	print("Playing Poison Sting card against same enemy. Result: should inflict Poison only if\
	target is stunned, and only for 1 turn (1 base, but Stunner artifact is not applied)\n")
	BattleMngr.PlayCard(4,[BattleMngr.enemies[0]])
	BattleMngr.EndTurn()
	
func GetHandSize():
	return 5

func GetEnergyPerTurn():
	return 5
