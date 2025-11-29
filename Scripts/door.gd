class_name Door
extends Node2D

@export var opened: bool
@export var dir := Vector2.UP
@export var gears: Array[Node2D]

var _open_pos: Vector2
var _closed_pos: Vector2

func _ready() -> void:
	_closed_pos = global_position
	_open_pos = global_position + dir * global_scale.y
	if opened: global_position = _open_pos
	
func change(pos: Vector2):
	get_tree().create_tween().tween_property(self, "global_position", pos, 0.5).set_trans(Tween.TRANS_BOUNCE)
	if len(gears) > 0:
		for gear in gears:
			get_tree().create_tween().tween_property(gear, "rotation_degrees", 180 if opened else 0, 0.5).set_trans(Tween.TRANS_BOUNCE)

	SoundEffects.singleton.add(10, global_position) # throw1.wav
	SoundEffects.singleton.add(19, global_position, 0.6)
	await get_tree().create_timer(0.4).timeout
	SoundEffects.singleton.add(20, global_position, 1.2)
	
func open():
	change(_open_pos)
	opened = true
	
func close():
	change(_closed_pos)
	opened = false

func toggle():
	opened = !opened
	if opened:
		open()
	else:
		close()
