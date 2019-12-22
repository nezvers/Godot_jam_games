extends RigidBody2D

export (float) var Turn_speed:float = 180.0
export (float) var Max_strength:float = 200.0
export (float) var Strength_speed:float = 1.55

onready var Indicator:Node2D = $Indicator
onready var Sound:AudioStreamPlayer = $AudioStreamPlayer
var min_length:float = 1.0
var max_length:float = 4.0
var pressed:bool = false
var strength:float = 0.0
var direction:float = 0.0
var prev_direction:float = 0.0
var turn_direction:float = 1.0
var angle:float = 0


func _physics_process(delta):
	direction =  Input.get_action_strength("Left") - Input.get_action_strength("Right")
	if direction != 0:
		turn_direction = direction
		strength = clamp(strength + (delta / Strength_speed * Max_strength), 0, Max_strength)
	
	angle += (Turn_speed*delta) * turn_direction
	if angle < 0:
		angle += 360
	elif angle >= 360:
		angle -= 360
	
	var vec: = Vector2.RIGHT.rotated(deg2rad(angle)) * (strength+1)
	var local_vec: = to_local(global_position + vec).rotated(rotation)
	
	Indicator.scale.x = lerp(min_length, max_length, strength/Max_strength)
	Indicator.global_rotation_degrees = angle
	
	
	if direction == 0 && prev_direction != 0: #just released
		apply_central_impulse(local_vec)
		play_sound()
		strength = 0
	
	prev_direction = direction

func play_sound():
	var percent = strength/Max_strength
	if percent < 0.9:
		Sound.stream = pre_load.snd_jump1
	else:
		Sound.stream = pre_load.snd_jump2
		percent -= 0.1 #adjust volume for louder sample
	Sound.volume_db = lerp(-20, 0, percent)
	Sound.play()






