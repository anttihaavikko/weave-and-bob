extends Node2D

@export var worm: PackedScene
@export var friendly: PackedScene

func spawn(friend: bool = false):
	spawn_with(friendly if friend else worm)

func spawn_with(prefab: PackedScene):
	var dir := Vector2.from_angle(randf() * TAU) * 2000
	global_position = GameState.player.live_gun.global_position + dir
	var w := prefab.instantiate()
	if w is Worm:
		w.dir = - dir.normalized()
	add_child(w)
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("taxi") and not GameState.worm:
		spawn(true)