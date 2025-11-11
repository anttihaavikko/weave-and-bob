extends Node

@export var inside_parts: Array[Node]
@export var outside_parts: Array[Node]
@export var area: Area2D

var change_locked := false

func _ready() -> void:
    area.body_entered.connect(entered)
    area.body_exited.connect(exited)

func entered(_node: Node2D):
    if change_locked:
        return
    for e in inside_parts:
        e.show()
    for e in outside_parts:
        e.hide()
    lock_change()

func exited(_node: Node2D):
    if change_locked:
        return
    for e in inside_parts:
        e.hide()
    for e in outside_parts:
        e.show()
    lock_change()
    
func lock_change():
    change_locked = true
    await get_tree().create_timer(0.2).timeout
    change_locked = false