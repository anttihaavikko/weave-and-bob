class_name Enemy
extends CharacterBody2D

@export var id: String
@export var title: String
@export var respawns_after := 2
@export var life := 10
@export var stomp_offset := 20
@export var starts_encounter: Encounter;
@export var frame: Node2D
@export var bump_cast: ShapeCast2D
@export var title_label: Label

@export var flasher: Flasher

enum Behaviour { None, Wave }
var mode: Behaviour
var dir: Vector2
var time := 0.0
var turn_delay := 0.0

var max_life := life

signal died;

func _ready() -> void:
	title_label.text = title
	if GameState.has(id):
		if starts_encounter: starts_encounter.open_doors()
		queue_free()
	
func _physics_process(delta: float) -> void:
	if mode == Behaviour.Wave:
		time += delta
		turn_delay -= delta
		velocity = (dir + dir.rotated(PI * 0.5) * sin(time * 5) * 1) * 20000 * delta
		move_and_slide()
		if turn_delay <= 0 and bump_cast.is_colliding():
			dir = -dir
			turn_delay = 0.5
			var p := bump_cast.get_collision_point(0)
			Effects.singleton.add_many([0, 1], p)
			SoundEffects.singleton.add(5, p, 0.3) # enemy_bump.wav
			squash(p)

func get_stomp_pos() -> float:
	return global_position.y - stomp_offset
	
func squash(pos: Vector2):
	frame.rotation = global_position.angle_to_point(pos)
	frame.scale = Vector2(0.9, 1.1)
	await get_tree().create_timer(0.1).timeout
	frame.scale = Vector2.ONE

func hurt(pos: Vector2):
	flasher.flash()
	squash(pos)
	life -= 1
	Effects.singleton.add(2, pos)
	if life <= 0:
		die()

func die():
	hide()
	process_mode = Node.PROCESS_MODE_DISABLED
	Effects.singleton.add_many([4, 3, 2, 2, 2, 0, 0, 0, 1], global_position)
	SoundEffects.singleton.add(2, global_position)
	died.emit()
	if starts_encounter: starts_encounter.start(self)
	if respawns_after > 0:
		await get_tree().create_timer(respawns_after).timeout
		life = max_life
		show()
		process_mode = Node.PROCESS_MODE_INHERIT
#		Effects.singleton.add(4, global_position)
		Effects.singleton.add(3, global_position)
	else:
		queue_free()
