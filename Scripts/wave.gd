class_name Wave
extends Node2D

@export var delay := 1.0
@export var title: String

var spawns: Array[Spawn]
var amount := 0
var encounter: Encounter

func _ready() -> void:
	for child in get_children():
		if child is Spawn:
			spawns.push_back(child)
			amount += 1

func start(enc: Encounter, count: String):
	encounter = enc
	print("activated wave")
	await get_tree().create_timer(0.5).timeout
	if title:
		GameState.main_text.show_with_text(title)
	GameState.sub_text.show_with_text("Wave %s" % [count])
	SoundEffects.singleton.add(12, global_position) # warn.wav
	Musics.intensify(true)
	await get_tree().create_timer(delay).timeout
	for spawn in spawns:
		spawn.start(self)
	await get_tree().create_timer(1).timeout
	GameState.main_text.disappear()
	GameState.sub_text.disappear()


func enemy_died():
	amount -= 1
	if amount <= 0:
		encounter.next_wave()
