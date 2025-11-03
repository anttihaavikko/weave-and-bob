class_name Enemy
extends Node2D

@export var respawns_after := 2
@export var life := 10

@export var flasher: Flasher

var max_life := life

func hurt(pos: Vector2):
	flasher.flash()
	life -= 1
	Effects.singleton.add(2, pos)
	if life <= 0:
		die()

func die():
	hide()
	process_mode = Node.PROCESS_MODE_DISABLED
	Effects.singleton.add(2, global_position)
	Effects.singleton.add(2, global_position)
	Effects.singleton.add(2, global_position)
	Effects.singleton.add(0, global_position)
	Effects.singleton.add(0, global_position)
	Effects.singleton.add(0, global_position)
	Effects.singleton.add(1, global_position)
	Effects.singleton.add(3, global_position)
	if respawns_after > 0:
		await get_tree().create_timer(respawns_after).timeout
		life = max_life
		show()
		process_mode = Node.PROCESS_MODE_INHERIT
		Effects.singleton.add(3, global_position)
	else:
		queue_free()
