extends Node

var has_magazine := true
var map_upgrades := 3
var damage := 100
var has_gun := true
var breaker_shots := true
var max_life := 1
var accuracy := 0

var spawn_set := false
var spawn_point: Vector2
var checkpoint: Checkpoint
var camera: ShakeableCamera
var help_text: Appearer
var main_text: Appearer
var sub_text: Appearer
var player: PlayerRoot
var blinders: Blinders

var ids: Array[String]
var unique: Array[String]
var pools: Dictionary

signal fix_player

func _ready() -> void:
	if not OS.is_debug_build():
		has_magazine = false
		map_upgrades = 0
		damage = 100
		has_gun = false
		breaker_shots = false
		max_life = 1
		accuracy = 0

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

func show_texts(main: String, sub: String, delay: float = 0, hide_delay: float = 0):
	main_text.show_with_text(main)
	await get_tree().create_timer(delay).timeout
	sub_text.show_with_text(sub)
	if hide_delay > 0:
		await get_tree().create_timer(hide_delay).timeout
		sub_text.disappear()
		await get_tree().create_timer(0.1).timeout
		main_text.disappear()