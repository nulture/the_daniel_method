extends Node

@export var audio_summer : AudioStreamPlayer
@export var audio_winter : AudioStreamPlayer

@export var volume_lerp_curve_summer : Curve
@export var volume_lerp_curve_winter : Curve
@export var volume_lerp_alpha = 1.0
@export var volume_all_lerp_alpha = 1.0

var target_music_all_volume = 0.0

var _summer_volume : float = 0.0
var summer_volume : float :
	get : return _summer_volume
	set (value) :
		_summer_volume = clamp(value, 0.0, 1.0)
		AudioServer.set_bus_volume_db(2, volume_lerp_curve_summer.sample(_summer_volume))
		AudioServer.set_bus_volume_db(3, volume_lerp_curve_winter.sample(_summer_volume))
		AudioServer.set_bus_volume_db(5, volume_lerp_curve_summer.sample(_summer_volume))
		AudioServer.set_bus_volume_db(6, volume_lerp_curve_winter.sample(_summer_volume))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	summer_volume = FogController.inst.is_inside_summer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	summer_volume = lerp(_summer_volume, float(FogController.inst.is_inside_summer), volume_lerp_alpha * delta)
	AudioServer.set_bus_volume_db(1, lerp(AudioServer.get_bus_volume_db(1), target_music_all_volume, volume_all_lerp_alpha * delta))

func play() -> void:
	audio_summer.play()
	audio_winter.play()
	
func fade_all_music() -> void:
	target_music_all_volume = -80.0

func _on_music_trigger_area_body_exited(_body: Node3D) -> void:
	play()

func _on_tunnel_body_entered(_body: Node3D) -> void:
	fade_all_music()

