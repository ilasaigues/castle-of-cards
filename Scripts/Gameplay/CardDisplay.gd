extends Control

@export var description_label:RichTextLabel
@export var cost_label:RichTextLabel

var instance:CardInstance
var xPos:int

func SetInstance(instance:CardInstance):
	self.instance = instance
	#subscribe to the instance in case it updates and call refresh
	Refresh()
	
func Refresh():
	description_label.text=instance.base_data.description
	cost_label.text = str(instance.current_cost)
