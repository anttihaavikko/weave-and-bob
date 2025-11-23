class_name Killbox
extends Node2D

@export var can_kill_enemies := true
@export var enabled := true:
	set(val):
		enabled = val
		if enabled and prev:
			if prev is PlayerPart and not GameState.attached:
				prev.player.die()

var prev: Node2D

func enter(node: Node2D):
	if not enabled:
		if node is PlayerPart:
			prev = node
		return
	if node is PlayerPart and not GameState.attached:
		node.player.die()
	if node is Enemy and can_kill_enemies:
		node.die()

func exit(node: Node2D):
	if node == prev:
		prev = null