extends Area2D

@export var appearers: Array[Appearer]

func _ready() -> void:
    if GameState.spawn_set:
        for a in appearers:
            a.queue_free()
        queue_free()
    body_entered.connect(entered)

func entered(_node: Node2D):
    queue_free()
    for a in appearers:
        a.disappear()