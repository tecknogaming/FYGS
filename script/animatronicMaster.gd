extends Node

const ANIMATRONIC_PATH_DATA = { # stores the path's of wich the animatronics will travel
	"test": {
		"start": ["test1"] 
	},
	"fine": {},
	"animtronic_fine": {},
	"animtronic_florb": {},
	"animtronic_xtl": {}
}
var path_node_data = {} # used to store runtime data of the PathNode's


# Register command used to register PathNodes of the animatronics
# Params: NodeName[STRING], Node[NODE3D/PATHNODE]
func register_path_node(nodeName: String, node: PathNode):
	_produce_path_node_data(nodeName, node)

# Finds the avilable paths of wich the animatronics can travel
# Params: AnimatronicName[STRING], CurrentHousingNode[STRING]
func find_next_available_paths(name: String, currentNode: String):
	if not ANIMATRONIC_PATH_DATA.has(name): # check if said animatronic is available in said data
		printerr("No animatronic data for the given name \"", name, "\"!")
		return[]
	if not ANIMATRONIC_PATH_DATA[name].has(currentNode): # check if said node is available for said animatronic
		printerr("Path data for node origin of ", currentNode, " not found for ", name, "!")
		return []
	
	# Outputs the data
	var next_available_paths = ANIMATRONIC_PATH_DATA[name][currentNode]
	if ANIMATRONIC_PATH_DATA[name][currentNode]:
		return next_available_paths
	else:
		return []

# Used for the animaronics to get path coordinates to travel to said destination
# Params: AnimatronicName[STRING], From[STRING], To[STRING]
func request_path(animatronicName: String, from: String, to: String):
	var coords = _get_coord_paths_for_node(animatronicName, from) # Request the coord paths for said animatronics
	var chosen_index = ANIMATRONIC_PATH_DATA[animatronicName][from].find(to) # get the index of the chosen coordpaths within the given array
	
	return coords[chosen_index] # outputs path

# Used privately to get all coordinate paths for the animatronic
# Params: AnimatronicName[STRING], CurrenHousingNodeName[STRING]
func _get_coord_paths_for_node(animName: String, nodeName: String):
	var options = ANIMATRONIC_PATH_DATA[animName][nodeName]
	var result = []
	for opt in options: # loop through all of the options to process them all
		var optionData = path_node_data[opt]
		var res = []
		res.push_front(Vector2(optionData["pos"].x, optionData["pos"].z)) # pushes the origin node's oordinates to the front
		while true:
			if optionData["child"] != null: # Check if looped ptions child paramater is valid or not
				optionData = optionData["child"] 
				res.push_front(Vector2(optionData["pos"].x, optionData["pos"].z))
				continue # if yes, push the coords to the temporary result array and continue looping
			else:
				break # if not break from loop
		
		result.append(res)
	
	return result

# Used to get a specific nodes coordinates
# Params: PathNodeInSpecifiedFormat
# PathNode Format: [PARENT NODE NAME]: TIER
func _get_node_coords(nodepath: String):
	var pathSplit = nodepath.split(":")
	var parent = pathSplit[0]
	var childTier = int(pathSplit[1])
	
	var parentData = path_node_data[parent]
	var resNode = parentData
	for tier in childTier:
		resNode = resNode["child"]
	
	return Vector2(resNode["pos"].x, resNode["pos"].z)

# Used to produce path node data to store
# Params: NodeName[STRING], Node[NODE3D/PATHNODE], PreTier[INT], IsChild[BOOL]
func _produce_path_node_data(nodeName: String, node: PathNode, preTier = 0, isChild = false):
	var standard_node_data = {
		"name": nodeName,
		"tier": preTier * -1,
		"pos": {
			"x": node.global_position.x,
			"z": node.global_position.z
		},
		"child": null,
	}
	
	if node.get_child_count() > 0:
		var tier = preTier - 1
		standard_node_data["child"] = _parse_node_path_child(node.get_child(0), tier)
		if path_node_data.has(standard_node_data["child"]["name"]): path_node_data.erase(standard_node_data["child"]["name"])

	if !isChild:
		path_node_data[nodeName] = standard_node_data
		return standard_node_data
	else:
		return standard_node_data

# Souly used to repeat the function above
# Params: Node[NODE3D/PATHNODE], PreTier[INT]
func _parse_node_path_child(node: PathNode, pretier = 0):
	return _produce_path_node_data(node.name, node, pretier, true )
