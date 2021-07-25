extends Node2D

export (String, FILE, "*.tscn") var next_level

onready var bombs: = $Bombs
onready var tilemap: = $BG/TileMap
onready var player: = $Player



func _ready()->void:
# warning-ignore:return_value_discarded
	Event.connect("reset", self, "reset")
	
	var size = tilemap.get_used_rect().size * 16.0
	var camera: Camera2D = player.find_node("Camera")
# warning-ignore:narrowing_conversion
	camera.limit_left = 0.0
# warning-ignore:narrowing_conversion
	camera.limit_top = 0.0
	camera.limit_right = size.x
	camera.limit_bottom = size.y

func reset()->void:
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()


# warning-ignore:function_conflicts_variable
func next_level()->void:
# warning-ignore:return_value_discarded
	get_tree().change_scene(next_level)
