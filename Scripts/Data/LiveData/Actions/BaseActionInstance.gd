extends Object
class_name BaseActionInstance

var base_action:BaseActionData
var action_context:ActionContext

func _init(base_action:BaseActionData, action_context:ActionContext):
	self.base_action = base_action
	self.action_context = action_context

func Execute():
	print ("This is the base action, it shoulnd't be called")
