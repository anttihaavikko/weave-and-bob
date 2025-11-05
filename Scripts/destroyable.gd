class_name Destroyable
extends Node2D

@export var stub: Node2D
@export var full: Node2D
@export var particle_point: Node2D
@export var effect_ids: Array[int]

func _ready() -> void:
	stub.hide()

func destroy():
	if len(effect_ids) > 0:
		Effects.singleton.add_many(effect_ids, particle_point.global_position)
	stub.show()
	full.queue_free()
	queue_free()
