extends Position2D

export var bulletScene:PackedScene

onready var gun2: = $"../Gun2"
onready var timer: = $Timer

var barrel: = []
var barelIndex: = 0
var isPlayer: = false
var canShoot: = true
var colLayer: = 1

func _ready()->void:
	barrel.append(self)
	barrel.append(gun2)

func timeout()->void:
	canShoot = true

func shoot()->void:
	if(!canShoot):
		return
	Audio.shoot()
	canShoot = false
	timer.start()
	barelIndex = (barelIndex + 1) % 2
	Global.emit_signal("spawn_bullet", bulletScene, barrel[barelIndex].global_position, barrel[barelIndex].global_rotation, colLayer)
