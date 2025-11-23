extends Node2D

@export var legs: Array[Node2D]
@export var body: Node2D
@export var blister_prefab: PackedScene
@export var killboxes: Array[Killbox]
@export var main: Node2D
@export var blister_points: Array[Node2D]
@export var pickup: PackedScene
@export var eyes: Array[Node2D]

var current: Node2D
var awake := false
var blister: WormBlister
var life := 6
var blister_index := 0
var time := 0.0

func _ready():
	spawn_blister()

func wake():
	awake = true
	for kb in killboxes:
		kb.enabled = true
	GameState.boss_fight = true
	GameState.show_texts("Daddy's awake!", "What now...", 0.2, 2.5)
	Musics.intensify(true, false)
	SoundEffects.singleton.add(12, GameState.player.live_gun.global_position) # warn.wav
	# await get_tree().create_timer(2.5).timeout
	if GameState.has_tracking:
		GameState.camera.target_zoom = 0.7
	strike()
	for eye in eyes:
		eye.show()
	
func spawn_blister():
	life -= 1
	
	if life <= 0:
		if not GameState.has("spider"):
			var pick := pickup.instantiate()
			if pick is Pickup:
				pick.type = Pickup.Type.Stomp
				pick.id = "spider"
				pick.global_position = blister.global_position
				get_parent().add_child(pick)
		GameState.camera.shake(30, 0.5)
		GameState.camera.target_zoom = 1
		GameState.boss_fight = false
		var p := body.global_position
		SoundEffects.singleton.add(13, p)
		SoundEffects.singleton.add(2, p)
		Musics.intensify(false, true)
		Effects.singleton.add_many([4, 3, 10, 2, 0, 0, 0, 1], p)
		queue_free()
		return

	var b = blister_prefab.instantiate()
	if b is Node2D:
		b.position = blister_points[blister_index].position
		blister_index = (blister_index + 1) % 3
		b.rotation = b.position.angle()
		main.add_child(b)
		blister = b.get_node("Body")
		if blister is WormBlister:
			blister.died.connect(spawn_blister)

	if life == 4:
		wake()

func _process(delta):
	time += delta
	var offset := Vector2(0, abs(sin(time * (5.0 if awake else 2.0))) * (100 if awake else 30))
	if not awake:
		body.position = offset
		return
	var pp := GameState.player.live_gun.global_position
	body.global_position = body.global_position.move_toward(pp, delta * 500)
	for leg in legs:
		if leg != current and leg.global_position.distance_to(body.global_position) > 1500:
			leg.global_position = (leg.global_position + body.global_position) * 0.5 + offset
			# get_tree().create_tween().tween_property(leg, "global_position", (leg.global_position + body.global_position) * 0.5, 0.3).set_trans(Tween.TRANS_ELASTIC)
			# await get_tree().create_timer(0.3).timeout

func pick_leg():
	var pp := GameState.player.live_gun.global_position
	var distance := 99999.0
	for leg in legs:
		var d := leg.global_position.distance_to(pp)
		if d < distance:
			distance = d
			current = leg
	await get_tree().create_timer(0.5).timeout
			
func strike():
	pick_leg()
	if not current: return
	var pp := GameState.player.live_gun.global_position
	if body.global_position.distance_to(pp) > 1800:
		await get_tree().create_timer(1).timeout
		strike()
		return
	await get_tree().create_timer(0.5).timeout
	get_tree().create_tween().tween_property(current, "global_position", (pp + global_position + current.global_position) / 3, 0.8).set_trans(Tween.TRANS_ELASTIC)
	await get_tree().create_timer(0.75).timeout
	get_tree().create_tween().tween_property(current, "global_position", pp, 0.5).set_trans(Tween.TRANS_BOUNCE)
	await get_tree().create_timer(1).timeout
	strike()
