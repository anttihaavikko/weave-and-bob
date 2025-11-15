class_name Gun
extends MovableRigidbody

var mouse: Vector2
var clicked: bool

@export var aim_target: Node2D
@export_flags_2d_physics var wall_mask: int
@export var barrel: Node2D
@export var camera: ShakeableCamera
@export var reticule: Node2D
@export var muzzle: GPUParticles2D
@export var flash: CPUParticles2D
@export var ejector: CasingEjector
@export var shot_sound: AudioStreamPlayer2D
@export var reload_sound: AudioStreamPlayer2D
@export var dry_shot_sound: AudioStreamPlayer2D
@export var sprite_wrap: Node2D
@export var hand_wrap: Node2D
@export var ammo: AmmoDisplay
@export var mag_ejector: CasingEjector
@export var root: PlayerRoot

var current_shot_line := 0
var just_shot := false
var full_screen := false
var cooldown := 0.0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(event):
	if event is InputEventMouseButton:
		clicked = !clicked
		
func reload(wasteful: bool) -> void:
	if !GameState.has_magazine: return
	if !clicked && ammo.get_amount() < (30 if wasteful else 20):
		mag_ejector.eject()
		ammo.reload()
		reload_sound.play()
		just_shot = false
		apply_impulse(Vector2(-50, 600))

func _process(delta: float) -> void:
	reticule.position = camera.get_local_mouse_position()

	if not root.visible:
		return

	mouse = reticule.global_position
	
	if cooldown > 0:
		cooldown -= delta
	
	var dir: Vector2 = (mouse - global_position).normalized()
	aim_target.global_position = global_position + dir * 80
	
#	var flipped := -1 if aim_target.global_position.x < global_position.x else 1
#	hand_wrap.scale = Vector2(flipped, flipped)
#	sprite_wrap.scale = Vector2(1, flipped)
	
	if clicked and root.gun_sprite.visible and GameState.has_gun:
		just_shot = cooldown <= 0
	else:
		cooldown = 0
		
	if Input.is_action_just_pressed("full"):
		full_screen = !full_screen
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if full_screen else DisplayServer.WINDOW_MODE_WINDOWED)
		
func _get_shot_end(space_state: PhysicsDirectSpaceState2D, p: Vector2, dir: Vector2, ignored: Array[RID]) -> Dictionary:
	var query := PhysicsRayQueryParameters2D.create(p, p + dir, wall_mask, ignored)
	var result := space_state.intersect_ray(query)
	if result.has("collider") and result.collider is Destroyable:
		result.collider.destroy()
		ignored.push_back(result.collider.get_rid())
		return _get_shot_end(space_state, result.position, dir, ignored)
	else:
		return result
		
func _physics_process(delta: float) -> void:
	muzzle.emitting = false
	flash.emitting = false
	
	if just_shot:
		if !ammo.has():
			dry_shot_sound.play()
			cooldown = 1
			return
		ammo.use()
		var d: Vector2 = (mouse - global_position).normalized()
		apply_impulse(-d * 20000 * delta)
		cooldown = 0.1
		just_shot = false
		var space_state := get_world_2d().direct_space_state
		var p := barrel.global_position
		var dir := Vector2.RIGHT.rotated(global_rotation + randf_range(-0.1, 0.1)).normalized() * 2000
		var result := _get_shot_end(space_state, p, dir, [])
		camera.shake(3, 0.05)
		
		if result.has("collider"):
			if result.collider is Enemy:
				result.collider.hurt(result.position)
			if result.collider is BreakableWall:
				result.collider.hit()
			if result.collider is Switch:
				result.collider.flip()
		
		var pos = result.position if result.has("position") else p + dir
		Effects.singleton.add_many([0, 1], pos)
		LineDrawer.singleton.add(p, pos)
		
		muzzle.emitting = true
		flash.emitting = true
		ejector.eject()
		shot_sound.pitch_scale = randf_range(0.9, 1.1)
		shot_sound.play()
