class_name BreakableWall
extends Node2D

@export var id: String
@export var life := 10
@export var flasher: Flasher
@export var break_effects: Array[int]
@export var break_sounds: Array[int]

func _ready() -> void:
    GameState.register(id)
    if GameState.has(id):
        queue_free()
            
func hit():
    life -= 1
    flasher.flash()
    if life <= 0:
        GameState.mark(id)
        queue_free()
        if len(break_effects) > 0:
            Effects.singleton.add_many(break_effects, global_position)
        if len(break_sounds) > 0:
            SoundEffects.singleton.add_many(break_sounds, global_position)
