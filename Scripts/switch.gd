class_name Switch
extends CharacterBody2D

@export var change := 45.0
@export var door: Door
@export var rotating_door: RotatingDoor

var start: float
var on := false

signal flipped

func _ready() -> void:
	start = rotation_degrees
	if rotating_door:
		flipped.connect(rotating_door.change)

func flip():
	on = !on
	get_tree().create_tween().tween_property(self, "rotation_degrees", start + (change if on else 0.0), 0.3).set_trans(Tween.TRANS_BOUNCE)
	flipped.emit()
