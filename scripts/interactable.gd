class_name Interactable extends Node

@export var title: String
@export var tags: Array[StringName]

func get_tooltip() -> String:
	return title
	
func has_tag(tag: StringName) -> bool:
	for i in tags.size():
		if (tag == tags[i]): return true
	return false
