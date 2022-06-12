extends KinematicBody2D

signal died

export var moveSpead: = 3.0 * 60
export var distance: = 300.0

onready var body:Node2D = $Body
onready var gun: = $Body/Gun1

var dir: = Vector2.ZERO
var target: = Vector2.RIGHT
var velocity: = Vector2.ZERO
var delta:float
var reposition = Vector2.ZERO
var isPlayer: = false
var health: = 3

func _draw()->void:
	draw_line(Vector2.ZERO, reposition, Color.white)

func _ready()->void:
	target = global_position + transform.x
	set_player(false)

func _process(_delta:float)->void:
	delta = _delta
	get_input()
	body.look_at(target)
	velocity = move_and_slide(moveSpead * (dir).normalized())

func get_input()->void:
	if isPlayer:
		player_move()
	else:
		ai_move()

func player_move()->void:
	dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	dir.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	target = get_global_mouse_position()
	if Input.is_action_pressed("shoot"):
		shoot()

func ai_move()->void:
	if Global.player == null:
		return
	target = Global.player.global_position
	reposition = target + ((global_position - target).normalized() * distance)
	var moveDir:Vector2 = reposition - global_position
	if moveDir.length() > moveSpead * delta:
		dir = moveDir.normalized()
	else:
		dir = Vector2.ZERO

func shoot()->void:
	gun.shoot()

func set_player(state:bool)->void:
	isPlayer = state
	# switch collision detection
	if state:
		collision_layer = 2
		gun.colLayer = 4 + 1
		Global.subscription.erase(self)
	else:
		collision_layer = 4
		gun.colLayer = 2 + 1
		Global.subscription.append(self)

func get_hit(damage:int)->void:
	health -= damage
	if health <= 0:
		emit_signal("died")
		queue_free()
		Audio.death()
		return
	Audio.damage()

func _exit_tree()->void:
	Global.subscription.erase(self)
