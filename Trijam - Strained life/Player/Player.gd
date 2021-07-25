extends Actor
class_name Player

onready var anim:AnimationPlayer = $AnimationPlayer
onready var audio:AudioStreamPlayer = $AudioStreamPlayer

enum {IDLE, WALK, JUMP}
var state: = IDLE
var prev_state: = state
var scaler: = Vector2(1.0, 1.0)

var isDead: = false
var landed: = false
var velocity_previous: = Vector2.ZERO
var steps: = [PreLoad.snd_Step1, PreLoad.snd_Step2, PreLoad.snd_Step3, PreLoad.snd_Step4]

func _ready()->void:
	pass

func _unhandled_input(event)->void:
	if event.is_action_pressed("jump"):
		jump = true
	elif event.is_action_released("jump"):
		jump = false
	elif event.is_action_pressed("reset"):
# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()
	elif event.is_action_pressed("exit"):
		get_tree().quit()

func direction_logic()->void:
	if !isDead:
		direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	else:
		direction = Vector2.ZERO

func _process(delta:float):
	if abs(direction.x)>= 0.001:
		body.scale.x *= sign(direction.x)
	
	state_check()
	
	if !is_grounded:
		scaler.y = range_lerp(abs(velocity.y), 0.0, abs(jump_impulse), 0.75, 1.25)
		scaler.x = range_lerp(abs(velocity.y), 0.0, abs(jump_impulse), 1.25, 0.75)
	
	if !landed && is_grounded:
		land()
		scaler.x = range_lerp(abs(velocity_previous.y), 0.0, abs(jump_impulse), 1.2, 1.25)
		scaler.y = range_lerp(abs(velocity_previous.y), 0.0, abs(jump_impulse), 0.8, 0.5)
	
	scaler.x = lerp(scaler.x, 1.0, 1.0 - pow(0.01, delta))
	scaler.y = lerp(scaler.y, 1.0, 1.0 - pow(0.01, delta))
	
	body.scale = scaler * Vector2(sign(body.scale.x), 1.0)
	
	landed = is_grounded
	velocity_previous = velocity

func state_check()->void:
	if is_grounded:
		if abs(direction.x) > 0.01:
			state = WALK
		else:
			state = IDLE
	else:
		state = JUMP
	
	if prev_state != state && !isDead:
		match state:
			IDLE:
				anim.play("Idle")
			WALK:
				anim.play("Walk")
			JUMP:
				anim.play("Idle")
	
	prev_state = state

func damage()->void:
	set_process_unhandled_input(false)
	set_process_unhandled_key_input(false)
	isDead = true
	jump_impulse *= 0.6
	anim.play("Death")
	collision_layer = 0
	collision_mask = 1
	jump = true
	audio.volume_db = 0.0
	audio.stream = PreLoad.snd_Die
	audio.play()
	yield(get_tree().create_timer(2), "timeout")
	Event.emit_signal("reset")

# warning-ignore:function_conflicts_variable
func steps()->void:
	
	audio.stream = steps[randi() % 4]
	audio.volume_db = -18.0
	audio.play()

func jump()->void:
	if isDead:
		return
	audio.stream = PreLoad.snd_Jump
	audio.volume_db = 0.0
	audio.play()
	jump_particles()

func land()->void:
	audio.stream = PreLoad.snd_Landing
	audio.volume_db = 0.0
	audio.play()
	land_particles()

func land_particles()->void:
	var particles:CPUParticles2D = PreLoad.landParticleScene.instance()
	particles.global_position = global_position
	owner.add_child(particles)

func jump_particles()->void:
	var particles:CPUParticles2D = PreLoad.jumpParticleScene.instance()
	particles.global_position = global_position
	owner.add_child(particles)



















