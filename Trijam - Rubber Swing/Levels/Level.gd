extends Node2D

export (String, FILE, "*.tscn") var Next_Scene
export (bool) var Slow_Start = false

onready var Solids = get_node("Solids")
onready var Player = get_node("Player")
onready var Stars = get_node("Stars")
onready var Sound:AudioStreamPlayer = AudioStreamPlayer.new()
var no_restart = false

onready var stars:int = get_tree().get_nodes_in_group("Star").size()
var speed:float = 0.5

func _ready()->void:
	Event.connect("restart", self, "on_restart")
	Event.connect("changeLevel", self, "on_changeLevel")
	Event.connect("collect", self, "on_collect")
	set_palette()
	if Slow_Start:
		Engine.time_scale = 0.01
	else:
		set_process(false)

func _process(delta):
	Engine.time_scale += delta/speed
	Engine.time_scale = clamp(Engine.time_scale, 0, 1)
	if Engine.time_scale == 1:
		set_process(false)

func set_palette():
	randomize()
	var pallete_index:int
	if !Event.special:
		pallete_index = randi() % Event.pallete_list.size()
	else:
		Event.special = false
		pallete_index = Event.pallete_list.size() - 1
		
	var pallete:Array = Event.pallete_list[pallete_index]
	VisualServer.set_default_clear_color(pallete[0])
	Solids.modulate = pallete[1]
	Stars.modulate = pallete[2]
	Player.modulate = pallete[3]

func on_collect():
	stars -= 1
	if stars == 0:
		no_restart = true
		var nice:Node = PreLoad.Congrats.instance()
		add_child(nice)
		Event.emit_signal("finished")




func on_changeLevel():
	get_tree().change_scene(Next_Scene)
