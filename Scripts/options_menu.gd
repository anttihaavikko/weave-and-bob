class_name OptionsMenu
extends Control

@export var toggle_button: Button
@export var music: Slider
@export var sounds: Slider

var pos: Vector2
var open: bool

func _ready():
	pos = position
	position += size.x * Vector2.RIGHT
	toggle_button.pressed.connect(toggle)
	music.value_changed.connect(volumes_changed)
	sounds.value_changed.connect(volumes_changed)

func volumes_changed(_val):
	AudioServer.set_bus_volume_linear(1, music.value * 2)
	AudioServer.set_bus_volume_linear(2, sounds.value * 2)

func toggle():
	open = !open
	get_tree().create_tween().tween_property(self, "position", pos if open else position + size.x * Vector2.RIGHT, 0.2).set_trans(Tween.TRANS_BOUNCE)

func _input(_event):
	if Input.is_action_just_pressed("escape"):
		toggle()

func restart():
	toggle()
	GameState.restart()
