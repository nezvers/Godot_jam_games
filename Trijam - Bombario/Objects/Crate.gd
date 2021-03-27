extends StaticBody2D

enum list {BOMB, REMOTE, STRENGTH}

export (list) var pickup

func damage()->void:
	var item: Area2D = PreLoad.Pickup.instance()
	item.pickup = pickup
	item.global_position = global_position
	get_parent().call_deferred('add_child', item)
	queue_free()
