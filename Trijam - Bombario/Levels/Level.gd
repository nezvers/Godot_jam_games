extends Node2D

export (String, FILE, "*.tscn") var next_level

onready var bombs: = $Bombs
onready var tilemap: = $BG/TileMap
onready var player: = $Player

onready var enemy_count: = get_tree().get_nodes_in_group("Enemy").size()

var bombs_max: = 1
var bombs_left: = 1
var strength: = 1.0
var remote_control: = false

func _ready()->void:
# warning-ignore:return_value_discarded
	Event.connect("bomb_spawn", self, "bomb_spawn")
# warning-ignore:return_value_discarded
	Event.connect("reset", self, "reset")
# warning-ignore:return_value_discarded
	Event.connect("enemy_killed", self, "enemy_killed")
# warning-ignore:return_value_discarded
	Event.connect("next_level", self, "next_level")
	
	var size = tilemap.get_used_rect().size * 16.0
	var camera: Camera2D = player.find_node("Camera")
# warning-ignore:narrowing_conversion
	camera.limit_left = 0.0
# warning-ignore:narrowing_conversion
	camera.limit_top = 0.0
	camera.limit_right = size.x
	camera.limit_bottom = size.y
	
	bombs_max = Stats.bombs_max
	bombs_left = Stats.bombs_left
	strength = Stats.strength
	remote_control = Stats.remote_control

func reset()->void:
	Stats.bombs_max = bombs_max
	Stats.bombs_left = bombs_left
	Stats.strength = strength
	Stats.remote_control = remote_control
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()

func bomb_spawn(_position:Vector2, _impulse:Vector2)->void:
	var bomb: = PreLoad.BombPhysics.instance()
	bombs.add_child(bomb)
	bomb.global_position = _position
	bomb.set_linear_velocity(_impulse)

func enemy_killed()->void:
	enemy_count -= 1
	if enemy_count == 0:
		Event.emit_signal("level_cleared")

# warning-ignore:function_conflicts_variable
func next_level()->void:
# warning-ignore:return_value_discarded
	get_tree().change_scene(next_level)
