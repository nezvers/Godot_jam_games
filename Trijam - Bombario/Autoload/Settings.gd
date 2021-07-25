extends Node


func _ready():
	OS.center_window()

func _unhandled_input(event:InputEvent)->void:
	if event.is_action_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
