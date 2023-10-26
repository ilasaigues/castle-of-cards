extends Resource
class_name BaseArtifact

@export var name:String
# La idea tal vez seria tener artefactos como assets reusables que puedan ser
# Common, Rare, Legendary. Pero que unicamente hagan mejor la carta con un simple
# valor numerico [Ex: Tus ataques hace +1/+2/+3 de daño por la energia restante
# en tu pool]
@export var property:ArtifactProperty
@export var description:String
#@export var image:Texture2D

func get_parsed_name():
	return name + " (" + ArtifactProperty.Rarity.keys()[property.rarity] + ")"
	
func get_parsed_description():
	var desc = description
	desc = desc.replace(str("{0}"),str(property.parameter))
	return desc
