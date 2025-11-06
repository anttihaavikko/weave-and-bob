class_name Wave
extends Node2D

@export var delay := 1.0

var spawns: Array[Spawn]
var amount := 0
var encounter: Encounter

func _ready() -> void:
	for child in get_children():
		if child is Spawn:
			spawns.push_back(child)
			amount += 1

func start(enc: Encounter):
	encounter = enc
	print("activated wave")
	await get_tree().create_timer(delay).timeout
	for spawn in spawns:
		spawn.start(self)

func enemy_died():
	amount -= 1
	if amount <= 0:
		encounter.next_wave()
	
