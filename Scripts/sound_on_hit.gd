class_name SoundOnHit
extends AudioStreamPlayer2D

@export var body: RigidBody2D
@export var min_speed := 100.0
@export var max_speed := 200.0
@export var volume_multiplier := 0.1

func _ready() -> void:
	body.body_entered.connect(_on_body_entered)
	body.contact_monitor = true
	body.max_contacts_reported = 1
	
func _on_body_entered(_other: Node):
	pitch_scale = randf_range(0.9, 1.1)
	volume_linear = clamp(body.linear_velocity.length(), min_speed, max_speed) / max_speed * volume_multiplier
	play()
