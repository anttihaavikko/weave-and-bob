class_name Pickup
extends Area2D

@export var id: String
@export var type: PickupType
@export var sprite: Sprite2D 
@export var icons: Array[Texture2D]

enum PickupType { None, Magazine, Map }

func _ready() -> void:
	sprite.texture = icons[type]
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
