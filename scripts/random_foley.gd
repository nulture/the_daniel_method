extends AudioStreamPlayer3D

@export var timer : Timer
@export var min_repeat_time : float = 10.0
@export var max_repeat_time : float = 60.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_on_finished()

func _on_finished() -> void:
	timer.wait_time = randf_range(min_repeat_time, max_repeat_time)
	timer.start()
