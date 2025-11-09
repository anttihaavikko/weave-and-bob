extends Node2D

@export var appear_after := 0.0
@export var auto_hide_after := 0.0

var size: Vector2

func _ready() -> void:
	size = scale
	scale = Vector2.ZERO
	if appear_after > 0:
		await get_tree().create_timer(appear_after).timeout
	appear()	
	if auto_hide_after:
		await get_tree().create_timer(auto_hide_after).timeout
		disappear()

func appear():
	get_tree().create_tween().tween_property(self, "scale", size, 0.3).set_trans(Tween.TRANS_BOUNCE)

func disappear():
	get_tree().create_tween().tween_property(self, "scale", Vector2.ZERO, 0.3).set_trans(Tween.TRANS_ELASTIC)
