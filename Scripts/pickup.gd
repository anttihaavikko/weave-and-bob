@tool
class_name Pickup
extends Area2D

const textures: Dictionary[Type, Texture2D] = {
	Type.None: null,
	Type.Magazine: preload("res://Sprites/mag-pickup.png"),
	Type.Map: preload("res://Sprites/map.png"),
	Type.Damage: preload("res://Sprites/damage-pickup.png"),
	Type.Breaker: preload("res://Sprites/breaker-pickup.png"),
	Type.Life: preload("res://Sprites/life-pickup.png")
}

@export var id: String
@export var type: Type:
	set(val):
		var icon := textures[val]
		if sprite: sprite.texture = icon
		type = val
@export var sprite: Sprite2D

enum Type { None, Magazine, Map, Damage, Breaker, Life }

var done := false

func _ready() -> void:
	sprite.texture = textures[type]
	body_entered.connect(_picked)
	if not Engine.is_editor_hint():
		GameState.register(id)
		if GameState.has(id):
			queue_free()

func _picked(_body: Node2D):
	if done:
		return
	done = true
	if type == Type.Magazine:
		GameState.has_magazine = true
		GameState.show_texts("Now we're talking!", "With bullets...", 0.5, 1.75)
	if type == Type.Damage:
		GameState.damage += 30
		GameState.show_texts("Shot damage up!", "By a whopping 30%...", 0.5, 2.5)
	if type == Type.Breaker:
		GameState.breaker_shots = true
		GameState.show_texts("Shots can break weak walls!", "Time for some shortcuts...", 0.5, 2.5)
	if type == Type.Life:
		GameState.max_life += 1
		GameState.show_texts("You feel healthier!", "Like you could take on anything...", 0.5, 2.5)
	if type == Type.Map:
		GameState.map_upgrades += 1
		if GameState.map_upgrades == 1:
			GameState.help_text.show_with_text("Press TAB or M to open the map...")
		if GameState.map_upgrades == 2:
			GameState.show_texts("Lorem ipsum!", "Dolor sit amet...", 0.5, 2.5)
		if GameState.map_upgrades == 3:
			GameState.show_texts("Pickups visible on the map!", "That should be helpful...", 0.5, 2.5)
		
	GameState.mark(id)
	Effects.singleton.add_many([0, 1, 3], global_position)
	SoundEffects.singleton.add(6, global_position, 0.3)
	SoundEffects.singleton.add(7, global_position, 0.5)
	SoundEffects.singleton.add(8, global_position)
	queue_free()
