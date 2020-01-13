extends Area2D

onready var kegCount:int = get_tree().get_nodes_in_group("Keg").size()


func _on_Area2D_body_entered(body)->void:
	if !$AudioStreamPlayer.playing: #because player is able to trigger on it's own
		$AudioStreamPlayer.play()


func _on_AudioStreamPlayer_finished():
	Event.emit_signal("restart")
