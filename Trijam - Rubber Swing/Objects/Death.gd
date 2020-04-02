extends Area2D

var no_sound: = false
func _ready()->void:
	Event.connect("finished", self, "on_finished")

func on_finished()->void:
	no_sound = true

func _on_Area2D_body_entered(body)->void:
	if !no_sound && !$AudioStreamPlayer.playing: #because player is able to trigger on it's own
		$AudioStreamPlayer.play()
		no_sound = true


func _on_AudioStreamPlayer_finished():
	Event.emit_signal("restart")
