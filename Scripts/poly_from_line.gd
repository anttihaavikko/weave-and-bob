extends Polygon2D

@export var line: Line2D
@export var control: Node2D

func _process(_delta: float) -> void:
	polygon = line.points
	var points: PackedVector2Array = []
	for p in line.points:
		points.push_back(p * 2 + global_position)
	uv = points
