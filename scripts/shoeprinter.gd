extends RayCast3D

@export var prefab : PackedScene

func create_shoeprint() -> void :
	if not is_colliding(): return

	var node : Node3D = prefab.instantiate()
	# node.global_transform = global_transform
	get_tree().root.add_child(node)

	node.global_position = get_collision_point()
	node.look_at(node.global_position + get_collision_normal(), -global_basis.z)
	
