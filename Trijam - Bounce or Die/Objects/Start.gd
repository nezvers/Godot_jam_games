extends Node2D



func _on_Area2D_body_exited(body):
	Event.emit_signal("Start")
	queue_free()
