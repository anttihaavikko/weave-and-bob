class_name CasingEjector
extends Node2D

@export var casing: PackedScene

func eject():
	var c := casing.instantiate()
	get_tree().root.get_child(0).add_child(c)
	
	if c is RigidBody2D:
		c.global_position = global_position
		c.global_rotation = global_rotation
		c.linear_velocity = Vector2.ZERO
		c.angular_velocity = 0
		c.apply_torque_impulse(-20)
		c.apply_impulse(Vector2(-7, -5).rotated(global_rotation) * randf_range(50, 100))
