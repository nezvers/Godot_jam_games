extends CanvasLayer

onready var player_label: Label = $Control/Label
onready var enemy_label: Label = $Control/Label2
onready var player_text: String = player_label.text
onready var enemy_text: String = enemy_label.text

func _ready()->void:
	Event.connect("Playing", self, "on_Playing")
	Event.connect("Score", self, "on_Score")
	on_Score(0)
	Event.connect("Result", self, "on_Result")

func on_Score(point:int)->void:
	player_label.text = player_text+str(Event.player_points)
	enemy_label.text = enemy_text+str(Event.enemy_points)
	
	if point==0 || (Event.player_points != 0 && Event.enemy_points != 0):
		$Control/Start.show()
	else:
		Event.game_end = true

func on_Result(won:bool)->void:
	if won:
		$Control/Win.show()
	else:
		$Control/Lost.show()
	$Control/Restart.show()

func _on_Button_pressed()->void:
	Event.game_end = false
	get_tree().reload_current_scene()

func _on_Start_pressed()->void:
	Event.playing = true
	Event.emit_signal("Start")

func on_Playing()->void:
	if Event.playing:
		$Control/Start.hide()
		show_buttons()
	else:
		hide_buttons()

func _on_Rock_pressed()->void:
	Event.chosen = 0
	hide_buttons()

func _on_Scissor_pressed()->void:
	Event.chosen = 1
	hide_buttons()

func _on_Paper_pressed()->void:
	Event.chosen = 2
	hide_buttons()

func hide_buttons()->void:
	$Control/Rock.hide()
	$Control/Scissor.hide()
	$Control/Paper.hide()

func show_buttons()->void:
	$Control/Rock.show()
	$Control/Scissor.show()
	$Control/Paper.show()