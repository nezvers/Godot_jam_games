extends Area2D

func _on_BlackHole_body_entered(body):
	if body is Player:
		body.death()
