class_name Appearer
extends Node

@export var appear_after := 0.0
@export var auto_hide_after := 0.0
@export var duration := 0.3

var obj
var size: Vector2
var shown := false

func _ready() -> void:
	obj = self
	if obj is Node2D or obj is Control:
		size = obj.scale
		obj.scale = Vector2.ZERO
		
	if appear_after > 0:
		await get_tree().create_timer(appear_after).timeout
		appear()	
	if auto_hide_after:
		await get_tree().create_timer(auto_hide_after).timeout
		disappear()

func appear():
	if shown:
		return
	shown = true
	get_tree().create_tween().tween_property(obj, "scale", size, duration).set_trans(Tween.TRANS_BOUNCE)

func disappear():
	if not shown:
		return
	shown = false
	get_tree().create_tween().tween_property(obj, "scale", Vector2.ZERO, duration).set_trans(Tween.TRANS_ELASTIC)

func show_with_text(text: String):
	if obj is Label:
		obj.text = text
	appear()