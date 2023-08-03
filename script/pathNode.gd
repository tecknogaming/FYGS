extends Node3D
class_name PathNode

enum PathNodeTypes {
	Path,
	Vent,
	TP
}

@export var PathNodeType: PathNodeTypes = 0

func _ready():
	AnimatronicMaster.register_path_node(name, self, PathNodeType)
	await get_tree().create_timer(1).timeout
	get_parent().remove_child(self)
