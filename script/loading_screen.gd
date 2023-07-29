extends Control
signal finish_out
signal finish_in

@onready var loadingIcon = $"loading and activity/loading"
@onready var activityTitle = $"loading and activity/activity"
@onready var animPlay = $AnimationPlayer
@onready var paths = []

func _ready():
	$ColorRect.color = Color(0, 0, 0, 255)
	loadingIcon.play("default")
	await get_tree().create_timer(2).timeout
	close()

func open():
	animPlay.play("in")
	emit_signal("finish_in")

func close():
	animPlay.play("out")
	emit_signal("finish_out")

func change_activiy(To: String):
	activityTitle.text = To
