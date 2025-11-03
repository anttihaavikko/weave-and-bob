class_name CasingEjector
extends Node2D

@export var casing: PackedScene
@export var limit := 100
@export var eject_dir := Vector2(-12, 5)

var casings: Array[Node]

func get_next() -> Node:
	if len(casings) > limit:
		return casings.pop_front()
	else:
		var c := casing.instantiate()
		get_tree().root.get_child(0).add_child(c)
		return c

func eject():
	var c := get_next()
	casings.push_back(c)
	if c is MovableRigidbody:
		c.freeze = true
		c.global_position = global_position
		c.move_to(global_position, global_rotation)
		c.linear_velocity = Vector2.ZERO
		c.angular_velocity = 0
		c.freeze = false
		c.apply_impulse(eject_dir.rotated(global_rotation + randf_range(-0.1, 0.1)) * randf_range(50, 100))
		c.apply_torque_impulse(randf_range(0, 1))
