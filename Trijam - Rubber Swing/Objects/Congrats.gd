extends CanvasLayer

onready var player:AnimationPlayer = $AnimationPlayer

func _ready()->void:
	var names = ['Great!', 'Nice!', 'Awesome!', 'Fabulous!', 'Gorgeous!', 'Exquisite!', 'For the Great China!']
	var label:Label = $"Control2/Control/Label"
	label.text = names[Event.level]
	Event.level = (Event.level+1) % names.size()
	if Event.level == 0:
		Event.special = true
	
	
func _on_AnimationPlayer_animation_finished(anim_name):
	Event.emit_signal("changeLevel")
	queue_free()
