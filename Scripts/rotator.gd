extends Node2D

@export var speed := 10.0

func _process(delta: float) -> void:
	rotation_degrees += delta * speed