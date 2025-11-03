class_name Enemy
extends Node2D

@export var respawns_after := 2
@export var life := 10

@export var flasher: Flasher

var max_life := life

func hurt():
	flasher.flash()
	life -= 1
	if life <= 0:
		die()

func die():
	hide()
	process_mode = Node.PROCESS_MODE_DISABLED
	if respawns_after > 0:
		await get_tree().create_timer(respawns_after).timeout
		life = max_life
		show()
		process_mode = Node.PROCESS_MODE_INHERIT
	else:
		queue_free()
