extends Node3D


func _ready():
	CameraSytem.main_camera = $Camera3D
	set_process(false)
	set_physics_process(false)
