class_name MapDisplay
extends Control

@export var left: Control
@export var right: Control
@export var paper: Control
@export var root: Control
@export var viewport: SubViewport

var state := false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("map"):
		toggle()
		viewport.world_2d = GameState.camera.get_world_2d()

func toggle():
	state = !state
	get_tree().create_tween().tween_property(right, "position", Vector2(543 if !state else 1099, -20), 0.4).set_trans(Tween.TRANS_BOUNCE)
	get_tree().create_tween().tween_property(left, "position", Vector2(475 if !state else -30, -24), 0.4).set_trans(Tween.TRANS_BOUNCE)
	get_tree().create_tween().tween_property(paper, "scale", Vector2.ONE if state else Vector2(0, 1), 0.4).set_trans(Tween.TRANS_BOUNCE)
	get_tree().create_tween().tween_property(self, "position", Vector2(-548, -323 if state else 768), 0.3).set_trans(Tween.TRANS_CUBIC)
