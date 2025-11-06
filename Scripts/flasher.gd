class_name Flasher
extends Node

@export var items: Array[CanvasItem]
@export var white: Material

func flash():
	for s in items: s.material = white
	await get_tree().create_timer(0.05).timeout
	for s in items: s.material = null