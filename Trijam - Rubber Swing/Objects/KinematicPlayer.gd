extends RigidKinematicBody2D
class_name Player

export(float) var pull_impulse: = 20
export(float) var length: = 180.0
export(float) var shoot_speed: = length * 4.0
export(NodePath) var DeathNode: NodePath

onready var ray:RayCast2D = $RayCast2D
onready var line:Line2D = $Line2D
onready var death:Area2D = get_node(DeathNode)
onready var deathY:float = death.global_position.y

enum {IDLE,SHOOT,PULL,MISS}
var state: = IDLE

var hook: = Vector2()
var target: = Vector2()

var finished: = false

func _draw()->void:
	draw_line(Vector2(), hook, Color.white, 1)

func _ready()->void:
	Event.connect("finished", self, "on_finished")

func _unhandled_input(event)->void:
	if event.is_action_pressed("restart"):
		Event.restart()

func _physics_process(delta)->void:
	match state:
		IDLE:
			idle(delta)
		SHOOT:
			shoot(delta)
		PULL:
			pull(delta)
		MISS:
			miss(delta)
	update()

func _process(delta:float)->void:
	if !finished && global_position.y > deathY:
		death.trigger()
	update()

func idle(delta:float)->void:
	rigid_physics(delta)
	if Input.is_action_just_pressed("click"):
		var dir: = (get_global_mouse_position() - global_position).normalized()
		target = global_position + (dir * length)
		state = SHOOT
		ray.enabled = true

func shoot(delta:float)->void:
	rigid_physics(delta)
	if Input.is_action_just_released("click"):
		ray.enabled = false
		apply_impulse(hook.normalized()*pull_impulse)
		state = MISS
		return
	hook = hook.move_toward(to_local(target), shoot_speed * delta)
	ray.cast_to = hook
	ray.force_raycast_update()
	if ray.is_colliding():
		target = ray.get_collision_point()
		hook = to_local(target)
		ray.enabled = false
		state = PULL
		return
	if hook.distance_to(to_local(target)) < shoot_speed * delta:
		ray.enabled = false
		apply_impulse(hook.normalized()*pull_impulse)
		state = MISS

func pull(delta:float)->void:
	if Input.is_action_just_released("click"):
		state = MISS
	else:
		apply_impulse(hook.normalized()*pull_impulse)
	rigid_physics(delta)
	hook = to_local(target)

func miss(delta:float)->void:
	rigid_physics(delta)
	hook = hook.move_toward(Vector2.ZERO, shoot_speed * delta)
	if Input.is_action_pressed("click"):
		ray.cast_to = hook
		ray.force_raycast_update()
		if ray.is_colliding():
			target = ray.get_collision_point()
			hook = to_local(target)
			ray.enabled = false
			state = PULL
			return
	if hook.distance_to(Vector2.ZERO) < shoot_speed * delta:
		ray.enabled = false
		hook = Vector2.ZERO
		state = IDLE

func on_finished()->void:
	finished = true
