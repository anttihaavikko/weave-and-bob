extends Area2D

func _ready() -> void:
	if GameState.has(name):
		queue_free()
		return
	show()
	body_entered.connect(entered)

func entered(_node: Node2D):
	GameState.mark(name)
	queue_free()