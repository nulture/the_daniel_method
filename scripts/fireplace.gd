class_name Fireplace extends Node3D

signal added_fuel
signal added_fuel_pointless

static var inst : Fireplace
static var warm_radius : float

@export var goal_heat : float = 100
@export var fuel_scalar : float = 1.0

@export var min_warm_radius : float
@export var decay_per_heat :float
@export var decay_per_tick : float
@export var follow_alpha : float
@export var pulse_depth : float
@export var pulse_speed : float

var _heat: float
var heat: float:
	get: return _heat
	set (value):
		_heat = max(value, 0.0)

var pulse : float :
	get :
		return sin(pulse_speed * Time.get_ticks_msec() / 1000.0) * pulse_depth

func _ready() -> void:
	inst = self

func _process(delta: float) -> void:
	if heat < goal_heat:
		heat -= (heat * decay_per_heat + decay_per_tick) * delta
	
	warm_radius = lerp(warm_radius, heat + min_warm_radius, follow_alpha * delta) 
	RenderingServer.global_shader_parameter_set("ring_position", global_position)
	RenderingServer.global_shader_parameter_set("ring_radius", warm_radius + pulse)

func _on_deposit_area_body_entered(body: Node3D) -> void:
	var fuel : Fuel = Utils.find_child(body, "Fuel")
	if (fuel == null): return
	
	heat += fuel.fuel_amount * fuel_scalar
	body.queue_free()
	
	added_fuel.emit()
	if heat == goal_heat:
		added_fuel_pointless.emit()

