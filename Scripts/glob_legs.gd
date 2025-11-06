extends MovableRigidbody

@export var jump_force := 1.0
@export var ground_cast: ShapeCast2D
@export var gun: Gun
@export var jump_particles: CPUParticles2D

var stomp_cooldown := 0.0

func _process(delta: float) -> void:
	var x: float = Input.get_axis("left", "right")
	apply_force(Vector2(x * 200000, 0) * delta)
	
	if stomp_cooldown > 0:
		stomp_cooldown -= delta
	
	var grounded := ground_cast.is_colliding()

	if (global_position - gun.global_position).length() > 60:
		move_to(gun.global_position, 0)
	
	if grounded && Input.is_action_just_pressed("jump"):
		_nudge(Vector2(0, -999 * jump_force))
		jump_particles.emitting = true
		SoundEffects.singleton.add(0, global_position, 0.5)
		SoundEffects.singleton.add(1, global_position, 1.5)
		
	if grounded:
		gun.reload(false)
		
func _hit_enemy(enemy: Node2D):
	if stomp_cooldown <= 0:
		stomp_cooldown = 0.2
		linear_velocity = Vector2.ZERO
		_nudge((global_position - enemy.global_position).normalized() * 1700)
		
		if enemy is Enemy:
			if enemy.get_stomp_pos() > global_position.y:
				gun.reload(true)
				enemy.die()
				jump_particles.emitting = true
			else:
				enemy.squash(global_position)
		
func _nudge(dir: Vector2):
	apply_impulse(dir)
	gun.apply_impulse(dir)
