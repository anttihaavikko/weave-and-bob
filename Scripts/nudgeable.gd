class_name Nudgeable
extends Node2D

@export var amount := 10

var cooldown := 0.0
var phase := 0.0
var dir := 1

var start := 0.0

func _ready() -> void:
	start = rotation_degrees

func _body_entered(body: Node2D):
	if cooldown <= 0:
		dir = 1 if body.global_position.x < global_position.x else -1
		cooldown = 0.5
		phase = 1.0
	
func _process(delta: float) -> void:
	rotation_degrees = start + sin(PI * phase) * amount * dir
	cooldown -= delta
	phase = clamp(phase - delta * 2, 0, 1)