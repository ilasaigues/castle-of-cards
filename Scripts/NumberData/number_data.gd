extends Object
class_name NumberData

var _value:float

var _base:NumberData

enum OpType {Flat, Mult, Override}

var op_type:OpType


func _init(value , operation:OpType = OpType.Flat, base:NumberData=null):
	self._value = value
	self.op_type = operation
	self._base = base
	
func Eval():
	var current = self
	
	var override
	
	var flat = 0
	var mult = 1
	
	while current != null:
		match current.op_type:
			OpType.Override:
				override = current._value
				break
			OpType.Flat:
				flat += current._value
			OpType.Mult:
				mult += current._value/100
		current = current._base
		
	if override:
		return override
	return flat*mult
	

