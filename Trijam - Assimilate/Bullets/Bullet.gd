extends Area2D

export var speed:float = 10.0 * 60
export var damage: = 1

func _destroy()->void:
	queue_free()

func _process(delta:float)->void:
	global_position += global_transform.x * speed * delta

func _body_entered(body):
	body.get_hit(damage)
	queue_free()
