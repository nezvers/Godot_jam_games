extends RigidBody2D
class_name Player

var drag: bool = false
export (float) var max_strength: = 300.0
export (float) var max_length: = 100.0
var length:float = 0.0
var vector: = Vector2.ZERO
var ratio:float = 0.0
var dying:bool = false

func _ready()->void:
	$AnimationPlayer.play("Default")
	#set_process(false)	#Disable _process

func _unhandled_input(event)->void:
	if !drag && event.is_action_pressed("click"):
		drag = true
		#set_process(true)	#Enable _process
	elif !dying && event.is_action_released("click"):
		drag = false
		launch()
		#set_process(false)	#Disable _process

func _process(delta)->void:
	get_distance()

func launch():
	Event.emit_signal("Strength", 0)
	apply_central_impulse(vector.normalized()*max_strength*ratio)

func get_distance()->void:
	if drag:
		vector = get_global_mouse_position() -global_position
		length = Vector2.ZERO.distance_to(vector)
		length = clamp(length, 0, max_length)
		ratio = length/max_length
		Event.emit_signal("Strength", ratio)

func _on_VisibilityNotifier2D_screen_exited():
	if !Event.is_finishing:
		get_tree().reload_current_scene()

func death()->void:
	dying = true
	linear_velocity = Vector2.ZERO
	set_applied_force(Vector2.ZERO)
	Event.emit_signal("StopTime")
	$AnimationPlayer.play("Pop")
	$AudioStreamPlayer.play()

func _on_AnimationPlayer_animation_finished(anim_name):
	if dying && !Event.is_finishing:
		get_tree().reload_current_scene()









