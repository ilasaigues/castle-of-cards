extends Node
class_name HandManager

var deck:Array[CardInstance]
var hand:Array[CardInstance]
var discard:Array[CardInstance]
var banish:Array[CardInstance]

var DeckMngr:DeckManager
var GameMngr:GameManager

func start_new_game(deckManager:DeckManager, gameManager:GameManager):
	DeckMngr = deckManager
	GameMngr = gameManager
	clear()
	deck.append_array(deckManager.Cards)
	deck.shuffle()
	
	new_turn()
	print("A")
	
func new_turn():
	if (hand.size() > 0):
		discard_all()
	draw_cards(GameMngr.GetHandSize())

	
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
