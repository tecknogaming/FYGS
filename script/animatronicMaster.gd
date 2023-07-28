extends Node

const ANIMATRONIC_PATH_DATA = {
	"test": {
		"start": ["test1"] 
	},
	"fine": {},
	"animtronic_fine": {},
	"animtronic_florb": {},
	"animtronic_xtl": {}
}
var path_node_runtime_data = {}
var path_node_locations = {}

func _ready():
	await get_tree().create_timer(1).timeout
#	_get_node_coords("test1:2")
	_get_coord_paths_for_node("test", "start")

func _process(delta):
	pass

func register_path_node(nodeName: String, node: PathNode):
#	if node != PathNode:
#		printerr("Node is not a type of PathNode! registration failed")
#		return { "err": "NOT_PATHNODE" }
	
	_parse_node_path(nodeName, node)
	_produce_path_node_runtime_data(nodeName, node)

func get_animatronic_path_nodes(name: String):
	pass

func find_next_available_paths(name: String, currentNode: String):
	if not ANIMATRONIC_PATH_DATA.has(name):
		printerr("No animatronic data for the given name \"", name, "\"!")
		return
	
	var next_available_paths = []
	
	if not ANIMATRONIC_PATH_DATA.has(currentNode):
		printerr("Path data for node origin of ", currentNode, " not found for ", name, "!")
		return []
	
	elif ANIMATRONIC_PATH_DATA[name][currentNode]:
		pass
	else:
		return []

func _get_coord_paths_for_node(animName: String, nodeName: String):
	var options = ANIMATRONIC_PATH_DATA[animName][nodeName]
	
	var result = []
	
	for opt in options:
		var optionData = path_node_runtime_data[opt]
		var res = []
		res.push_front(Vector2(optionData["pos"].x, optionData["pos"].z))
		while true:
			if optionData["child"] != null:
				optionData = optionData["child"]
				res.push_front(Vector2(optionData["pos"].x, optionData["pos"].z))
				continue
			else:
				break
		
		result.append(res)
	
	return result

# how PathNodes: [PARENT NODE NAME]: TIER
func _get_node_coords(nodepath: String):
	var pathSplit = nodepath.split(":")
	var parent = pathSplit[0]
	var childTier = int(pathSplit[1])
	
	var parentData = path_node_runtime_data[parent]
	var resNode = parentData
	for tier in childTier:
		resNode = resNode["child"]
	
	return Vector2(resNode["pos"].x, resNode["pos"].z)

func _produce_path_node_runtime_data(nodeName: String, node: PathNode, preTier = 0, isChild = false):
	var standard_node_data = {
		"name": nodeName,
		"tier": preTier * -1,
		"pos": {
			"x": node.global_position.x,
			"z": node.global_position.z
		},
		"child": null,
		"used": false, # used for if an animatronic is already in the node to avoid overlaping
		"targated": false # used for if an animatronic is traveling towards the node to avoid overlaping
	}
	
	print(standard_node_data)
	
	if node.get_child_count() > 0:
		var tier = preTier - 1
		standard_node_data["child"] = _parse_node_path_child(node.get_child(0), tier)
		if path_node_locations.has(standard_node_data["child"]["name"]): path_node_locations.erase(standard_node_data["child"]["name"])
		if path_node_runtime_data.has(standard_node_data["child"]["name"]): path_node_runtime_data.erase(standard_node_data["child"]["name"])

	if !isChild:
		path_node_runtime_data[nodeName] = standard_node_data
		return standard_node_data
	else:
		return standard_node_data

func _parse_node_path_child(node: PathNode, pretier = 0):
	return _produce_path_node_runtime_data(node.name, node, pretier, true )

func _parse_node_path(nodeName: String, node: PathNode):
	path_node_locations[nodeName] =  node.global_position
	
