extends Control

export (String, FILE, "*.tscn") var Next_Level

func _ready():
	Event.connect("Next_scene", self, "next_scene")

func next_scene():
	get_tree().change_scene(Next_Level)
