extends Node2D

@export var moves: bool
@export var move_direction: Vector2
@export var move_speed := 5.0
@export var single_direction: bool

var start_pos: Vector2
var time: float


func _ready() -> void:
	start_pos = position


func _process(delta: float) -> void:
	time += delta

	if moves:
		var dir := sin(time * move_speed)
		position = start_pos + move_direction * (abs(dir) if single_direction else dir)
