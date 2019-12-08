extends Node

signal Lap
signal Checkpoint
signal Start
signal Fail
signal NextScene

func _unhandled_input(event):
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()
	elif event.is_action_pressed("quit"):
		get_tree().quit()