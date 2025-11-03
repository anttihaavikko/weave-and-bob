class_name SoundOnHit
extends AudioStreamPlayer2D

@export var body: RigidBody2D
	
func _on_body_entered(other: Node):
	pitch_scale = randf_range(0.9, 1.1)
	volume_db = clamp(-80 + body.linear_velocity.length() * 0.5, -80, -30)
	play()
