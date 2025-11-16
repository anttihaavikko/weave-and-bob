class_name CasingEjector
extends Node2D

@export var pool_id: String
@export var casing: PackedScene
@export var limit := 100
@export var eject_dir := Vector2(-12, 5)

func _ready() -> void:
	if not GameState.pools.has(pool_id):
		GameState.pools[pool_id] = []

func get_pool() -> Array:
	return GameState.pools[pool_id]

func get_next() -> Node:
	var casings := get_pool()
	if len(casings) > limit:
		return casings.pop_front()
	else:
		var c := casing.instantiate()
		get_tree().root.call_deferred("add_child", c)
		return c

func eject():
	# print("%s count: %d" % [pool_id, len(get_pool())])
	var c := get_next()
	get_pool().push_back(c)
	if c is MovableRigidbody:
		c.freeze = true
		c.global_position = global_position
		c.move_to(global_position, global_rotation)
		c.linear_velocity = Vector2.ZERO
		c.angular_velocity = 0
		c.freeze = false
		c.apply_impulse(eject_dir.rotated(global_rotation + randf_range(-0.1, 0.1)) * randf_range(50, 100))
		c.apply_torque_impulse(randf_range(0, 1))
