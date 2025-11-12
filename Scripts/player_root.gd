class_name PlayerRoot
extends Node2D

@export var control: Node2D
@export var live_gun: Gun
@export var gun: PackedScene
@export var cam: ShakeableCamera

var dead := false

func _ready() -> void:
	GameState.camera = cam
	GameState.unique.clear()

func die() -> void:
	if dead: return
	Musics.intensify(false)
	Musics.pitch(0.5, 1.5)
	Gameplay.hit_stop(get_tree(), 0.25, 5 / 60.0)
	dead = true
	hide()
	Effects.singleton.add_many([4, 3, 0, 0, 0, 1, 9, 10, 2], control.global_position)
	SoundEffects.singleton.add_many([2, 13], control.global_position)
	process_mode = PROCESS_MODE_DISABLED
	var g := gun.instantiate() as RigidBody2D
	g.global_position = live_gun.global_position
	g.rotation = live_gun.rotation
	Effects.singleton.add_child(g)
	cam.enabled = false
	g.apply_impulse(live_gun.linear_velocity * 1)
	await get_tree().create_timer(0.1).timeout
	g.apply_torque_impulse(randf_range(-1, 1) * 10000)
	await get_tree().create_timer(1.5).timeout
	get_tree().reload_current_scene()
