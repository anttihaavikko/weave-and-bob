@tool
class_name DevSprite
extends Node2D

@export var texture : Texture2D:
	set(value):
		texture = value
		queue_redraw()

func _draw():
	if Engine.is_editor_hint():
		draw_texture(texture, texture.get_size() * -0.5)
