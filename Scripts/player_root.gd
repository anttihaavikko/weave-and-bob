class_name PlayerRoot
extends Node2D

@export var control: Node2D
@export var live_gun: Gun
@export var gun: PackedScene
@export var cam: ShakeableCamera
@export var map_sprite: Node2D
@export var gun_sprite: Node2D
@export var arm_left: Node
@export var arm_right: Node

var dead := false
var health := 1
var immunity := 0.0

func _ready() -> void:
	gun_sprite.visible = GameState.has_gun
	arm_left.visible = GameState.has_gun
	arm_right.visible = GameState.has_gun
	health = GameState.max_life
	GameState.camera = cam
	GameState.unique.clear()
	var vp := get_tree().root.get_viewport()
	vp.canvas_cull_mask = 1

func _process(delta: float) -> void:
	cam.extra_offset = cam.extra_offset.move_toward(Vector2(0, -230) if map_sprite.visible else Vector2(0, 0), delta * 500)
	
	if immunity > 0:
		immunity -= delta

	if Input.is_action_just_pressed("map") and GameState.has_gun and GameState.map_upgrades > 0:
		map_sprite.visible = !map_sprite.visible
		gun_sprite.visible = !gun_sprite.visible
		SoundEffects.singleton.add(1, global_position)

func die() -> void:
	if immunity > 0:
		return
	health -= 1
	if health > 0:
		immunity = 0.3
		var dir := -live_gun.linear_velocity
		live_gun.apply_impulse(dir * 100)
		Gameplay.hit_stop(get_tree(), 0.25, 5 / 60.0)
		Effects.singleton.add_many([4, 3, 0, 0, 0, 1, 9, 10, 2], control.global_position)
		SoundEffects.singleton.add_many([2], control.global_position)
		return
	if dead: return
	Musics.intensify(false)
	Musics.pitch(0.5, 1.5)
	Gameplay.hit_stop(get_tree(), 0.25, 5 / 60.0)
	dead = true
	hide()
	Effects.singleton.add_many([4, 3, 0, 0, 0, 1, 9, 10, 2], control.global_position)
	SoundEffects.singleton.add_many([2, 13], control.global_position)
	process_mode = PROCESS_MODE_DISABLED
	if gun_sprite.visible:
		launch_gun()
	await get_tree().create_timer(1.5).timeout
	get_tree().reload_current_scene()

func launch_gun():
	var g := gun.instantiate() as RigidBody2D
	g.global_position = live_gun.global_position
	g.rotation = live_gun.rotation
	Effects.singleton.add_child(g)
	cam.enabled = false
	g.apply_impulse(live_gun.linear_velocity * 1)
	await get_tree().create_timer(0.1).timeout
	g.apply_torque_impulse(randf_range(-1, 1) * 10000)
