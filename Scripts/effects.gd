class_name Effects
extends Node

@export var effects: Array[PackedScene]

func add(index: int, pos: Vector2):
	var effect := effects[index].instantiate()
	add_child(effect)
	
	if effect is Node2D:
		effect.position = pos
		
	if effect is GPUParticles2D:
		effect.restart()