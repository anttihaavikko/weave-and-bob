extends Node

@export var lines: LineDrawer
@export var effects: Effects
	
func _on_gun_shot(hit: bool, from: Vector2, to: Vector2):
	lines.add_line(from, to)
	if hit:
		effects.add(0, to)
		effects.add(1, to)
	
