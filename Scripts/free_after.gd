extends Node

@export var delay := 5.0

func _ready() -> void:
	await get_tree().create_timer(delay).timeout
	queue_free()