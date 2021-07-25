extends Area2D

onready var sprite:Sprite = $Sprite

func _ready()->void:
# warning-ignore:return_value_discarded
	Event.connect("level_cleared", self, "level_cleared")

func level_cleared()->void:
	$CollisionShape2D.set_deferred("disabled", false)
	sprite.frame = 1


func _on_Door_body_entered(body):
	if body is Player:
		Event.emit_signal("next_level")
