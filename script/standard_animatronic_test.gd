extends CharacterBody3D

@export var move_interval := 3
@export var move_chance := 2
@export var move_speed_level := 1
@export var activation_delay := 5
var currentNode = "start"

var MoveSpeeds = {
	1: {
		animation_speed = 1,
		movement_speed = 120
	}
}

var timer: Timer
var isMoving = false

func _ready():
	_setup()
	await get_tree().create_timer(activation_delay).timeout
	initiate()

func _setup():
	timer = Timer.new()
	timer.wait_time = move_interval
	timer.one_shot = false
	timer.timeout.connect(_can_move)
	add_child(timer)

func initiate():
	timer.start()

func _can_move():
	var ran1 = randi() % move_chance + 1
	var ran2 = randi() % move_chance
	var isTrue = ran1 == ran2
	
	if isTrue:
		print("yes")
		var path = _request_path()
		_follow_path(path[0], path[1])

func _request_path():
	var next_available = AnimatronicMaster.find_next_available_paths(name, currentNode)
	var chosen_path = next_available[(randi() % next_available.size())]
	var fetched_path = AnimatronicMaster.request_path(name, currentNode, chosen_path)
	return [chosen_path, fetched_path]

func _follow_path(chosenPathName, pathCoords):
	pass
