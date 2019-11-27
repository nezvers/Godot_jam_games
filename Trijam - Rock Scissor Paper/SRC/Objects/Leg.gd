extends Node2D

func _ready():
	var pos: = get_node("../Position2D")
	new_position(pos.global_position)
	$Sprite.flip_h = bool(randi() % 2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func new_position(pos:Vector2)->void:
	var randRange: int = 86
	var randv: Vector2 = Vector2(float(randi() % randRange/2)-randRange/4, float(randi() % randRange)-randRange/2)
	var randTime: = 0.7 + randf() * 0.7
	$Tween.interpolate_property(self, "global_position", global_position, pos + randv, randTime, Tween.TRANS_CUBIC, Tween.EASE_IN, 0)
	$Tween.interpolate_property(self, "rotation_degrees", rotation_degrees, rotation_degrees + (randi()%960), randTime, Tween.TRANS_CUBIC, Tween.EASE_IN, 0)
	
	$Tween.start()