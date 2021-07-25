extends RigidKinematicBody2D

onready var timer:Timer = $Timer
onready var anim:AnimationPlayer = $AnimationPlayer
onready var audio:AudioStreamPlayer = $AudioStreamPlayer

func _ready()->void:
# warning-ignore:return_value_discarded
	connect("collided", self, "collided")
	audio.stream = PreLoad.snd_BombBounce
	if !Stats.remote_control:
		anim.play("Pulse")
# warning-ignore:return_value_discarded
		timer.connect("timeout", self, "timeout")
		timer.start()
	else:
		anim.play("Idle")

func _physics_process(delta)->void:
	rigid_physics(delta)

func timeout()->void:
	explode()

func damage()->void:
# warning-ignore:return_value_discarded
	anim.connect("animation_finished", self, "_on_AnimationPlayer_animation_finished")
	anim.play("Remote")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Remote":
		explode()

func explode()->void:
	Event.emit_signal("bomb_exploded")
	var explosion: Area2D = PreLoad.Explosion.instance()
	explosion.global_position = global_position
	explosion.scale *= Stats.strength
	get_parent().add_child(explosion)
	queue_free()

func collided(collision, strength)->void:
	if strength > 1.0:
		audio.play()
