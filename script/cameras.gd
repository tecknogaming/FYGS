extends Node3D


func _ready():
	for cam in get_children():
		CameraSytem.register_camera(cam.name, cam)

