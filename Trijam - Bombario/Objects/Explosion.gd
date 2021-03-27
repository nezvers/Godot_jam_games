extends Area2D

onready var audio:AudioStreamPlayer = $AudioStreamPlayer

func _ready()->void:
	audio.stream = PreLoad.snd_Explosion
	audio.play()

func _on_Explosion_body_entered(body):
	if body.has_method("damage"):
		body.damage()


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
