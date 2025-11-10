extends Node

@export var normal: AudioStreamPlayer
@export var combat: AudioStreamPlayer
@export var rhythm: RhythmNotifier

var _intense := false
var _pitch_target := 1.0

func _ready() -> void:
	rhythm.beat.connect(func(_count: int):
		normal.volume_linear = 0 if _intense else 1
		combat.volume_linear = 1 if _intense else 0
	)

func _process(delta: float) -> void:
	var tp = move_toward(normal.pitch_scale, _pitch_target, delta * 10)
	var ps := AudioServer.get_bus_effect(1, 0)
	if ps is AudioEffectPitchShift:
		ps.pitch_scale = tp
	
func intensify(state: bool):
	_intense = state

func pause():
	normal.volume_linear = 0
	combat.volume_linear = 0
	
func pitch(target: float, reset_after: float = -1):
	_pitch_target = target
	# AudioServer.set_bus_effect_enabled(1, 1, true)
	if reset_after > 0:
		await get_tree().create_timer(reset_after).timeout
		_pitch_target = 1
		# AudioServer.set_bus_effect_enabled(1, 1, false)
