extends Node2D

var dialogue: bool = false
var has_life:bool = true
var kill:bool = false
onready var dialogue_node = get_node("CanvasLayer/dialogue")

func set_dialogue(value:bool)->void:
	dialogue = value
	if value:
		dialogue_node.show_text("INTRO", "Greetings")

func _ready()->void:
	set_dialogue(true)

func _on_dialogue_dialog_control(msg):
	if msg.answer == null:
		return
	print(msg)
	match msg.dialog:
		"Greetings":
			match msg.answer:
				0:
					print("death")

func bonus_life(msg):
	if has_life:
		has_life = false
		#Do animation
	else:
		death(msg)

func death(msg):
	kill=true
	dialogue_node.show_text("Kill", msg)

func _on_dialogue_finished():
	if !kill:
		pass
	else:
		
