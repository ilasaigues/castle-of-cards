extends Object
class_name ResultData

var resultsPerTarget:Dictionary

func setTargetResult(character:CharacterInstance, value:int):
    resultsPerTarget[character] = value
    