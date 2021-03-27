extends Node


var bombs_max: = 1
var bombs_left: = 1 setget set_bombs_left
var strength: = 1.0

var remote_control: = false

func _ready()->void:
	#Event.connect("reset", self, "reset")
	pass

func set_bombs_left(value:int)->void:
	bombs_left = value

func reset()->void:
	bombs_max = 1
	bombs_left = 1
