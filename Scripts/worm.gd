extends Node2D

@export var segments: Array[Node2D]
@export var line: Line2D
@export var inner_line: Line2D
@export var blister: PackedScene

var dir := Vector2.UP
var points: PackedVector2Array
var angles: PackedFloat32Array
var segment_length := 20
var life := 6
var active := false
	
func activate():
	GameState.show_texts("Mother is coming!", "Better start running...", 0.2, 2.5)
	SoundEffects.singleton.add(12, global_position) # warn.wav
	Musics.intensify(true, false)
	await get_tree().create_timer(2.5).timeout
	# GameState.camera.target_zoom = 0.8
	points.resize(len(segments) * segment_length)
	points.fill(global_position)
	angles.resize(len(points))
	angles.fill(0)
	active = true
	respawn_blister()
			
func respawn_blister():
	life -= 1

	if life <= 0:
		GameState.camera.shake(30, 0.5)
		var p := segments[0].global_position
		SoundEffects.singleton.add(13, p)
		SoundEffects.singleton.add(2, p)
		for s in segments:
			Effects.singleton.add_many([4, 3, 10, 2, 0, 0, 0, 1], s.global_position)
		queue_free()
		return

	var b := blister.instantiate()
	if b is Node2D:
		var i = randi_range(1, len(segments) - 2)
		var flip := -1 if randf() < 0.5 else 1
		b.position = Vector2(185 * flip, 0)
		b.scale = Vector2(flip, 1)
		segments[i].add_child(b)
		var bls = b.get_node("Body")
		if bls is WormBlister:
			bls.died.connect(respawn_blister)

func _process(delta: float) -> void:
	if not active:
		return

	if GameState.player:
		var pp = GameState.player.live_gun.global_position
		dir = Vector2.from_angle(rotate_toward(dir.angle(), segments[0].global_position.angle_to_point(pp), delta))
		
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
