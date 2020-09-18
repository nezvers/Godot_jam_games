extends Area2D

func _ready():
	$AudioStreamPlayer.stream = PreLoad.snd_collect

func _on_Star_body_entered(body):
	Event.emit_signal("collect")
	visible = false
	$AudioStreamPlayer.play()


func _on_AudioStreamPlayer_finished():
	queue_free()
