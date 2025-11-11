@tool
class_name Pickup
extends Area2D

const textures: Dictionary[Type, Texture2D] = {
	Type.None: null,
	Type.Magazine: preload("res://Sprites/mag-pickup.png"),
	Type.Map: preload("res://Sprites/map.png"),
}

@export var id: String
@export var type: Type:
	set(val):
		var icon := textures[val]
		if sprite: sprite.texture = icon
		type = val
@export var sprite: Sprite2D

enum Type {None, Magazine, Map}

func _ready() -> void:
	sprite.texture = textures[type]
	if not Engine.is_editor_hint():
		GameState.register(id)
		if GameState.has(id):
			queue_free()

func _picked(_body: Node2D):
	if type == Type.Magazine: GameState.has_magazine = true
	if type == Type.Map: GameState.map_upgrades += 1
	GameState.mark(id)
	Effects.singleton.add_many([0, 1, 3], global_position)
	SoundEffects.singleton.add(6, global_position, 0.3)
	SoundEffects.singleton.add(7, global_position, 0.5)
	SoundEffects.singleton.add(8, global_position)
	queue_free()
