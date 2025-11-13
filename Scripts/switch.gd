class_name Switch
extends CharacterBody2D

@export var change := 45.0

var start: float
var on := false

signal flipped

func _ready() -> void:
    start = rotation_degrees

func flip():
    on = !on
    get_tree().create_tween().tween_property(self, "rotation_degrees", start + (change if on else 0.0), 0.3).set_trans(Tween.TRANS_BOUNCE)
    flipped.emit()
