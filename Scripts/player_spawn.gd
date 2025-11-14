extends Node2D

@export var player: PackedScene
@export var main_text: Appearer
@export var sub_text: Appearer

var plr: PlayerRoot

func _ready() -> void:
	if GameState.spawn_set: global_position = GameState.spawn_point
	spawn()
	GameState.fix_player.connect(respawn)
	GameState.main_text = main_text
	GameState.sub_text = sub_text

func respawn():
	var p = plr.control.global_position
	plr.queue_free()
	global_position = p
	spawn()
	
func spawn():
	plr = player.instantiate()
	add_child(plr)
	
func add_gun():
	plr.gun_sprite.visible = true
	plr.arm_left.visible = true
	plr.arm_right.visible = true
	SoundEffects.singleton.add(16, global_position)