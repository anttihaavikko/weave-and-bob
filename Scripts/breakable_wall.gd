class_name BreakableWall
extends Node2D

@export var id: String
@export var life := 10
@export var flasher: Flasher
@export var break_effects: Array[int]
@export var break_sounds: Array[int]
@export var others: Array[Node]
@export var particle_points: Array[Node2D]
@export var requires_breaker := true

func _ready() -> void:
	GameState.register(id)
	if GameState.has(id):
		destroy()

func destroy() -> void:
	queue_free()
	for o in others:
		o.queue_free()
			
func hit():
	if requires_breaker && not GameState.breaker_shots:
		return
	life -= 1
	if flasher:
		flasher.flash()
	if life <= 0:
		GameState.mark(id)
		destroy()
		if len(break_effects) > 0:
			if len(particle_points) > 0:
				for pp in particle_points:
					Effects.singleton.add_many(break_effects, pp.global_position)
			Effects.singleton.add_many(break_effects, global_position)
		if len(break_sounds) > 0:
			SoundEffects.singleton.add_many(break_sounds, global_position)
