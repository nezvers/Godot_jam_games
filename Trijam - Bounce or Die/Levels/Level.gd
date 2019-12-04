extends Node2D

export (String, FILE, "*.tscn") var Next_scene
#export (PackedScene) var Next_scene_pack

func _ready()->void:
	Event.is_finishing = false
	#Event is singleton
	Event.connect("Finish", self, "on_Finish")

func on_Finish()->void:
	#Function is triggered but scene is restarted instead of changing to supposed scene
	Event.is_finishing = true
	get_tree().change_scene(Next_scene)
	#get_tree().change_scene_to(Next_scene_pack)