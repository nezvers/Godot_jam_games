extends CanvasLayer

export (float) var Time: float = 20.0
onready var time_text: String = $Control/Time.text
onready var time_label: Label = $Control/Time

func _ready()->void:
	Event.connect("Strength", self, "on_Strength")
	Event.connect("Start", self, "on_Start")
	Event.connect("StopTime", self, "on_StopTime")
	draw_text()
	set_process(false)

func on_Strength(strength:float)->void:
	$Control/TextureProgress.value = strength*100

func on_Start()->void:
	set_process(true)

func on_StopTime()->void:
	set_process(false)

func _process(delta)->void:
	Time -= delta
	if Time <= 0.0:
		get_tree().reload_current_scene()
		pass
	draw_text()

func draw_text()->void:
	var t = floor(Time * 100)/100
	time_label.text = time_text+ str(t)