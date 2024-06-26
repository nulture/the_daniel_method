extends RigidBody3D

const emit_threshold = 100.0
const force_domain = 700.0
const volume_min = -10.0
const volume_max = 6.0

@export var audio_player : AudioStreamPlayer3D

var previous_velocity : Vector3

func _physics_process(delta: float) -> void:
	var acceleration = (linear_velocity - previous_velocity) / delta
	var dot = -previous_velocity.dot(acceleration)
	if dot > emit_threshold && audio_player != null && !audio_player.playing:
		audio_player.volume_db = clamp(remap(dot, emit_threshold, force_domain, volume_min, volume_max), volume_min, volume_max)
		audio_player.play()
	previous_velocity = linear_velocity
	
