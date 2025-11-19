extends Node

@export var bodies: Array[PhysicsBody2D]
@export_flags_2d_physics var normal_layers: int
@export_flags_2d_physics var platform_layers: int

func _input(_event: InputEvent) -> void:
	for body in bodies:
		body.collision_mask = normal_layers if Input.is_action_pressed("down") else normal_layers + platform_layers
