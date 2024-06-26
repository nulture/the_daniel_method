@tool
extends Node3D

@export var pawn_node : Node3D

var view_node : Camera3D :
	get: return EditorInterface.get_editor_viewport_3d().get_camera_3d()

var applied_rotation : Vector3 :
	get: return Vector3(pawn_node.global_rotation.x, global_rotation.y, pawn_node.global_rotation.z)

func _ready() -> void:
	if !Engine.is_editor_hint():
		if OS.is_debug_build() && visible:
			pawn_node.global_position = global_position
			pawn_node.global_rotation = applied_rotation
		queue_free()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		global_position = view_node.global_position
		global_rotation = view_node.global_rotation
