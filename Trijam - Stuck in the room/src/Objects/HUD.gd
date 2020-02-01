extends CanvasLayer

onready var score:Label = $"Control/MarginContainer/Label"
onready var score_text:String = score.text
onready var bricks:Label = $"Control/MarginContainer/Label3"
onready var bricks_text:String = bricks.text

signal restart

func _ready()->void:
	Event.connect("score", self, "on_score")
	Event.connect("game_over", self, "on_game_over")
	$Control/MarginContainer/Label2.visible = false
	set_process_unhandled_input(false)
	score.text = score_text + str(0)
	bricks.text = bricks_text + str(0)

func _unhandled_input(event)->void:
	if event is InputEventKey && event.is_pressed():
		emit_signal("restart")

func on_score()->void:
	score.text = score_text + str(Event.highest)
	bricks.text = bricks_text + str(Event.bricks)

func on_game_over(msg = null)->void:
	print(msg)
	$Control/MarginContainer/Label2.visible = true
	set_process_unhandled_input(true)
	yield(self, "restart")
	Event.emit_signal("reset")
