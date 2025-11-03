class_name Effects
extends Node

static var _singleton: Effects = null
static var singleton: Effects:
	get:
		return _singleton

func _enter_tree() -> void:
	if singleton == null:
		_singleton = self
		
func _exit_tree() -> void:
	if singleton == self:
		_singleton = null

func _init() -> void:
	if singleton == null:
		_singleton = self

@export var effects: Array[PackedScene]

func add(index: int, pos: Vector2):
	var effect := effects[index].instantiate()
	add_child(effect)
	
	if effect is Node2D:
		effect.position = pos
		
	if effect is GPUParticles2D:
		effect.restart()
