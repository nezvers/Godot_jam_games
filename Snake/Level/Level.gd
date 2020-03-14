extends Node2D

func _ready()->void:
	Event.connect("Restart", self, "Restart")

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		Restart()


func _on_Timer_timeout():
	print("timeout")

func Restart()->void:
	get_tree().reload_current_scene()
