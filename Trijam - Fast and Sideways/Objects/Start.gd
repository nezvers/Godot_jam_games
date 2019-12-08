extends Area2D

var firstTime:bool = true
onready var parent = get_parent()
var failed:bool = false

func _on_Start_body_entered(body):
	if failed:
		return
	
	if firstTime:
		firstTime = false
		Event.emit_signal("Start")
		$AudioStreamPlayer.play()
		blink()
		return
	
	var child_list = parent.get_children()
	for child in child_list:
		if child.is_in_group("Checkpoint"):
			if !child.check:
				Event.emit_signal("Fail")
				failed = true
				return
	Event.emit_signal("Lap")
	$AudioStreamPlayer.play()
	blink()


func _on_Start_body_exited(body):
	pass # Replace with function body.

func blink()->void:
	$Tween.interpolate_property($"blink", "color", Color(1,1,1,0.75), Color(1,1,1,0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
	$Tween.start()