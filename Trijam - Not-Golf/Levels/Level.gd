extends Node2D
class_name Level

export (String, FILE, "*.tscn") var Next_Scene: String

func _ready():
	#$"../../HUD_layer".show = true
	pass

func change_level()->void:
	Event.emit_signal("ChangeScene", Next_Scene)
