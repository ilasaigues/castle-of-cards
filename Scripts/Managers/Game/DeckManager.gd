extends Node
class_name DeckManager

var Cards:Array[CardInstance]

func setDeck(baseDeck:BaseDeckData):
	for baseCard in baseDeck.cards:
		Cards.append(CardInstance.new(baseCard))
