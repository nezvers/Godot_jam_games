extends Area2D

onready var sprite:Sprite = $Sprite
onready var audio:AudioStreamPlayer = $AudioStreamPlayer

enum {BOMB, REMOTE, STRENGTH}

var pickup:int

func _ready()->void:
	sprite.frame = pickup
	audio.stream = PreLoad.snd_Coin

func _on_Pickup_body_entered(body):
	match pickup:
		BOMB:
			Stats.bombs_max += 1
			Stats.bombs_left += 1
		REMOTE:
			Stats.remote_control = true
		STRENGTH:
			Stats.strength += 0.2
	
	Event.emit_signal("pickup")
	visible = false
	monitorable = false
	monitoring = false
	audio.play()
	yield(audio, "finished")
	queue_free()
