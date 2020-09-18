extends RigidBody2D
class_name _Player

export(float) var speed = 2 *60
export(NodePath) var DeathNode
export (float) var line_length: = 180

onready var ray:RayCast2D 	= $RayCast2D
onready var line:Line2D 	= $Line2D
onready var cam:Camera2D 	= $Camera2D #Had an idea to move camere to the direction of Linear_velocity
onready var death:Area2D 	= get_node(DeathNode)

var pulling:bool 			= false
var contactPoint: 			= Vector2.ZERO
var removeLine:bool 		= false
onready var deathY:float 	= death.global_position.y
var targetPoint: 			= Vector2.ZERO
var shoot: 					= false
var linePoints: 			= []


func _unhandled_input(event)->void:
	if event.is_action_pressed("click"):
		targetPoint = get_global_mouse_position()
		shoot = true
	elif event.is_action_released("click"):
		pulling = false						#Stop pulling
#		line.points = PoolVector2Array()
	elif event.is_action_pressed("restart"):
		get_tree().reload_current_scene()

func _physics_process(delta)->void:
	if shoot:
		var VecDir = (targetPoint-global_position).normalized()
		var cast_to = VecDir *line_length
		ray.cast_to = cast_to
		ray.enabled = true
		ray.force_raycast_update()	#get response on demand
		if ray.is_colliding():
			contactPoint = ray.get_collision_point()
			pulling = true				#start pulling
		else:
			#linePoints = [Vector2(), cast_to]
#			line.points = PoolVector2Array(points)
			apply_central_impulse(VecDir * (speed * delta)) #give some push if standing on block with no reach
		ray.enabled = false	#don't use more than needed
		shoot = false

	
	if pulling:
		var vecDir = (contactPoint - global_position)
		linePoints = [Vector2(), vecDir]
#		line.points = PoolVector2Array(points)
		apply_central_impulse(vecDir.normalized() * speed * delta)
	
	if global_position.y > death.global_position.y:
		death._on_Area2D_body_entered(self)


func _on_Timer_timeout()->void:
	pass
