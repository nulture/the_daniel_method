extends Area3D

@export var shape : CollisionShape3D
var sphere : SphereShape3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sphere = shape.shape as SphereShape3D
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	sphere.radius = Fireplace.warm_radius
	pass

func _on_body_entered(body: Node3D) -> void:
	if body is TimeBody:
		body.on_entered_summer()


func _on_body_exited(body: Node3D) -> void:
	if body is TimeBody:
		body.on_exited_summer()
