extends Polygon2D

@export var line: Line2D

func _process(delta: float) -> void:
	polygon = line.points
