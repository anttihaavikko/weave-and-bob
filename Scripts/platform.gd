@tool
extends Node2D

@export var show_right := true:
	set(value):
		show_right = value
		right.visible = value
@export var show_left := true:
	set(value):
		show_left = value
		left.visible = value
@export var size := Vector2(500, 40):
	set(value):
		size = value
		sprite.scale = size
		collider.shape = RectangleShape2D.new()
		collider.shape.size = size
		left.position = Vector2(-value.x * 0.5 + 90, left.position.y)
		right.position = Vector2(value.x * 0.5 - 90, left.position.y)
			
@export var sprite: Sprite2D
@export var left: Node2D
@export var right: Node2D
@export var collider: CollisionShape2D
