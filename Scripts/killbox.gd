class_name Killbox
extends Node2D

@export var can_kill_enemies := true
@export var enabled := true

func enter(node: Node2D):
	if not enabled:
		return
	if node is PlayerPart and not GameState.attached:
		node.player.die()
	if node is Enemy and can_kill_enemies:
		node.die()
