extends TileMap

# warning-ignore:unused_argument
func _process(delta:float)->void:
	if Global.player != null:
		var pos:Vector2 = Global.player.global_position
		global_position.x = floor(pos.x / 128) * 128
		global_position.y = floor(pos.y / 128) * 128
