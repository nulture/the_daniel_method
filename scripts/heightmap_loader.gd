@tool
extends CollisionShape3D

# var _height_scale : float = 1.0
# @export var height_scale : float :
# 	get: return _height_scale
# 	set (value):
# 		_height_scale = value
# 		refresh()

@export var refresh_button : bool :
	get: return false
	set (value):
		refresh()

var _height_texture : Image
@export var height_texture : Image :
	get: return _height_texture
	set (value):
		_height_texture = value
		refresh()

func _ready() -> void:
	refresh()

func refresh() -> void:	
	if (_height_texture == null) : return

	_height_texture.convert(Image.FORMAT_RF)
	var map = shape as HeightMapShape3D
	map.map_width = _height_texture.get_width()
	map.map_depth = _height_texture.get_height()

	map.map_data = _height_texture.get_data().to_float32_array()
