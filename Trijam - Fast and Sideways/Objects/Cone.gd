extends RigidBody2D

onready var pos: = global_position

func _on_Cone_body_shape_entered(body_id, body, body_shape, local_shape):
	Event.emit_signal("Fail")
	$AudioStreamPlayer.play()
