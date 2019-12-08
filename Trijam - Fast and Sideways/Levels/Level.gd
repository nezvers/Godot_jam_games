extends Node2D

export (String, FILE, "*.tscn") var Next_Scene
export (float) var Time_limit:float = 20

func _ready()->void:
	Event.connect("NextScene", self, "next_scene")

func next_scene()->void:
	$Timer.start()
	$AudioStreamPlayer.play()

func _on_Timer_timeout()->void:
	get_tree().change_scene(Next_Scene)
