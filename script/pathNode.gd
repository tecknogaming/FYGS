extends Node3D
class_name PathNode

func _ready():
	AnimatronicMaster.register_path_node(name, self)
	set_process(false)
	await get_tree().create_timer(1).timeout
	get_parent().remove_child(self)
