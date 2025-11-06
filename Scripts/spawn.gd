class_name Spawn
extends Node2D

@export var mode: Enemy.Behaviour
@export var dir: Vector2
@export var delay := 1.0

@export var _enemy: PackedScene

func start(wave: Wave):
	Effects.singleton.add(3, global_position)
	await get_tree().create_timer(delay).timeout
	var e := _enemy.instantiate()
	add_child(e)
	if e is Enemy:
		e.respawns_after = 0
		e.initialize(mode, dir)
		e.died.connect(wave.enemy_died)