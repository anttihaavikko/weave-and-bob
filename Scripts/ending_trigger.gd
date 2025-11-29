extends Area2D

var used := false

func _ready():
	body_entered.connect(enter)

func enter(_other: Node2D):
	if GameState.met_bobs >= 5 and GameState.spawn_set and not used:
		used = true
		GameState.blinders.close()
		await get_tree().create_timer(0.5).timeout
		GameState.spawn_set = false
		GameState.restart()