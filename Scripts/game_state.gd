extends Node

var has_magazine := true
var map_upgrades := 0
var damage := 100

var spawn_set := false
var spawn_point: Vector2
var checkpoint: Checkpoint

var ids: Array[String]

func mark(id: String):
	ids.push_back(id)

func has(id: String) -> bool:
	return ids.has(id)

func change_spawn(cp: Checkpoint) -> void:
	if cp == checkpoint: return
	if checkpoint: checkpoint.deactivate()
	checkpoint = cp
	spawn_point = cp.global_position
	spawn_set = true
