extends Resource
class_name CardProperty

enum TargetType {none, all, player, any, singleEnemy, allEnemies}

@export var target:TargetType
@export var effect:BaseCardEffect
@export var parameter:int


#armor
#damage
#buffLength
#deals {damage}
