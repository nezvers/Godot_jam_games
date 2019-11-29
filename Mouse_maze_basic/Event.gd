extends Node

signal Start
signal Finish
signal Next_scene

var can_finish = false setget set_finish

func set_finish(value):
	can_finish = value
	
	if can_finish :
		emit_signal("Finish")
	else:
		emit_signal("Start")