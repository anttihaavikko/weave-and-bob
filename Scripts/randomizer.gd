extends Node2D

@export var anim: AnimationPlayer

@export var randomize_scale: bool
@export var min_scale := 0.9
@export var max_scale := 1.1

func _ready() -> void:
	if anim:
		anim.speed_scale = randf_range(0.9, 1.1)
		anim.seek(randf_range(0, 1))
	if randomize_scale:
		scale *= randf_range(min_scale, max_scale)

