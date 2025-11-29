class_name SlidingPanel
extends Control

@export var direction := Vector2.RIGHT

var pos: Vector2
var open: bool

func _ready():
	pos = position
	position += size.x * direction
	
func toggle():
	open = !open
	get_tree().create_tween().tween_property(self, "position", pos if open else pos + size.x * direction, 0.2).set_trans(Tween.TRANS_BOUNCE)