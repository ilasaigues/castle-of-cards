extends Object
class_name CardInstance

var base_data:BaseCardData
var current_cost:int = 0
var exhaust:bool = false

func _init(base_card:BaseCardData):
	self.base_data = base_card
	self.current_cost = base_card.cost
	self.exhaust = base_card.exhaust
