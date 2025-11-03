extends RigidBody2D

@export var jump_force := 1.0
@export var ground_cast: ShapeCast2D
@export var gun: Gun

func _process(delta: float) -> void:
	var x: float = Input.get_axis("left", "right")
	apply_force(Vector2(x * 200000, 0) * delta)
	
	var grounded := ground_cast.is_colliding()
	
	if grounded && Input.is_action_just_pressed("jump"):
		apply_force(Vector2(0, -99999 * jump_force))
		gun.apply_force(Vector2(0, -99999 * jump_force))
		
	if grounded:
		gun.reload()