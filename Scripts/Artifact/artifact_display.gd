extends Control
class_name ArtifactDisplay

@export var artifactData: BaseArtifact 

@export var titleLabel: Label
@export var descLabel: Label
@export var colorRect: ColorRect

func _ready():
	if !artifactData: return
	titleLabel.text = self.artifactData.get_parsed_name()
	descLabel.text = self.artifactData.get_parsed_description()
	
	# Set rect color
	var rarity = self.artifactData.property.rarity
	match rarity:
		ArtifactProperty.Rarity.common:
			colorRect.color = Color.WEB_GREEN
		ArtifactProperty.Rarity.heroic:
			colorRect.color = Color.REBECCA_PURPLE
		ArtifactProperty.Rarity.mythical:
			colorRect.color = Color.GOLD
			
	
	
