extends Control

func _ready():
	Event.connect("Finish", self, "on_Finish")
	Event.connect("Start", self, "on_Start")

func _on_rect_mouse_entered():
	Event.can_finish = true

func on_Finish():
	hide()

func on_Start():
	show()