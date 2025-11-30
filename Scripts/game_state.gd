extends Node

var has_magazine := true
var map_upgrades := 1
var damage := 100
var has_gun := true
var breaker_shots := true
var max_life := 1
var accuracy := 0
var has_tracking := true
var has_double_jump := true
var has_taxi := false
var has_dash := true
var met_bobs := 5

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
var checkpoints: Array[Checkpoint]
var boss_fight := false
var attached := false
var worm: Worm
var options: OptionsMenu
var saver: Saver

signal fix_player

func _ready() -> void:
	saver = Saver.new()
	if not OS.is_debug_build():
		reset()
		load_save()

func reset():
	ids.clear()
	has_magazine = false
	map_upgrades = 0
	damage = 100
	has_gun = false
	breaker_shots = false
	max_life = 1
	accuracy = 0
	has_tracking = false
	has_double_jump = false
	has_taxi = false
	has_dash = false
	met_bobs = 0

func mark(id: String):
	if len(id) > 1:
		ids.push_back(id)
		
func request_player_fix():
	fix_player.emit()

func has(id: String) -> bool:
	return len(id) > 1 and ids.has(id)

func get_percentage() -> String:
	var total = 0
	if has_magazine: total += 1
	if has_gun: total += 1
	if breaker_shots: total += 1
	if has_tracking: total += 1
	if has_double_jump: total += 1
	if has_taxi: total += 1
	if has_dash: total += 1
	total += (max_life - 1)
	total += int((damage - 100) / 30.0)
	total += map_upgrades
	total += accuracy
	return str(int((total / 20.0) * 100)) + "%"

func register(id: String):
	if len(id) > 1 and unique.has(id):
		# print("DUPLICATED ID %s" % [id])
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
	save()

func show_texts(main: String, sub: String, delay: float = 0, hide_delay: float = 0):
	main_text.show_with_text(main)
	await get_tree().create_timer(delay).timeout
	sub_text.show_with_text(sub)
	if hide_delay > 0:
		await get_tree().create_timer(hide_delay).timeout
		sub_text.disappear()
		await get_tree().create_timer(0.1).timeout
		main_text.disappear()

func restart():
	checkpoints.clear()
	blinders.close()
	boss_fight = false
	await get_tree().create_timer(GameState.blinders.duration + 0.2).timeout
	get_tree().reload_current_scene()

func show_help(text: String, delay: float):
	await get_tree().create_timer(delay).timeout
	help_text.show_with_text(text)

func save():
	var data: Dictionary = {
		"success": true,
		"ids": ids,
		"spawn_x": spawn_point.x,
		"spawn_y": spawn_point.y,
		"has_gun": has_gun,
		"has_magazine": has_magazine,
		"map_upgrades": map_upgrades,
		"damage": damage,
		"breaker_shots": breaker_shots,
		"max_life": max_life,
		"accuracy": accuracy,
		"has_tracking": has_tracking,
		"has_double_jump": has_double_jump,
		"has_taxi": has_taxi,
		"has_dash": has_dash,
		"met_bobs": met_bobs
	}
	saver.save(data)
	
func load_save():
	var data := saver.load()
	if data.has("success"):
		for id in data.ids:
			ids.push_back(id)
		spawn_point = Vector2(data.spawn_x, data.spawn_y)
		spawn_set = true
		has_gun = data.has_gun
		has_magazine = data.has_magazine
		map_upgrades = data.map_upgrades
		damage = data.damage
		breaker_shots = data.breaker_shots
		max_life = data.max_life
		accuracy = data.accuracy
		has_tracking = data.has_tracking
		has_double_jump = data.has_double_jump
		has_taxi = data.has_taxi
		has_dash = data.has_dash
		met_bobs = data.met_bobs
