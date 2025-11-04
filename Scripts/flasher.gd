class_name Flasher
extends Node

@export var sprites: Array[Sprite2D]
@export var white: Material

func flash():
	for s in sprites: s.material = white
	await get_tree().create_timer(0.05).timeout
	for s in sprites: s.material = null