@tool
class_name Enemy
extends CharacterBody2D

@export var id: String
@export var mode: Behaviour
@export var title: String:
	set(value):
		title = value
		title_label.text = value
@export var respawns_after := 2
@export var life := 500
@export var speed := 1.0
@export var vision_range := 700.0
@export var stomp_offset := 20

@export var starts_encounter: Encounter;
@export var frame: Node2D
@export var bump_cast: ShapeCast2D
@export var title_label: Label
@export var halo: Node2D
@export var left_wing: Node2D
@export var right_wing: Node2D
@export var flasher: Flasher
@export var vision_cast: RayCast2D

enum Behaviour {None, Wave, Charge}
var dir: Vector2
var vertical_dir: float
var time := 0.0
var turn_delay := 0.0
var charging := false

var max_life := life

signal died;

func _ready() -> void:
	if not Engine.is_editor_hint():
		if GameState.has(id):
			if starts_encounter: starts_encounter.open_doors()
			queue_free()
		else:
			GameState.register(id)
	
func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	if mode == Behaviour.Charge and GameState.player:
		var pp := GameState.player.live_gun.global_position
		vision_cast.target_position = vision_cast.to_local(pp)
		if not charging and global_position.distance_to(pp) < vision_range and not vision_cast.is_colliding():
			charging = true
			dir = (pp - global_position).normalized()
		velocity = dir * 30000 * speed * delta
		move_and_slide()
		if bump_cast.is_colliding():
			dir = Vector2.ZERO
			charging = false
	if mode == Behaviour.Wave:
		time += delta
		turn_delay -= delta
		velocity = (dir - dir.rotated(PI * vertical_dir * 0.5) * sin(time * 5) * 1) * 20000 * speed * delta
		move_and_slide()
		if turn_delay <= 0 and bump_cast.is_colliding():
			dir = - dir
			turn_delay = 0.5
			var p := bump_cast.get_collision_point(0)
			Effects.singleton.add_many([0, 1], p)
			SoundEffects.singleton.add(5, p, 0.3) # enemy_bump.wav
			squash(p)

func get_stomp_pos() -> float:
	return global_position.y - stomp_offset
	
func squash(pos: Vector2):
	frame.rotation = global_position.angle_to_point(pos)
	# frame.scale = Vector2(0.9, 1.1)
	# await get_tree().create_timer(0.1).timeout
	# frame.scale = Vector2.ONE
	var tween := get_tree().create_tween()
	tween.tween_property(frame, "rotation", global_position.angle_to_point(pos), 0.1).set_trans(Tween.TRANS_BOUNCE)
	tween.parallel().tween_property(frame, "scale", Vector2(0.9, 1.1), 0.05).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(frame, "scale", Vector2.ONE, 0.1).set_trans(Tween.TRANS_ELASTIC)

func hurt(pos: Vector2):
	flasher.flash()
	squash(pos)
	life -= GameState.damage
	Effects.singleton.add(2, pos)
	if life <= 0:
		die()

func die():
	hide()
	GameState.camera.shake(10, 0.3)
	process_mode = Node.PROCESS_MODE_DISABLED
	Effects.singleton.add_many([4, 3, 10, 2, 0, 0, 0, 1], global_position)
	SoundEffects.singleton.add(2, global_position)
	SoundEffects.singleton.add(13, global_position)
	Effects.singleton.add(7, left_wing.global_position) # feathers.tscn
	Effects.singleton.add(7, right_wing.global_position) # feathers.tscn
	Musics.pitch(1.3, 1)
	var h: RigidBody2D = Effects.singleton.add(6, halo.global_position, 10)
	for c in h.get_children():
		if c is Node2D:
			c.scale *= global_scale
	h.apply_impulse(Vector2.UP * 500 + dir * 300)
	died.emit()
	await get_tree().create_timer(0.1).timeout
	Gameplay.hit_stop(get_tree(), 0.5, 3 / 60.0)
	h.apply_torque_impulse(2000 * randf_range(-1, 1))
	if starts_encounter: starts_encounter.start(self)
	if respawns_after > 0:
		await get_tree().create_timer(respawns_after).timeout
		life = max_life
		show()
		process_mode = Node.PROCESS_MODE_INHERIT
#		Effects.singleton.add(4, global_position)
		Effects.singleton.add(3, global_position)
	else:
		queue_free()
