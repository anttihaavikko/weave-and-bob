class_name LineDrawer
extends Node

@export var line: Line2D
@export var timer: Timer

func add_line(from: Vector2, to: Vector2):
	line.points[0] = from
	line.points[1] = to
	line.width = randf_range(3, 12)
	line.show()
	timer.start()
	
func _on_timer_timeout():
	line.hide()
