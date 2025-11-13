extends Node2D

@export var player: PackedScene

var plr: PlayerRoot

func _ready() -> void:
	if GameState.spawn_set: global_position = GameState.spawn_point
	plr = player.instantiate()
	add_child(plr)
	GameState.fix_player.connect(respawn)

func respawn():
	var p = plr.control.global_position
	plr.queue_free()
	global_position = p
	plr = player.instantiate()
	add_child(plr)
	
func add_gun():
	plr.gun_sprite.visible = true
	plr.arm_left.visible = true
	plr.arm_right.visible = true
	SoundEffects.singleton.add(16, global_position)