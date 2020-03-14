extends Position2D

enum {EMPTY = -1, SOLID, SNAKE, FOOD, BAD}
export (float) var speed = 0.3


onready var start = position
const SIZE: = Vector2(20,10)
onready var tilemap: = $"../TileMap"
var positions: = []
var free: = []
var size: int = 4
var dir: = Vector2.RIGHT
var nextDir: = Vector2.RIGHT

func _ready()->void:
	#make a snake
	for i in size:
		var p: = (position-Vector2(i,0)).round()
		positions.append(p)
		tilemap.set_cellv(p, SNAKE)
	#make list of free positions
	for x in SIZE.x:
		for y in SIZE.y:
			if tilemap.get_cell(x,y) == EMPTY:
				free.append(Vector2(x,y).round())
	create_food()
	$Timer.wait_time = speed
	$Timer.start()

func _tick():
	get_dir()
	var tile = check_tile(positions.front())
	match tile:
		EMPTY:
			move()
		FOOD:
			eat()
		SNAKE:
			print('hit snake')
			Event.emit_signal("Restart")
		SOLID:
			print('hit solid')
			Event.emit_signal("Restart")

func _unhandled_input(event)->void:
	if !(event is InputEventKey):
		return
	var d = Vector2.ZERO
	if event.is_action_pressed("move_right"):
		d = Vector2.RIGHT
	elif event.is_action_pressed("move_left"):
		d = Vector2.LEFT
	elif event.is_action_pressed("move_down"):
		d = Vector2.DOWN
	elif event.is_action_pressed("move_up"):
		d = Vector2.UP
	if d != Vector2.ZERO && (d + dir) != Vector2.ZERO:
		nextDir = d

func get_dir()->void:
	if nextDir != Vector2.ZERO && (nextDir + dir) != Vector2.ZERO:
		dir = nextDir

func check_tile(pos:Vector2)->int:
	var tile = tilemap.get_cellv(pos_wrap(pos+dir))
	return tile

func move()->void:
	var tail = positions.pop_back().round()
	var next = pos_wrap(positions.front() + dir).round()
	#tail as next head
	positions.push_front(next)
	#remove tail and add head
	tilemap.set_cellv(tail, EMPTY)
	tilemap.set_cellv(next, SNAKE)
	#update free slot list
	var index = free.rfind(next)
	free.erase(next)
	free.append(tail)

func pos_wrap(pos:Vector2)->Vector2:
	pos.x = fmod(pos.x+SIZE.x, SIZE.x)
	pos.y = fmod(pos.y+SIZE.y, SIZE.y)	
	return pos

func create_food()->void:
	var pos:Vector2 = free[randi() % free.size()].round()
	tilemap.set_cellv(pos, FOOD)

func eat()->void:
	var next = pos_wrap(positions.front() + dir).round()
	#tail as next head
	positions.push_front(next)
	#remove tail and add head
	tilemap.set_cellv(next, SNAKE)
	#update free slot list
	free.erase(next)
	create_food()
