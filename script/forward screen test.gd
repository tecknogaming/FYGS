extends Control

enum FacingDirection {
	Forward,
	Left,
	Right
}

@onready var camera = $"../../Camera3D"
@onready var anim = $"../../AnimationPlayer"

@onready var left_area_trigger: ColorRect = $"area left"
@onready var right_area_trigger: ColorRect = $"area right"

var current_direction = FacingDirection.Forward

func _ready():
	left_area_trigger.mouse_entered.connect(_left_area_mouse_entered)
	right_area_trigger.mouse_entered.connect(_right_area_mouse_entered)

func _left_area_mouse_entered():
	if current_direction == 0:
		anim.play("camera_rotate_left")
		current_direction = FacingDirection.Left
	elif current_direction == 2:
		anim.play("camera_rotate_right_back")
		current_direction = FacingDirection.Forward


func _right_area_mouse_entered():
	if current_direction == 0:
		anim.play("camera_rotate_right")
		current_direction = FacingDirection.Right
	elif current_direction == 1:
		anim.play("camera_rotate_left_back")
		current_direction = FacingDirection.Forward
