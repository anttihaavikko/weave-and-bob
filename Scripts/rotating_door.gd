class_name RotatingDoor
extends Node2D

@export var _open_pos: float = 45
@export var body: AnimatableBody2D

var _closed_pos: float
var state := false

func _ready() -> void:
	_closed_pos = global_rotation_degrees
	_open_pos += global_rotation_degrees
	if body:
		body.reparent(get_tree().root)

func change():
	state = !state
	var pos := _open_pos if state else _closed_pos
	get_tree().create_tween().tween_property(body, "rotation_degrees", pos, 0.5).set_trans(Tween.TRANS_BOUNCE)
	SoundEffects.singleton.add(10, global_position) # throw1.wav
