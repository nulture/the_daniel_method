
extends Control

@export var anim_player : AnimationPlayer
@export var label : Label
@export var fuel_percent_label : Label

func _ready() -> void:
	anim_player.play("fade_from_black")
	
func notify(message : String) -> void:
	label.text = message
	#anim_player.play("notify")

func _on_fireplace_added_fuel_pointless() -> void:
	notify("You sense that the flame cannot grow any further...")

func _on_tunnel_body_entered(_body: Node3D) -> void:
	anim_player.play("fade_to_white")
	var fuel_in_world = Fireplace.inst.heat / Fireplace.inst.fuel_scalar
	var fuel_percent = fuel_in_world / Fuel.total_fuel
	var percent_string = "%0.1f" % (fuel_percent * 100.0)
	fuel_percent_label.text = percent_string + "% fuel burned"
