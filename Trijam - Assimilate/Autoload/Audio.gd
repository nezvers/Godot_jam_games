extends Node

onready var damage_player: = $Damage
onready var shoot_player: = $Shoot
onready var death_player: = $Death
onready var assimilate_player: = $Assimilate

func damage()->void:
	damage_player.pitch_scale = rand_range(0.8, 1.2)
	damage_player.play()
	
func shoot()->void:
	shoot_player.pitch_scale = rand_range(0.8, 1.2)
	shoot_player.play()
	
func death()->void:
	death_player.pitch_scale = rand_range(0.8, 1.2)
	death_player.play()
	
func assimilate()->void:
	assimilate_player.pitch_scale = rand_range(0.8, 1.2)
	assimilate_player.play()
