extends Control

@onready var anim = $"../../AnimationPlayer"
@onready var trigger = $"area left"

func _ready():
	trigger.mouse_entered.connect(_trigger_facing)

func _trigger_facing():
	anim.play("camera_rotate_right_back")
