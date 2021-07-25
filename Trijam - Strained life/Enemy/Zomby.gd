extends Actor

onready var ray:RayCast2D = $Body/RayCast2D
onready var anim:AnimationPlayer = $AnimationPlayer
onready var timer:Timer = $Timer
onready var audio:AudioStreamPlayer = $AudioStreamPlayer
onready var attackArea: = $Body/Attack
onready var damageArea: = $Damage


enum {IDLE, WALK}
var state: = IDLE
var prev_state: = state
var die_sounds: = [PreLoad.snd_Splash1, PreLoad.snd_Splash2, PreLoad.snd_Splash3]

func _ready()->void:
	._ready()
	timer.wait_time = range_lerp(randf(), 0.0, 1.0, 0.2, 1.0)
	timer.start()
	audio.stream = die_sounds[randi() % 3]


func direction_logic()->void:
	if is_on_wall() || !ray.is_colliding():
		direction.x *= -1

func _process(delta:float):
	if abs(direction.x)>= 0.001:
		body.scale.x = direction.x
	
	if prev_state != state:
		match state:
			IDLE:
				anim.play("Idle")
			WALK:
				anim.play("Walk")
	
	prev_state = state

func damage()->void:
	Event.emit_signal("enemy_killed")
	set_physics_process(false)
	set_process(false)
	attackArea.collision_mask = 0
	damageArea.collision_mask = 0
	collision_mask = 0
	visible = false
	audio.play()
	yield(audio, "finished")
	queue_free()

func _on_Timer_timeout():
	if state == IDLE:
		direction.x = (randi()%2) * 2 -1
		timer.wait_time = range_lerp(randf(), 0.0, 1.0, 2.0, 6.0)
		timer.start()
		state = WALK
	else:
		direction.x = 0.0
		timer.wait_time = range_lerp(randf(), 0.0, 1.0, 0.3, 1.5)
		timer.start()
		state = IDLE


func Damage_body_entered(body)->void:
	damage()
	body.velocity.y = body.jump_impulse *0.5
	attackArea.collision_mask = 0
	damageArea.collision_mask = 0
	collision_layer = 0


func Attack_body_entered(body)->void:
	body.damage()
