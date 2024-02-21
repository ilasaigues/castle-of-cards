extends Node
class_name ArtifactManager

var Artifacts:Array[ArtifactInstance]=[]

func InitArtifacts(starterArtifacts:Array[BaseArtifactData]):
	for artifactData in starterArtifacts:
		var artifact=ArtifactInstance.new(artifactData)
		self.Artifacts.append(artifact)
	
