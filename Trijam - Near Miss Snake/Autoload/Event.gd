extends Node

signal Restart

var difficulity:float = 3 setget set_difficulity
var maxDifficulity:float = 10
var maxSpeed = 0.5
var speed = 0.1

func set_difficulity(value:float)->void:
	difficulity = clamp(value, 1, maxDifficulity)
	speed = maxSpeed - (difficulity/maxDifficulity)*0.4

func _ready()->void:
	set_difficulity(difficulity)
