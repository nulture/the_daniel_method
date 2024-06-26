class_name Fuel extends Node

@export var fuel_amount: float

static var total_fuel : float
func _ready() -> void:
	total_fuel += fuel_amount
	print("Total fuel in world: %s" % total_fuel)
