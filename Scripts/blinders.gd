class_name Blinders
extends Control

@export var left: ColorRect
@export var right: ColorRect
@export var duration = 0.3

func _ready() -> void:
	GameState.blinders = self
	await get_tree().create_timer(0.1).timeout
	open()
	
func open():
	get_tree().create_tween().tween_property(left, "scale", Vector2(0, 1), duration).set_trans(Tween.TRANS_BOUNCE)
	get_tree().create_tween().tween_property(right, "scale", Vector2(0, 1), duration).set_trans(Tween.TRANS_BOUNCE)

func close():
	get_tree().create_tween().tween_property(left, "scale", Vector2(1, 1), duration).set_trans(Tween.TRANS_BOUNCE)
	get_tree().create_tween().tween_property(right, "scale", Vector2(1, 1), duration).set_trans(Tween.TRANS_BOUNCE)

func quit():
	if OS.get_name() == "Web":
		return
	close()
	await get_tree().create_timer(duration + 0.1).timeout
	get_tree().quit()
