extends Node2D

onready var tilemap: = $ViewportContainer/Viewport/TileMap
onready var tween = $ViewportContainer/Viewport/Tween
onready var snake = $ViewportContainer/Viewport/Snake
var duration:float = 2.0

func _ready()->void:
	Event.connect("Restart", self, "Restart")
	change_color()
	pre_load.player.stream = pre_load.s_start
	pre_load.player.play()

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to(load("res://Menu/Menu.tscn"))

func Restart()->void:
	get_tree().reload_current_scene()

func change_color()->void:
	Palette.new_palette()
	var material:Material = tilemap.material
	tween.interpolate_method(VisualServer,
								"set_default_clear_color",
								Palette.previous[0], Palette.current[0], duration,
								Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.interpolate_property(material,
								"shader_param/color1",
								Palette.previous[1], Palette.current[1], duration,
								Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.interpolate_property(material,
								"shader_param/color2",
								Palette.previous[2], Palette.current[2], duration,
								Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.interpolate_property(material,
								"shader_param/color3",
								Palette.previous[3], Palette.current[3], duration,
								Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()

func Tween_completed():
	snake.get_node("Timer").start()
