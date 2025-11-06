class_name Spawn
extends Node2D

@export var title: String
@export var mode: Enemy.Behaviour
@export var dir: Vector2
@export var delay := 1.0

@export var _enemy: PackedScene

func start(wave: Wave):
	Effects.singleton.add(3, global_position)
	SoundEffects.singleton.add(11, global_position) # spawn.wav
	await get_tree().create_timer(delay).timeout
	var e := _enemy.instantiate()
	if e is Enemy:
		e.respawns_after = 0
		e.mode = mode
		e.dir = dir
		e.title = title
		e.died.connect(wave.enemy_died)
	add_child(e)
