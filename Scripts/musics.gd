extends Node

@export var normal: AudioStreamPlayer
@export var combat: AudioStreamPlayer
@export var ambient: AudioStreamPlayer
@export var rhythm: RhythmNotifier

var intense := false
var chill := true
var _pitch_target := 1.0
var prev: AudioStreamPlayer
var needs_sync := false
var has_synced := false
var started := false

func _ready() -> void:
	prev = ambient
	rhythm.beat.connect(func(_count: int):
		if _count % 2 == 0 and started:
			# print(_count)
			normal.volume_linear = 0.0 if intense or chill else 1.0
			combat.volume_linear = 1.0 if intense else 0.0
			ambient.volume_linear = 1.0 if chill else 0.0
			if needs_sync and not has_synced:
				has_synced = true
				print("sync musics")
				sync_pieces()
				needs_sync = false
	)
	
func start(delay: float = 0):
	await get_tree().create_timer(delay).timeout
	normal.seek(0)
	combat.seek(0)
	ambient.seek(0)
	rhythm.running = true
	get_tree().create_tween().tween_property(ambient, "volume_linear", 1, 0.5).set_trans(Tween.TRANS_BOUNCE)
	started = true

func sync_pieces():
	var pos = prev.get_playback_position() + AudioServer.get_time_since_last_mix()
	if pos > 112:
		pos -= 112
	print("sync to ", pos)
	normal.seek(pos)
	combat.seek(pos)
	ambient.seek(pos)

func _process(delta: float) -> void:
	var tp = move_toward(normal.pitch_scale, _pitch_target, delta * 10)
	var ps := AudioServer.get_bus_effect(1, 0)
	if ps is AudioEffectPitchShift:
		ps.pitch_scale = tp
	
func intensify(aggro: bool, mild: bool):
	# var cur = get_current_piece()
	# if cur != prev:
	# 	needs_sync = true
	# 	prev = cur
	intense = aggro
	chill = mild

func get_current_piece() -> AudioStreamPlayer:
	if intense:
		return combat
	if chill:
		return ambient
	return normal

func pause():
	normal.volume_linear = 0
	combat.volume_linear = 0