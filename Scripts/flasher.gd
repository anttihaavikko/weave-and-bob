class_name Flasher
extends Node

@export var sprites: Array[Sprite2D]
@export var white: Material

func flash():
	_colorize(Color.WHITE)
		
func _colorize(color: Color):
	for s in sprites: s.material = white
	await get_tree().create_timer(0.05).timeout
	for s in sprites: s.material = null
