extends Node

var has_magazine := true
var map_upgrades := 0
var damage := 100
var has_gun := true

var spawn_set := false
var spawn_point: Vector2
var checkpoint: Checkpoint
var camera: ShakeableCamera
var help_text: Appearer

var ids: Array[String]
var unique: Array[String]

signal fix_player

func mark(id: String):
	if len(id) > 1:
		ids.push_back(id)
		
func request_player_fix():
	fix_player.emit()		

func has(id: String) -> bool:
	return len(id) > 1 and ids.has(id)

func register(id: String):
	if len(id) > 1 and unique.has(id):
		print("DUPLICATED ID %s" % [id])
		return
	unique.push_back(id)

func change_spawn(cp: Checkpoint) -> void:
	if cp == checkpoint:
		return
	if checkpoint:
		checkpoint.deactivate()
	checkpoint = cp
	spawn_point = cp.global_position
	spawn_set = true
