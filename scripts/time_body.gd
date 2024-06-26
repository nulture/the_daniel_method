class_name TimeBody extends CollisionObject3D

@export var is_visibility_changed : bool = true
@export var is_enabled_in_winter : bool

var _is_collision_enabled : bool
var is_collision_enabled : bool :
	get: return _is_collision_enabled
	set (value):
		_is_collision_enabled = value
		
		if value:
			collision_layer = _default_layer
		else:
			collision_layer = 0
		
		set_collision_layer_value(4, true)
		if is_visibility_changed:
			visible = value
		
var _default_layer : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_default_layer = collision_layer
	on_exited_summer()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func on_entered_summer() -> void:
	is_collision_enabled = !is_enabled_in_winter
	pass
	
func on_exited_summer() -> void:
	is_collision_enabled = is_enabled_in_winter
	pass
