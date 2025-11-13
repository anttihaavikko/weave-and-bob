extends Area2D

signal grab

func _ready() -> void:
    if GameState.has_gun:
        queue_free()
        return
    body_entered.connect(enter)

func enter(_other: Node2D):
    if _other is Gun:
        GameState.has_gun = true
        grab.emit()
        queue_free()