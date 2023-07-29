extends Node
signal data_saved

const SAVE_FILE = "user://CMDSAVE.sv"
const DEFAULT_SAVE_FILE = "res://defaults/save_file_default.json"
var SAVE_DATA = {}

func _ready():
	_check_save()
	get_data_from_file()

func _check_save():
	if not FileAccess.file_exists(SAVE_FILE):
		_load_default_data()
		_write_data_to_file()

func _write_data_to_file():
	var svFile = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	var string_data = ""
	var version = ProjectSettings.get_setting("global/build_version")
	string_data += String("["+version+"]"+"\n")
	string_data += "-\n"
	for data in SAVE_DATA:
		if data == "version": 
			continue
		var data_name = data
		data = SAVE_DATA[data]
		string_data += data_name+"="+str(data)+"\n"
	svFile.store_string(string_data)
	emit_signal("data_saved")
	svFile.close()

func get_data_from_file():
	var svFile = FileAccess.open(SAVE_FILE, FileAccess.READ)
	var string_data = svFile.get_as_text().split("\n")
	string_data.remove_at(1)
	string_data.remove_at(string_data.size() - 1)
	for dat in string_data:
		if dat.begins_with("[") or dat.begins_with("-"):
			continue
		var splited_data = dat.split("=")
		SAVE_DATA[splited_data[0]] = splited_data[1]

func _load_default_data():
	var default_string = FileAccess.open(DEFAULT_SAVE_FILE, FileAccess.READ).get_as_text()
	var default = JSON.parse_string(default_string)
	SAVE_DATA = default
