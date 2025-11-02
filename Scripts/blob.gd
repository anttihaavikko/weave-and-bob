extends Node

@export var lines: LineDrawer
	
func _on_gun_shot(from: Vector2, to: Vector2):
	lines.add_line(from, to)
	
