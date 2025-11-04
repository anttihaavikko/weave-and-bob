extends Area2D

@export var id: String
@export var type: GameState.PickupType

func _ready() -> void:
	if GameState.has(id):
		queue_free()

func _picked(_body: Node2D):
	GameState.collect(type)
	GameState.mark(id)
	Effects.singleton.add_many([0, 1, 3], global_position)
	queue_free()
