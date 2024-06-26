@tool
extends Node3D

@export var randomize_yaw := true

var _scene_index_override : int = -1
@export var scene_index_override : int = -1 :
	get : return _scene_index_override
	set (value) :
		if _scene_index_override == value : return
		_scene_index_override = clamp(value, -1, scene_pool.size() - 1)
		
		if is_scene_index_overridden: scene_index = _scene_index_override
		else: scene_index = random_index

@export var scene_pool : Array[PackedScene]

@export var _serialized_hash : int
var _child : Node3D

var random := RandomNumberGenerator.new()

var is_scene_index_overridden : bool :
	get : return _scene_index_override != -1

var random_index : int :
	get : return random.randi_range(0, scene_pool.size() - 1)
	
var random_yaw : float :
	get : return random.randf_range(0.0, 360.0)

var _scene_index : int = -1
var scene_index : int :
	get : return _scene_index
	set (value) :
		if _scene_index == value : return
		_scene_index = value
		
		refresh_scene()

func _ready() -> void:
	for i in get_child_count():
		get_child(i).queue_free()
	if !Engine.is_editor_hint():
		process_mode = Node.PROCESS_MODE_DISABLED
	_process(0)
	#var body := get_child(0).get_child(0) as StaticBody3D
	#body.collision_layer = body.collision_layer
	
func _process(_delta: float) -> void:
	refresh_seed()
	if !is_scene_index_overridden :
		scene_index = random_index
	else :
		refresh_rotation()
		
func refresh_seed() -> void :
	if Engine.is_editor_hint():
		_serialized_hash = hash(position)
	random.seed = _serialized_hash
	
func refresh_scene() -> void :
	if _child != null :
		_child.queue_free()
	_child = scene_pool[_scene_index].instantiate()
	refresh_rotation()
	add_child(_child)
	
func refresh_rotation() -> void :
	if randomize_yaw :
		_child.rotation_degrees = Vector3(_child.rotation_degrees.x, random_yaw, _child.rotation_degrees.z)
