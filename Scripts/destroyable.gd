class_name Destroyable
extends Node2D

@export var stub: Node2D
@export var full: Node2D
@export var particle_points: Array[Node2D]
@export var effect_ids: Array[int]

func _ready() -> void:
	stub.hide()

func destroy():
	if len(effect_ids) > 0 and len(particle_points) > 0:
		for pp in particle_points:
			Effects.singleton.add_many(effect_ids, pp.global_position)
	stub.show()
	full.queue_free()
	queue_free()
