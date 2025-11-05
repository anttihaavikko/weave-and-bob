class_name Letter
extends Nudgeable

@export var letter := ""
@export var label: Label

func _ready() -> void:
	label.text = letter
	
