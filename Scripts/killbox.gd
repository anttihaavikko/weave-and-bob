extends Node2D

@export var can_kill_enemies := true

func enter(node: Node2D):
	if node is PlayerPart and not GameState.attached:
		node.player.die()
	if node is Enemy and can_kill_enemies:
		node.die()
