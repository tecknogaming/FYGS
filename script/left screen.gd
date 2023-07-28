extends Control

@onready var anim = $"../../AnimationPlayer"
@onready var trigger = $"area right"

func _ready():
	trigger.mouse_entered.connect(_trigger_facing)

func _trigger_facing():
	anim.play("camera_rotate_left_back")
