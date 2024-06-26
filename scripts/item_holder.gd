class_name ItemHolder extends Node3D

@export var sensor: InteractionSensor
@export var collision_change_timer: Timer

@export var forward_strength = 200.0
@export var up_strength = 100.0
@export var diff_strength = 10.0

var last_dropped_item : RigidBody3D
var held_collision_layer : int
var previous_position : Vector3
var delta_time : float

var throw_force : Vector3 :
	get :
		var base_force = -global_transform.basis.z * forward_strength + Vector3.UP * up_strength
		#var diff_force = (global_position - previous_position) * min(diff_strength / delta_time, forward_strength + up_strength)
		#var the_force : Vector3
		#if base_force.length_squared() > diff_force.length_squared() :
			#the_force = base_force
		#else :
			#the_force = diff_force
		#
		#return (the_force) * _held_item.mass
		return base_force

var _held_item: RigidBody3D
var held_item: RigidBody3D:
	get: return _held_item
	set (value):
		if (_held_item == value): return
		
		if (is_holding_item):
			last_dropped_item = _held_item
			collision_change_timer.start()
			_held_item.freeze = false
			_held_item.reparent(get_tree().root)
			_held_item.apply_force(throw_force)
		
		_held_item = value
		
		if (is_holding_item):
			held_collision_layer = _held_item.collision_layer
			_held_item.collision_layer = 0
			_held_item.freeze = true
			_held_item.reparent(self)
			_held_item.position = -_held_item.center_of_mass
			_held_item.rotation = Vector3.ZERO

var is_holding_item: bool:
	get: return _held_item != null
	
func _physics_process(delta: float) -> void:
	delta_time = delta
	if (is_holding_item):
		if (Input.is_action_just_released("primary")):
			held_item = null
	elif (Input.is_action_just_pressed("primary")):
		if (sensor.current_interactable != null):
			var body = sensor.current_interactable.get_parent() as RigidBody3D
			if (body != null && body is RigidBody3D):
				held_item = body
	previous_position = global_position

func _on_collision_change_timer_timeout() -> void:
	last_dropped_item.collision_layer = held_collision_layer
