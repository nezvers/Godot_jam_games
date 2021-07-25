extends CPUParticles2D

func _ready()->void:
	emitting = true


func _on_Timer_timeout():
	queue_free()
