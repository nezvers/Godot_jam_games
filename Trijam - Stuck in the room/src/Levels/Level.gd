extends Node2D

export (String, FILE, "*.tscn") var menu

onready var tilemap:TileMap = $TileMap
onready var buffer_length:float = get_viewport().get_visible_rect().size.y * 0.6
const TILESIZE: int = 8
const WIDTH: int = 160
var highest_built: int = -1
var highest_detected: int = -1 setget set_highest_detected
var tetris_pieces: Array = [pre_load.tetris_I, pre_load.tetris_L, pre_load.tetris_O, pre_load.tetris_T, pre_load.tetris_Z]

func _ready()->void:
	Event.connect("set_tiles", self, "set_tiles")
	Event.connect("reset", self, "reset")
	set_highest_detected(-buffer_length)
	spawn_tetris_piece()

func set_highest_detected(value:int)->void:
	var v: int = int(floor((float(value) - buffer_length)/TILESIZE))
	if v < highest_detected:
		highest_detected = v
		make_walls()

func make_walls()->void:
	var difference:int = abs(highest_detected - highest_built)
	for i in range(difference):
		tilemap.set_cell(0, highest_built - i, 3)
		tilemap.set_cell(19, highest_built - i, 3)
	highest_built = highest_detected
	

func spawn_tetris_piece()->void:
	var height:int = highest_detected * TILESIZE
	var width_center:int = WIDTH / 2
	var pieces_count:int = tetris_pieces.size()
	var piece:KinematicBody2D = tetris_pieces[randi() % pieces_count].instance()
	$Objects.add_child(piece)
	piece.spawned(Vector2(width_center, height+30))

func set_tiles(positions:Array)->void:
	for pos in positions:
		var vec2:Vector2 = tilemap.world_to_map(pos)
		tilemap.set_cell(vec2.x, vec2.y, 0)
	spawn_tetris_piece()

func reset()->void:
	get_tree().reload_current_scene()




