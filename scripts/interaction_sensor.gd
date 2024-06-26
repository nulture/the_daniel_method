class_name InteractionSensor extends RayCast3D

const HEX_ANIM_SHOW := "hex_show"
const HEX_ANIM_HIDE := "hex_hide"

@export var ui_label: Label
@export var ui_anim_player: AnimationPlayer

var _current_collider: CollisionObject3D
var current_collider: CollisionObject3D:
	get: return _current_collider
	set (value):
		if (_current_collider == value): return
		
		_current_collider = value
		
		if (!is_detecting_collider):
			current_interactable = null
		else:
			current_interactable = Utils.find_child(_current_collider, "Interactable")

var _current_interactable: Interactable
var current_interactable: Interactable:
	get: return _current_interactable
	set (value):
		if _current_interactable == value: return
		#if !value is Interactable:
			#value = null
		
		if (!is_detecting_interactable):
			ui_anim_player.play(HEX_ANIM_SHOW)
			
		_current_interactable = value
		
		if (is_detecting_interactable):
			ui_label.text = _current_interactable.get_tooltip()
		else:
			ui_anim_player.play(HEX_ANIM_HIDE)
			ui_label.text = String()
			
var is_detecting_collider: bool:
	get: return _current_collider != null
	
var is_detecting_interactable: bool:
	get: return _current_interactable != null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ui_anim_player.play(HEX_ANIM_HIDE)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	current_collider = get_collider()
