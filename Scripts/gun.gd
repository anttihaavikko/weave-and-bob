extends RigidBody2D

var mouse: Vector2
var clicked: bool

@export var aim_target: Node2D
@export var shot_lines: Array[Line2D]
@export_flags_2d_physics var wall_mask: int
@export var barrel: Node2D

var current_shot_line := 0
var just_shot := false

signal shot

func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		clicked = !clicked
	elif event is InputEventMouseMotion:
		mouse = event.position

func _process(delta: float) -> void:
	var dir: Vector2 = (mouse - global_position).normalized()
	aim_target.global_position = global_position + dir * 80
	if (clicked):
		apply_force(-dir * 200000 * delta)
		just_shot = true
		
func _physics_process(delta: float) -> void:
	if just_shot:
		just_shot = false
		var space_state := get_world_2d().direct_space_state
		var p := barrel.global_position
		var dir := Vector2.RIGHT.rotated(global_rotation + randf_range(-0.1, 0.1)).normalized() * 2000
		var query := PhysicsRayQueryParameters2D.create(p, p + dir, wall_mask)
		var result := space_state.intersect_ray(query)
		shot.emit(p, result.position if result else p + dir)
