extends Polygon2D

@export var line: Line2D
@export var control: Node2D

func _process(_delta: float) -> void:
	polygon = line.points
