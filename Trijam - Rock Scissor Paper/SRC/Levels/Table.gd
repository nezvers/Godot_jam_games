extends Node2D

var WHITE: Color = Color(1,1,1,1)
const RED: Color = Color(1,0,0,1)
const YELLOW: Color = Color(1,1,0,1)
onready var player:Sprite = get_node("Hands/Player")
var enemy:int = -1
var sound_hands: Array = [pre_load.s_hand1, pre_load.s_hand2, pre_load.s_hand3]

func _ready()->void:
	randomize()
	Event.connect("Playing", self, "playing")
	Event.connect("Choice", self, "choice")
	Event.connect("Start", self, "start")
	Event.connect("Score", self, "on_Score")

func playing()->void:
	if Event.playing:
		start()

func start()->void:
	$AnimationPlayer.stop(true)
	$AnimationPlayer.play("Start")
	player.modulate = WHITE
	$Hands/Enemy.texture = pre_load.hand1
	enemy = -1

func play_hit_sound()->void:
	sound_hands.shuffle()
	$SFX.stream = sound_hands.front()
	$SFX.play()

func choice()->void:
	if !Event.can_reveal:
		player.modulate = RED
		$SFX.stream = pre_load.s_wrong
		$SFX.play()
	match Event.chosen:
		-1:	#Rock
			player.texture = pre_load.hand1
		0:	#Rock
			player.texture = pre_load.hand1
		1:	#Scissor
			player.texture = pre_load.hand2
		2:	#Paper
			player.texture = pre_load.hand3

func reveal_time()->void:
	Event.can_reveal = true
	if player.modulate == WHITE:
		player.modulate = YELLOW
	enemy_choice()

func score()->void:
	Event.can_reveal = false
	player.modulate = WHITE
	get_point()
	

func animation_end()->void:
	$AnimationPlayer.play("Default")

func enemy_choice()->void:
	enemy = randi() % 3
	match enemy:
		0:	#Rock
			$Hands/Enemy.texture = pre_load.hand1
		1:	#Scissor
			$Hands/Enemy.texture = pre_load.hand2
		2:	#Paper
			$Hands/Enemy.texture = pre_load.hand3

func get_point()->void:
	var p = Event.chosen	#Player hand
	if p == -1:
		Event.player_points -= 1
	if p == 0:
		if enemy == 0: #draw
			Event.player_points -= 0
		elif enemy == 1:
			Event.enemy_points -= 1
		elif enemy == 2:
			Event.player_points -= 1
	elif p == 1:
		if enemy == 0: #draw
			Event.player_points -= 1
		elif enemy == 1:
			Event.player_points -= 0
		elif enemy == 2:
			Event.enemy_points -= 1
	elif p == 2:
		if enemy == 0: #draw
			Event.enemy_points -= 1
		elif enemy == 1:
			Event.player_points -= 1
		elif enemy == 2:
			Event.player_points -= 0

func on_Score(point:int)->void:
	if point == 0:
		$SFX.stream = pre_load.s_draw
		$SFX.play()
		return
	if point == -1:
		var childs = $PlayerLegs.get_children()
		for child in childs:
			if child.is_in_group("Legs"):
				$PlayerLegs.remove_child(child)
				get_node("EnemyLegs").add_child(child)
				child.new_position(get_node("EnemyLegs/Position2D").global_position)
				$SFX.stream = pre_load.s_lose
				$SFX.play()
				break
	if point == +1:
		var childs = get_node("EnemyLegs").get_children()
		for child in childs:
			if child.is_in_group("Legs"):
				$EnemyLegs.remove_child(child)
				get_node("PlayerLegs").add_child(child)
				child.new_position(get_node("PlayerLegs/Position2D").global_position)
				$SFX.stream = pre_load.s_win
				$SFX.play()
				break








