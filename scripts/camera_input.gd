extends Node3D

@export var yaw_node: Node3D
@export var stick_speed: float = 1
@export var mouse_speed: float = 1
@export var pitch_limit: float = 89

@export_category("sensitivity_settings")
@export var anim_player : AnimationPlayer
@export var sensitivity_label : Label
@export var min_sensitivity : float = 0.1
@export var max_sensitivity : float = 2.0
@export var sensitivity_interval : float = 0.1

var _sensitivity = 1.0
var sensitivity : float = 1.0 :
	get : return _sensitivity
	set (value) :
		_sensitivity = clamp(value, min_sensitivity, max_sensitivity)
		sensitivity_label.text = "Sensitivity: " + ("%1.1f" % _sensitivity) + "x"
		anim_player.stop()
		anim_player.play("notify")
	
var input_disabled = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if input_disabled : return
	var input_vector = Input.get_vector("camera_down", "camera_up", "camera_right", "camera_left")
	rotate_input(input_vector * stick_speed * sensitivity * delta)
	

func _input(event: InputEvent) -> void:
	if input_disabled : return
	if event is InputEventMouseMotion:
		var input_vector = -Vector2(event.relative.y, event.relative.x)
		rotate_input(input_vector * mouse_speed * sensitivity * 0.0167)
	if Input.is_action_just_pressed("sensitivity_add") :
		sensitivity += sensitivity_interval
	elif Input.is_action_just_pressed("sensitivity_sub") :
		sensitivity -= sensitivity_interval

func rotate_input(vector: Vector2) -> void:
	yaw_node.rotate_y(vector.y)
	rotate_x(vector.x)
	
	rotation_degrees.x = clampf(rotation_degrees.x, -pitch_limit, pitch_limit)


func _on_tunnel_body_entered(_body: Node3D) -> void:
	input_disabled = true
