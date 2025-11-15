extends Node2D

@export var player: PackedScene
@export var main_text: Appearer
@export var sub_text: Appearer
@export var home_pos: Node2D
@export var moving_blanket: Node2D
@export var blanket: Node2D

var plr: PlayerRoot
var started := false

func _ready() -> void:
	if GameState.spawn_set:
		global_position = GameState.spawn_point
	else:
		global_position = home_pos.global_position
	spawn()
	GameState.fix_player.connect(respawn)
	GameState.main_text = main_text
	GameState.sub_text = sub_text
	if not GameState.has_gun and not GameState.spawn_set:
		GameState.camera.zoom = Vector2.ONE * 1.5
		plr.hide()

func _process(_delta: float) -> void:
	if not started and (abs(Input.get_axis("left", "right")) > 0 or Input.is_action_just_pressed("jump")):
		started = true
		plr.show()
		moving_blanket.hide()
		blanket.show()
		SoundEffects.singleton.add(1, global_position)
		SoundEffects.singleton.add(5, global_position, 0.1)

func respawn():
	var p = plr.control.global_position
	var life = plr.health
	plr.queue_free()
	global_position = p
	spawn()
	plr.health = life
	
func spawn():
	plr = player.instantiate()
	add_child(plr)
	GameState.player = plr
	
func add_gun():
	plr.ammo_display.visible = true
	plr.gun_sprite.visible = true
	plr.arm_left.visible = true
	plr.arm_right.visible = true
	SoundEffects.singleton.add(16, global_position)
