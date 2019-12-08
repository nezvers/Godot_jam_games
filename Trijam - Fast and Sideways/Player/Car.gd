extends RigidBody2D

const DEG2RAD = 0.0174532925199432957

var steering_com = 0.0
var force_com = 0.0
const add_steering = 3000
const max_steering = 1500
const add_force = 1 * 60
const max_force = 60

const TDC_LEFT = 0x1
const TDC_RIGHT = 0x2
const TDC_UP = 0x4
const TDC_DOWN = 0x8
var m_controlState = 0

onready var engine:AudioStreamPlayer = $AudioStreamPlayer
onready var default_pitch:float = $AudioStreamPlayer.pitch_scale
var pitch_range:float = 2.0

func get_input()->void:
	if Input.is_action_just_pressed("move_left"):
		m_controlState |= TDC_LEFT
	if Input.is_action_just_pressed("move_right"):
		m_controlState |= TDC_RIGHT
	if Input.is_action_just_pressed("move_up"):
		m_controlState |= TDC_UP
	if Input.is_action_just_pressed("move_down"):
		m_controlState |= TDC_DOWN
	if Input.is_action_just_released("move_left"):
		m_controlState &= ~TDC_LEFT
	if Input.is_action_just_released("move_right"):
		m_controlState &= ~TDC_RIGHT
	if Input.is_action_just_released("move_up"):
		m_controlState &= ~TDC_UP
	if Input.is_action_just_released("move_down"):
		m_controlState &= ~TDC_DOWN

func apply_input(delta)->void:
	match (m_controlState & (TDC_UP|TDC_DOWN)):
		TDC_UP:
			force_com += add_force * delta
		TDC_DOWN:
			force_com += -add_force * delta
		_:
			force_com = lerp(force_com, 0, 0.2)
	force_com = clamp(force_com, -max_force, max_force)
	engine.pitch_scale = default_pitch + pitch_range * (abs(force_com)/ max_force)
	
	match (m_controlState & (TDC_RIGHT|TDC_LEFT)):
		TDC_RIGHT:
			steering_com = max_steering
		TDC_LEFT:
			steering_com = -max_steering
		_:
			steering_com = 0
	steering_com = clamp(steering_com, -max_steering, max_steering)

func update_drive()->void:
	var tf = get_global_transform()
	var vel = get_linear_velocity()
	#   get the orthogonal velocity vector
	var right_vel = tf.x * tf.x.dot(vel)
	#   decrease the force in proportion to the velocity to stop endless acceleration
	var force = force_com - force_com * clamp(vel.length() / 400.0, 0.0, 1.0)
	#Can use force above some value to kick off a dust particles
	
	var steering_torque = steering_com
	if tf.y.dot(vel) < 0.0:
	#   if reversing, reverse the steering
		steering_torque = -steering_com
	#   make reversing much slower
		if force_com <= 0.0:
			force *= 0.3
	#   apply the side force, the lower this is the more the car slides
	#   make the sliding depend on the power command somewhat
	if force!=0:
		apply_impulse(Vector2(), -right_vel * 0.15 * clamp(1.0 / abs(force), 0.01, 1.0))
	#  
	apply_impulse(Vector2(), tf.basis_xform(Vector2(0, force)))
	#   scale the steering torque with velocity to prevent turning the car when not moving
	set_applied_torque(steering_torque * vel.length() / 200.0)
	$CPUParticles2D.angle = -rad2deg(global_rotation)

func _physics_process(delta)->void:
	get_input()
	apply_input(delta)
	update_drive()