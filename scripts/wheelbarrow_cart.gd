extends RigidBody3D

@export var handle : RigidBody3D
@export var cable : Path3D
@export var tether_pull_distance = 4.0
@export var tether_pull_strength = 1.0
@export var tether_turn_distance = 1.0
@export var tether_turn_strength = 1.0

@export_category("upright")
@export var upright_strength = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	var diff = handle.global_position - global_position
	var diff_length = diff.length()
	var pull_distance = max(diff_length - tether_pull_distance, 0.0)
	var turn_distance = float(diff_length > tether_turn_distance)
	var norm = diff.normalized()
	var turn_dot = global_basis.x.dot(diff)
	
	var upright_x = Vector3.RIGHT * global_basis.x.dot(Vector3.UP)
	var upright_z = Vector3.FORWARD * global_basis.z.dot(Vector3.UP)
	
	var upright_angular = (upright_x + upright_z) * upright_strength
	var tether_angular = Vector3.UP * turn_dot * turn_distance * tether_turn_strength
	var tether_linear = norm * pull_distance * tether_pull_strength
	
	apply_torque((upright_angular + tether_angular) * mass * delta)
	apply_force(tether_linear * mass * delta)
	
func _process(_delta: float) -> void:
	cable.curve.set_point_position(1, handle.global_position - cable.global_position)
	cable.global_rotation = Vector3()
	
