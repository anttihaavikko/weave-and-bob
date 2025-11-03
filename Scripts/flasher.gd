class_name Flasher
extends Node

@export var sprites: Array[Sprite2D]

var colors := {} 

func _ready() -> void:
	for s in sprites:
		colors[s.name] = s.modulate
		
	print(colors)	

func flash():
	_colorize(Color.WHITE)
		
func _colorize(color: Color):
	for s in sprites: s.modulate = color
	await get_tree().create_timer(0.05).timeout
	for s in sprites: s.modulate = colors[s.name]
