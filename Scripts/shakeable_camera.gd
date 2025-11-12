class_name ShakeableCamera
extends Camera2D

var amount := 0.0
var duration := 0.0
var extra_offset: Vector2

func shake(amt: float, dur: float):
	amount = amt
	duration = dur

func _process(delta: float) -> void:
	if duration > 0:
		duration -= delta
		offset = Vector2(randf_range(-1, 1) * amount, randf_range(-1, 1) * amount) + extra_offset
	else:
		offset = extra_offset
