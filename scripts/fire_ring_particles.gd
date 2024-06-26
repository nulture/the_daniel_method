extends GPUParticles3D

func _process(_delta: float) -> void:
	scale = Vector3(1, 0, 1) * Fireplace.warm_radius + Vector3.UP
	visible = Fireplace.inst.heat > 0
	amount_ratio = Fireplace.warm_radius
