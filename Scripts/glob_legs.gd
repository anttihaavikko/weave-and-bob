extends RigidBody2D

@export var gun: RigidBody2D
@export var jump_force := 1.0

func _process(delta: float) -> void:
	var x: float = Input.get_axis("left", "right")
	apply_force(Vector2(x * 200000, 0) * delta)
	
	if(Input.is_action_just_pressed("jump")):
		apply_force(Vector2(0, -99999 * jump_force))
		gun.apply_force(Vector2(0, -99999 * jump_force))
