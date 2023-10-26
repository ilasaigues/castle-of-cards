extends Control
class_name CardDisplay

@export var card_data:BaseCard

@export var mana_cost:Label
@export var card_name:Label
@export var card_description:Label

func _ready():
	if !card_data: return
	mana_cost.text = str(card_data.cost)
	card_name.text = card_data.name
	card_description.text = card_data.get_parsed_description()



