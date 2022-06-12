extends Node2D

export (Array, PackedScene) var enemyScenes:Array

onready var bulletParent: = $Bullets
onready var enemyParent: = $Enemies
onready var score: = $CanvasLayer/Control/Label

var enemyCount: = 0
var enemyMax: = 3
var killCount: = 0
var increaseTreshold: = 3

func _ready()->void:
# warning-ignore:return_value_discarded
	#Global.connect("spawn_enemy", self, "spawn_enemies")
# warning-ignore:return_value_discarded
	Global.connect("spawn_bullet", self, "spawn_bullets")
# warning-ignore:return_value_discarded
	Global.connect("start_game", self, "start_game")
	set_process(false)

func spawn_enemies(scene:PackedScene, pos:Vector2)->void:
	var inst:KinematicBody2D = scene.instance()
	inst.global_position = pos
	enemyParent.add_child(inst)
	inst.connect("died", self, "enemyKilled")
	enemyCount += 1

# warning-ignore:unused_argument
func spawn_bullets(scene:PackedScene, pos:Vector2, rot:float, colLayer:int)->void:
	var inst:Area2D = scene.instance()
	inst.global_position = pos
	inst.global_rotation = rot
	inst.collision_mask = colLayer
	bulletParent.add_child(inst)

func start_game()->void:
	set_process(true)

func _process(delta:float)->void:
	if Global.player == null:
		return
	if enemyCount >= enemyMax:
		return
	
	var pos:Vector2 = Global.player.global_position
	var angle:float = PI * 2 * randf()
	var dist: float = 800.0
	pos.x += cos(angle) * dist
	pos.y += sin(angle) * dist
	
	spawn_enemies(enemyScenes[randi() % enemyScenes.size()], pos)

func enemyKilled()->void:
	enemyCount -= 1
	killCount += 1
	score.text = "Kill Count " + str(killCount)
	if killCount % increaseTreshold == 0:
		enemyMax += 1
