extends Node2D

@export var player: PackedScene

func _ready() -> void:
	if GameState.spawn_set: global_position = GameState.spawn_point
	var plr := player.instantiate()
	add_child(plr)
