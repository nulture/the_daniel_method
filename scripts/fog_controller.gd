class_name FogController extends WorldEnvironment

signal on_warp
signal on_warp_summer
signal on_warp_winter

@export_category("Refs")
@export var camera: Node3D
@export var fireplace: Fireplace

@export_category("Density")
@export var min_density: float
@export var max_density: float
@export var summer_multiplier : float

@export var dot_curve: Curve
@export var dist_max: float
@export var dist_curve: Curve
@export var heat_max: float
@export var heat_curve: Curve
@export var density_lerp_alpha : float = 1.0

@export_category("Color")
@export var winter_color : Color
@export var summer_color : Color
@export var color_lerp_alpha : float = 1.0

static var inst : FogController

var _is_inside_summer : bool
var is_inside_summer : bool :
	get : return _is_inside_summer
	set (value) :
		if _is_inside_summer == value : return
		_is_inside_summer = value
		on_warp.emit()
		if _is_inside_summer : on_warp_summer.emit()
		else : on_warp_winter.emit()

var color : Color :
	get :
		if is_inside_summer : return summer_color
		else : return winter_color

var summer_density_mult : float :
	get :
		if is_inside_summer : return summer_multiplier
		else : return 1.0

var fromto : Vector3 :
	get: return camera.global_position - fireplace.global_position
	
func _ready() -> void:
	inst = self

func _process(delta: float) -> void :
	is_inside_summer = fromto.length() < Fireplace.inst.warm_radius
	var density_alpha : float
	if is_inside_summer :
		density_alpha = clamp(Fireplace.inst.warm_radius / Fireplace.inst.goal_heat, 0, 1)
	else :
		density_alpha = 0.0
	var density = lerp(max_density, min_density, density_alpha) * summer_density_mult
	environment.fog_density = lerp(environment.fog_density, density, density_lerp_alpha * delta)
	
	environment.fog_light_color = lerp(environment.fog_light_color, color, color_lerp_alpha * delta)

