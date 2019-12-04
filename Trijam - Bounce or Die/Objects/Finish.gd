extends Node2D

func _on_Area2D_body_entered(body):
	if body is Player:
		Event.emit_signal("Finish")
