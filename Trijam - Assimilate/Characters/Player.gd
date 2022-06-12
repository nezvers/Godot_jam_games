extends CPUParticles2D

# warning-ignore:unused_signal
signal game_over

onready var raycast: = $RayCast2D
onready var target: = $Sprite
var parent:Node2D
var isAssimilating: = false
var followTarget:Node2D
var timer: = 0.0
var delta:float
var hp: = 1

func _ready()->void:
	parent = get_parent()
	target.set_as_toplevel(true)
	target.visible = false

func _process(_delta:float)->void:
	delta = _delta
	if followTarget != null:
		if timer < 1.0:
			timer += delta * 2
			if timer >= 1.0:
				timer = 1.0
				Global.player = self
		global_position = global_position.linear_interpolate(followTarget.global_position, timer)
	look_at(get_global_mouse_position())
	if raycast.is_colliding():
		show_enemy(raycast.get_collider())
	else:
		target.visible = false

func show_enemy(enemy:KinematicBody2D)->void:
	if enemy == null:
		return
	target.visible = true
	target.global_position = enemy.global_position
	if Input.is_action_just_pressed("assimilate"):
		timer = 0.0
		target.visible = false
		enemy.set_player(true)
		if followTarget != null:
			followTarget.disconnect("died", self, "follow_target_died")
			followTarget.set_player(false)
		else:
			Global.emit_signal("start_game")
		followTarget = enemy
		Audio.assimilate()
# warning-ignore:return_value_discarded
		followTarget.connect("died", self, "follow_target_died")

func follow_target_died()->void:
	followTarget.disconnect("died", self, "follow_target_died")
	hp -= 1
	if hp <= 0:
		Global.emit_signal("game_over")
		Global.player = null
# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()
