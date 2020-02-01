extends Node

signal score
signal set_tiles
signal game_over
signal reset

onready var brick_sfx:AudioStreamPlayer
var highest = 0 setget set_highest
var bricks = 0 setget set_bricks

func set_highest(value:float)->void:
	var v: float = floor(abs(value + 8))
	if v > highest:
		highest = v
		emit_signal("score")

func set_bricks(value:int)->void:
	bricks = value
	emit_signal("score")

func _ready()->void:
	connect("reset", self, "on_reset")
	brick_sfx = AudioStreamPlayer.new()
	add_child(brick_sfx)

func on_reset()->void:
	highest = 0
