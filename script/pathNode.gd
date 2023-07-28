extends Node3D
class_name PathNode

func _ready():
	AnimatronicMaster.register_path_node(name, self)
	set_process(false)
