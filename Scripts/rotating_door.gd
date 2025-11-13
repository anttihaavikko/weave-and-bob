extends Node2D

@export var _open_pos: float = 45

var _closed_pos: float
var state := false

func _ready() -> void:
    _closed_pos = global_rotation_degrees
    _open_pos += global_rotation_degrees

func change():
    state = !state
    var pos := _open_pos if state else _closed_pos
    get_tree().create_tween().tween_property(self, "global_rotation_degrees", pos, 0.5).set_trans(Tween.TRANS_BOUNCE)
    SoundEffects.singleton.add(10, global_position) # throw1.wav
    await get_tree().create_timer(0.4).timeout
    process_mode = Node.PROCESS_MODE_INHERIT if !state else Node.PROCESS_MODE_DISABLED
