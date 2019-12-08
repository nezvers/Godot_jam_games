extends Area2D

var check = false
var failed:bool = false

func _ready()->void:
	Event.connect("Lap", self, "on_Lap")
	Event.connect("Fail", self, "on_Fail")

func on_Lap()->void:
	check = false

func on_fail()->void:
	failed = true

func _on_Checkpoint_body_entered(body):
	if check || failed:
		return
	check = true
	$AudioStreamPlayer.play()
	$Tween.interpolate_property($ColorRect, "color", Color(1,1,1,1), Color(1,1,1,0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
	$Tween.start()
