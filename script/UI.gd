extends Control
signal flashlight_flash

@onready var flashlight = $"../../flashlight"
@onready var animPlayer = $"../../AnimationPlayer"
@onready var area_right = $"area right"
@onready var area_left = $"area left"
@onready var area_middle = $"area middle"
@onready var area_top = $"area top"
@onready var area_bottom_1 = $"area bottom 1"
@onready var area_bottom_2 = $"area bottom 2"
@onready var fpsCounter = $"fps counter"


enum FacingDirections {
	Forward,
	Left,
	Bed,
	Camera
}

var current_facing = 0

func _ready():
	area_right.mouse_entered.connect(_area_right_trigger)
	area_left.mouse_entered.connect(_area_left_trigger)
	area_right.gui_input.connect(_area_right_gui_trigger)
	area_left.gui_input.connect(_area_left_gui_trigger)
	area_middle.gui_input.connect(_area_middle_trigger)
	area_bottom_1.mouse_entered.connect(_area_bottom_1_trigger)
	area_bottom_2.mouse_entered.connect(_area_bottom_2_trigger)
	area_top.mouse_entered.connect(_area_top_trigger)
	var tim = Timer.new()
	tim.one_shot = false
	tim.autostart = true
	tim.wait_time = 1
	tim.timeout.connect(_update_fps)
	add_child(tim)

func _update_fps():
	fpsCounter.text = str(Engine.get_frames_per_second()) + " fps"

func _area_left_trigger():
	match current_facing:
		FacingDirections.Forward:
			area_left.visible = false
			area_bottom_1.visible = false
			area_bottom_2.visible = false
			animPlayer.play("look_side")
			await animPlayer.animation_finished
			current_facing = FacingDirections.Left
			area_right.visible = true
			area_middle.visible = true
			pass
		_:
			pass

func _area_right_trigger():
	match current_facing:
		FacingDirections.Left:
			area_right.visible = false
			area_middle.visible = false
			animPlayer.play("look_forward")
			await animPlayer.animation_finished
			current_facing = FacingDirections.Forward
			area_left.visible = true
			area_bottom_1.visible = true
			area_bottom_2.visible = true
			pass
		_:
			pass

func _area_middle_trigger(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				flashlight.visible = true
				emit_signal("flashlight_flash")
			elif not event.pressed:
				flashlight.visible = false

func _area_bottom_1_trigger():
	match current_facing:
		FacingDirections.Forward:
			area_left.visible = false
			area_bottom_1.visible = false
			area_bottom_2.visible = false
			animPlayer.play("camera_open")
			await  animPlayer.animation_finished
			CameraSytem.open_camera()
			current_facing = FacingDirections.Camera
			area_top.visible = true
			area_left.visible = true
			area_right.visible = true

func _area_bottom_2_trigger():
	match current_facing:
		FacingDirections.Forward:
			area_bottom_1.visible = false
			area_bottom_2.visible = false
			area_right.visible = false
			area_left.visible = false
			animPlayer.play("enter_sleep")
			await animPlayer.animation_finished
			current_facing = FacingDirections.Bed
			area_top.visible = true
			pass
			
		_:
			pass

func _area_top_trigger():
	match current_facing:
		FacingDirections.Bed:
			area_top.visible = false
			animPlayer.play("exit_sleep")
			await animPlayer.animation_finished
			current_facing = FacingDirections.Forward
			area_bottom_1.visible = true
			area_bottom_2.visible = true
			area_left.visible = true
		
		FacingDirections.Camera:
			CameraSytem.close_camera()
			await CameraSytem.cam_close
			area_top.visible = false
			area_left.visible = false
			area_right.visible = false
			animPlayer.play_backwards("camera_open")
			await animPlayer.animation_finished
			current_facing = FacingDirections.Forward
			area_bottom_1.visible = true
			area_bottom_2.visible = true
			area_left.visible = true
		
		_:
			pass

func _area_left_gui_trigger(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				match current_facing:
					FacingDirections.Camera:
						var cam_before_current = ""
						if CameraSytem.curr_cam_num == "01":
							cam_before_current = "06"
						else:
							cam_before_current =  "0"+str(int(CameraSytem.curr_cam_num) - 1);
						CameraSytem.change_camera(cam_before_current)
						pass
					_:
						pass

func _area_right_gui_trigger(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				match current_facing:
					FacingDirections.Camera:
						var cam_after_current = ""
						if CameraSytem.curr_cam_num == "06":
							cam_after_current = "01"
						else:
							cam_after_current =  "0"+str(int(CameraSytem.curr_cam_num) + 1);
						CameraSytem.change_camera(cam_after_current)
						pass
					_:
						pass
