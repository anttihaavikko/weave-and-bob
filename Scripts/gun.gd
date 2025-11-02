extends RigidBody2D

var mouse: Vector2
var clicked: bool

@export var aim_target: Node2D
@export var shot_lines: Array[Line2D]
@export_flags_2d_physics var wall_mask: int
@export var barrel: Node2D
@export var camera: Camera2D
@export var reticule: Node2D

var current_shot_line := 0
var just_shot := false

signal shot

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		clicked = !clicked
#	elif event is InputEventMouseMotion:
#		mouse = event.position - camera.global_position
#		mouse = camera.get_viewport().get_mouse_position() - camera.global_position
#		mouse = get_local_mouse_position()
#		mouse = event.position - camera.get_target_position()
#		mouse = event.position
#		reticule.global_position = mouse - global_position + camera.global_position
#		reticule.global_position = global_position
#		print(mouse)

func _process(delta: float) -> void:
	reticule.position = camera.get_local_mouse_position()
	mouse = reticule.global_position
	
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
		camera.offset = Vector2(randf_range(-1, 1), randf_range(-1, 1)) * 3
