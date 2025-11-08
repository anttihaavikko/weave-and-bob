@tool
class_name Pickup
extends Area2D

const textures: Dictionary[PickupType, Texture2D] = {
	PickupType.None: null,
	PickupType.Magazine: preload("res://Sprites/mag-pickup.png"),
	PickupType.Map: preload("res://Sprites/map.png")
} 

@export var id: String
@export var type: PickupType:
	set(val):
		var icon = textures[val]
		if sprite: sprite.texture = icon
		type = val
@export var sprite: Sprite2D 

enum PickupType { None, Magazine, Map }

func _ready() -> void:
	sprite.texture = textures[type]
	if not Engine.is_editor_hint():
		if GameState.has(id):
			queue_free()	

func _picked(_body: Node2D):
	if type == PickupType.Magazine: GameState.has_magazine = true
	if type == PickupType.Map: GameState.map_upgrades += 1
	GameState.mark(id)
	Effects.singleton.add_many([0, 1, 3], global_position)
	SoundEffects.singleton.add(6, global_position, 0.3)
	SoundEffects.singleton.add(7, global_position, 0.5)
	SoundEffects.singleton.add(8, global_position)
	queue_free()
