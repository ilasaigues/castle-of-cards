extends Node
class_name HandManager

var deck:Array[CardInstance]
var hand:Array[CardInstance]
var discard:Array[CardInstance]
var banish:Array[CardInstance]

var DeckMngr:DeckManager
var GameMngr:GameManager

#TEMP
var cardPrefab = load("res://Prefabs/card_prefab.tscn")

# TODO: Consider having a turn manager
var currentEnergy: int

func start_new_game(deckManager:DeckManager, gameManager:GameManager):
	DeckMngr = deckManager
	GameMngr = gameManager
	clear()
	deck.append_array(deckManager.Cards)
	# DEBUG
	# deck.shuffle()
	new_turn()
	
	

	
# Return void for now
func play_card(index: int, targets: Array[CharacterInstance]) -> ActionContext:
	var card = hand[index]
	var cardData : BaseCardData = card.base_data
	# Debug
	print("Playing card %s" % cardData.name)
	
	# This validation should probably be done before requesting to play_card
	# Otherwise this method should return detailed objects with the results
	# (such as wiggle cards when not enough energy)
	if currentEnergy < card.current_cost:
		print("not enough energy, lol")
		return
		
	# This should be moved elsewhere. Maybe TurnManager which handles all the
	# logic of player/enemy actions
	var actionContext = ActionContext.new(Enums.GamePhase.PlayingCard,\
		GameMngr.PlayerCharacter,targets,card,\
		GameMngr.ArtifactMngr.Artifacts)
	
	GameMngr.BattleMngr.RunArtifactsAndStatusEffectsTriggers(Enums.GamePhase.PlayingCard, actionContext)

	currentEnergy = currentEnergy - card.current_cost
	
	for baseAction in cardData.action_list:
		var actionInstance = BaseActionInstance.GetActionInstance(baseAction,actionContext,GameMngr.BattleMngr)
		actionInstance.Execute()
		actionContext.current_target_eval = null
	
	GameMngr.BattleMngr.RunArtifactsAndStatusEffectsTriggers(Enums.GamePhase.CardPlayed, actionContext)

	return actionContext

# Also should go in a TurnManager. The idea behind this is to have a pre-play
# phase where a card is selected, the targets (potential targets) are highlighted,
# the card is displayed differently if not enough energy
# Placeholder method
func select_card(index: int):
	var card = hand[index]
	var cardData : BaseCardData = card.base_data
	
	var target = cardData.target
	var requiresTarget : bool = false
	# Cards have multiple Actions. We should limit the the targeting system
	# only for the "main/first" action.
	match cardData.target:
		Enums.ActionTargetType.TargetAny:
			requiresTarget = true
		Enums.ActionTargetType.TargetEnemy:
			requiresTarget = true
	
	var enoughEnergy = currentEnergy >= card.current_cost
	
	# Returning a result object is so whoever is calling this actions, 
	# can then add a mid-stage for targetting, or display visual queues
	# Maybe the TurnManager does this. Maybe we don't use return values, and
	# the Managers can have subscribers (like an AudioController which emits
	# audio queues when selecting a card, or a VisualController which highlights selected card)
	return {
		requiresTarget: requiresTarget,
		enoughEnergy: enoughEnergy
	}

func new_turn():
	if (hand.size() > 0):
		discard_all()
	draw_cards(GameMngr.GetHandSize())
	currentEnergy = GameMngr.GetEnergyPerTurn()

	var idx = 0
	for cardInstance in hand:
		var display = cardPrefab.instantiate()
		display.SetInstance(cardInstance)
		GameMngr.add_child(display)
		display.position.x += 110 * idx
		idx=idx+1

func draw_cards(amount:int):
	for i in range(amount,0,-1):
		if (deck.size()>0):
			hand.append(deck[0])
			deck.remove_at(0)
		elif (discard.size()>0):
			reshuffle()
			draw_cards(i)
			return
		else:
			print("no more cards, lol")
			break

func discard_all():
	discard.append_array(hand)
	hand.clear()

func reshuffle():
	deck.append_array(discard)
	discard.clear()

func clear():
	deck.clear()
	hand.clear()
	discard.clear()
	banish.clear()
