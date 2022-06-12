extends Camera2D

func _rady()->void:
# warning-ignore:return_value_discarded
	Global.connect("game_over", self, "game_over")

func game_over()->void:
	set_process(false)

# warning-ignore:unused_argument
func _process(_delta:float)->void:
	if Global.player != null:
		global_position = Global.player.global_position
