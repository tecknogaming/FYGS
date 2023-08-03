extends Node3D


func _ready():
	remove_child($DevMarkers)
	set_process(false)
	set_physics_process(false)
	
