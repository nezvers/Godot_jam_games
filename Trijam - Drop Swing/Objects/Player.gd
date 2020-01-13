extends RigidBody2D
class_name Player

export(float) var speed = 2 *60
export(NodePath) var DeathNode

onready var ray:RayCast2D = $RayCast2D
onready var line:Line2D = $Line2D
onready var cam:Camera2D = $Camera2D #Had an idea to move camere to the direction of Linear_velocity
onready var death:Area2D = get_node(DeathNode)

var pulling:bool = false
var contactPoint:Vector2 = Vector2.ZERO
var removeLine:bool = false
onready var deathY:float = death.global_position.y



func _unhandled_input(event)->void:
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()

func _physics_process(delta)->void:
	if Input.is_action_just_pressed("click"):
		var mousePos = get_global_mouse_position()
		var VecDir = (mousePos-global_position).normalized()
		ray.cast_to = VecDir *180
		ray.enabled = true
		ray.force_raycast_update()	#get response on demand
		if ray.is_colliding():
			contactPoint = ray.get_collision_point()
			pulling = true
		else:
			var points:Array = [Vector2(), ray.cast_to]
			line.points = PoolVector2Array(points)
			removeLine = true
			$Timer.start()
			apply_central_impulse(VecDir * (speed * delta)) #give some push if standing on block with no reach
		ray.enabled = false	#don't use more than needed
		

	if Input.is_action_just_released("click"):
		pulling = false
		line.points = PoolVector2Array()
		removeLine = false
	
	if pulling:
		var points:Array = [Vector2(), contactPoint-global_position]
		line.points = PoolVector2Array(points)
		var vecDir = (contactPoint - global_position).normalized()
		apply_central_impulse(vecDir * (speed * delta))
	
	if global_position.y > death.global_position.y:
		death._on_Area2D_body_entered(self)





func _on_Timer_timeout()->void:
	if removeLine:
		line.points = PoolVector2Array()
		removeLine = false
