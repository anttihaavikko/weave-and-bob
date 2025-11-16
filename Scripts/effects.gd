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

var pools: Array[Array]

func _ready() -> void:
	pools = []
	pools.resize(len(effects))
	pools.fill([])

func add_many(indices: Array[int], pos: Vector2):
	for i in indices: add(i, pos)

func add(index: int, pos: Vector2, pool_size: int = -1) -> Node:
	var effect := effects[index].instantiate()
	if pool_size >= 0:
		pools[index].push_back(effect)
		if len(pools[index]) > pool_size:
			(pools[index].pop_front() as Node).queue_free()
		
	call_deferred("add_child", effect)
	
	if effect is MovableRigidbody:
		effect.move_to(pos, 0)
		return effect
	
	if effect is Node2D:
		effect.position = pos
		
	if effect is GPUParticles2D:
		effect.restart()
		
	return effect
