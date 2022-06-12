extends Node

# warning-ignore:unused_signal
signal spawn_bullet
# warning-ignore:unused_signal
signal spawn_enemy
# warning-ignore:unused_signal
signal game_over
# warning-ignore:unused_signal
signal start_game

var player: Node2D = null
var subscription: = []
var timer: = Timer.new()

func _ready()->void:
	OS.center_window()
	add_child(timer)
# warning-ignore:return_value_discarded
	timer.connect("timeout", self, "timeout")
	timer.wait_time = 1.0
	timer.start()

func timeout()->void:
	if player == null || subscription.empty():
		return
	subscription[randi() % subscription.size()].shoot()
