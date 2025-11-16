extends Node

@export var id: String

func _ready() -> void:
	if GameState.has(id):
		queue_free()