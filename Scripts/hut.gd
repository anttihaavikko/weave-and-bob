extends Node

@export var inside_parts: Array[Node]
@export var outside_parts: Array[Node]
@export var area: Area2D
@export var attic_area: Area2D
@export var attic_dark: Node

var change_locked := false

func _ready() -> void:
    area.body_entered.connect(entered)
    area.body_exited.connect(exited)
    attic_area.body_entered.connect(entered_attic)
    
func entered_attic(_node: Node2D):
    var idx := inside_parts.find(attic_dark)
    if idx > 0:
        inside_parts.remove_at(idx)
    attic_dark.hide()

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