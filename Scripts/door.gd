class_name Door
extends Node2D

@export var opened: bool

var _open_pos: Vector2
var _closed_pos: Vector2

func _ready() -> void:
	_closed_pos = global_position
	_open_pos = global_position + Vector2.UP * global_scale.y
	if opened: global_position = _open_pos
	
func change(pos: Vector2):
	get_tree().create_tween().tween_property(self, "global_position", pos, 0.5).set_trans(Tween.TRANS_BOUNCE)
	
func open():
	change(_open_pos)
	
func close():
	change(_closed_pos)
