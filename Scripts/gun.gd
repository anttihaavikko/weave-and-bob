extends RigidBody2D

var mouse: Vector2
var clicked: bool

@export var aim_target: Node2D
@export var shot_lines: Array[Line2D]
@export_flags_2d_physics var wall_mask: int
@export var barrel: Node2D
@export var camera: Camera2D
@export var reticule: Node2D
@export var muzzle: GPUParticles2D
@export var flash: GPUParticles2D

var current_shot_line := 0
var just_shot := false
var full_screen := false

signal shot

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(event):
	if event is InputEventMouseButton:
		clicked = !clicked

func _process(delta: float) -> void:
	reticule.position = camera.get_local_mouse_position()
	mouse = reticule.global_position
	
	var dir: Vector2 = (mouse - global_position).normalized()
	aim_target.global_position = global_position + dir * 80
	if clicked:
		apply_force(-dir * 200000 * delta)
		just_shot = true
		
	if Input.is_action_just_pressed("full"):
		full_screen = !full_screen
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if full_screen else DisplayServer.WINDOW_MODE_WINDOWED)
		
func _physics_process(delta: float) -> void:
	muzzle.emitting = false
	flash.emitting = false
	
	if just_shot:
		just_shot = false
		var space_state := get_world_2d().direct_space_state
		var p := barrel.global_position
		var dir := Vector2.RIGHT.rotated(global_rotation + randf_range(-0.1, 0.1)).normalized() * 2000
		var query := PhysicsRayQueryParameters2D.create(p, p + dir, wall_mask)
		var result := space_state.intersect_ray(query)
		shot.emit(result.has("position"), p, result.position if result else p + dir)
		camera.offset = Vector2(randf_range(-1, 1), randf_range(-1, 1)) * 3
		muzzle.emitting = true
		flash.emitting = true
