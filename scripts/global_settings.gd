extends Node

var is_fullscreen : bool:
	get:
		return DisplayServer.window_get_mode()
	set(value):
		if (value):
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _input(event: InputEvent) -> void:
	if (OS.is_debug_build()):
		if (Input.is_action_just_pressed("quit")):
			get_tree().quit()
	
	if (event is InputEventMouseButton):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if (Input.is_action_just_pressed("fullscreen")):
		is_fullscreen = !is_fullscreen

