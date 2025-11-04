class_name Enemy
extends Node2D

@export var respawns_after := 2
@export var life := 10
@export var stomp_offset := 20
@export var frame: Node2D

@export var flasher: Flasher

var max_life := life

func get_stomp_pos() -> float:
	return global_position.y - stomp_offset
	
func squash(pos: Vector2):
	frame.rotation = global_position.angle_to_point(pos)
	frame.scale = Vector2(0.9, 1.1)
	await get_tree().create_timer(0.1).timeout
	frame.scale = Vector2.ONE

func hurt(pos: Vector2):
	flasher.flash()
	squash(pos)
	life -= 1
	Effects.singleton.add(2, pos)
	if life <= 0:
		die()

func die():
	hide()
	process_mode = Node.PROCESS_MODE_DISABLED
	Effects.singleton.add(4, global_position)
	Effects.singleton.add(3, global_position)
	Effects.singleton.add(2, global_position)
	Effects.singleton.add(2, global_position)
	Effects.singleton.add(2, global_position)
	Effects.singleton.add(0, global_position)
	Effects.singleton.add(0, global_position)
	Effects.singleton.add(0, global_position)
	Effects.singleton.add(1, global_position)
	if respawns_after > 0:
		await get_tree().create_timer(respawns_after).timeout
		life = max_life
		show()
		process_mode = Node.PROCESS_MODE_INHERIT
#		Effects.singleton.add(4, global_position)
		Effects.singleton.add(3, global_position)
	else:
		queue_free()
