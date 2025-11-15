extends Node2D

@export var enemy: Enemy
@export var left_arm: Limb
@export var right_arm: Limb
@export var back_target: Node2D
@export var front_target: Node2D

func _ready() -> void:
	global_rotation = randf() * TAU

func _process(delta: float) -> void:
	if GameState.player and not GameState.player.dead:
		var pp := GameState.player.live_gun.global_position
		if global_position.distance_to(pp) < enemy.vision_range:
			# global_rotation = enemy.dir.angle()
			global_rotation = rotate_toward(global_rotation, global_position.angle_to_point(pp), 20 * delta)
			# global_rotation = rotate_toward(global_rotation, enemy.dir.angle(), 20 * delta)
			if abs(global_rotation) > PI * 0.5:
				left_arm.target = front_target
				right_arm.target = back_target
			else:
				left_arm.target = back_target
				right_arm.target = front_target
