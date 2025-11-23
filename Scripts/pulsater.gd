class_name Pulsater
extends Node2D

@export var constant := true
@export var absoluted := true
@export var amount := 0.1
@export var speed := 10.0

var origin: Vector2
var phase: float

func _ready():
	origin = scale
	phase = 0

func _process(delta):
	if constant:
		phase += delta
		var amt = sin(phase * speed)
		var val = abs(amt) if absoluted else sin(phase * speed)
		scale = origin * (1 + val * amount)