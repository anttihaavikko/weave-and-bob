extends Node2D

@export var angle := 5.0
@export var speed := 10.0

var time := 0.0

func _process(delta: float) -> void:
	rotation_degrees = sin(time * speed) * angle
	time += delta
