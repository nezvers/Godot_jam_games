extends Node2D


onready var last_position: = global_position
onready var target: = get_parent()
onready var player: = owner
onready var sprite: = $Sprite
onready var audio:AudioStreamPlayer = $AudioStreamPlayer

var strength: = 100
var pressed: = false
var timer: = 0.0
var max_time: = 2.0

func _ready()->void:
	Event.connect("bomb_exploded", self, "bomb_exploded")

func _unhandled_input(event)->void:
	if event.is_action_pressed("action"):
		if Stats.bombs_left > 0:
			pressed = true
			audio.volume_db = 0.0
			audio.stream = PreLoad.snd_Charging
			audio.play()
		
	elif event.is_action_released("action"):
		if pressed:
			throw()
			pressed = false
			timer = 0.0

func _process(delta:float)->void:
	global_position = last_position.linear_interpolate(target.global_position, 0.5)
	last_position = global_position
	if pressed:
		timer += delta
		if timer > max_time:
			timer = max_time
		play_charging()
	
func throw()->void:
	audio.stream = PreLoad.snd_SpawnBomb
	audio.volume_db = 0.0
	audio.play()
	Stats.bombs_left -= 1
	var dir: Vector2 = (player.direction * Vector2(1.0, 1.5)).normalized()
	var mult: = timer/max_time
	var impulse: = dir * strength * mult
	Event.emit_signal("bomb_spawn", global_position, impulse)
	if Stats.bombs_left == 0:
		sprite.visible = false


func bomb_exploded()->void:
	Stats.bombs_left += 1
	sprite.visible = true

func play_charging():
	var ratio = timer/ max_time
	audio.pitch_scale = range_lerp(ratio, 0.0, 1.0, 0.5, 2.5)
