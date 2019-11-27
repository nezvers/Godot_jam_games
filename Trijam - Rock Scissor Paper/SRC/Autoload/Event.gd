extends Node

signal Score
signal Result
signal Start
signal Playing
signal Choice

var player_points: int = 13 setget set_player_points
var enemy_points: int = 13 setget set_enemy_points
var playing: bool = false setget start_playing
var can_reveal: bool = false
var chosen: int = -1 setget set_chosen
var game_end:bool = false

func set_player_points(points:int)->void:
	if player_points == points:
		emit_signal("Score", 0)	#false for being draw
		return
	player_points = points
	enemy_points += 1
	emit_signal("Score", -1)
	if player_points == 0 :
		emit_signal("Result", false)

func set_enemy_points(points:int)->void:
	enemy_points = points
	player_points +=1
	emit_signal("Score", +1)
	if enemy_points == 0 :
		emit_signal("Result", true)

func start_playing(value:bool)->void:
	playing = value
	emit_signal("Playing")

func set_chosen(value:int)->void:
	if can_reveal:
		chosen = value
	emit_signal("Choice")















