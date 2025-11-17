class_name Worm
extends Node2D

@export var friendly: bool
@export var segments: Array[Node2D]
@export var line: Line2D
@export var inner_line: Line2D
@export var blister: PackedScene
@export var sound: AudioStreamPlayer2D
@export var pickup: PackedScene

var dir := Vector2.UP
var points: PackedVector2Array
var angles: PackedFloat32Array
var segment_length := 20
var life := 6
var active := false
var sound_cooldown := 0.0
var prev_blister: WormBlister
var goal: Node2D
var leaving := false

func _ready() -> void:
	activate()
	
	if friendly:
		for s in segments:
			s.get_node("Area2D").queue_free()
	
func activate():
	if not friendly:
		GameState.boss_fight = true
		GameState.show_texts("Mother is coming!", "Better start running...", 0.2, 2.5)
		respawn_blister()
		Musics.intensify(true, false)
	else:
		GameState.show_texts("Mother is coming!", "Catch a ride...", 0.2, 2.5)

	SoundEffects.singleton.add(12, GameState.player.live_gun.global_position) # warn.wav
	await get_tree().create_timer(2.5).timeout
	if GameState.has_tracking and not friendly:
		GameState.camera.target_zoom = 0.7
	points.resize(len(segments) * segment_length)
	points.fill(global_position)
	angles.resize(len(points))
	angles.fill(0)
	active = true
	GameState.worm = self
			
func respawn_blister():
	life -= 1

	if life <= 0:
		if not GameState.has("worm"):
			var pick := pickup.instantiate()
			if pick is Pickup:
				pick.type = Pickup.Type.WormTaxi
				pick.id = "worm"
				pick.global_position = prev_blister.global_position
				get_parent().add_child(pick)
		GameState.camera.shake(30, 0.5)
		GameState.camera.target_zoom = 1
		GameState.boss_fight = false
		var p := segments[0].global_position
		SoundEffects.singleton.add(13, p)
		SoundEffects.singleton.add(2, p)
		Musics.intensify(false, true)
		for s in segments:
			Effects.singleton.add_many([4, 3, 10, 2, 0, 0, 0, 1], s.global_position)
		queue_free()
		return

	var b := blister.instantiate()
	if b is Node2D:
		scream()
		var i = randi_range(1, len(segments) - 2)
		var flip := -1 if randf() < 0.5 else 1
		b.position = Vector2(190 * flip, 0)
		b.scale = Vector2(flip, 1)
		segments[i].add_child(b)
		prev_blister = b.get_node("Body")
		if prev_blister is WormBlister:
			prev_blister.died.connect(respawn_blister)
			
func change_goal():
	if not leaving and len(GameState.checkpoints) > 0:
		goal = GameState.checkpoints[randi_range(0, len(GameState.checkpoints) - 1)]
		scream()
		await get_tree().create_timer(5).timeout
		change_goal()
	
func leave():
	leaving = true
	goal = null
	await get_tree().create_timer(5).timeout
	queue_free()

func _process(delta: float) -> void:
	if not active:
		return
	
	sound_cooldown -= delta

	if (not friendly or not goal) and not leaving:
		goal = GameState.player.live_gun

	if goal:
		var pp = goal.global_position
		dir = Vector2.from_angle(rotate_toward(dir.angle(), segments[0].global_position.angle_to_point(pp), delta))

		if (pp - sound.global_position).length() < 700 and sound_cooldown <= 0:
			scream()
			sound_cooldown = 2.5
		
	var count := len(points)
	for i in range(len(points)):
		if i > 0:
			points[count - i] = points[count - i - 1]
			angles[count - i] = angles[count - i - 1]

	points[0] += dir * 1000 * delta
	angles[0] = dir.angle()

	var line_points = []
	for i in range(len(segments)):
		segments[i].global_position = points[i * segment_length]
		segments[i].rotation = angles[i * segment_length] + PI * 0.5
		line_points.push_back(line.to_local(segments[i].global_position))

	line.points = line_points
	inner_line.points = line_points

func scream():
	sound.play()
	sound.play()
	GameState.camera.shake(8, 0.4)
