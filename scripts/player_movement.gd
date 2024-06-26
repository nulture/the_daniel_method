extends CharacterBody3D

signal step_l()
signal step_r()

@export var step_interval : float = 1.0

var step_distance : float
var step_on_left : bool
var input_disabled = false

@export var speed := 5.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var previous_position : Vector3

func _ready() -> void:
	previous_position = global_position

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	if input_disabled : return

	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
	
	step_distance += (global_position - previous_position).length()
	if (step_distance >= step_interval):
		step_distance -= step_interval
		shoe_step()
	previous_position = global_position

func shoe_step() -> void :
	if (!is_on_floor()): return

	if (step_on_left):
		step_l.emit()
	else:
		step_r.emit()
	step_on_left = !step_on_left


func _on_tunnel_body_entered(_body: Node3D) -> void:
	input_disabled = true
