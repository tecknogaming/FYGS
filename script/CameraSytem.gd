extends Node
signal cam_open
signal cam_close

@export var isBroken := false
@export var isBlocked := false

var main_camera: Camera3D
var used_camera: Camera3D
# format: [ID] : [NODE]
var starting_cam = "02"
var curr_cam_num = "02"
var registered_cameras = {}
var registerd_camera_locations = []
var current_camera: Camera3D = null

func _ready():
	curr_cam_num = starting_cam

func register_camera(id: String, camera: Camera3D):
	registered_cameras[id] = camera
	return camera

func open_camera():
	if current_camera == null:
		current_camera = registered_cameras[starting_cam]
	
	main_camera.current = false
	current_camera.current = true
	emit_signal("cam_open")
	

func close_camera():
	main_camera.current = true
	current_camera.current = false
	emit_signal("cam_close")

func change_camera(To: String):
	if not registered_cameras.has(To):
		printerr("Camera with id \"", To, " \" Not Found!")
		pass
	
	var camera_before = current_camera
	current_camera = registered_cameras[To]
	camera_before.current = false
	current_camera.current = true
	curr_cam_num = To

func fix_camera():
	var delay = 8 # in seconds
	



