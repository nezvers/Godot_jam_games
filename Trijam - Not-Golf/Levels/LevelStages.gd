extends Level

onready var Solids = get_node("Solids")
onready var Player = get_node("Player/Sprite")
onready var Indicator = get_node("Player/Indicator")
onready var Goal:Area2D = get_node("Goal")
onready var Sound:AudioStreamPlayer = AudioStreamPlayer.new()


func _ready():
	Goal.connect("body_entered", self, "Goal_reached")
	add_child(Sound)
	randomize()
	var pallete_index:int = randi() % Event.pallete_list.size()
	var pallete:Array = Event.pallete_list[pallete_index]
	VisualServer.set_default_clear_color(pallete[0])
	Solids.modulate = pallete[1]
	Player.modulate = pallete[2]
	Indicator.modulate = pallete[3]


func Goal_reached(body):
	print("GOAL")
	Sound.stream = pre_load.snd_goal
	Sound.play()
	change_level()