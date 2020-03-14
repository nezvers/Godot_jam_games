extends Node

var s_start:AudioStream = preload("res://Assets/Sounds/Level_start.wav")
var s_point:AudioStream = preload("res://Assets/Sounds/Point_1.wav")
var s_died:AudioStream = preload("res://Assets/Sounds/Died.wav")
var player:AudioStreamPlayer

func _ready()->void:
	player = AudioStreamPlayer.new()
	add_child(player)
