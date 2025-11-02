extends RigidBody2D

var mouse: Vector2
var clicked: bool

@export var aim_target: Node2D

func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		clicked = !clicked
	elif event is InputEventMouseMotion:
		mouse = event.position

func _process(delta: float) -> void:
	var dir: Vector2 = (mouse - global_position).normalized()
	aim_target.global_position = global_position + dir * 80
	if (clicked):
		apply_force(-dir * 200000 * delta)
		
