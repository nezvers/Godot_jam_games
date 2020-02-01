extends KinematicBody2D

var blocks:Array
var blocks_positions:Array
var distance_to_left:float = 0
var distance_to_right:float = 0
const TILESIZE = 8
var state:int = 0 setget set_state
var speed:float = 1

func set_state(value: int)->void:
	state = value
	state_machine()

func spawned(pos:Vector2):
	global_position = pos
	set_blocks()
	Event.connect("game_over", self, "on_game_over")

func set_blocks()->void:	#need to be rounded to tile size
	randomize()
	var origin:Vector2 = floorVec2(global_position/TILESIZE) * TILESIZE
	origin.y += TILESIZE * 0.5
	global_position = origin
	rotation_degrees = 90 * (randi() % 4) 	#choose random rotation
	scale.x -= (randi() % 2) * 2			#choose if flip horizontally
	for child in get_children():					#gather pieces position when rotated
		if child is CollisionShape2D:
			blocks.append(child)
			var pos:Vector2 = floorVec2(child.global_position/TILESIZE) * TILESIZE
			blocks_positions.append(pos)
			distance_to_left = min(distance_to_left, pos.x-origin.x)
			distance_to_right = max(distance_to_right, pos.x-origin.x)
	#Return original scale and rotation
	scale.x = 1
	rotation_degrees = 0
	for i in range(blocks.size()):	#set positions as they were rotated
		blocks[i].global_position = blocks_positions[i]

func state_machine()->void:
	match state:
		1:
			go_above_the_player()
		2:
			go_to_floor()
		3:
			place_tiles()

func go_above_the_player()->void:
	var collide:bool = test_move(global_transform, Vector2.ZERO)
	if collide:
		Event.emit_signal("game_over", "collide")
		return
	var player_group:Array = get_tree().get_nodes_in_group("Player")
	if player_group.empty():	#if no players alive
		Event.emit_signal("game_over", "player_group")
		return
	var player:KinematicBody2D = player_group[0]		#assuming only one player
	
	var extents:float = TILESIZE/2
	var player_pos:float = floor(player.global_position.x/TILESIZE) * TILESIZE +extents	#round to tile size
	var screen_width: float = floor(get_viewport_rect().size.x / TILESIZE) * TILESIZE - TILESIZE
	var posX:float = clamp(player_pos, TILESIZE-distance_to_left+extents, screen_width - distance_to_right - extents)
	var move_time:float = 1*speed
	$Node2D/Tween.interpolate_property(self, "global_position:x", global_position.x, posX, move_time, Tween.TRANS_CUBIC, Tween.EASE_OUT, 0)
	$Node2D/Tween.start()
	
	var soundFX_pre_time:float = 0.25
	$Node2D/Timer.wait_time = max(move_time - soundFX_pre_time, 0)
	$Node2D/Timer.start()
	
	

func go_to_floor()->void:
	var collide:bool = test_move(global_transform, Vector2.ZERO)
	if collide:
		Event.emit_signal("game_over", 'go_to_floor')
		return
	var distance:float = 160
	for block in blocks:
		var ray: RayCast2D = block.get_node("RayCast2D")
		ray.enabled = true
		ray.force_raycast_update()
		var collision_point: Vector2 = ray.get_collision_point()
		ray.enabled = false
		var difference: float = collision_point.y - ray.global_position.y
		distance = min(distance, difference)
	
	$Node2D/Tween.interpolate_property(self, "position:y", position.y, position.y + distance, distance/90 *speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0)
	$Node2D/Tween.start()

func place_tiles()->void:
	for i in range(blocks.size()):
		blocks_positions[i] = blocks[i].global_position
	Event.emit_signal("set_tiles", blocks_positions)
	Event.brick_sfx.stream = pre_load.snd_brick1
	Event.brick_sfx.play()
	Event.bricks += 1
	queue_free()

func floorVec2(vec2:Vector2)->Vector2:
	return Vector2(floor(vec2.x), floor(vec2.y))

func advance_state()->void:
	set_state(state + 1)

func _on_Tween_tween_all_completed():
	advance_state()

func _on_AnimationPlayer_animation_finished(anim_name):
	advance_state()

func on_game_over()->void:
	queue_free()


func _on_Timer_timeout():
	Event.brick_sfx.stream = pre_load.snd_brick2
	Event.brick_sfx.play()
