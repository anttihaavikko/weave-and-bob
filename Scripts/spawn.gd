@tool
#@icon("res://Sprites/checkpoint.svg")
class_name Spawn
extends Node2D

@export var title: String
@export var mode: Enemy.Behaviour
@export var dir: Vector2
@export var vertical_dir: float
@export var delay := 1.0

## Enemy to spawn
@export var _enemy: PackedScene
	
var texture: Texture2D = preload("res://Sprites/spawn-ring.png")

func start(wave: Wave):
	Effects.singleton.add(8, global_position) # spawn_ring.tscn
	SoundEffects.singleton.add(11, global_position) # spawn.wav
	await get_tree().create_timer(delay).timeout
	var e := _enemy.instantiate()
	if e is Enemy:
		e.respawns_after = 0
		e.mode = mode
		e.dir = dir
		e.vertical_dir = vertical_dir
		e.title = title
		e.died.connect(wave.enemy_died)
	add_child(e)

func _draw():
	if Engine.is_editor_hint():
		draw_texture(texture, texture.get_size() * -0.5)
