extends BaseCardEffect
class_name CardEffectDamage

func process_effect(target,args:Array):
	if target.has("take_damage"):
		target.take_damage(args)
	
