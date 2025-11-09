extends Node2D

@export var speed := 100.0
@export var randomization := 0.0
@export var random_direction := false

func _ready() -> void:
	speed *= 1 + randomization * randf_range(-1, 1)
	if random_direction and randf() < 0.5:
		speed *= -1

func _process(delta: float) -> void:
	rotation_degrees += delta * speed