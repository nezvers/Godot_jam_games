extends Control

func _ready():
	Event.connect("Finish", self, "on_Finish")
	Event.connect("Start", self, "on_Start")

func on_Finish():
	show()

func on_Start():
	hide()

func _on_ColorRect_mouse_entered():
	print("YAY")
	Event.emit_signal("Next_scene")
