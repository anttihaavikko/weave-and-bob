extends Node

@export var normal: AudioStreamPlayer
@export var combat: AudioStreamPlayer
@export var ambient: AudioStreamPlayer
@export var rhythm: RhythmNotifier

var intense := false
var chill := true
var _pitch_target := 1.0

func _ready() -> void:
	rhythm.beat.connect(func(_count: int):
		if _count % 4 == 0:
			normal.volume_linear = 0 if intense or chill else 1
			combat.volume_linear = 1 if intense else 0
			ambient.volume_linear = 1 if chill else 0
	)

func _process(delta: float) -> void:
	var tp = move_toward(normal.pitch_scale, _pitch_target, delta * 10)
	var ps := AudioServer.get_bus_effect(1, 0)
	if ps is AudioEffectPitchShift:
		ps.pitch_scale = tp
	
func intensify(aggro: bool, mild: bool):
	intense = aggro
	chill = mild

func pause():
	normal.volume_linear = 0
	combat.volume_linear = 0