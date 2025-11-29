class_name Switch
extends AnimatableBody2D

@export var change := 45.0
@export var doors: Array[Door]
@export var rotating_door: RotatingDoor

var start: float
var on := false

signal flipped

func _ready() -> void:
	start = rotation_degrees
	if rotating_door:
		flipped.connect(rotating_door.change)

func flip():
	on = !on
	get_tree().create_tween().tween_property(self, "rotation_degrees", start + (change if on else 0.0), 0.3).set_trans(Tween.TRANS_BOUNCE)
	SoundEffects.singleton.add(21, global_position)
	flipped.emit()
	for door in doors:
		door.toggle()
